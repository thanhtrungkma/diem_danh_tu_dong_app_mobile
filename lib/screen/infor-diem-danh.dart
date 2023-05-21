// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'package:login_app/common/common.dart';
import 'package:login_app/model/diem-danh.dart';
import 'package:login_app/model/lich-hoc.dart';
import 'package:login_app/model/lop-hoc.dart';
import 'package:login_app/model/sinh-vien.dart';
import 'package:login_app/screen/infor_monhoc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../controller/provider.dart';
import '../draw.dart';
import '../model/mon-hoc.dart';
import '../model/nganh.dart';
import '../model/teacher.dart';
import '../style/color.dart';
import '../style/style.dart';
import 'infor-sv.dart';
import 'trang-chu-defalut.dart';

class InforDiemDanh extends StatefulWidget {
  LichHoc data;
  InforDiemDanh({Key? key, required this.data}) : super(key: key);

  State<InforDiemDanh> createState() => _TrangChuBodyState();
}

class _TrangChuBodyState extends State<InforDiemDanh> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<int> stringToList(String inputString) {
    String myString = inputString.substring(1, inputString.length - 1);
    List<String> myList = myString.split(",");
    return myList.map((e) => int.parse(e)).toList();
  }

  List<DiemDanh> listDiemDanh = [];
  List<Nganh> listCourse = [];
  static Database? database;
  callData() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'userdata.db');
    ByteData data = await rootBundle.load(join('assets', 'userdata.db'));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);
// open the database
    database = await openDatabase(path);
    final List<Map<String, dynamic>> lisCourseDb = await database!.query('course');
    for (var element in lisCourseDb) {
      Nganh itemT = Nganh(
        id: element['id'],
        he: element['he'],
        nganh: element['nganh'],
      );
      setState(() {
        listCourse.add(itemT);
      });
    }
    final List<Map<String, dynamic>> listDiemDanhDB = await database!.query(
      'attendance',
      orderBy: 'id DESC',
      where: 'schedule_id = ?',
      whereArgs: [widget.data.id],
    );
    for (var element in listDiemDanhDB) {
      DiemDanh itemT = DiemDanh(
        id: element['id'],
        lichHoc: widget.data,
        ngayDiemDanh: element['ngayDiemDanh'],
        trangthai: element['trangThai'],
      );
      final List<Map<String, dynamic>> sinhVienDb = await database!.query(
        'students',
        where: 'id = ?',
        whereArgs: [element['student_id']],
      );
      if (sinhVienDb.isNotEmpty) {
        SinhVien itemSV = SinhVien(
          id: sinhVienDb.first['id'],
          ten: sinhVienDb.first['ten'],
          sdt: sinhVienDb.first['sdt'],
          diaChi: sinhVienDb.first['diaChi'],
          ngaySinh: sinhVienDb.first['ngaySinh'],
          email: sinhVienDb.first['email'],
          cmnd: sinhVienDb.first['cmnd'],
          gioiTinh: sinhVienDb.first['gioiTinh'],
          nienKhoa: sinhVienDb.first['nienKhoa'],
          nganh: (sinhVienDb.first['course_id'] == 1)
              ? listCourse[0]
              : (sinhVienDb.first['course_id'] == 2)
                  ? listCourse[1]
                  : (sinhVienDb.first['course_id'] == 3)
                      ? listCourse[2]
                      : (sinhVienDb.first['course_id'] == 4)
                          ? listCourse[3]
                          : null,
        );
        itemT.sinhVien = itemSV;
      }
      setState(() {
        listDiemDanh.add(itemT);
      });
    }

    setState(() {
      statusData = true;
    });
  }

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
          title: Text('${widget.data.lopHoc!.ten} - ${widget.data.giaoVien!.ten}'),
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
                    for (DiemDanh element in listDiemDanh)
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
                                builder: (BuildContext context) => InforSV(
                                  data: element.sinhVien!,
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
                                      " Sinh viên: ${(element.sinhVien != null) ? element.sinhVien!.ten ?? "" : ""}",
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
                                      " Giờ vào: ${(element.ngayDiemDanh != null) ? DateFormat('HH:mm dd/MM/yyyy').format(DateTime.parse(element.ngayDiemDanh!)) : ""}",
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
                                      " Trạng thái: ${(element.trangthai.toString() == "X") ? "Đã điểm danh" : element.trangthai.toString()}",
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
