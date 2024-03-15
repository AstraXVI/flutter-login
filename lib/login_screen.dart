import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:sample/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const users = {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginData? loginData; // Declare loginData

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    const url = 'http://192.168.1.136:8012/flutterBE/match.php';
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
          // Set loginData when authentication is successful
          setState(() {
            loginData = data;
          });
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

  Future<String?> _signupUser(SignupData data) async {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    const url = 'http://192.168.1.136:8012/flutterBE/insert.php';
    try {
      final response1 = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'email': data.name,
          'password': data.password,
        },
      );

      if (response1.statusCode == 200) {
        final responseData = jsonDecode(response1.body);
        if (responseData['status'] == 'error') {
          // Handle error
          return responseData['message'];
        } else {
          return null;
        }
      } else {
        // Handle error
        return 'Failed to Register';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  // void _confirmSignupSuccess(BuildContext context, String message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Register Successfully'),
  //         content: Text(message),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
      logo: const AssetImage('assets/images/everfirst_new.png'),
      onLogin: _authUser,
      onSignup: _signupUser,//(data) async {
      // final message = await _signupUser(data);
      // if (message == null) {
        // Sign-up successful, show confirmation dialog
        // _confirmSignupSuccess(context, 'Registered Successfully');
      // } else {
      //   // Sign-up failed, show error message
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text(message),
      //   ));
      // }
      // return message; // Return message in any case
      // },
      messages: LoginMessages(
        userHint: 'Email',
        passwordHint: 'Password',
        confirmPasswordHint: 'Confirm Password',
        confirmPasswordError: 'Passwords do not match!',
        forgotPasswordButton: 'Forgot your password?',
        loginButton: 'LOG IN',
        signupButton: 'REGISTER',
        recoverPasswordButton: 'SEND',
        goBackButton: 'BACK',
        // confirmPasswordLabel: 'Confirm Password',
        recoverPasswordDescription:
            'We will send you an email to reset your password.',
        recoverPasswordSuccess: 'Password recovered successfully.',
      ),
      // additionalSignupFields: const [
      //   UserFormField(
      //     keyName: 'Username',
      //     icon: Icon(Icons.person),
      //   ),
      // ],
      onSubmitAnimationCompleted: () {
        if (loginData != null) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
        }
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
