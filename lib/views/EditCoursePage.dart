import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';

import 'HomePage.dart';

class EditCoursePage extends StatefulWidget {
  final String id;
  final String courseName;
  final String courseNumber;
  final String courseGrade;
  final DateTime courseDate;
  final DateTime firstDueDate;
  final DateTime secondDueDate;
  final DateTime thirdDueDate;

  EditCoursePage({
    this.id,
    this.courseName,
    this.courseNumber,
    this.courseGrade,
    this.courseDate,
    this.firstDueDate,
    this.secondDueDate,
    this.thirdDueDate
  });

  @override
  _EditCoursePageState createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  TextStyle style = GoogleFonts.montserrat(fontSize: 20.0);
  TextEditingController _courseName;
  var _courseNumber;
  var _courseGrade;
   DateTime _courseDate;
   DateTime _firstDueDate;
   DateTime _secondDueDate;
   DateTime _thirdDueDate;

  final _courseNumberList = [
    '1-1회',
    '1-2회',
    '1-3회',
    '1-4회',
    '1-5회',
    '2-1회',
    '2-2회',
    '2-3회',
    '2-4회',
    '2-5회',
    '3-1회',
    '3-2회',
    '3-3회',
    '3-4회',
    '3-5회',
    '4-1회',
    '4-2회',
    '4-3회',
    '4-4회',
    '4-5회',
    '5-1회',
    '5-2회',
    '5-3회',
    '5-4회',
    '5-5회',
    '6-1회',
    '6-2회',
    '6-3회',
    '6-4회',
    '6-5회',
    '7-1회',
    '7-2회',
    '7-3회',
    '7-4회',
    '7-5회',
    '8-1회',
    '8-2회',
    '8-3회',
    '8-4회',
    '8-5회',
    '9-1회',
    '9-2회',
    '9-3회',
    '9-4회',
    '9-5회',
    '10-1회',
    '10-2회',
    '10-3회',
    '10-4회',
    '10-5회',
  ];
  final _gradeList = [
    '중학교 1학년',
    '중학교 2학년',
    '중학교 3학년',
    '고등학교 1학년',
    '고등학교 2학년',
    '고등학교 3학년',
  ];

  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
   bool processing;

