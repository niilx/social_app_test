/*
 *
 * @author Md. Touhidul Islam
 * @ updated at 12/14/21 4:26 PM.
 * /
 */

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static Future<Map<String, dynamic>?> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);
    if (jsonString != null && jsonString.isNotEmpty) {
      return json.decode(jsonString);
    }
    return null;
  }

  static remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static contain(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  static save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }
}
