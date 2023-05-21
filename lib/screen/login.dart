// ignore_for_file: prefer_const_constructors

// import 'dart:convert';
import 'dart:io';
import 'dart:math';
// import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_app/model/teacher.dart';
import 'package:login_app/screen/trang-chu-defalut.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import '../controller/provider.dart';
import '../model/user.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:provider/provider.dart';

import 'trang-chu.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  State<Login> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<Login> {
  List<int> stringToList(String inputString) {
    String myString = inputString.substring(1, inputString.length - 1);
    List<String> myList = myString.split(",");
    return myList.map((e) => int.parse(e)).toList();
  }

  List<User> listUser = [];
  List<Teacher> listTeacher = [];
  static Database? database;
  callData() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'userdata.db');

// copy database from assets to app's local file system
    ByteData data = await rootBundle.load(join('assets', 'userdata.db'));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);

// open the database
    database = await openDatabase(path);
    final List<Map<String, dynamic>> abccc = await database!.query('account');
    for (var element in abccc) {
      User item = User(
        id: element['id'],
        username: element['username'],
        password: element['password'],
        role: element['role'],
        question: element['question'],
        answer: element['answer'],
        teacherId: element['teacher_id'],
      );
      setState(() {
        listUser.add(item);
      });
    }

    final List<Map<String, dynamic>> listTeachDb = await database!.query('teachers');
    for (var element in listTeachDb) {
      Teacher itemT = Teacher(
        id: element['id'],
        ten: element['ten'],
        sdt: element['sdt'],
        diaChi: element['diaChi'],
        email: element['email'],
        loai: element['loai'],
      );
      setState(() {
        listTeacher.add(itemT);
      });
    }
  }

  final username = TextEditingController();
  final password = TextEditingController();
  bool _passwordVisible = true;
  var salt = BCrypt.gensalt();
  @override
  void initState() {
    super.initState();
    // callData();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> processing() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
    }

    return Consumer<UserLogin>(
      builder: (context, user, child) => Scaffold(
        body: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: NetworkImage("https://connectedremag.com/wp-content/uploads/2019/10/facial-recognition-connected-real-estate.png"),
          //     fit: BoxFit.cover,
          //   ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
                width: 300,
                height: 230,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        enableSuggestions: true,
                        // maxLines: 1,
                        controller: username,
                        autofillHints: const [AutofillHints.username],
                        style: GoogleFonts.montserrat(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Tên đăng nhập',
                          labelStyle: GoogleFonts.montserrat(color: Colors.black),
                          hintStyle: GoogleFonts.montserrat(color: Colors.black),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 0.5, color: Colors.black), borderRadius: BorderRadius.all(Radius.circular(10))),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.5,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          hintText: 'Email',
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return null;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        enableSuggestions: true,
                        autofillHints: const [AutofillHints.password],
                        controller: password,
                        // maxLines: 1,
                        style: GoogleFonts.montserrat(color: Colors.black),
                        obscureText: _passwordVisible,

                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          labelStyle: GoogleFonts.montserrat(color: Colors.black),
                          hintStyle: GoogleFonts.montserrat(color: Colors.black),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 0.5, color: Colors.black), borderRadius: BorderRadius.all(Radius.circular(10))),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.5,
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return null;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        child: Text('Login'),
                        onPressed: () async {
                          processing();
                          if (username.text == "" || password.text == "") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Cần nhập đủ thông tin"),
                              backgroundColor: Colors.blue,
                            ));
                            Navigator.pop(context);
                          } else {
                            await callData();
                            try {
                              bool check = false;
                              for (User element in listUser) {
                                if (element.username == username.text) {
                                  check = true;
                                  for (Teacher elementT in listTeacher) {
                                    if (element.teacherId == elementT.id) {
                                      elementT.userName = username.text;
                                      elementT.role = element.role;
                                      user.changeUser(elementT);
                                      print(elementT.ten);
                                      break;
                                    }
                                  }
                                  break;
                                }
                              }
                              if (check == true) {
                                Navigator.push<void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) => TrangChuDefalut(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text('Tên đăng nhập/mật khẩu sai'),
                                  backgroundColor: Colors.blue,
                                ));
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              print("Loi:$e");
                              Navigator.pop(context);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                )

                //  Column(
                //   children: [

                //     // for (var element in listUser)
                //     //   Column(
                //     //     children: [
                //     //       SizedBox(
                //     //         height: 30,
                //     //       ),
                //     //       Row(
                //     //         children: [Text("Ten: "), Text("${element.username}")],
                //     //       ),
                //     //       Row(
                //     //         children: [Text("Câu hỏi là : "), Text("${element.question}")],
                //     //       ),
                //     //       Row(
                //     //         children: [Text("Câu hỏi là : "), Text("${element.answer}")],
                //     //       )
                //     //     ],
                //     //   ),
                //     // TextButton(
                //     //   onPressed: () async {},
                //     //   child: Text("Loginn"),
                //     // ),
                //   ],
                // ),

                ),
          ),
        ),
      ),
    );
  }
}
