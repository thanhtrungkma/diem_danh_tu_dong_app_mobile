import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:login_app/common/common.dart';
import 'package:login_app/model/nganh.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../controller/provider.dart';
import '../draw.dart';
import '../model/sinh-vien.dart';
import '../style/color.dart';
import '../style/style.dart';
import 'infor-sv.dart';
import 'trang-chu-defalut.dart';

class DSSinhVien extends StatefulWidget {
  DSSinhVien({Key? key}) : super(key: key);

  State<DSSinhVien> createState() => _TrangChuBodyState();
}

class _TrangChuBodyState extends State<DSSinhVien> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<int> stringToList(String inputString) {
    String myString = inputString.substring(1, inputString.length - 1);
    List<String> myList = myString.split(",");
    return myList.map((e) => int.parse(e)).toList();
  }

  List<SinhVien> listSinhVien = [];
  List<Nganh> listCourse = [];
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

    final List<Map<String, dynamic>> listTeachDb = await database!.query('students');
    for (var element in listTeachDb) {
      SinhVien itemT = SinhVien(
        id: element['id'],
        ten: element['ten'],
        sdt: element['sdt'],
        diaChi: element['diaChi'],
        ngaySinh: element['ngaySinh'],
        email: element['email'],
        cmnd: element['cmnd'],
        gioiTinh: element['gioiTinh'],
        nienKhoa: element['nienKhoa'],
        nganh: (element['course_id'] == 1)
            ? listCourse[0]
            : (element['course_id'] == 2)
                ? listCourse[1]
                : (element['course_id'] == 3)
                    ? listCourse[2]
                    : (element['course_id'] == 4)
                        ? listCourse[3]
                        : null,
      );
      setState(() {
        listSinhVien.add(itemT);
      });
    }
    setState(() {
      statusData = true;
    });
  }

  SinhVien selectedStudent = SinhVien(id: 0, ten: "--Chọn--");
  Future<List<SinhVien>> getTeacher() async {
    List<SinhVien> listStudents = [];
    listStudents.add(SinhVien(id: 0, ten: "--Chọn--"));
    final List<Map<String, dynamic>> listTeachDb = await database!.query('students');
    for (var element in listTeachDb) {
      SinhVien itemT = SinhVien(
        id: element['id'],
        ten: element['ten'],
        sdt: element['sdt'],
        diaChi: element['diaChi'],
        ngaySinh: element['ngaySinh'],
        email: element['email'],
        cmnd: element['cmnd'],
        gioiTinh: element['gioiTinh'],
        nienKhoa: element['nienKhoa'],
        nganh: (element['course_id'] == 1)
            ? listCourse[0]
            : (element['course_id'] == 2)
                ? listCourse[1]
                : (element['course_id'] == 3)
                    ? listCourse[2]
                    : (element['course_id'] == 4)
                        ? listCourse[3]
                        : null,
      );
      setState(() {
        listStudents.add(itemT);
      });
    }
    return listStudents;
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
            )),
          ),
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
                      "Danh sách sinh viên",
                      style: AppStyles.medium(),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      margin: EdgeInsets.only(top: 15),
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: DropdownSearch<SinhVien>(
                          popupProps: PopupPropsMultiSelection.menu(
                            showSearchBox: true,
                          ),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              constraints: const BoxConstraints.tightFor(
                                width: 300,
                                height: 40,
                              ),
                              contentPadding: const EdgeInsets.only(left: 20, bottom: 20),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide(color: Colors.black, width: 0.5),
                              ),
                              hintText: "--Chọn--",
                              hintMaxLines: 2,
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide(color: Colors.black, width: 0.5),
                              ),
                            ),
                          ),
                          asyncItems: (String? filter) => getTeacher(),
                          itemAsString: (SinhVien u) => u.ten ?? "",
                          selectedItem: selectedStudent,
                          onChanged: (value) {
                            selectedStudent = value!;
                            if (selectedStudent.id != 0)
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) => InforSV(
                                    data: selectedStudent,
                                  ),
                                ),
                              );
                          }),
                    ),
                    SizedBox(height: 20),
                    for (SinhVien element in listSinhVien)
                      Container(
                        width: 300,
                        height: 40,
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
                                  data: element,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                " Giáo viên: ${element.ten}",
                                style: const TextStyle(color: Colors.black, fontSize: 16),
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
