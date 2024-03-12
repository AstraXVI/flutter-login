import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:sample/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const users = {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
      const url =  'http://192.168.1.136:8012/flutterBE/match.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'email': data.name,
          'password': data.password,
        },

      );

      // Log response
      debugPrint('Response: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'error') {
          // Handle error
          return responseData['message'];
        } else {
          // User authenticated successfully
          return null;
        }
      } else {
        // Handle error
        return 'Failed to authenticate';
      }
    } catch (e) {
      // Handle exceptions
      return 'Error: $e';
    }
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Sample',
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
