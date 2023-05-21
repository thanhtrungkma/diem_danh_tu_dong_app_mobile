// ignore_for_file: prefer_const_constructors

// import 'dart:convert';
import 'dart:io';
import 'dart:math';
// import 'dart:typed_data';
import 'package:login_app/model/mon-hoc.dart';
import 'package:login_app/model/teacher.dart';
import 'package:login_app/screen/trang-chu.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import '../common/edit-input.dart';
import '../controller/provider.dart';
import '../draw.dart';
import '../model/user.dart';
import 'package:bcrypt/bcrypt.dart';

import '../style/color.dart';
import '../style/style.dart';
import 'trang-chu-defalut.dart';

class InforMonHoc extends StatefulWidget {
  Subjects data;
  InforMonHoc({Key? key, required this.data}) : super(key: key);

  State<InforMonHoc> createState() => _InforMonHocBodyState();
}

class _InforMonHocBodyState extends State<InforMonHoc> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    // callData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserLogin>(
      builder: (context, user, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: maincolor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: colorWhite,
                size: 20,
              )),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => TrangChuDefalut(),
                    ),
                  );
                },
                icon: const Icon(Icons.home, size: 25))
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            controller: ScrollController(),
            children: [
              EditInput(
                widget: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          "Tên",
                          style: AppStyles.medium(),
                        )),
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              "${widget.data.ten}",
                              style: AppStyles.appTextStyle(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              EditInput(
                widget: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          "Số buổi",
                          style: AppStyles.medium(),
                        )),
                    Expanded(
                      flex: 5,
                      child: Text("${widget.data.soBuoi}", style: AppStyles.appTextStyle()),
                    ),
                  ],
                ),
              ),
              EditInput(
                widget: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          "Thuộc kì",
                          style: AppStyles.medium(),
                        )),
                    Expanded(
                      flex: 5,
                      child: Text("${widget.data.ki}", style: AppStyles.appTextStyle()),
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
