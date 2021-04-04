// @dart=2.9
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:input_data_to_excel/views/HomePage.dart';
import 'package:input_data_to_excel/widgets/OptionTileWidget.dart';
import 'package:toast/toast.dart';

List<dynamic> myAnswerList;

class CourseRoom2 extends StatefulWidget {
  final event;

  CourseRoom2(this.event);

  @override
  _CourseRoom2State createState() => _CourseRoom2State();
}

class _CourseRoom2State extends State<CourseRoom2> {
  final totalLength = 50;

  @override
  void initState() {
    super.initState();
    // checked = 0;
    myAnswerList = List.generate(totalLength, (index) => null); // 50개 답안지 생성

    for(int i = 0; i < myAnswerList.length; i++) {
      myAnswerList[i] = new List<int>(5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.event.courseName}-${widget.event.courseNumber}\n${widget.event.courseGrade}',
            style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        // iconTheme: IconThemeData.fallback(), // 뒤로 가기
        leading: InkWell(
            onTap: () => _onBackPressed(),
            child: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.blueGrey,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(3, 6, 26, 6),
            child: FlatButton(
                color: Colors.blueAccent,
                onPressed: () => checkSubmitPopup(),
                child: Text('제출',
                    style: TextStyle(fontSize: 18, color: Colors.white))),
          ),
        ],
      ),
      body: answerList(),
    ));
  }

  // back 버튼 클릭시 종료할건지 물어보는
  Future<bool> _onBackPressed() async{
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("홈으로 이동"),
        content: Text("이동하시겠습니까? 입력된 자료는 저장되지 않습니다."),
        actions: <Widget>[
          FlatButton(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Text('확인',
                  style: GoogleFonts.montserrat(
                      color: Colors.blueAccent, fontSize: 20)),
            ),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(0)));
            },
          ),
          FlatButton(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Text('취소',
                  style: GoogleFonts.montserrat(
                      color: Colors.grey, fontSize: 20)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ) ?? false;
  }

  answerList() {
    return Container(
        child: Scrollbar(
      thickness: 15,
      // 문제 리스트에 스크롤 보이게
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          // The getter 'documents' was called on null. 오류 남
          ListView.builder(
            primary: true,
            padding: EdgeInsets.symmetric(horizontal: 24),
            shrinkWrap: true,
            // 'visible' was called on null 방지
            physics: ClampingScrollPhysics(),
            // 'visible' was called on null 방지
            itemCount: 50,
            itemBuilder: (context, index) {
              return AnswerTile(
                index: index,
              );
            },
          ),
        ],
      ),
    ));
  }

  checkSubmitPopup() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('과제 제출'),
            content: Text("한 번 제출하면 다시 제출할 수 없습니다. 제출하시겠습니까?"),
            actions: [
              FlatButton(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text('확인',
                      style: GoogleFonts.montserrat(
                          color: Colors.blueAccent, fontSize: 20)),
                ),
                onPressed: () {
                  _submit();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage(0)));
                  showToast('제출 완료', duration: 2);
                },
              ),
              FlatButton(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text('취소',
                      style: GoogleFonts.montserrat(
                          color: Colors.grey, fontSize: 20)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _submit() {
    // 몇차수 제출기간에 냈는지 체크
    var checkDegree;
    var firstDueDate = DateTime(widget.event.firstDueDate.year,
            widget.event.firstDueDate.month, widget.event.firstDueDate.day, 23, 59, 59)
        .microsecondsSinceEpoch;
    var secondDueDate = DateTime(widget.event.secondDueDate.year,
            widget.event.secondDueDate.month, widget.event.secondDueDate.day, 23, 59, 59)
        .microsecondsSinceEpoch;
    var today = DateTime.now().microsecondsSinceEpoch;

    // 오늘이 1차기간 이전이면 "1차", 1차기간 ~ 2차기간 사이면 "2차", 이외는 "3차"
    today < firstDueDate
        ? checkDegree = "1차"
        : firstDueDate < today && today < secondDueDate
            ? checkDegree = "2차"
            : checkDegree = "3차";

    courseReference
        .doc(widget.event.id)
        .collection("SubmitUsers")
        .doc(currentUser.id)
        .set({
      "id": currentUser.id,
      "courseName": widget.event.courseName,
      "courseNumber": widget.event.courseNumber,
      "submitDegree": checkDegree,
      "name": currentUser.name,
      "phoneNumber": currentUser.phoneNumber,
      "answer1": myAnswerList[0],
      "answer2": myAnswerList[1],
      "answer3": myAnswerList[2],
      "answer4": myAnswerList[3],
      "answer5": myAnswerList[4],
      "answer6": myAnswerList[5],
      "answer7": myAnswerList[6],
      "answer8": myAnswerList[7],
      "answer9": myAnswerList[8],
      "answer10": myAnswerList[9],
      "answer11": myAnswerList[10],
      "answer12": myAnswerList[11],
      "answer13": myAnswerList[12],
      "answer14": myAnswerList[13],
      "answer15": myAnswerList[14],
      "answer16": myAnswerList[15],
      "answer17": myAnswerList[16],
      "answer18": myAnswerList[17],
      "answer19": myAnswerList[18],
      "answer20": myAnswerList[19],
      "answer21": myAnswerList[20],
      "answer22": myAnswerList[21],
      "answer23": myAnswerList[22],
      "answer24": myAnswerList[23],
      "answer25": myAnswerList[24],
      "answer26": myAnswerList[25],
      "answer27": myAnswerList[26],
      "answer28": myAnswerList[27],
      "answer29": myAnswerList[28],
      "answer30": myAnswerList[29],
      "answer31": myAnswerList[30],
      "answer32": myAnswerList[31],
      "answer33": myAnswerList[32],
      "answer34": myAnswerList[33],
      "answer35": myAnswerList[34],
      "answer36": myAnswerList[35],
      "answer37": myAnswerList[36],
      "answer38": myAnswerList[37],
      "answer39": myAnswerList[38],
      "answer40": myAnswerList[39],
      "answer41": myAnswerList[40],
      "answer42": myAnswerList[41],
      "answer43": myAnswerList[42],
      "answer44": myAnswerList[43],
      "answer45": myAnswerList[44],
      "answer46": myAnswerList[45],
      "answer47": myAnswerList[46],
      "answer48": myAnswerList[47],
      "answer49": myAnswerList[48],
      "answer50": myAnswerList[49],
      "createdAt": DateTime.now(),
    });
  }

  showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}

class AnswerTile extends StatefulWidget {
  final int index;

  AnswerTile({this.index});

  @override
  _AnswerTileState createState() => _AnswerTileState();
}

class _AnswerTileState extends State<AnswerTile> {
  List<String> optionSelected = new List<String>(5);

  @override
  void initState() {
    super.initState();

    for(int i = 0; i < optionSelected.length; i++) {
      optionSelected[i] = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 4,
              child: Container(
                width: 50,
                child: Text(
                  "${widget.index + 1}. ",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ),
            // String option, description, correctAnswer, optionSelected
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  if(optionSelected[0] == "1") {
                    setState(() {
                      optionSelected[0] = "";
                      myAnswerList[widget.index][0] = 0;
                    });
                  } else {
                    setState(() {
                      optionSelected[0] = "1";
                      myAnswerList[widget.index][0] = 1; // 정답지에 답 체크
                      // checked++;
                    });
                  }
                },
                child: OptionTile(
                  option: "1",
                  optionSelected: optionSelected[0],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  if(optionSelected[1] == "2") {
                    setState(() {
                      optionSelected[1]= "";
                      myAnswerList[widget.index][1] = 0;
                    });
                  } else {
                    setState(() {
                      optionSelected[1] = "2";
                      myAnswerList[widget.index][1] = 1; // 정답지에 답 체크
                    });
                  }
                },
                child: OptionTile(
                  option: "2",
                  optionSelected: optionSelected[1],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  if(optionSelected[2] == "3") {
                    setState(() {
                      optionSelected[2]= "";
                      myAnswerList[widget.index][2] = 0;
                    });
                  } else {
                    setState(() {
                      optionSelected[2] = "3";
                      myAnswerList[widget.index][2] = 1; // 정답지에 답 체크
                      // checked++;
                    });
                  }
                },
                child: OptionTile(
                  option: "3",
                  optionSelected: optionSelected[2],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  if(optionSelected[3] == "4") {
                    setState(() {
                      optionSelected[3]= "";
                      myAnswerList[widget.index][3] = 0;
                    });
                  } else {
                    setState(() {
                      optionSelected[3] = "4";
                      myAnswerList[widget.index][3] = 1; // 정답지에 답 체크
                      // checked++;
                    });
                  }
                },
                child: OptionTile(
                  option: "4",
                  optionSelected: optionSelected[3],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  if(optionSelected[4] == "5") {
                    setState(() {
                      optionSelected[4]= "";
                      myAnswerList[widget.index][4] = 0;
                    });
                  } else {
                    setState(() {
                      optionSelected[4] = "5";
                      myAnswerList[widget.index][4] = 1; // 정답지에 답 체크
                    });
                  }
                },
                child: OptionTile(
                  option: "5",
                  optionSelected: optionSelected[4],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                  width: 20,
                  color: optionSelected[0] != "" || optionSelected[1] != ""
                      || optionSelected[2] != "" || optionSelected[3] != "" || optionSelected[4] != ""
                      ? Colors.green.withOpacity(0.7)
                      : Colors.redAccent.withOpacity(0.7)),
            ),
          ],
        ));
  }
}
