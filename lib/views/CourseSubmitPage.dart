// @dart=2.9
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

import 'package:input_data_to_excel/models/CourseModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:toast/toast.dart';
import 'dart:core';
import 'AddCoursePage.dart';
import 'CourseRoom.dart';
import 'HomePage.dart';

String fileName;
File f;

class CourseSubmitPage extends StatefulWidget {
  @override
  _CourseSubmitPageState createState() => _CourseSubmitPageState();
}

class _CourseSubmitPageState extends State<CourseSubmitPage> {
  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _events = {};
  List<dynamic> _selectedEvents = [];
  String filePath;
  final weekDayList = ["일", "월", "화", "수", "목", "금", "토", "일"];

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  void _onDaySelected(day, events, List e) {
    setState(() {
      _selectedEvents = events;
    });
  }

  Map<DateTime, List<dynamic>> _groupCourses(List<CourseModel> courses) {
    Map<DateTime, List<dynamic>> data = {};
    courses.forEach((course) {
      DateTime date = DateTime(course.courseDate.year, course.courseDate.month,
          course.courseDate.day, 12);
      if (data[date] == null) data[date] = [];
      data[date].add(course);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: currentUser != null
            ? Container(
                height: MediaQuery.of(context).size.height * 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("과제 목록",
                              style: GoogleFonts.montserrat(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        ),
                        Spacer(),
                      ],
                    ),
                    currentUser.validateByAdmin == true
                        ? Expanded(
                            child: _viewCalendar(),
                          )
                        : Expanded(
                            child: Center(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  Text('관리자 승인 후 이용 가능합니다.',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold))
                                ])),
                          )
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                strokeWidth: 10,
              )),
        floatingActionButton: currentUser != null
            ? currentUser.role == 'admin'
                ? FloatingActionButton(
                    backgroundColor: Colors.blueGrey,
                    child: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddCoursePage()));
                    },
                  )
                : Container()
            : Center(
                child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                strokeWidth: 10,
              )));
  }

  Widget _viewCalendar() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(colors: [
          Colors.blueGrey.withOpacity(0.1),
          Colors.grey.withOpacity(0.1)
        ]),
      ),
      child: StreamBuilder<List<CourseModel>>(
          stream: currentUser.role == 'admin'
              ? courseReference.snapshots().map((list) => list.docs
                  .map((doc) => CourseModel.fromDS(doc.id, doc.data()))
                  .toList())
              : courseReference
                  .where('courseGrade', isEqualTo: currentUser.grade)
                  .snapshots()
                  .map((list) => list.docs
                      .map((doc) => CourseModel.fromDS(doc.id, doc.data()))
                      .toList()),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                strokeWidth: 10,
              ));
            } else {
              List<CourseModel> allCourses = snapshot.data;
              if (allCourses.isNotEmpty) {
                _events = _groupCourses(allCourses);
              }
            }
            return ListView(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _events != null
                      ? TableCalendar(
                          locale: 'ko_KR',
                          events: _events,
                          initialCalendarFormat: CalendarFormat.twoWeeks,
                          calendarStyle: CalendarStyle(
                            markersColor: Colors.grey,
                            markersMaxAmount: 1,
                            weekdayStyle:
                                GoogleFonts.montserrat(color: Colors.black),
                            highlightToday: true,
                            todayColor: Colors.grey.withOpacity(0.3),
                            todayStyle: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: 15),
                            selectedColor: Colors.blueGrey,
                            selectedStyle: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            outsideWeekendStyle: GoogleFonts.montserrat(
                                color: Colors.grey.shade400),
                            outsideStyle: GoogleFonts.montserrat(
                                color: Colors.grey.shade400),
                            weekendStyle:
                                GoogleFonts.montserrat(color: Colors.red[400]),
                            // renderDaysOfWeek: false,
                          ),
                          onDaySelected: _onDaySelected,
                          calendarController: _calendarController,
                          headerStyle: HeaderStyle(
                              leftChevronIcon: Icon(Icons.arrow_back_ios,
                                  size: 15, color: Colors.blueGrey),
                              rightChevronIcon: Icon(Icons.arrow_forward_ios,
                                  size: 15, color: Colors.blueGrey),
                              titleTextStyle: GoogleFonts.montserrat(
                                  color: Colors.blueGrey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              formatButtonVisible: false,
                              centerHeaderTitle: true),
                        )
                      : LinearProgressIndicator(),
                  ..._selectedEvents.map((event) => ListTile(
                        tileColor: event.courseGrade == "중학교 1학년"
                            ? Colors.blueAccent.withOpacity(0.2)
                            : event.courseGrade == "중학교 2학년"
                                ? Colors.blueAccent.withOpacity(0.4)
                                : event.courseGrade == "중학교 3학년"
                                    ? Colors.blueAccent.withOpacity(0.7)
                                    : event.courseGrade == "고등학교 1학년"
                                        ? Colors.blueGrey.withOpacity(0.2)
                                        : event.courseGrade == "고등학교 2학년"
                                            ? Colors.blueGrey.withOpacity(0.5)
                                            : Colors.blueGrey.withOpacity(0.8),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Text(
                                "${event.courseName}-${event.courseNumber}",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(width: 20),
                            Flexible(
                              flex: 1,
                              child: Text(
                                event.courseGrade,
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("제출기한"),
                            Text(
                                "1차: ${event.firstDueDate.month}/${event.firstDueDate.day}(${weekDayList[event.firstDueDate.weekday]})",
                                style: GoogleFonts.montserrat(
                                    color: Colors.black54)),
                            Text(
                                "2차: ${event.secondDueDate.month}/${event.secondDueDate.day}(${weekDayList[event.secondDueDate.weekday]})",
                                style: GoogleFonts.montserrat(
                                    color: Colors.black54)),
                            Text(
                                "3차: ${event.thirdDueDate.month}/${event.thirdDueDate.day}(${weekDayList[event.thirdDueDate.weekday]})",
                                style: GoogleFonts.montserrat(
                                    color: Colors.black54)),
                            // event.courseTeacher != null ? Text(event.courseTeacher) : Container(),
                            // Text("${event.coursePoint.toString()} Points",
                            //     style:
                            //         GoogleFonts.montserrat(color: Colors.red)),
                          ],
                        ),
                        onLongPress: () async {
                          if (currentUser.role == "admin") {
                            await submitDeletePopup(event);
                          }
                        }, onTap: () {
                          checkCoursePopup(event);
                        },
                      )),
                ],
              ),
            ]);
          }),
    );
  }

  checkCoursePopup(event) async {
    fileName =
        '${event.courseName}-${event.courseNumber}_${event.courseGrade}_${event.courseDate.year}년${event.courseDate.month}월${event.courseDate.day}일.xlsx';
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('과제 풀기'),
            content: Text(
                "과제명: ${event.courseName}-${event.courseNumber}\n학년: ${event.courseGrade}"),
            actions: [
              currentUser.role == 'admin'
                  ? FlatButton(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Text('전송',
                            style: GoogleFonts.montserrat(
                                color: Colors.red, fontSize: 20)),
                      ),
                      onPressed: () async {
                        // 엑셀 취합
                        await getExcel(event);
                        // 이메일 전송
                        sendMail(event);
                      },
                    )
                  : Container(),
              FlatButton(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text('확인',
                      style: GoogleFonts.montserrat(
                          color: Colors.blueAccent, fontSize: 20)),
                ),
                onPressed: () async {
                  // 해당 과제에 대해 db에 저장한 답 있는지 체크 (있으면 팝업띄워서 삭제 후 새로 풀지확인, 아니면 그냥 풀기)
                  courseReference
                      .doc(event.id)
                      .collection('SubmitUsers')
                      .doc(currentUser.id)
                      .get()
                      .then((val) {
                    if (val.exists) {
                      checkDeletePopup(event);
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CourseRoom(event)));
                    }
                  });
                },
              ),
              FlatButton(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text('취소',
                      style: GoogleFonts.montserrat(
                          color: Colors.grey, fontSize: 20)),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  submitDeletePopup(event) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
      return AlertDialog(
        title: Text('과제 삭제'),
        content: Text("해당 과제를 삭제하시겠습니까?",
            style: TextStyle(color: Colors.redAccent)),
        actions: [
          FlatButton(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Text('확인',
                  style: GoogleFonts.montserrat(
                      color: Colors.blueAccent, fontSize: 20)),
            ),
            onPressed: () async {
              // batch 생성
              WriteBatch writeBatch =
              firestoreReference.batch();

              await courseReference.doc(event.id).collection('messages').get().then((snapshot) {
                for (DocumentSnapshot ds in snapshot.docs){
                  writeBatch.delete(ds.reference);
                }
              });

              writeBatch.delete(courseReference.doc(event.id));

              // batch end
              writeBatch.commit();

              showToast("과제 삭제 완료");
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage(0) // ProfilePage
                  ));
            },
          ),
          FlatButton(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Text('취소',
                  style: GoogleFonts.montserrat(
                      color: Colors.grey, fontSize: 20)),
            ),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
        ],
      );
    });
  }

  checkDeletePopup(event) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('제출 완료'),
            content: Text("이미 제출한 과제입니다. 삭제 후 다시 푸시겠습니까?",
                style: TextStyle(color: Colors.redAccent)),
            actions: [
              FlatButton(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text('확인',
                      style: GoogleFonts.montserrat(
                          color: Colors.blueAccent, fontSize: 20)),
                ),
                onPressed: () async {
                  await courseReference
                      .doc(event.id)
                      .collection('SubmitUsers')
                      .doc(currentUser.id)
                      .delete();
                  showToast("기존 답안 삭제 완료");
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CourseRoom(event)));
                },
              ),
              FlatButton(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text('취소',
                      style: GoogleFonts.montserrat(
                          color: Colors.grey, fontSize: 20)),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  getExcel(event) async {
    var excel = Excel.createExcel();
    // excel.delete('Sheet1');
    Sheet sheetObject = excel['Sheet1'];
    // excel[
    //     '${event.courseName}-${event.courseNumber}_${event.courseGrade}_${event.courseDate.year}년${event.courseDate.month}월${event.courseDate.day}일'];

    // 최상단 꾸밀 raw
    List<dynamic> raw;
    var cloud =
        await courseReference.doc(event.id).collection('SubmitUsers').get();

    raw = [
      "수험번호".toString(),
      "제출차수".toString(),
      "이름".toString(),
      "휴대폰".toString(),
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
      22,
      23,
      24,
      25,
      26,
      27,
      28,
      29,
      30,
      31,
      32,
      33,
      34,
      35,
      36,
      37,
      38,
      39,
      30,
      41,
      42,
      43,
      44,
      45,
      46,
      47,
      48,
      49,
      50,
    ];

    // 최상단에 셋팅
    sheetObject.insertRowIterables(raw, 0);

    if (cloud.docs != null) {
      for (int i = 0; i < cloud.docs.length; i++) {
        List<dynamic> row = List<dynamic>();
        // 수험번호 넣기
        row.add(int.parse(cloud.docs[i].data()['id']));
        // 제출차수 넣기
        row.add(cloud.docs[i].data()['submitDegree'].toString());
        // 이름 넣기
        row.add(cloud.docs[i].data()['name'].toString());
        // 휴대폰번호 넣기
        row.add(cloud.docs[i].data()['phoneNumber'].toString());
        // 50까지 입력 답 넣기
        for (int j = 0; j < 50; j++) {
          if (cloud.docs[i].data()['answer'][j] == null) {
            row.add("");
          } else {
            row.add(cloud.docs[i].data()['answer'][j]);
          }
        }
        sheetObject.insertRowIterables(row, i + 1);
      }

      // Save the Changes in file
      f = await _localFile;
      excel.encode().then((onValue) {
        f
          ..createSync(recursive: true)
          ..writeAsBytesSync(onValue);
      });
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();
    return directory.absolute.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    filePath = '$path/$fileName';
    return File(filePath).create();
  }

  sendMail(event) async {
    // if (Platform.isIOS) {
    Reference levelTestRef = FirebaseStorage.instance.ref().child(
        'submitList/${DateTime.now().year}년/${DateTime.now().month}월/$fileName');
    // // upload Task는 제공되나 아직 실제 업로드 전
    UploadTask uploadTask = levelTestRef.putFile(f);
    // 실제 파일 업로드 (중간에 중단, 취소 등 하지 않을 것이므로 최대한 심플하게 가보자.)
    await uploadTask.whenComplete(() => showToast('파일 업로드 완료', duration: 2));
    // } else {
    //   // 이메일 전송 테스트
    //   final MailOptions mailOptions = MailOptions(
    //     body:
    //         event.courseName + event.courseNumber + ' 과제에 대한 엑셀 취합내용 메일 전송입니다.',
    //     subject:
    //         '${event.courseName}-${event.courseNumber}_${event.courseGrade}_${event.courseDate.year}년${event.courseDate.month}월${event.courseDate.day}일',
    //     recipients: ['skyboom86@gmail.com'],
    //     isHTML: false,
    //     // bccRecipients: ['other@example.com'],
    //     // ccRecipients: ['third@example.com'],
    //     attachments: [
    //       filePath,
    //     ],
    //   );
    //
    //   await FlutterMailer.send(mailOptions);
    // }
    Navigator.pop(context);
  }

  showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
