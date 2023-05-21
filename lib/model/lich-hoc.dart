// ignore_for_file: file_names

import 'lop-hoc.dart';
import 'mon-hoc.dart';
import 'teacher.dart';

class LichHoc {
  int? id;
  Teacher? giaoVien;
  Subjects? monHoc;
  LopHoc? lopHoc;
  String? batDau;
  String? ketThuc;

  LichHoc({
    this.id,
    this.giaoVien,
    this.monHoc,
    this.lopHoc,
    this.batDau,
    this.ketThuc,
  });
}
