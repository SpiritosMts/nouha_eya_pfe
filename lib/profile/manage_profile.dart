import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:server_room/my_voids.dart';
import 'package:server_room/profile/manage_profile_ctr.dart';

import '../models/user.dart';

class ManageProfile extends StatefulWidget {
  const ManageProfile({Key? key}) : super(key: key);

  @override
  _ManageProfileState createState() => _ManageProfileState();
}

class _ManageProfileState extends State<ManageProfile> {
  final _formKey = GlobalKey<FormState>();
  final _formKey0 = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final ManageProfileCtr gc = Get.put<ManageProfileCtr>(ManageProfileCtr());

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();



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


  refreshUser(email){
    getUserInfoByEmail(email);

    Future.delayed(const Duration(milliseconds: 500), () {


      setState(() {

      });

    });
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
                    //prop('Admin access:  ', '${currentUser.pwd}'),
                    prop('Admin access:  ', '${currentUser.isAdmin? 'Validated':'Not Validated'}'),

                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Change Informations',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            color: Colors.blue,
                            letterSpacing: 1.5,
                          fontSize: 18
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Form(
                          key: _formKey,
                          child: SizedBox(
                            width: 62.w,
                            child: TextFormField(
                              decoration: const InputDecoration(labelText: "Name"),
                              controller: _nameController,

                              validator: (value) {

                                if (value!.length < 4) {
                                  return "Name must be at least 4 characters long";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                //gc.changeUserEmailPwd('azerty123@gmail.com','123456');

                                if (_formKey.currentState!.validate()) {
                                  //changeUserInfo(_nameController.text, _emailController.text,_passwordController.text);
                                 //  changeUserName(_nameController.text);

                                   await usersColl.doc(currentUser.id).get().then((DocumentSnapshot documentSnapshot) async {
                                    if (documentSnapshot.exists) {
                                      await usersColl.doc(currentUser.id).update({
                                        'name': _nameController.text, // turn verified to true in  db
                                      }).then((value) async {
                                        showSnk('name updated');
                                        refreshUser(currentUser.email);

                                      }).catchError((error) async {
                                        //print('## user request accepted accepting error =${error}');
                                        //toastShow('user request accepted accepting error');
                                      });
                                    }
                                  });

                                }
                              },
                              child: const Text("Change"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Form(
                          key: _formKey0,
                          child: SizedBox(
                            width: 62.w,
                            child: TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(labelText: "Email"),
                              validator: (value) {

                                if (!EmailValidator.validate(value!)) {
                                  return "Please enter a valid email address";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey0.currentState!.validate()) {
                                  User? user = FirebaseAuth.instance.currentUser;
                                  if (user != null) {
                                    try {


                                      // Change password
                                      if(_emailController.text!= '')  await user.updateEmail(_emailController.text).then((value){

                                        print('## pwd auth updated');
                                        usersColl.doc(currentUser.id).get().then((DocumentSnapshot documentSnapshot) async {
                                          if (documentSnapshot.exists) {
                                            await usersColl.doc(currentUser.id).update({
                                              'email': _emailController.text, // turn verified to true in  db
                                            }).then((value) async {
                                              print('## pwd firestore updated');
                                              showSnk('email updated');
                                              refreshUser(_emailController.text);
                                            }).catchError((error) async {
                                            });
                                          }
                                        });
                                      });



                                    } catch (e) {

                                      showSnk('This operation is sensitive and requires recent authentication.\n Log in again before retrying this request');
                                      print('## Failed 4to update email:===> $e');
                                    }
                                  }
                                }
                              },
                              child: const Text("Change"),
                            ),
                          ),
                        ),

                      ],
                    ),
                    Row(
                      children: [
                        Form(
                          key: _formKey1,
                          child: SizedBox(
                            width: 62.w,
                            child: TextFormField(
                              controller: _passwordController,
                              decoration: const InputDecoration(labelText: "Password"),
                              obscureText: true,
                              validator: (value) {
                                if (value!.length < 8) {
                                  return "Password must be at least 8 characters long";
                                }
                                return null;
                              },

                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey1.currentState!.validate()) {
                                  User? user = FirebaseAuth.instance.currentUser;

                                  if (user != null) {
                                    try {


                                      // Change password
                                      if(_passwordController.text!= '')  await user.updatePassword(_passwordController.text).then((value){
                                        usersColl.doc(currentUser.id).get().then((DocumentSnapshot documentSnapshot) async {
                                          if (documentSnapshot.exists) {
                                            await usersColl.doc(currentUser.id).update({
                                              'pwd': _passwordController.text, // turn verified to true in  db
                                            }).then((value) async {
                                              showSnk('password updated');
                                              refreshUser(currentUser.email);

                                            }).catchError((error) async {
                                            });
                                          }
                                        });
                                      });



                                    } catch (e) {

                                      showSnk('This operation is sensitive and requires recent authentication.\n Log in again before retrying this request');

                                      print('## Failed to update password:===> $e');
                                    }
                                  }
                                }

                              },
                              child: const Text("Change"),
                            ),
                          ),
                        ),

                      ],
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
