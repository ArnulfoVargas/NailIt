import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  bool loaded = false;
  String username = "";
  String mail = "";
  String password = "";
  String phone = "";
  String? profileImage;

  UserModel({this.mail = "", this.loaded = false, this.password = "", this.phone = "", this.username = "", this.profileImage});

  UserModel copyWith({String? username, String? mail, String? password, String? phone, String? profileImage}) {
    final user = UserModel(
      mail: mail ?? this.mail,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      username: username ?? this.username
    );
    if (profileImage == null) {
      user.profileImage = this.profileImage;
    } else {
      var file = File(profileImage);
      if (file.existsSync()) {
        user.profileImage = profileImage;
      } else {
        user.profileImage = null;
      }
    }
    return user;
  }

  Future<UserModel> loadData() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    return UserModel(
      username: sh.getString("user") ?? "",
      mail: sh.getString("mail") ?? "",
      password: sh.getString("pass") ?? "",
      phone: sh.getString("phone") ?? "",
      profileImage: sh.getString("profileImg"),
      loaded: true
    );
  }

  Future<UserModel> clearData() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    await sh.clear();

    return UserModel();
  }

  Future<void> saveData() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    sh.setString("user", username);
    sh.setString("mail", mail);
    sh.setString("pass", password);
    sh.setString("phone", phone);
    if (profileImage != null){
      sh.setString("profileImg", profileImage!);
    }
  }

  static bool _isValidEmail(String value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value.isNotEmpty && regex.hasMatch(value);
  }

  static bool _isValidPassword(String value) {
    const pattern = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$";
    final regex = RegExp(pattern);

    return value.isNotEmpty && regex.hasMatch(value);
  }

  static bool _isValidUsername(String value) {
    const pattern = r"[a-zA-Z]{6,18}";
    final regex = RegExp(pattern);
    return value.isNotEmpty && regex.hasMatch(value);
  }

  static bool _isValidPhoneNumber(String value) {
    const pattern = r"^(\+\d{1,2}\s?)?1?\-?\.?\s?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$";
    final regex = RegExp(pattern);
    return value.isNotEmpty && regex.hasMatch(value);
  }

  static SingleValidResult _uniqueValidate({required bool Function(String) validatorFunction, required String value, String emptyMsg = "Empty Field", required String unsatisfiedMessage}){
    SingleValidResult result = SingleValidResult();

    if (value.isEmpty) {
      result.errorMsg = emptyMsg;
      result.isValid = false;
    } else {
      bool isValid = validatorFunction(value);
      result.errorMsg = unsatisfiedMessage;
      result.isValid = isValid;
    }

    return result;
  }

  static SingleValidResult validateMail(String value) {
    return _uniqueValidate(
      validatorFunction: _isValidEmail, 
      value: value, 
      unsatisfiedMessage: "Invalid mail"
    );
  }

  static SingleValidResult validatePassword(String value) {
    return _uniqueValidate(
      validatorFunction: _isValidPassword, 
      value: value, 
      emptyMsg: "Must have at least 8 characters",
      unsatisfiedMessage: "Must have at least 1 character and 1 number"
    );
  }

  static SingleValidResult validateUsername(String value) {
    return _uniqueValidate(
      validatorFunction: _isValidUsername, 
      value: value, 
      unsatisfiedMessage: "Must have between 6-18 characters"
    );
  }

  static SingleValidResult validatePhone(String value) {
    return _uniqueValidate(
      validatorFunction: _isValidPhoneNumber, 
      value: value, 
      unsatisfiedMessage: "Invalid phone number"
    );
  }

  static ValidationResult validateAllFields({required String mail, required String password, String? username, String? phone, String? mailConfirm, String? passwordConfirm}) {
    ValidationResult result = ValidationResult();

    SingleValidResult mailValid = validateMail(mail);

    result.mailIsValid = mailValid.isValid;
    result.mailErrorMsg = mailValid.errorMsg;

    SingleValidResult passwordValid = validatePassword(password);

    result.passwordIsValid = passwordValid.isValid;
    result.passwordErrorMsg = passwordValid.errorMsg;

    if (username != null) {
      SingleValidResult userValid = validateUsername(username);

      result.userIsValid = userValid.isValid;
      result.userErrorMsg = userValid.errorMsg;
    }

    if (phone != null) {
      SingleValidResult phoneValid = validatePhone(phone);

        result.phoneIsValid = phoneValid.isValid;
        result.phoneErrorMsg = phoneValid.errorMsg;
    }

    if (mailConfirm != null) {
      if (mailConfirm != mail) {
        result.mailConfirmIsValid = false;
        result.mailConfirmErrorMsg = "Mail does not match";
      } else {
        result.mailConfirmIsValid = mailValid.isValid;
        result.mailConfirmErrorMsg = mailValid.errorMsg;
      }
    }

    if (passwordConfirm != null) {
      if (passwordConfirm != password) {
        result.passwordConfirmIsValid = false;
        result.passwordConfirmErrorMsg = "Password does not match";
      } else {
        result.passwordConfirmIsValid = passwordValid.isValid;
        result.passwordConfirmErrorMsg = passwordValid.errorMsg;
      }
    }

    result.hasErrors =  !result.userIsValid || 
                        !result.mailIsValid ||
                        !result.mailConfirmIsValid ||
                        !result.passwordIsValid ||
                        !result.passwordConfirmIsValid ||
                        !result.phoneIsValid;

    return result;
  } 
}

class SingleValidResult {
  bool isValid = true;
  String errorMsg = "";
}

class ValidationResult {
  bool hasErrors = false;

  bool userIsValid = true;
  String userErrorMsg = "";

  bool mailIsValid = true;
  String mailErrorMsg = "";

  bool mailConfirmIsValid = true;
  String mailConfirmErrorMsg = "";

  bool passwordIsValid = true;
  String passwordErrorMsg = "";

  bool passwordConfirmIsValid = true;
  String passwordConfirmErrorMsg = "";

  bool phoneIsValid = true;
  String phoneErrorMsg = "";
}