import 'dart:io';
import 'package:login_app/common/common.dart';
import 'package:login_app/model/teacher.dart';
import 'package:login_app/screen/trang-chu-defalut.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../common/edit-input.dart';
import '../controller/provider.dart';
import '../draw.dart';
import '../style/color.dart';
import '../style/style.dart';

class TrangChu extends StatefulWidget {
  TrangChu({Key? key}) : super(key: key);

  State<TrangChu> createState() => _TrangChuBodyState();
}

class _TrangChuBodyState extends State<TrangChu> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static Database? database;
  bool statusData = false;
  callData() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'userdata.db');
    ByteData data = await rootBundle.load(join('assets', 'userdata.db'));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);
    database = await openDatabase(path);

    setState(() {
      statusData = true;
    });
  }

  Teacher selectedTeacher = Teacher();
  Future<List<Teacher>> getTeacher() async {
    List<Teacher> listEmployers = [];
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
        listEmployers.add(itemT);
      });
    }
    return listEmployers;
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
          child: statusData
              ? ListView(
                  controller: ScrollController(),
                  children: [
                    EditInput(
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Thông tin cá nhân",
                            style: AppStyles.medium(),
                          )
                        ],
                      ),
                    ),
                    EditInput(
                      widget: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Text(
                                "Chức vụ : ",
                                style: AppStyles.medium(),
                              )),
                          Expanded(
                            flex: 5,
                            child: Text("Giảng viên", style: AppStyles.appTextStyle()),
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
                                "Tên đn : ",
                                style: AppStyles.medium(),
                              )),
                          Expanded(
                            flex: 5,
                            child: Text("${user.user.userName}", style: AppStyles.appTextStyle()),
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
                                "Tên : ",
                                style: AppStyles.medium(),
                              )),
                          Expanded(
                            flex: 5,
                            child: Text("${user.user.ten}", style: AppStyles.appTextStyle()),
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
                                "SĐT : ",
                                style: AppStyles.medium(),
                              )),
                          Expanded(
                            flex: 5,
                            child: Text("${user.user.sdt}", style: AppStyles.appTextStyle()),
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
                                "Email : ",
                                style: AppStyles.medium(),
                              )),
                          Expanded(
                            flex: 5,
                            child: Text("${user.user.email}", style: AppStyles.appTextStyle()),
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
                                "Địa chỉ : ",
                                style: AppStyles.medium(),
                              )),
                          Expanded(
                            flex: 5,
                            child: Text("${user.user.diaChi}", style: AppStyles.appTextStyle()),
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
                                "Loại : ",
                                style: AppStyles.medium(),
                              )),
                          Expanded(
                            flex: 5,
                            child: Text("${user.user.loai}", style: AppStyles.appTextStyle()),
                          ),
                        ],
                      ),
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
                    //   child: DropdownSearch<Teacher>(
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
                    //       asyncItems: (String? filter) => getTeacher(),
                    //       itemAsString: (Teacher u) => u.ten ?? "",
                    //       selectedItem: selectedTeacher,
                    //       onChanged: (value) {
                    //         selectedTeacher = value!;
                    //       }),
                    // )
                  ],
                )
              : CommonApp().loadingCallAPi(),
        ),
      ),
    );
  }
}
