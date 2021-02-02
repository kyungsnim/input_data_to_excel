import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'HomePage.dart';

class AddCoursePage extends StatefulWidget {
  @override
  _AddCoursePageState createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  TextStyle style = GoogleFonts.montserrat(fontSize: 20.0);
  TextEditingController _courseName;
  var _courseNumber;
  var _courseGrade;
  DateTime _courseDate;
  DateTime _firstDueDate;
  DateTime _secondDueDate;
  DateTime _thirdDueDate;

  final _courseNumberList = [
    '1회',
    '2회',
    '3회',
    '4회',
    '5회',
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

    _courseName = TextEditingController(text: "");
    _courseNumber = '1회';
    _courseGrade = '중학교 1학년';
    _courseDate = DateTime.now();
    _firstDueDate = DateTime.now();
    _secondDueDate = DateTime.now();
    _thirdDueDate = DateTime.now();
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("과제 추가"),
      ),
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
                                  DateTime picked = await showDatePicker(
                                      context: context,
                                      initialDate: _courseDate,
                                      firstDate: DateTime(_courseDate.year - 5),
                                      lastDate: DateTime(_courseDate.year + 5));
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
                                  DateTime picked = await showDatePicker(
                                      context: context,
                                      initialDate: _firstDueDate,
                                      firstDate:
                                          DateTime(_firstDueDate.year - 5),
                                      lastDate:
                                          DateTime(_firstDueDate.year + 5));
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
                                  DateTime picked = await showDatePicker(
                                      context: context,
                                      initialDate: _secondDueDate,
                                      firstDate:
                                          DateTime(_secondDueDate.year - 5),
                                      lastDate:
                                          DateTime(_secondDueDate.year + 5));
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
                                  DateTime picked = await showDatePicker(
                                      context: context,
                                      initialDate: _thirdDueDate,
                                      firstDate:
                                          DateTime(_thirdDueDate.year - 5),
                                      lastDate:
                                          DateTime(_thirdDueDate.year + 5));
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
                              var id = DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString();
                              await courseReference.doc(id).set({
                                "id": id,
                                "courseName": _courseName.text,
                                "courseNumber": _courseNumber,
                                "courseGrade": _courseGrade,
                                "courseDate": _courseDate,
                                "firstDueDate": _firstDueDate,
                                "secondDueDate": _secondDueDate,
                                "thirdDueDate": _thirdDueDate,
                              });

                              Navigator.pop(context);
                              setState(() {
                                processing = false;
                              });
                            }
                          },
                          child: Text(
                            "과제 생성",
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

  @override
  void dispose() {
    _courseName.dispose();
    super.dispose();
  }
}
