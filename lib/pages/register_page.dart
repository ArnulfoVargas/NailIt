import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/models/models.dart';
import 'package:tarea/widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  ValidationResult validations = ValidationResult();

  bool passObscureText = true;
  bool passConfirmObscureText = true;
  bool isValidating = false;

  final TextEditingController userController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController mailConfirmController = TextEditingController();
  final TextEditingController passConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormKeyboardHidder(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  const SizedBox(height: 50, width: double.infinity,),

                  const Image(
                    image: AssetImage("images/LogoNailItI.png"),
                    color: Color(0xFF229799),
                    height: 100,
                  ),
                      
                  const Text("Register",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF424242)
                    ),
                  ),
              
                  const SizedBox(height: 20,),
                      
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
                    onChanged: _validateMailConfirm,
                    controller: mailConfirmController,
                    autocorrect: true,
                    hasError: !validations.mailConfirmIsValid,
                    icon: Icons.mail,
                    inputType: TextInputType.emailAddress,
                    labelText: "Confirm Mail",
                    errorText: validations.mailConfirmErrorMsg,
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
                      
                  CustomInput(
                    onChanged: _validatePassConfirm,
                    controller: passConfirmController,
                    autocorrect: false,
                    hasError: !validations.passwordConfirmIsValid,
                    icon: Icons.security,
                    inputType: TextInputType.visiblePassword,
                    labelText: "Confirm Password",
                    errorText: validations.passwordConfirmErrorMsg,
                    obscureText: passConfirmObscureText,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          passConfirmObscureText = !passConfirmObscureText;
                        });
                      }, 
                      icon: Icon(passConfirmObscureText ? Icons.visibility : Icons.visibility_off, color: Colors.black38,)
                    ),
                  ),
                      
                  const SizedBox(height: 50,),
              
                  CustomElevatedButton(
                    onPressed: !isValidating && !validations.hasErrors ? _registerUser : null,
                    text: "Register",
                  ),
                      
                  const SizedBox(height: 100,),
        
                  CustomLabeledTextbutton(
                    topText: "Already have an account?",
                    buttonText: "Login now",
                    onPressed: () => Navigator.of(context).pop("login"),
                  )
                ],
              ),
            ),
          )
        ),
      ),
    );
  }

  _validateInputs() {
    validations = UserModel.validateAllFields(
      username: userController.text,
      phone: phoneController.text,
      mail: mailController.text, 
      mailConfirm: mailConfirmController.text,
      password: passController.text,
      passwordConfirm: passConfirmController.text
    );
  }

  _registerUser() {
    _validateInputs();

    if (!validations.hasErrors) {
      isValidating = true;
      _saveAndPush();
    } 
    setState(() {});
  }

  _saveAndPush() async {
    await context.read<UserBloc>().storeAndUpdate(
      username: userController.text, 
      mail: mailController.text, 
      phone: phoneController.text, 
      password: passController.text
    );
    _goHome();
  }

  _goHome() {
    Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => !route.isActive);
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

  _validateMailConfirm(String value) {
    if (value != mailController.text) {
      validations.mailConfirmIsValid = false;
      validations.mailConfirmErrorMsg = "Mails does not match";
    } else {
      final validator = UserModel.validateMail(value);
      validations.mailConfirmErrorMsg = validator.errorMsg;
      validations.mailConfirmIsValid = validator.isValid;
    }
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
  _validatePassConfirm(String value) {
    if (value != passController.text) {
      validations.passwordConfirmIsValid = false;
      validations.passwordConfirmErrorMsg = "Passwords does not match";
    } else {
      final validator = UserModel.validatePassword(value);
      validations.passwordConfirmErrorMsg = validator.errorMsg;
      validations.passwordConfirmIsValid = validator.isValid;
    }
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