// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:login_app/screen/ds_mon_hoc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../controller/provider.dart';
import '../draw.dart';
import '../style/color.dart';
import 'ds-giao-vien.dart';
import 'ds-sinh-vien.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

import 'ds_diem_danh.dart';

class TrangChuDefalut extends StatefulWidget {
  TrangChuDefalut({Key? key}) : super(key: key);

  State<TrangChuDefalut> createState() => _TrangChuDefalutBodyState();
}

class _TrangChuDefalutBodyState extends State<TrangChuDefalut> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int soLgGV = 0;
  int soLgSV = 0;
  int soLgMH = 0;
  int soLgDD = 0;
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
    final List<Map<String, dynamic>> listTeachDb = await database!.query('teachers');
    final List<Map<String, dynamic>> listTeachSV = await database!.query('students');
    final List<Map<String, dynamic>> listTeachMH = await database!.query('subjects');
    final List<Map<String, dynamic>> listTeachDD = await database!.query('attendance');

    setState(() {
      soLgGV = listTeachDb.length;
      soLgSV = listTeachSV.length;
      soLgMH = listTeachMH.length;
      soLgDD = listTeachDD.length;
    });
  }

  @override
  void initState() {
    super.initState();
    callData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserLogin>(
      builder: (context, user, child) => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('${user.user.ten}'),
          backgroundColor: maincolor,
          leading: TextButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              child: ClipOval(
                child: Image.asset(
                  "assets/1.jpg",
                  fit: BoxFit.cover,
                  height: 100,
                  width: 100,
                ),
              )),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: colorWhite,
              ),
              tooltip: 'Show Snackbar',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Đây là phần thông báo'),
                  backgroundColor: Colors.blue,
                ));
              },
            ),
          ],
        ),
        drawer: const DrawerApp(),
        body: Container(
          // padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            controller: ScrollController(),
            children: [
              Container(
                height: 50,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    )),
                child: Text(
                  "DashBoard",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 26,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: ClipOval(
                  child: Image.asset(
                    "assets/logokma.png",
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.all(10),
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => DSGiaoVien(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Icon(
                              Icons.supervisor_account,
                              size: 30,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Số giáo viên",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "$soLgGV",
                            style: TextStyle(fontSize: 30, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  )),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.all(10),
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => DSSinhVien(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.purple[100],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Icon(
                              Icons.diversity_3,
                              size: 30,
                              color: Colors.purple,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Số sinh viên",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "$soLgSV",
                            style: TextStyle(fontSize: 30, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ))
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.all(10),
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => DSMonHoc(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Icon(
                              Icons.ballot_sharp,
                              size: 30,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Số môn học",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "$soLgMH",
                            style: TextStyle(fontSize: 30, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  )),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.all(10),
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => DSDiemDanh(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Icon(
                              Icons.access_time_outlined,
                              size: 30,
                              color: Colors.orange,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Bản điểm danh",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "$soLgDD",
                            style: TextStyle(fontSize: 30, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
