import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:input_data_to_excel/views/HomePage.dart';

class DatabaseService {

  // 로그인을 위한 회원 로그인정보록 가져오기
  getUserLoginInfo(String userId) async {
    // DocumentSnapshot currentUser;
    String password = "";
    print('userId : $userId');
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get().then((value) {
        // currentUser = value;
        password = value.data()["password"];
        print("password : $password");
      });
    } catch (e) {
      return "ID error";
    }
    // return currentUser;
    return password;
  }

  Future<void> addUser(Map pUserMap, String userId) async {
    // random id 부여,
    Map<String, dynamic> userMap = {
      "id": userId,
      "password": pUserMap['password'],
      "grade": pUserMap['grade'],
      "validateByAdmin": false, // 최초 회원가입시 관리자 검증 false
      "role": "student",
      "createdAt": DateTime.now()
    };

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userMap)
        .catchError((e) {
      print(e.toString());
    });
  }
  //
  // Future<void> addCourseByExcelUpload(Map courseMap, String courseId) async {
  //   // random id 부여,
  //   await FirebaseFirestore.instance
  //       .collection("boards/course/courses")
  //       .doc(courseId)
  //       .set(courseMap)
  //       .catchError((e) {
  //     print(e.toString());
  //   });
  // }

  // 수험번호 검색 유저목록 가져오기
  getUserInfoList(userId) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get();
  }
  // 모든 학년 유저 목록 가져오기
  getUserGradeList() async {
    return await userReference.get();
  }

  // 중학교 2학년 유저 목록 가져오기
  getJ2List() async {
    return userReference.where('grade', isEqualTo: '중학교 2학년')
        .get();
  }
  // 중학교 3학년 유저 목록 가져오기
  getJ3List() async {
    return userReference.where('grade', isEqualTo: '중학교 3학년')
        .get();
  }
  // 고등학교 1학년 유저 목록 가져오기
  getG1List() async {
    return userReference.where('grade', isEqualTo: '고등학교 1학년')
        .get();
  }
  // 고등학교 2학년 유저 목록 가져오기
  getG2List() async {
    return userReference.where('grade', isEqualTo: '고등학교 2학년')
        .get();
  }
  // 고등학교 3학년 유저 목록 가져오기
  getG3List() async {
    return userReference.where('grade', isEqualTo: '고등학교 3학년')
        .get();
  }

  // 승인안된 유저목록 가져오기
  getUserInfoListByNotValidate() async {
    return userReference.where('validateByAdmin', isEqualTo: false)
        .orderBy('grade')
        .snapshots();
  }
  // 이름검색 유저목록 가져오기
  getUserInfoListByUsername(name) async {
    return FirebaseFirestore.instance
        .collection("users")
        // .where('name', isEqualTo: name)
        .orderBy('name').startAt([name.toString().trim()]).endAt([name.toString().trim()+'\uf8ff'])
        .snapshots();
  }

  // 수험번호검색 유저목록 가져오기
  getUserInfoListById(id) async {
    return FirebaseFirestore.instance
        .collection("users")
    // .where('phoneNumber', isEqualTo: phoneNumber)
        .orderBy('id')
        .startAt([id.toString().trim()]).endAt([id.toString().trim()+'\uf8ff'])
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
