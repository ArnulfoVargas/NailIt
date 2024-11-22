import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea/blocs/blocs.dart';
import 'package:tarea/models/user/user_model.dart';
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
                  const SizedBox(height: 50, width: double.infinity,),

                  const Image(
                    image: AssetImage("images/LogoNailItI.png"),
                    color: Color(0xFF229799),
                    height: 100,
                  ),

              
                  const Text("Login",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF424242)
                    ),
                  ),
              
                  const SizedBox(height: 20,),
              
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
                    onPressed: !isValidating && !validations.hasErrors ? _loginUser : null,
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
    validations = UserModel.validateAllFields(mail: mailController.text, password: passController.text);
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

    final result = await context.read<UserBloc>().loginUser(mail: mailController.text, password: passController.text);

    if (result["ok"]) {
      _navigateToHome();
    } else {
      isValidating = false;
      _showError(context, result["error"]);
      setState(() {});
    }
  }

  _navigateToHome() {
    context.read<CurrentPageBloc>().setCurrentPage(0);
    Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => !route.isActive);
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
    validations.hasErrors = !validations.mailIsValid ||
                        !validations.passwordIsValid;
  }
   _showError(BuildContext context, String errorMsg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 252, 49, 49),
        dismissDirection: DismissDirection.down,
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        content: Text(errorMsg,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      )
    );
  }
}