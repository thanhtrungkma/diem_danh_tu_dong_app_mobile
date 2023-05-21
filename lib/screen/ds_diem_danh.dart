// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'package:login_app/common/common.dart';
import 'package:login_app/model/diem-danh.dart';
import 'package:login_app/model/lich-hoc.dart';
import 'package:login_app/model/lop-hoc.dart';
import 'package:login_app/screen/infor_monhoc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../controller/provider.dart';
import '../draw.dart';
import '../model/mon-hoc.dart';
import '../model/teacher.dart';
import '../style/color.dart';
import '../style/style.dart';
import 'infor-diem-danh.dart';
import 'trang-chu-defalut.dart';

class DSDiemDanh extends StatefulWidget {
  DSDiemDanh({Key? key}) : super(key: key);

  State<DSDiemDanh> createState() => _TrangChuBodyState();
}

class _TrangChuBodyState extends State<DSDiemDanh> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<int> stringToList(String inputString) {
    String myString = inputString.substring(1, inputString.length - 1);
    List<String> myList = myString.split(",");
    return myList.map((e) => int.parse(e)).toList();
  }

  List<LichHoc> listLichHoc = [];
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

    final List<Map<String, dynamic>> listLichHocDB = await database!.query(
      'schedule',
      orderBy: 'id DESC',
    );
    for (var element in listLichHocDB) {
      LichHoc itemT = LichHoc(
        id: element['id'],
        batDau: element['batDau'],
        ketThuc: element['ketThuc'],
      );
      final List<Map<String, dynamic>> giaoVienDb = await database!.query(
        'teachers',
        where: 'id = ?',
        whereArgs: [element['teacher_id']],
      );
      if (giaoVienDb.isNotEmpty) {
        Teacher itemTeacher = Teacher(
          id: giaoVienDb.first['id'],
          ten: giaoVienDb.first['ten'],
          sdt: giaoVienDb.first['sdt'],
          diaChi: giaoVienDb.first['diaChi'],
          email: giaoVienDb.first['email'],
          loai: giaoVienDb.first['loai'],
        );
        itemT.giaoVien = itemTeacher;
      }
      final List<Map<String, dynamic>> monHocDb = await database!.query(
        'subjects',
        where: 'id = ?',
        whereArgs: [element['subject_id']],
      );
      if (monHocDb.isNotEmpty) {
        Subjects itemMH = Subjects(
          id: monHocDb.first['id'],
          ten: monHocDb.first['ten'],
          soBuoi: monHocDb.first['soBuoi'].toString(),
          ki: monHocDb.first['semester_id'].toString(),
        );
        itemT.monHoc = itemMH;
      }
      final List<Map<String, dynamic>> lopHocDb = await database!.query(
        'class',
        where: 'id = ?',
        whereArgs: [element['class_id']],
      );
      if (lopHocDb.isNotEmpty) {
        LopHoc itemLH = LopHoc(
          id: lopHocDb.first['id'],
          ten: lopHocDb.first['ten'],
          diaDiem: lopHocDb.first['diaDiem'],
        );
        itemT.lopHoc = itemLH;
      }
      setState(() {
        listLichHoc.add(itemT);
      });
    }

    setState(() {
      statusData = true;
    });
  }

  // Subjects selectedMonHoc = Subjects(id: 0, ten: "--Chọn--");
  // Future<List<Subjects>> getSubjects() async {
  //   List<Subjects> listSubjects = [];
  //   listSubjects.add(Subjects(id: 0, ten: "--Chọn--"));
  //   final List<Map<String, dynamic>> listTeachDb = await database!.query('attendance');
  //   for (var element in listTeachDb) {
  //     Subjects itemT = Subjects(
  //       id: element['id'],
  //       ten: element['ten'],
  //       soBuoi: element['soBuoi'].toString(),
  //       ki: element['semester_id'].toString(), // soBuoi: element['soBuoi'],
  //     );

  //     setState(() {
  //       listSubjects.add(itemT);
  //     });
  //   }
  //   return listSubjects;
  // }

  bool statusData = false;
  @override
  void initState() {
    super.initState();
    callData();
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
              ))),
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
        drawer: const DrawerApp(),
        body: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: (statusData)
              ? ListView(
                  controller: ScrollController(),
                  children: [
                    Text(
                      "Danh sách bản điểm danh",
                      style: AppStyles.medium(),
                    ),
                    // Container(
                    //   width: MediaQuery.of(context).size.width * 0.20,
                    //   margin: EdgeInsets.only(top: 15),
                    //   height: 40,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.all(
                    //       Radius.circular(10),
                    //     ),
                    //   ),
                    //   child: DropdownSearch<Subjects>(
                    //       popupProps: PopupPropsMultiSelection.menu(
                    //         showSearchBox: true,
                    //       ),
                    //       dropdownDecoratorProps: DropDownDecoratorProps(
                    //         dropdownSearchDecoration: InputDecoration(
                    //           constraints: const BoxConstraints.tightFor(
                    //             width: 300,
                    //             height: 40,
                    //           ),
                    //           contentPadding: const EdgeInsets.only(left: 20, bottom: 20),
                    //           focusedBorder: const OutlineInputBorder(
                    //             borderRadius: BorderRadius.all(
                    //               Radius.circular(10),
                    //             ),
                    //             borderSide: BorderSide(color: Colors.black, width: 0.5),
                    //           ),
                    //           hintText: "--Chọn--",
                    //           hintMaxLines: 2,
                    //           enabledBorder: const OutlineInputBorder(
                    //             borderRadius: BorderRadius.all(
                    //               Radius.circular(10),
                    //             ),
                    //             borderSide: BorderSide(color: Colors.black, width: 0.5),
                    //           ),
                    //         ),
                    //       ),
                    //       asyncItems: (String? filter) => getSubjects(),
                    //       itemAsString: (Subjects u) => u.ten ?? "",
                    //       selectedItem: selectedMonHoc,
                    //       onChanged: (value) {
                    //         selectedMonHoc = value!;
                    //         if (selectedMonHoc.id != 0)
                    //           Navigator.push<void>(
                    //             context,
                    //             MaterialPageRoute<void>(
                    //               builder: (BuildContext context) => InforMonHoc(
                    //                 data: selectedMonHoc,
                    //               ),
                    //             ),
                    //           );
                    //       }),
                    // ),
                    SizedBox(height: 20),
                    for (LichHoc element in listLichHoc)
                      Container(
                        width: 300,
                        height: 110,
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(color: Colors.black, width: 0.5),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => InforDiemDanh(
                                  data: element,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      " Tên lớp học: ${(element.lopHoc != null) ? element.lopHoc!.ten ?? "" : ""}",
                                      style: const TextStyle(color: Colors.black, fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      " Tên giáo viên: ${(element.giaoVien != null) ? element.giaoVien!.ten ?? "" : ""}",
                                      style: const TextStyle(color: Colors.black, fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      " TG: ${(element.batDau != null) ? DateFormat('HH:mm dd/MM/yyyy').format(DateTime.parse(element.batDau!)) : ""} - ${(element.ketThuc != null) ? DateFormat('HH:mm dd/MM/yyyy').format(DateTime.parse(element.ketThuc!.toString())) : ""}",
                                      style: const TextStyle(color: Colors.black, fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                )
              : CommonApp().loadingCallAPi(),
        ),
      ),
    );
  }
}
