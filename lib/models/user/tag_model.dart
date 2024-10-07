import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class TagModel {
  final String title;
  final Color color;
  const TagModel({required this.title, required this.color});

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
      color = Color(json["color"] as int); 
}

class TagsModel {
  Map<String, TagModel> _tags = {};
  Map<String, TagModel> get getTags => _tags;

  TagsModel({Map<String, TagModel>? tags}) {
    _tags = tags ?? <String, TagModel>{};
  }

  TagsModel removeTag(String id) {
    if (!_tags.containsKey(id)) return this;
    _tags.remove(id);
    saveData();
    return TagsModel(tags: _tags);
  }

  TagsModel addTag(TagModel tag) {
    const uuid = Uuid();
    final id = uuid.v8();
    if (!_tags.containsKey(id)) _tags[id] = tag;

    saveData();
    return TagsModel(tags: _tags);
  }

  TagsModel editTag(String id, TagModel tag) {
    if (!_tags.containsKey(id)) return this;

    _tags[id] = tag;
    saveData();
    return TagsModel(tags: _tags);
  }

  Future<void> saveData() async {
    final json = jsonEncode(_tags);
    final sh = await SharedPreferences.getInstance();

    sh.setString("tags", json);
  }

  Future<TagsModel> loadData() async {
    final sh = await SharedPreferences.getInstance();
    final data = sh.getString("tags");
    if (data == null) return TagsModel();

    final decoded = jsonDecode(data);
    return TagsModel.fromJson(decoded);
  }

  Future<TagsModel> clearData() async {
    final sh = await SharedPreferences.getInstance();
    sh.remove("tags");

    return TagsModel();
  }

  Map<String, dynamic> toJson() {
    return {
      "tags" : _tags
    };
  }
  TagsModel.fromJson(Map<String, dynamic> json) {
    _tags = {};
    for (var entry in json.entries) {
      final model = TagModel(title: entry.value["title"], color: Color(entry.value["color"]));
      _tags[entry.key] = model;
    }
  }
}

class TagArguments {
  final bool isEditing;
  final TagModel? tag;
  final String tagId;

  TagArguments({this.tagId = "",this.isEditing = false, this.tag});
}