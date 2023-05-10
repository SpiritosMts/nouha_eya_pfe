import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:server_room/my_voids.dart';
import 'package:server_room/profile/manage_profile_ctr.dart';

class ManageProfile extends StatefulWidget {
  const ManageProfile({Key? key}) : super(key: key);

  @override
  _ManageProfileState createState() => _ManageProfileState();
}

class _ManageProfileState extends State<ManageProfile> {
  final _formKey = GlobalKey<FormState>();
  final ManageProfileCtr gc = Get.put<ManageProfileCtr>(ManageProfileCtr());

  String _email = "";
  String _password = "";



  Widget prop(title,prop){
    return   Padding(
      padding: const EdgeInsets.only(bottom: 9.0),
      child: Row(
        children: [
          Text(
            '$title',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          Text(
            '$prop',
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    prop('User ID:  ', '${currentUser.id}'),
                    prop('User Name:  ', '${currentUser.name}'),
                    prop('User Email:  ', '${currentUser.email}'),
                    prop('User Password:  ', '${currentUser.pwd}'),
                    prop('Account State:  ', '${currentUser.verified? 'Validated':'Not Validated'}'),

                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change email & password',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: Colors.blue,
                              letterSpacing: 1.5,
                            fontSize: 18
                          ),
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Email"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          } else if (!EmailValidator.validate(value)) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value ?? "";
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Password"),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          } else if (value.length < 8) {
                            return "Password must be at least 8 characters long";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value ?? "";
                        },
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              gc.changeUserEmailPwd('azerty123@gmail.com','123456');

                              // if (_formKey.currentState!.validate()) {
                              //   _formKey.currentState!.save();
                              //   changeUserEmailPwd('azerty123@gmail.com','123456');
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(content: Text("Profile modified successfully!")),
                              //   );
                              // }
                            },
                            child: const Text("Change"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
