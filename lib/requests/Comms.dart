import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:dio/dio.dart';
import 'package:frontend/creds.dart';

Dio dio = Dio(
  BaseOptions(
    connectTimeout: Duration(seconds: 5),
    headers: {'Content-Type': 'application/json'},
  ),
);

class Comms {
  Map<String, dynamic> _handleErrorResponse(Response response) {
    print("Error ${response.statusCode}: ${response.data}");

    switch (response.statusCode) {
      case 403:
        return {"success": false, "rsp": response.data};
      case 401:
        return {
          "success": false,
          "rsp": "Unauthorized: Please check your token.",
        };
      case 400:
        return {"success": false, "rsp": "Bad Request: ${response.data}"};
      case 500:
        return {"success": false, "rsp": "Server Error: ${response.data}"};
      default:
        return {
          "success": false,
          "rsp": "Error ${response.statusCode}: ${response.data}",
        };
    }
  }


  Future<Map<String, dynamic>> getRequests({
    required String endpoint,
    bool? isServer,
  }) async {
    final String url = "${isServer!=null? serverUrl:baseUrl}/$endpoint";
    try {
      print("Hitting endpoint: $url");
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        return {"success": true, "rsp": response.data};
      } else if (response.statusCode == 400) {
        // Handle bad request errors
        return {
          "success": false,
          "rsp": response.data['message'] ?? 'Bad request error',
          "statusCode": 400,
        };
      } else if (response.statusCode == 401) {
        // Handle unauthorized errors
        return {
          "success": false,
          "rsp": "Unauthorized access",
          "statusCode": 401,
        };
      } else {
        // Handle other errors
        return {
          "success": false,
          "rsp": response.data['message'] ?? 'Unknown error occurred',
          "statusCode": response.statusCode,
        };
      }
    } on DioException catch (e) {
      print("DioException: ${e.message}");
      print("DioException type: ${e.type}");
      print("DioException response: ${e.response?.data}");

      // Handle different types of DioException
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          return {
            "success": false,
            "rsp": "Connection timeout",
            "statusCode": e.response?.statusCode,
          };
        case DioExceptionType.receiveTimeout:
          return {
            "success": false,
            "rsp": "Server not responding",
            "statusCode": e.response?.statusCode,
          };
        case DioExceptionType.badResponse:
          return {
            "success": false,
            "rsp": e.response?.data['message'] ?? "Server error occurred",
            "statusCode": e.response?.statusCode,
          };
        default:
          return {
            "success": false,
            "rsp": "Network error occurred",
            "statusCode": e.response?.statusCode,
          };
      }
    } catch (e) {
      print("General error: $e");
      return {"success": false, "rsp": "An unexpected error occurred"};
    }
  }


// POST request
    Future<Map<String, dynamic>> postRequest({
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    try {
      print("Request data: $data");
      final String url = "$baseUrl/$endpoint";
      print("Hitting endpoint: $url");

      final response = await dio.post(
        url,
        data: data,
      );

      print(response.data);

      // Handle different status codes
      // create
      if (response.statusCode == 201) {
        return {
          "success": true,
          "rsp": response.data,
        };
      }
      //  login
      else if (response.statusCode == 200) {
        return {
          "success": true,
          "rsp": response.data,
        };
      }
       else if (response.statusCode == 400) {
        // Handle bad request errors
        return {
          "success": false,
          "rsp": response.data['message'] ?? 'Bad request error',
          "statusCode": 400
        };
      } 
      else if (response.statusCode == 401) {
        // Handle unauthorized errors
        if (response.data['message'] != null && 
        response.data['message']['text'] == 'Account is locked') {
          return {
        "success": false,
        "rsp": response.data['message']['text'],
        "nextAttempt": response.data['message']['nextAttempt'],
        "statusCode": 401
          };
        }
        return {
          "success": false,
          "rsp": response.data['message'] ?? 'Unauthorized access',
          "statusCode": 401
        };
      }
      else {
        // Handle other errors
        return {
          "success": false,
          "rsp": response.data['message'] ?? 'Unknown error occurred',
          "statusCode": response.statusCode
        };
      }
    } on DioException catch (e) {
      print("DioException: ${e.message}");
      print("DioException type: ${e.type}");
      print("DioException response: ${e.response?.data}");

      // Handle different types of DioException
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          return {
            "success": false,
            "rsp": "Connection timeout",
            "statusCode": e.response?.statusCode
          };
        case DioExceptionType.receiveTimeout:
          return {
            "success": false,
            "rsp": "Server not responding",
            "statusCode": e.response?.statusCode
          };
        case DioExceptionType.badResponse:
          return {
            "success": false,
            "rsp": e.response?.data['message'] ?? "Server error occurred",
            "statusCode": e.response?.statusCode
          };
        default:
          return {
            "success": false,
            "rsp": "Network error occurred",
            "statusCode": e.response?.statusCode
          };
      }
    } catch (e) {
      print("General error: $e");
      return {
        "success": false,
        "rsp": "An unexpected error occurred",
      };
    }
  }
}
