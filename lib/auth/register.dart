import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../my_voids.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {


  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> registerButtonPressed() async {
    // Check if all fields are filled
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      dialogShow('Error', 'Please fill all fields');
      return;
    }

    // Email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(_emailController.text)) {
      dialogShow('Error', 'Please enter a valid email address');
      return;
    }

    // Password validation
    if (_passwordController.text.length < 8) {
      dialogShow('Error', 'Password must be at least 8 characters long');

      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ).then((value) {// register success auth
        addDocument(fieldsMap: {
          'name': _nameController.text,
          'email': _emailController.text,
          'pwd': _passwordController.text,
          'isAdmin': false,
          'verified': false,
        }, collName: 'users').then((value) {
          // Show registration successful message
          dialogShow(
            'Registration Successful',
            'Your application has been registered. Please wait for the admin to add you.',
            isSuccessful: true,
          );

          // Clear text fields
          _nameController.clear();
          _emailController.clear();
          _passwordController.clear();
        });
      });
    } on FirebaseAuthException catch (e) {
      print('## error signUp => ${e.message}');

      if (e.code == 'weak-password') {
        print('## weak password.');
      } else if (e.code == 'email-already-in-use') {
        dialogShow('email already in use', '');
        print('## email already in use');
      }
    } catch (e) {
      dialogShow('Register error', '');
      print('## catch err in signUp user_auth: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 200.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Create an account\n',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Full Name',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: registerButtonPressed,
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(33, 150, 243, 1),
                  ),
                  child: const Text('Register'),
                ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: TextButton.styleFrom(
                    primary: const Color.fromRGBO(33, 150, 243, 1),
                  ),
                  child: const Text('Back to login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
