import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static String localUserLoggedInKey = "signedIn";
  static String themeKey = "isDark";
  static String localUserNameKey = "USERNAMEKEY";
  static String localuserEmailKey = "USEREMAILKEY";

  // Saving data to local storage

  static Future<bool> saveUserLoggedInState(bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(localUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserName(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(localUserNameKey, username);
  }

  static Future<bool> saveUserLEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(localuserEmailKey, email);
  }

  // Getting data from local storage

  static Future<bool> getUserLoggedInState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("signedIn") == false) {
      return false;
    }
    return prefs.getBool(localUserLoggedInKey);
  }

  static Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isDark") == false) {
      return false;
    }
    return prefs.getBool("isDark");
  }

  static Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(localUserNameKey);
  }

  static Future<String> getUserLEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(localuserEmailKey);
  }

  //Clear Storage

  static clearStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(localUserNameKey);
    await prefs.remove(localuserEmailKey);
  }

  //checking if the logged In state exists in storage

  static Future<bool> checkLoggedInStateExistence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(localUserLoggedInKey);
  }
}
