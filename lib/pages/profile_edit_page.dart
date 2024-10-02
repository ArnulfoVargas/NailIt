import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/controllers/controllers.dart';
import 'package:tarea/widgets/widgets.dart';

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FormKeyboardHidder(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: _EditForm(),
            ),
          )
        ),
    );
  }
}

class _EditForm extends StatefulWidget {
  const _EditForm({super.key});

  @override
  State<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<_EditForm> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  late UserController userData;
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
    
        CustomGradientButton(
          onPressed: _onApply,
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
            CustomGradientTextButton(
              height: 40,
              onPressed: () => Navigator.of(context).pop(),
              text: "Cancel",
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold
              ),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF416C),
                  Color(0xFFFF4B2B),
                ]
              )
            ),

            const SizedBox(width: 5,),

            CustomGradientTextButton(
              height: 40,
              onPressed: () {
                Navigator.of(context).pop();
                _applyChanges();
              },
              text: "Apply",
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF134E5E),
                  Color(0xFF71B280),
                ]
              )
            ),
          ],
        );
      }
    );
  }

  void _updateControllers(UserController controller) {
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
    validations = UserController.validateAllFields(
      mail: mailController.text,
      password: passController.text,
      username: userController.text,
      phone: phoneController.text
    );
  }

  _applyChanges() {
    _validateInputs();
    setState(() {});
    if (validations.hasErrors) {
      _pop();
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

    Navigator.pop(context);
  }

  _pop() {
    Navigator.of(context).pop();
  }

  _showAddChagesAlert() {
    Navigator.of(context).pop();

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
        content: const Text("You must add some changes to apply them"),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        actions: [
          CustomGradientTextButton(
            height: 40,
            onPressed: () => Navigator.of(context).pop(),
            text: "Ok",
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF134E5E),
                Color(0xFF71B280),
              ]
            )
          ),
        ],
      )
    );
  }

  _validateUser(String value) {
    final validator = UserController.validateUsername(value);
    validations.userErrorMsg = validator.errorMsg;
    validations.userIsValid = validator.isValid;
    setState(() {});
  }

  _validatePhone(String value) {
    final validator = UserController.validatePhone(value);
    validations.phoneErrorMsg = validator.errorMsg;
    validations.phoneIsValid = validator.isValid;
    setState(() {});
  }

  _validateMail(String value) {
    final validator = UserController.validateMail(value);
    validations.mailErrorMsg = validator.errorMsg;
    validations.mailIsValid = validator.isValid;
    setState(() {});
  }

  _validatePass(String value) {
    final validator = UserController.validatePassword(value);
    validations.passwordErrorMsg = validator.errorMsg;
    validations.passwordIsValid = validator.isValid;
    setState(() {});
  }
}