import 'package:codesafari/src/features/authentication/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

// Define the LoginResponse class with better null safety and error handling
class LoginResponse {
  final String? message;
  final String? accessToken;
  final String? refreshToken;
  final String? errorMessage;
  final String? fullname;
  final String? username;
  final List<Map<String, dynamic>>? qa_history;

  LoginResponse({this.message, this.accessToken, this.refreshToken, this.errorMessage, this.fullname , this.username, this.qa_history});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error')) {
      return LoginResponse(errorMessage: json['error']);
    } else {
      return LoginResponse(
        message: json['message'] as String?,
        accessToken: json['tokens']?['access_token'] as String?,
        refreshToken: json['tokens']?['refresh_token'] as String?,
        fullname: json['fullname'] as String?,
        username: json['username'] as String?,
        qa_history: (json['qa_history'] as List<dynamic>?)
            ?.map((item) => {
          'question': item['question'] as String,
          'answer': item['answer'] as Map<String, dynamic>,
        })
            .toList(),
      );
    }
  }
}

// Define a class for managing authentication
class AuthRepositoryLocal {
  final Uri _url_Login = Uri.parse('${dotenv.env['BE_URL']}${dotenv.env['BE_LOGIN_URL']}');
  final Uri _url_Register = Uri.parse('${dotenv.env['BE_URL']}${dotenv.env['BE_REGISTER_URL']}');
  final Map<String, String> _headers = {'Content-Type': 'application/json'};
  var logger = Logger();

  Future login(String username, String password) async {
    final body = jsonEncode({'username': username, 'password': password});

    try {
      final response = await http.post(_url_Login, headers: _headers, body: body);

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(jsonResponse);
      } else {
        return LoginResponse.fromJson(jsonResponse);
      }
    } catch (error) {
      return LoginResponse(errorMessage: 'Error during login: $error');
    }
  }

  Future signup(UserModel user) async {

    final body = jsonEncode({
      'username': user.email,
      'password': user.password,
      'fullname': user.fullName,
      'phoneNo': user.phoneNo,
    });

    try {
      final response = await http.post(_url_Register, headers: _headers, body: body);

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return LoginResponse.fromJson(jsonResponse);
      } else {
        return LoginResponse.fromJson(jsonResponse);
      }
    } catch (error) {
      return LoginResponse(errorMessage: 'Error during signup: $error');
    }
  }
}


