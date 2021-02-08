import 'package:firebase_helpers/firebase_helpers.dart';

class CourseModel extends DatabaseItem {
  String id;
  String courseName;      // 과제 명
  String courseNumber;    // 과제 회차
  String courseGrade;    // 학년
  DateTime courseDate;    // 수업일시
  DateTime firstDueDate;  // 1차 제출기간
  DateTime secondDueDate; // 2차 제출기간
  DateTime thirdDueDate;  // 3차 제출기간

  CourseModel(
      { this.id,
         this.courseName,
         this.courseNumber,
         this.courseGrade,
         this.courseDate,
         this.firstDueDate,
         this.secondDueDate,
         this.thirdDueDate})
      : super(id);

  factory CourseModel.fromMap(Map data) {
    return CourseModel(
      id: data['id'],
      courseName: data['courseName'],
      courseNumber: data['courseNumber'],
      courseGrade: data['courseGrade'],
      courseDate: data['courseDate'].toDate(),
      firstDueDate: data['firstDueDate'].toDate(),
      secondDueDate: data['secondDueDate'].toDate(),
      thirdDueDate: data['thirdDueDate'].toDate(),
    );
  }

  factory CourseModel.fromDS(String id, Map<String, dynamic> data) {
    return CourseModel(
      id: id,
      courseName: data['courseName'],
      courseNumber: data['courseNumber'],
      courseGrade: data['courseGrade'],
      courseDate: data['courseDate'].toDate(),
      firstDueDate: data['firstDueDate'].toDate(),
      secondDueDate: data['secondDueDate'].toDate(),
      thirdDueDate: data['thirdDueDate'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "courseName": courseName,
      "courseNumber": courseName,
      "courseGrade": courseGrade,
      "courseDate": courseDate,
      "firstDueDate": firstDueDate,
      "secondDueDate": secondDueDate,
      "thirdDueDate": thirdDueDate,
    };
  }
}
