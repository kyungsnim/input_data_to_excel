import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:input_data_to_excel/models/CourseModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:core';
import 'dart:io' as io;
import 'AddCoursePage.dart';
import 'CourseRoom.dart';
import 'HomePage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class CourseSubmitPage extends StatefulWidget {
  @override
  _CourseSubmitPageState createState() => _CourseSubmitPageState();
}

class _CourseSubmitPageState extends State<CourseSubmitPage> {
  CalendarController _regularCalendarController;
  Map<DateTime, List<dynamic>> _regularEvents = {};
  List<dynamic> _selectedRegularEvents = [];

  final weekDayList = ["일", "월", "화", "수", "목", "금", "토"];

  @override
  void dispose() {
    _regularCalendarController.dispose();
    super.dispose();
  }

  Future<QuerySnapshot> getDS() async {
    return FirebaseFirestore.instance.collection('courses')
        .get();
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
    return Scaffold(
      body: currentUser != null
          ? Container(
                      height: MediaQuery.of(context).size.height * 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 50),
                          Row(
                            children: [
                              Padding(padding: const EdgeInsets.all(10.0),
                                child: Text("과제 목록",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold))
                                    ,
                              ),
                              Spacer(),
                            ],
                          ),
                          Expanded(
                            child: regularCalendar(),
                          )
                        ],
                      ),
                    ) : Center(child: CircularProgressIndicator()),
        floatingActionButton: currentUser != null
            ?
        FloatingActionButton(
          backgroundColor: Colors.blueGrey,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddCoursePage()));
          },
        ) : Center(child: CircularProgressIndicator())
    );
  }

  Widget regularCalendar() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          gradient:
              LinearGradient(colors: [Colors.blueGrey.withOpacity(0.1), Colors.grey.withOpacity(0.1)]),
      ),
      child: StreamBuilder<List<CourseModel>>(
          stream: courseReference
              .orderBy('courseName')
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
                  _regularEvents != null ? TableCalendar(
                    events: _regularEvents,
                    initialCalendarFormat: CalendarFormat.twoWeeks,
                    calendarStyle: CalendarStyle(
                      markersColor: Colors.grey,
                      markersMaxAmount: 1,
                      weekdayStyle: GoogleFonts.montserrat(color: Colors.black),
                      highlightToday: true,
                      todayColor: Colors.grey.withOpacity(0.3),
                      todayStyle: GoogleFonts.montserrat(
                          color: Colors.white, fontSize: 15),
                      selectedColor: Colors.blueGrey,
                      selectedStyle: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      outsideWeekendStyle:
                          GoogleFonts.montserrat(color: Colors.grey.shade400),
                      outsideStyle:
                          GoogleFonts.montserrat(color: Colors.grey.shade400),
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
                  ) : LinearProgressIndicator(),
                  ..._selectedRegularEvents.map((event) => ListTile(
                        tileColor: event.courseGrade == "중학교 1학년" ? Colors.blueAccent.withOpacity(0.2)
                            : event.courseGrade == "중학교 2학년" ? Colors.blueAccent.withOpacity(0.4)
                            : event.courseGrade == "중학교 3학년" ? Colors.blueAccent.withOpacity(0.7)
                            : event.courseGrade == "고등학교 1학년" ? Colors.blueGrey.withOpacity(0.2)
                            : event.courseGrade == "고등학교 2학년" ? Colors.blueGrey.withOpacity(0.5)
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
                            Text("1차: ${event.firstDueDate.month}/${event.firstDueDate.day}(${weekDayList[event.firstDueDate.weekday]})",
                                style:
                                    GoogleFonts.montserrat(color: Colors.black54)),
                            Text("2차: ${event.secondDueDate.month}/${event.secondDueDate.day}(${weekDayList[event.secondDueDate.weekday]})",
                                style:
                                GoogleFonts.montserrat(color: Colors.black54)),
                            Text("3차: ${event.thirdDueDate.month}/${event.thirdDueDate.day}(${weekDayList[event.thirdDueDate.weekday]})",
                                style:
                                GoogleFonts.montserrat(color: Colors.black54)),
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
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('과제 풀기'),
            content: Text("과제명: ${event.courseName}-${event.courseNumber}\n학년: ${event.courseGrade}"),
            actions: [
              FlatButton(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text('확인',
                      style: GoogleFonts.montserrat(
                          color: Colors.blueAccent, fontSize: 20)),
                ),
                onPressed: () async {
                  bool submitted = false;
                  // 이미 제출했다면 기존 제출자료 삭제하고 다시 제출해야 함
                  courseReference.doc(event.id).collection("SubmitUsers").doc(currentUser.id).get().then((value) {
                  print('1');
                    if(value.exists) {
                      setState(() {
                        submitted = true;
                      });
                    }
                    print('111 : $submitted');
                  });

                  if(submitted) {
                    print('제출완료');
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(
                            builder: (context) => CourseRoom(event)));
                  }
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
}
