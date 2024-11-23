import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarea/utils/utils.dart';
import 'package:http/http.dart' as http;

class TagModel {
  final int id;
  final String title;
  final Color color;
  const TagModel({required this.title, required this.color, this.id = 0});

  static bool isValidTagName(String value) {
    const pattern = r"^(?:[A-Za-z]{3,15})?$";
    final regex = RegExp(pattern);
    return value.isNotEmpty && regex.hasMatch(value);
  }

  Map<String, dynamic> toJson() {
    return {
      "title" : title,
      "color" : color.value,
    };
  }

  TagModel.fromJson(Map<String, dynamic> json) 
    : title = json["title"] as String,
      color = Color(json["color"] as int),
      id = json["id_tag"] as int; 
}

class TagDto {
  late final String title;
  late final Color color;
  late final int createdBy;

  TagDto(TagModel tag, int id) {
    title = tag.title;
    color = tag.color;
    createdBy = id;
  }

  Map<String, dynamic> toJson() {
    return {
      "title" : title,
      "color" : color.value,
      "created_by" : createdBy
    };
  }

  TagDto.fromJson(Map<String, dynamic> json)
    : title = json["title"],
      color = Color(json["color"] as int),
      createdBy = json["created_by"] as int;
}

class TagsModel {
  Map<int, TagModel> _tags = {};
  Map<int, TagModel> get getTags => _tags;

  TagsModel({Map<int, TagModel>? tags}) {
    _tags = tags ?? <int, TagModel>{};
  }

  Future<Map<String, dynamic>> removeTag(int idTag, int idUser, TagModel t) async {
    try {
      final uri = Uri.https(NailUtils.baseRoute, "tags/delete/$idTag");
      final res = await http.delete(uri, body: jsonEncode(<String, dynamic>{
        "title" : t.title,
        "color" : t.color.value,
        "created_by" : idUser
      })).timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        _tags.remove(idTag);

        return {
          "state" : copyWith(tags: _tags),
          "ok" : true,
          "error" : ""
        };
      }

      return {
        "state" : this,
        "ok" : false,
        "error" : "Cannot delete tag"
      };
    } catch (e) {
      return {
        "state" : this,
        "ok" : false,
        "error" : "Internal server error"
      };
    }
  }

  Future<Map<String, dynamic>> addTag(TagModel t, int id) async {
    try {
      final uri = Uri.https(NailUtils.baseRoute, "tags/create");
      final res = await http.post(uri, body: jsonEncode(<String, dynamic>{
        "title" : t.title,
        "color" : t.color.value,
        "created_by" : id
      })).timeout(const Duration(seconds: 5));

      final data = jsonDecode(res.body);
      final body = data["body"];
      final tag = body["tag"];

      if (res.statusCode == 201) {
        _tags[body["id"]] = TagModel(title: tag["title"], color: Color(tag["color"] as int), id: body["id"]);

        return {
          "state" : copyWith(tags: _tags),
          "ok" : true,
          "error" : ""
        };
      }

      return {
        "state" : this,
        "ok" : false,
        "error" : "Cannot create tag"
      };
    } catch (e) {
      return {
        "state" : this,
        "ok" : false,
        "error" : "Internal server error"
      };
    }
  }

  Future<Map<String, dynamic>> editTag(int idTag, int idUser, TagModel t) async {
    try {
      final uri = Uri.https(NailUtils.baseRoute, "tags/update/$idTag");
      final res = await http.put(uri, body: jsonEncode(<String, dynamic>{
        "title" : t.title,
        "color" : t.color.value,
        "created_by" : idUser
      })).timeout(const Duration(seconds: 5));

      final data = jsonDecode(res.body);
      final tag = data["body"];

      if (res.statusCode == 200) {
        _tags[idTag] = TagModel(title: tag["title"], color: Color(tag["color"] as int), id: idTag);

        return {
          "state" : copyWith(tags: _tags),
          "ok" : true,
          "error" : ""
        };
      }

      return {
        "state" : this,
        "ok" : false,
        "error" : "Cannot create tag"
      };
    } catch (e) {
      return {
        "state" : this,
        "ok" : false,
        "error" : "Internal server error"
      };
    }
  }

  Future<Map<String, dynamic>> loadData(int userId) async {
     try {
      final uri = Uri.https(NailUtils.baseRoute, "tags/user/$userId");
      final res = await http.get(uri).timeout(const Duration(seconds: 5));

      final data = jsonDecode(res.body);
      final body = data["body"];

      for (int i = 0; i < (body as List<dynamic>).length; i++) {
        final tag = body[i];
        int id = tag["id"] as int;

        _tags[id] = TagModel(
          title: tag["title"], 
          color: Color(tag["color"] as int),
          id: id
        );
      }

      if (res.statusCode == 200) {
        return {
          "state" : copyWith(tags: _tags),
          "ok" : true,
          "error" : ""
        };
      }

      return {
        "state" : this,
        "ok" : false,
        "error" : "Cannot create tag"
      };
    } catch (e) {
      return {
        "state" : this,
        "ok" : false,
        "error" : "Internal server error"
      };
    }
  }

  Future<TagsModel> clearData() async {
    final sh = await SharedPreferences.getInstance();
    sh.remove("tags");

    return TagsModel();
  }

  TagsModel copyWith({Map<int, TagModel>? tags}) {
    return TagsModel(tags: tags ?? _tags);
  }
}

class TagArguments {
  final bool isEditing;
  final TagModel? tag;
  final int tagId;

  TagArguments({this.tagId = 0,this.isEditing = false, this.tag});
}