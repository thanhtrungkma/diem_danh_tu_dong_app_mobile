import 'package:flutter/material.dart';
import 'package:login_app/screen/ds_mon_hoc.dart';
import 'package:login_app/screen/trang-chu-defalut.dart';
import 'package:provider/provider.dart';
import 'controller/provider.dart';
import 'screen/ds-giao-vien.dart';
import 'screen/ds-sinh-vien.dart';
import 'screen/ds_diem_danh.dart';
import 'screen/login.dart';
import 'style/color.dart';
import 'screen/trang-chu.dart';

class DrawerApp extends StatefulWidget {
  const DrawerApp({
    super.key,
  });
  @override
  State<DrawerApp> createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> {
  @override
  Widget build(BuildContext context) {
    Future<void> processing() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
    }

    return Drawer(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        child: Consumer<UserLogin>(
          builder: (context, user, child) {
            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                    decoration: const BoxDecoration(
                      color: maincolor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                            child: Image.asset(
                          "assets/1.jpg",
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                        )),
                        const SizedBox(height: 10),
                        Text(user.user.ten ?? "", style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400, color: colorWhite)),
                      ],
                    )),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => TrangChuDefalut(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Icon(
                          Icons.home,
                          size: 25,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          'Trang chủ',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: maincolor),
                        ),
                      ],
                    ),
                  ),
                ),
                (user.user.role == "ROLE_ADMIN")
                    ? Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                        child: TextButton(
                          onPressed: () async {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => DSGiaoVien(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Icon(
                                Icons.supervisor_account,
                                size: 25,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 15),
                              const Text(
                                'Danh sách giáo viên',
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: maincolor),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: TextButton(
                    onPressed: () async {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => DSSinhVien(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Icon(
                          Icons.diversity_3,
                          size: 25,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          'Danh sách sinh viên',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: maincolor),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: TextButton(
                    onPressed: () async {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => DSMonHoc(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Icon(
                          Icons.ballot_sharp,
                          size: 25,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          'Danh sách môn học',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: maincolor),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: TextButton(
                    onPressed: () async {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => DSDiemDanh(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Icon(
                          Icons.access_time_outlined,
                          size: 25,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          'Thông tin điểm danh',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: maincolor),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  child: TextButton(
                    onPressed: () async {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => TrangChu(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Icon(
                          Icons.accessibility_outlined,
                          size: 25,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 15),
                        const Text(
                          'Thông tin cá nhân',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: maincolor),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => Login(),
                      ),
                    );
                    // user.changeAuthorization("");
                    // user.changeUser(UserLogin());
                    // user.changeListRecruitment({});
                  },
                  icon: const Icon(
                    Icons.logout,
                    size: 35,
                    color: Colors.blue,
                  ),
                ),
              ],
            );
          },
        ));
  }
}
