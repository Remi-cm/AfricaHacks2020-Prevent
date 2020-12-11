import 'package:flutter/material.dart';

class UserProfileProvider with ChangeNotifier {
  String _id;
  String _name;
  String _email;
  String _phone;
  String _title;
  List _skillSet;
  String _aboutMe;
  List _friends;
  bool _isStaff;
  String _avatarUrl;
  String _createdAt;

  UserProfileProvider(
      this._id,
      this._name,
      this._email,
      this._phone,
      this._title,
      this._skillSet,
      this._friends,
      this._isStaff,
      this._avatarUrl,
      this._createdAt,
      this._aboutMe);

  String get getId => _id;
  String get getName => _name;
  String get getEmail => _email;
  String get getPhone => _phone;
  String get getTitle => _title;
  List get getSkillSet => _skillSet;
  String get getAboutMe => _aboutMe;
  List get getFriends => _friends;
  bool get getIsStaff => _isStaff;
  String get getAvatar => _avatarUrl;
  String get getCreatedAt => _createdAt;

  void setId(String newVal) {
    _id = newVal;
    notifyListeners();
  }

  void setName(String newVal) {
    _name = newVal;
    notifyListeners();
  }

  void setEmail(String newVal) {
    _email = newVal;
    notifyListeners();
  }

  void setPhone(String newVal) {
    _phone = newVal;
    notifyListeners();
  }

  void setTitle(String newVal) {
    _title = newVal;
    notifyListeners();
  }

  void setIsStaff(bool newVal) {
    _isStaff = newVal;
    notifyListeners();
  }

  void setSkillSet(List newVal) {
    _skillSet = newVal;
    notifyListeners();
  }

  void setAboutMe(String newVal) {
    _aboutMe = newVal;
    notifyListeners();
  }

  void setAvatarUrl(String newVal) {
    _avatarUrl = newVal;
    notifyListeners();
  }
}