  @override
  void initState() {
    super.initState();

    _courseName = TextEditingController(text: widget.courseName);
    _courseNumber = widget.courseNumber;
    _courseGrade = widget.courseGrade;
    _courseDate = widget.courseDate;
    _firstDueDate = widget.firstDueDate;
    _secondDueDate = widget.secondDueDate;
    _thirdDueDate = widget.thirdDueDate;
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                  child: Text('과제명',
                                      style: GoogleFonts.montserrat(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold)))),
                        ],
                      ),
                      SizedBox(height: 3),
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                style: GoogleFonts.montserrat(fontSize: 15),
                                controller: _courseName,
                                validator: (value) =>
                                    (value.isEmpty) ? "과제명을 입력하세요." : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                  child: Text('과제 회차',
                                      style: GoogleFonts.montserrat(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold)))),
                        ],
                      ),
                      SizedBox(height: 3),
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: DropdownButton(
                                  value: _courseNumber,
                                  icon: Icon(Icons.arrow_downward),
                                  underline: Container(
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                  items: _courseNumberList.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text("$value",
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15)),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _courseNumber = value;
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                  child: Text('과제 학년',
                                      style: GoogleFonts.montserrat(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold)))),
                        ],
                      ),
                      SizedBox(height: 3),
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: DropdownButton(
                                  value: _courseGrade,
                                  icon: Icon(Icons.arrow_downward),
                                  underline: Container(
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                  items: _gradeList.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text("$value",
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15)),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _courseGrade = value;
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                  child: Text('수업 일시',
                                      style: GoogleFonts.montserrat(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold)))),
                        ],
                      ),
                      SizedBox(height: 3),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueGrey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                        "${_courseDate.year}-${_courseDate.month}-${_courseDate.day}"),
                                    SizedBox(width: 10),
                                    Icon(Icons.calendar_today,
                                        color: Colors.blueGrey)
                                  ],
                                ),
                                onTap: () async {
                                  DateTime picked = (await showDatePicker(
                                      context: context,
                                      initialDate: _courseDate,
                                      firstDate: DateTime(_courseDate.year - 5),
                                      lastDate: DateTime(_courseDate.year + 5)));
                                  if (picked != null) {
                                    setState(() {
                                      _courseDate = picked;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                  child: Text('1차 제출기간',
                                      style: GoogleFonts.montserrat(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold)))),
                        ],
                      ),
                      SizedBox(height: 3),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueGrey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                        "${_firstDueDate.year}-${_firstDueDate.month}-${_firstDueDate.day}"),
                                    SizedBox(width: 10),
                                    Icon(Icons.calendar_today,
                                        color: Colors.blueGrey)
                                  ],
                                ),
                                onTap: () async {
                                  DateTime picked = (await showDatePicker(
                                      context: context,
                                      initialDate: _firstDueDate,
                                      firstDate:
                                          DateTime(_firstDueDate.year - 5),
                                      lastDate:
                                          DateTime(_firstDueDate.year + 5)));
                                  if (picked != null) {
                                    setState(() {
                                      _firstDueDate = picked;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                  child: Text('2차 제출기간',
                                      style: GoogleFonts.montserrat(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold)))),
                        ],
                      ),
                      SizedBox(height: 3),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueGrey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                        "${_secondDueDate.year}-${_secondDueDate.month}-${_secondDueDate.day}"),
                                    SizedBox(width: 10),
                                    Icon(Icons.calendar_today,
                                        color: Colors.blueGrey)
                                  ],
                                ),
                                onTap: () async {
                                  DateTime picked = (await showDatePicker(
                                      context: context,
                                      initialDate: _secondDueDate,
                                      firstDate:
                                          DateTime(_secondDueDate.year - 5),
                                      lastDate:
                                          DateTime(_secondDueDate.year + 5)));
                                  if (picked != null) {
                                    setState(() {
                                      _secondDueDate = picked;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                  child: Text('3차 제출기간',
                                      style: GoogleFonts.montserrat(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold)))),
                        ],
                      ),
                      SizedBox(height: 3),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueGrey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                        "${_thirdDueDate.year}-${_thirdDueDate.month}-${_thirdDueDate.day}"),
                                    SizedBox(width: 10),
                                    Icon(Icons.calendar_today,
                                        color: Colors.blueGrey)
                                  ],
                                ),
                                onTap: () async {
                                  DateTime picked = (await showDatePicker(
                                      context: context,
                                      initialDate: _thirdDueDate,
                                      firstDate:
                                          DateTime(_thirdDueDate.year - 5),
                                      lastDate:
                                          DateTime(_thirdDueDate.year + 5)));
                                  if (picked != null) {
                                    setState(() {
                                      _thirdDueDate = picked;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 10.0),
              processing
                  ? Center(child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                strokeWidth: 10,
              ),)
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.blueAccent,
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                processing = true;
                              });
                              await courseReference.doc(widget.id).update({
                                "id": widget.id,
                                "courseName": _courseName.text,
                                "courseNumber": _courseNumber,
                                "courseGrade": _courseGrade,
                                "courseDate": _courseDate,
                                "firstDueDate": _firstDueDate,
                                "secondDueDate": _secondDueDate,
                                "thirdDueDate": _thirdDueDate,
                              });

                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(0)));

                              showToast("과제 변경 완료", duration: 2);
                              setState(() {
                                processing = false;
                              });
                            }
                          },
                          child: Text(
                            "과제 수정",
                            style: style.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }

  showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  @override
  void dispose() {
    _courseName.dispose();
    super.dispose();
  }
}
