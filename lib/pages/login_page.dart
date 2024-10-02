import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/controllers/user/user_controller.dart';
import 'package:tarea/utils/utils.dart';
import 'package:tarea/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ValidationResult validations = ValidationResult();

  bool passObscureText = true;

  bool isValidating = false;

  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();

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
                  const SizedBox(height: 75, width: double.infinity,),
              
                  const Text("Login",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold
                    ),
                  ),
              
                  const SizedBox(height: 50,),
              
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
                    onPressed: !isValidating ? _loginUser : null,
                    text: "Login",
                  ),
          
                  const SizedBox(height: 100,),
          
                  CustomLabeledTextbutton(
                    topText: "Don't have an account?",
                    buttonText: "Create one!",
                    onPressed: () => Navigator.of(context).pushNamed("register"),
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  _validateInputs() {
    validations = UserController.validateAllFields(mail: mailController.text, password: passController.text);
  }

  _loginUser() {
    NailUtils.hideKeyboard(context);
    _validateInputs();

    if (!validations.hasErrors) {
      isValidating = true;
      _checkData();
    } else {
      setState(() {});
    }
  }

  _checkData() async {

    if (mailController.text != "test@test.com") {
      validations.mailIsValid = false;
      validations.hasErrors = true;
    }
    if (passController.text != "1asd1asd") {
      validations.passwordIsValid = false;
      validations.hasErrors = true;
    }

    if (validations.hasErrors) return;

    await _storeDefaultData();
    _navigateToHome();
  }

  _storeDefaultData() {
    context.read<UserBloc>().storeAndUpdate(
      username: "Arnulfo", 
      mail: mailController.text, 
      password: passController.text, 
      phone: "0123456789"
    );
  }

  _navigateToHome() {
    Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => !route.isActive);
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