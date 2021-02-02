import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:input_data_to_excel/views/HomePage.dart';

class DatabaseService {

  // 로그인을 위한 회원 로그인정보록 가져오기
  getUserLoginInfo(String userId) async {
    // DocumentSnapshot currentUser;
    String password = "";
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get().then((value) {
          // currentUser = value;
          password = value.data()["password"];
    });
    // print("password : $password");
    // return currentUser;
    return password;
  }

  Future<void> addUser(Map userMap, String userId) async {
    // random id 부여,
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addCourseByExcelUpload(Map courseMap, String courseId) async {
    // random id 부여,
    await FirebaseFirestore.instance
        .collection("boards/course/courses")
        .doc(courseId)
        .set(courseMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  // 해당 강의의 Feedback을 위한 수강생 목록 가져오기
  getUserFeedbackList(courseId) async {
    return FirebaseFirestore.instance
        .collection("boards/course/courses")
        .doc(courseId)
        .collection('users')
        .snapshots();
  }

  // 해당 강사의 강의목록 가져오기
  getHisOrHerCourseInfoList(username, courseDate) async {
    return await FirebaseFirestore.instance
        .collection("boards/course/courses")
        .where('courseTeacher', isEqualTo: username)
        .where('courseDate',
            isGreaterThan: DateTime(courseDate.year, courseDate.month, 1, 00))
        .where('courseDate',
            isLessThan: DateTime(
                courseDate.month == 12 ? courseDate.year + 1 : courseDate.year,
                courseDate.month == 12 ? 1 : courseDate.month + 1,
                1,
                00))
        .orderBy('courseDate')
        .get();
  }

  // 강사목록 가져오기
  getTeacherInfoList(username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where('profileName', isEqualTo: username)
        .where('role', isEqualTo: 'teacher')
        .get();
  }

  // 이름검색 유저목록 가져오기
  getUserInfoList(username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where('profileName', isEqualTo: username)
        .orderBy('level')
        .snapshots();
  }

  // 승인안된 유저목록 가져오기
  getUserInfoListByNotValidate() async {
    return userReference.where('validateByAdmin', isEqualTo: false)
        .orderBy('grade')
        .snapshots();
  }
  // 이름검색 유저목록 가져오기
  getUserInfoListByUsername(username) async {
    return FirebaseFirestore.instance
        .collection("users")
        // .where('profileName', isEqualTo: username)
        .orderBy('profileName').startAt([username]).endAt([username+'\uf8ff'])
        .snapshots();
  }

  // 휴대폰번호검색 유저목록 가져오기
  getUserInfoListByPhoneNumber(phoneNumber) async {
    return FirebaseFirestore.instance
        .collection("users")
    // .where('phoneNumber', isEqualTo: phoneNumber)
        .orderBy('phoneNumber')
        .startAt([phoneNumber.toString().toUpperCase().trim()]).endAt([phoneNumber.toString().toUpperCase().trim()+'\uf8ff'])
        .snapshots();
  }

  // 강의 신청목록 가져오기
  getUserApplyCourse(String userId) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("courses")
        .orderBy('courseDate')
        .where('courseType', isEqualTo: 'CourseType.Regular')
        .where('courseDate',
            isGreaterThanOrEqualTo: DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day))
        // .where('courseTime', isLessThan: int.parse(formatDate(DateTime.now(), [HH])))
        // .where('attendance', isEqualTo: false)
        .get();
  }

  // 무료강의 신청목록 가져오기
  getUserApplyFreeCourse(String userId) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("courses")
        .where('courseType', isEqualTo: 'CourseType.Free')
        .where('courseDate',
            isGreaterThanOrEqualTo: DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day))
        // .where('attendance', isEqualTo: false)
        .get();
  }

  // 강의 완료목록 가져오기
  getUserCompleteCourse(String userId) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("courses")
        .where('courseDate',
            isLessThan: DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day)) // 다음 날이 되면 강의완료로 바뀜
        // .where('attendance', isEqualTo: true)
        .get();
  }
}
