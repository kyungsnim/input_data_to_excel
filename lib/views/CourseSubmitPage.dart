import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

// import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:input_data_to_excel/models/CourseModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server/gmail.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:core';
import 'dart:io' as io;
import 'AddCoursePage.dart';
import 'CourseRoom.dart';
import 'HomePage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

String fileName;
File f;
class CourseSubmitPage extends StatefulWidget {
  @override
  _CourseSubmitPageState createState() => _CourseSubmitPageState();
}

class _CourseSubmitPageState extends State<CourseSubmitPage> {
  CalendarController _regularCalendarController;
  Map<DateTime, List<dynamic>> _regularEvents = {};
  List<dynamic> _selectedRegularEvents = [];
  String filePath;
  final weekDayList = ["일", "월", "화", "수", "목", "금", "토"];

  @override
  void dispose() {
    _regularCalendarController.dispose();
    super.dispose();
  }

  Future<QuerySnapshot> getDS() async {
    return FirebaseFirestore.instance.collection('courses').get();
  }

  @override
  void initState() {
    super.initState();
    _regularCalendarController = CalendarController();
  }

  void _onDayRegularSelected(day, events, List e) {
    setState(() {
      _selectedRegularEvents = events;
    });
  }

  Map<DateTime, List<dynamic>> _groupRegularCourses(List<CourseModel> courses) {
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
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
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
                      Expanded(
                        child: regularCalendar(),
                      )
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator()),
          floatingActionButton: currentUser != null
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
              : Center(child: CircularProgressIndicator())),
    );
  }

  Widget regularCalendar() {
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
              return Center(child: CircularProgressIndicator());
            } else {
              List<CourseModel> allCourses = snapshot.data;
              if (allCourses.isNotEmpty) {
                _regularEvents = _groupRegularCourses(allCourses);
              }
            }
            return ListView(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _regularEvents != null
                      ? TableCalendar(
                          events: _regularEvents,
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
                          onDaySelected: _onDayRegularSelected,
                          calendarController: _regularCalendarController,
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
                  ..._selectedRegularEvents.map((event) => ListTile(
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
                        onTap: () {
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
    fileName = '${event.courseName}-${event.courseNumber}_${event.courseGrade}_${event.courseDate.year}년${event.courseDate.month}월${event.courseDate.day}일.csv';
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
                        await getCsv(event);
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

  getCsv(event) async {
    List<List<dynamic>> rows = List<List<dynamic>>();

    var cloud =
        await courseReference.doc(event.id).collection('SubmitUsers').get();

    rows.add([
      "수험번호",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10",
      "11",
      "12",
      "13",
      "14",
      "15",
      "16",
      "17",
      "18",
      "19",
      "20",
      "21",
      "22",
      "23",
      "24",
      "25",
      "26",
      "27",
      "28",
      "29",
      "30",
      "31",
      "32",
      "33",
      "34",
      "35",
      "36",
      "37",
      "38",
      "39",
      "30",
      "41",
      "42",
      "43",
      "44",
      "45",
      "46",
      "47",
      "48",
      "49",
      "50",
    ]);

    if (cloud.docs != null) {
      for (int i = 0; i < cloud.docs.length; i++) {
        List<dynamic> row = List<dynamic>();
        // 수험번호 넣기
        row.add(cloud.docs[i].data()['id']);
        // 50까지 입력 답 넣기
        for (int j = 0; j < 50; j++) {
          row.add(cloud.docs[i].data()['answer'][j]);
        }
        rows.add(row);
      }
      // for (int i = 0; i < cloud.data["collected"].length; i++) {
      //   List<dynamic> row = List<dynamic>();
      //   row.add(cloud.data["collected"][i]["name"]);
      //   row.add(cloud.data["collected"][i]["gender"]);
      //   row.add(cloud.data["collected"][i]["phone"]);
      //   row.add(cloud.data["collected"][i]["email"]);
      //   row.add(cloud.data["collected"][i]["age_bracket"]);
      //   row.add(cloud.data["collected"][i]["area"]);
      //   row.add(cloud.data["collected"][i]["assembly"]);
      //   row.add(cloud.data["collected"][i]["meal_ticket"]);
      //   rows.add(row);
      // }

      f = await _localFile;

      String csv = const ListToCsvConverter().convert(rows);
      f.writeAsString(csv);
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
    const GMAIL_SCHEMA = 'com.google.android.gm';

    // final bool gmailinstalled =  await isAppInstalled(GMAIL_SCHEMA);
    // final bool canSend = await canSendMail();

    if(Platform.isIOS) {
      Reference levelTestRef = FirebaseStorage.instance.ref().child('submitList/${DateTime.now().year}년/${DateTime.now().month}월/${event.courseName}-${event.courseNumber}_${event.courseGrade}_${event.courseDate.year}년${event.courseDate.month}월${event.courseDate.day}일');
      // // upload Task는 제공되나 아직 실제 업로드 전
      UploadTask uploadTask = levelTestRef.putFile(f);
      // 실제 파일 업로드 (중간에 중단, 취소 등 하지 않을 것이므로 최대한 심플하게 가보자.)
      await uploadTask.whenComplete(() => showToast('파일 업로드 완료', duration: 2));
    } else {
      // 이메일 전송 테스트
      final MailOptions mailOptions = MailOptions(
        body: event.courseName + event.courseNumber + ' 과제에 대한 엑셀 취합내용 메일 전송입니다.',
        subject:
        '${event.courseName}-${event.courseNumber}_${event.courseGrade}_${event.courseDate.year}년${event.courseDate.month}월${event.courseDate.day}일',
        recipients: ['skyboom86@gmail.com'],
        isHTML: false,
        // bccRecipients: ['other@example.com'],
        // ccRecipients: ['third@example.com'],
        attachments: [ filePath, ],
      );

      await FlutterMailer.send(mailOptions);
    }
    // final Uri _emailLaunchUri = Uri(
    //   scheme: 'mailto',
    //   path: 'skyboom86@gmail.com',
    //   queryParameters: {
    //     'subject' : event.courseName+event.courseNumber
    //   },
    //
    // );
    //
    // launch(_emailLaunchUri.toString());
    Navigator.pop(context);
  }

  showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
