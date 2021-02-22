import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_helpers/firebase_helpers.dart';

class CurrentUser extends DatabaseItem {
  String id; // 수험번호 (학번)
  String password;
  String grade; // 학년호
  String name; // 이름
  String phoneNumber; // 휴대폰번호
  bool validateByAdmin; // 검증 전/후
  String role; // 학생, 관리자
  DateTime createdAt;

  CurrentUser(
      {this.id,
      this.password,
      this.grade,
      this.name,
      this.phoneNumber,
      this.validateByAdmin,
      this.role,
      this.createdAt})
      : super(id);

  factory CurrentUser.fromDocument(DocumentSnapshot doc) {
    Map getDocs = doc.data();
    return CurrentUser(
        id: doc.id,
        password: getDocs["password"],
        grade: getDocs["grade"],
        name: getDocs["name"] != null ? getDocs["name"] : "-",
        phoneNumber:
            getDocs["phoneNumber"] != null ? getDocs["phoneNumber"] : "-",
        validateByAdmin: getDocs["validateByAdmin"],
        role: getDocs["role"],
        createdAt: getDocs["createdAt"].toDate());
  }
}
