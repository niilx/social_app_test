/*
 *
 * @author Md. Touhidul Islam
 * @ updated at 12/14/21 4:26 PM.
 * /
 */

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../helpers/projectResources.dart';
import 'apis.dart';

class NetworkManager {
  static Future<http.Response> getDataFromApi(
      {required String apiUrl, String? token}) async {
    http.Response response = http.Response("Something went wrong", 500);

    bool internetOn = await ProjectResource.internetConnection();
    if (kDebugMode) {
      print("API End: $apiUrl");
      print("token: $token");
      print("Token: $token");
      print("internet Status");
      print(internetOn);
    }
    if (internetOn) {
      try {
        await http
            .get(Uri.parse(ApiEnd.baseUrl + apiUrl), headers: {
          "Accept": 'application/json',
          "Authorization": 'Bearer $token',
        })
            .timeout(Duration(seconds: 30))
            .then((val) {
          response = val;
          // print("status code Token:${response.statusCode}");
          // print(response.body);
        });
      } catch (e) {
        print(e);
        return response;
      }
    } else {
      print(" Not Connected");
      ProjectResource.showToast("Check internet connection", true);
    }
    return response;
  }

  static Future<http.Response> postDataToApi(
      {required String apiUrl, String? token, dynamic jsonData}) async {
    http.Response response = http.Response("Something went wrong", 500);
    bool internetOn = await ProjectResource.internetConnection();
    if (kDebugMode) {
      print("API End: ${ApiEnd.baseUrl}$apiUrl");
      print("Json: $jsonData");
      print("internet Status");
      print("Token: $token");
      print(internetOn);
    }

    if (internetOn) {
      String bToken = '';
      if(token != null) {
        bToken = 'Bearer $token';
      }

      try {
        await http
            .post(Uri.parse(ApiEnd.baseUrl + apiUrl),
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
              "Authorization": bToken,
            },
            body: jsonData)
            .timeout(Duration(seconds: 30))
            .then((val) {
          response = val;
          print("status code Token:${response.statusCode}");
          print(response.body);
        });
      } catch (e) {
        print(e);
        return response;
      }
    } else {
      print(" Not Connected");
      ProjectResource.showToast("Check internet connection", true);
    }
    return response;
  }

  static Future<http.Response> patchDataToApi(
      {required String apiUrl, String? token, dynamic jsonData}) async {
    http.Response response = http.Response("Something went wrong", 500);
    bool internetOn = await ProjectResource.internetConnection();
    if (kDebugMode) {
      print("API End: ${ApiEnd.baseUrl}$apiUrl");
      print("Json: $jsonData");
      print("internet Status");
      print("Token: $token");
      print(internetOn);
    }
    if (internetOn) {
      print("Connected");
      try {
        await http
            .patch(Uri.parse(ApiEnd.baseUrl + apiUrl),
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
              "Authorization": 'Bearer $token',
            },
            body: jsonData)
            .timeout(Duration(seconds: 30))
            .then((val) {
          response = val;
          print("status code Token:${response.statusCode}");
          print(response.body);
        });
      } catch (e) {
        print(e);
        return response;
      }
    } else {
      print(" Not Connected");
      ProjectResource.showToast("Check internet connection", true);
    }
    return response;
  }

  static Future<http.Response> putDataToApi(
      {required String apiUrl, String? token, dynamic jsonData}) async {
    http.Response response = http.Response("Something went wrong", 500);
    bool internetOn = await ProjectResource.internetConnection();
    if (kDebugMode) {
      print("API End: ${ApiEnd.baseUrl}$apiUrl");
      print("Json: $jsonData");
      print("internet Status");
      print("Token: $token");
      print(internetOn);
    }
    if (internetOn) {
      print("Connected");
      try {
        await http
            .put(Uri.parse(ApiEnd.baseUrl + apiUrl),
            headers: {
              "Authorization": 'Bearer $token',
            },
            body: jsonData)
            .timeout(Duration(seconds: 30))
            .then((val) {
          response = val;
          print("status code Token:${response.statusCode}");
          print(response.body);
        });
      } catch (e) {
        print(e);
        return response;
      }
    } else {
      print(" Not Connected");
      ProjectResource.showToast("Check internet connection", true);
    }
    return response;
  }

  static Future<http.Response> deleteDataToApi(
      {required String apiUrl, String? token, dynamic jsonData}) async {
    http.Response response = http.Response("Something went wrong", 500);
    bool internetOn = await ProjectResource.internetConnection();
    if (kDebugMode) {
      print("API End: ${ApiEnd.baseUrl}$apiUrl");
      print("Json: $jsonData");
      print("internet Status");
      print("Token: $token");
      print(internetOn);
    }
    if (internetOn) {
      print("Connected");
      try {
        await http
            .delete(Uri.parse(ApiEnd.baseUrl + apiUrl),
            headers: {
              "Accept": "application/json",
              "Authorization": 'Bearer $token',
            },
            body: jsonData)
            .timeout(const Duration(seconds: 30))
            .then((val) {
          response = val;
          print("status code Token:${response.statusCode}");
          print(response.body);
        });
      } catch (e) {
        print(e);
        return response;
      }
    } else {
      print(" Not Connected");
      ProjectResource.showToast("Check internet connection", true);
    }
    return response;
  }

  static Future<http.Response> postDataToApiJson(
      {required String apiUrl, String? tokens, dynamic jsonData}) async {
    http.Response response = http.Response("Something went wrong", 500);
    bool internetOn = await ProjectResource.internetConnection();
    if (kDebugMode) {
      print("API End: ${ApiEnd.baseUrl}$apiUrl");
      print("Json: $jsonData");
      print("Token: $tokens");
      print("internet Status");
      print(internetOn);
    }
    var jsonBody = json.encode(jsonData);
    if (internetOn) {
      print("Connected");
      try {
        await http
            .post(Uri.parse(ApiEnd.baseUrl + apiUrl),
            headers: {
              "Content-Type": "application/json",
              "Authorization": 'Bearer $tokens',
            },
            body: json.encode(jsonData))
            .timeout(Duration(seconds: 30))
            .then((val) {
          response = val;
          print("status code Token:${response.statusCode}");
          print(response.body);
        });
      } catch (e) {
        print(e);
        return response;
      }
    } else {
      print(" Not Connected");
      ProjectResource.showToast("Check internet connection", true);
    }
    return response;
  }
}
