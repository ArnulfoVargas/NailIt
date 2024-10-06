import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/models/models.dart';
import 'package:tarea/widgets/widgets.dart';

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            }, 
            icon: const Icon(Icons.exit_to_app,
              color: Colors.black54,
            )
          )
        ],
      ),
      body: const FormKeyboardHidder(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: _EditForm(),
              ),
            )
          ),
      ),
    );
  }
}

class _EditForm extends StatefulWidget {
  const _EditForm();

  @override
  State<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<_EditForm> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  late UserModel userData;
  ValidationResult validations = ValidationResult();

  bool passObscureText = true;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<UserBloc>();
    userData = bloc.state;
    _updateControllers(userData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInput(
          onChanged: _validateUser,
          controller: userController,
          autocorrect: true,
          hasError: !validations.userIsValid,
          icon: Icons.person,
          labelText: "Username",
          errorText: validations.userErrorMsg,
        ),
    
        CustomInput(
          onChanged: _validatePhone,
          controller: phoneController,
          autocorrect: true,
          hasError: !validations.phoneIsValid,
          inputType: TextInputType.phone,
          icon: Icons.phone,
          labelText: "Phone Number",
          errorText: validations.phoneErrorMsg,
        ),
    
        CustomInput(
          onChanged: _validateMail,
          controller: mailController,
          autocorrect: true,
          hasError: !validations.mailIsValid,
          icon: Icons.mail,
          inputType: TextInputType.emailAddress,
          labelText: "Mail",
          errorText: validations.mailErrorMsg,
        ),
    
        CustomInput(
          onChanged: _validatePass,
          controller: passController,
          autocorrect: false,
          hasError: !validations.passwordIsValid,
          icon: Icons.security,
          inputType: TextInputType.visiblePassword,
          labelText: "Password",
          errorText: validations.passwordErrorMsg,
          obscureText: passObscureText,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                passObscureText = !passObscureText;
              });
            }, 
            icon: Icon(passObscureText ? Icons.visibility : Icons.visibility_off, color: Colors.black38,)
          ),
        ),
    
        const SizedBox(height: 50,),
    
        CustomElevatedButton(
          onPressed: validations.hasErrors ? null : _onApply,
          text: "Apply",
        )
      ],
    );
  }

  void _onApply() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure?",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              color: Colors.black54
            ),
          ),
          content: const Text("This action cannot be reversed"),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _applyChanges();
              }, 
              child: const SizedBox(
                width: double.infinity,
                child: Text("Apply",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF229799),
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ),

            ElevatedButton(
              onPressed: () {
                  Navigator.of(context).pop();
              }, 
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.redAccent,
                shadowColor: Colors.transparent
              ),
              child: const SizedBox(
                width: double.infinity,
                child: Text("Cancel",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ),
          ],
        );
      }
    );
  }

  void _updateControllers(UserModel controller) {
    userController.text = controller.username;
    mailController.text = controller.mail;
    passController.text = controller.password;
    phoneController.text = controller.phone;
  }

  bool _hasChanges() {
    return  userController.text != userData.username || 
            phoneController.text != userData.phone ||
            mailController.text != userData.mail ||
            passController.text != userData.password;
  }

  _validateInputs() {
    validations = UserModel.validateAllFields(
      mail: mailController.text,
      password: passController.text,
      username: userController.text,
      phone: phoneController.text
    );
  }

  _applyChanges() {
    _validateInputs();
    if (validations.hasErrors) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("There are some errors") 
        )
      );
      return;
    } 

    bool hasModifications = _hasChanges();

    if (!hasModifications) {
      _showAddChagesAlert();
      return;
    }

    context.read<UserBloc>().storeAndUpdate(
      username: userController.text,
      mail: mailController.text, 
      password: passController.text, 
      phone: phoneController.text
    );

    _pop();
  }

  _pop() {
    Navigator.of(context).pop();
  }

  _showAddChagesAlert() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text("No changes made",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            color: Colors.black54
          ),
        ),
        content: const Text("You must add some changes"),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        actions: [
            TextButton(
              onPressed: _pop, 
              child: const SizedBox(
                width: double.infinity,
                child: Text("Ok",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            )
        ],
      )
    );
  }

  _validateUser(String value) {
    final validator = UserModel.validateUsername(value);
    validations.userErrorMsg = validator.errorMsg;
    validations.userIsValid = validator.isValid;
    _updateHasErrors();
    setState(() {});
  }

  _validatePhone(String value) {
    final validator = UserModel.validatePhone(value);
    validations.phoneErrorMsg = validator.errorMsg;
    validations.phoneIsValid = validator.isValid;
    _updateHasErrors();
    setState(() {});
  }

  _validateMail(String value) {
    final validator = UserModel.validateMail(value);
    validations.mailErrorMsg = validator.errorMsg;
    validations.mailIsValid = validator.isValid;
    _updateHasErrors();
    setState(() {});
  }

  _validatePass(String value) {
    final validator = UserModel.validatePassword(value);
    validations.passwordErrorMsg = validator.errorMsg;
    validations.passwordIsValid = validator.isValid;
    _updateHasErrors();
    setState(() {});
  }

  _updateHasErrors() {
    validations.hasErrors = !validations.userIsValid || 
                        !validations.mailIsValid ||
                        !validations.mailConfirmIsValid ||
                        !validations.passwordIsValid ||
                        !validations.passwordConfirmIsValid ||
                        !validations.phoneIsValid;
  }
}