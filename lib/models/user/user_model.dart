import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarea/utils/utils.dart';

class UserModel {
  int id = 0;
  bool loaded = false;
  String username = "";
  String mail = "";
  String password = "";
  String phone = "";
  String? profileImage;
  int userType;

  UserModel({this.mail = "", this.loaded = false, this.password = "", this.phone = "", this.username = "", this.profileImage, this.id = -1, this.userType = -1});

  UserModel copyWith({String? username, String? mail, String? password, String? phone, String? profileImage}) {
    final user = UserModel(
      mail: mail ?? this.mail,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      username: username ?? this.username,
      id: id,
      userType: userType
    );
    if (profileImage == null) {
      user.profileImage = this.profileImage;
    } else {
      user.profileImage = profileImage;
    } 

    return user;
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

  Future<UserModel> loadData() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String tk = sh.getString("tk") ?? "";

    if (tk == "") {
      return UserModel(
        id: -1,
        loaded: true
      );
    }
    try {
      final url = Uri.https(NailUtils.baseRoute, "user/validate");
      final res = await http.post(url, body: jsonEncode({"pauth":tk}));
      final data = jsonDecode(res.body);
      final user = data["body"]["user"];

      return UserModel(
        id: data["body"]["id"],
        username: user["name"],
        mail: user["mail"],
        phone: user["phone"],
        password: user["password"],
        profileImage: user["image_url"],
        userType: user["user_type"],
        loaded: true
      );
    } catch(error) {
      sh.remove("tk");
      return UserModel(
        id: -1,
        loaded: true
      );
    }
 
  }

  Future<UserModel> clearData() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    sh.remove("tk");

    return UserModel();
  }

  Future<Map<String, dynamic>> updateUser() async {

    try {
      final uri = Uri.https(NailUtils.baseRoute, "user/update/$id");
      final res = await http.patch(uri, body: jsonEncode(toJson()));
      final data = jsonDecode(res.body);

      final ok = data["status"] == 200;

      if (ok) {
        final body = data["body"];
        SharedPreferences.getInstance().then((sh) {
          sh.setString("tk", body["tk"]);
        });

        final user = data["body"]["user"];
        username = user["name"];
        mail = user["mail"];
        phone = user["phone"];
        password = user["password"];

        return {
          "ok" : true
        };
      }

      return {
        "ok" : false,
        "error": data["error_msg"]
      };
    } catch (e) {
      return {
        "ok": false,
        "error": "Couldnt connect to service, try again later"
      };
    }
  }

  Future<Map<String, dynamic>> register() async {
    try {
      final uri = Uri.https(NailUtils.baseRoute, "user/register");
      final res = await http.post(uri, body: jsonEncode(toJson()));
      final data = jsonDecode(res.body);
      final ok = data["status"] == 201;

      if (ok) {
        SharedPreferences.getInstance().then((sh) {
          sh.setString("tk", data["body"]["tk"]);
        });

        final user = data["body"]["user"];
        username = user["name"];
        mail = user["mail"];
        phone = user["phone"];
        password = user["password"];
        userType = user["user_type"];
        profileImage = user["image_url"];
        id = data["body"]["id"];

        return {
          "ok" : ok,
          "id" : data["body"]["id"],
        };
      }

      return {
        "ok" : false,
        "error" : data['error_msg']
      };
    } catch (e) {
      return {
        "ok": false,
        "error": "Couldnt connect to service, try again later"
      };
    }
  }

  Future<Map<String, dynamic>> loginUser() async {
    try {
      final uri = Uri.https(NailUtils.baseRoute, "user/login");
      final res = await http.post(uri, body: jsonEncode(toJson()));
      final data = jsonDecode(res.body);
      final ok = data["status"] == 200;

      if (ok) {
        SharedPreferences.getInstance().then((sh) {
          sh.setString("tk", data["body"]["tk"]);
        });

        final user = data["body"]["user"];
        username = user["name"];
        mail = user["mail"];
        phone = user["phone"];
        password = user["password"];
        profileImage = user["image_url"];
        userType = user["user_type"];
        id = data["body"]["id"];

        return {
          "ok" : true,
          "id" : data["body"]["id"]
        };
      }

      return {
        "ok" : false,
        "error" : data['error_msg']
      };
    } catch (e) {
      return {
        "ok": false,
        "error": "Couldnt connect to service, try again later"
      };
    }
  }

  Future<Map<String, dynamic>> updateImage() async {
    try {
      if (profileImage == null || id < 0) {
        return {
          "ok" : false,
          "error" : "No such image"
        };
      }

      final uri = Uri.https(NailUtils.baseRoute, "user/profile/$id");
      final req = http.MultipartRequest("PUT", uri);
      final file = await http.MultipartFile.fromPath("file", profileImage!);
      req.files.add(file);
      final stream = await req.send();
      final res = await http.Response.fromStream(stream);
      final data = jsonDecode(res.body);

      if (data["status"] != 200) {
        return {
          "ok" : false,
          "error": data["error_msg"]
        };
      }

      profileImage = data["body"];

      return {
        "ok" : true,
      };
    } catch (e) {
      return {
        "ok": false,
        "error": "Couldnt connect to service, try again later"
      };
    }
  } 

  Future<Map<String, dynamic>> removeImage() async {
    try {
      final uri = Uri.https(NailUtils.baseRoute, "user/profile/$id");
      final req = await http.delete(uri);
      final data = jsonDecode(req.body);

      if (data["status"] != 200) {
        return {
          "ok" : false,
          "error": data["error_msg"]
        };
      }

      profileImage = "";
      return {
        "ok" : true
      };
    } catch (e) {
      return {
        "ok": false,
        "error": "Couldnt connect to service, try again later"
      };
    }
  }

  Future<Map<String, dynamic>> convertToPremium() async {
    try {
      final uri = Uri.https(NailUtils.baseRoute, "user/premium/$id");
      final req = await http.patch(uri);
      final data = jsonDecode(req.body);

      if (data["status"] != 200) {
        return {
          "ok" : false,
          "error": data["error_msg"]
        };
      }

      userType = 1;

      return {
        "ok" : true
      };
    } catch (e) {
      return {
        "ok": false,
        "error": "Couldnt connect to service, try again later"
      };
    }
  }

  Map<String ,dynamic> toJson() {
    return {
      "name" : username,
      "mail" : mail,
      "phone": phone,
      "password": password
    };
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

