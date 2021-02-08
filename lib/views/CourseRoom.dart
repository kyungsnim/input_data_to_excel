// @dart=2.9
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:input_data_to_excel/views/HomePage.dart';
import 'package:input_data_to_excel/widgets/OptionTileWidget.dart';

List<dynamic> myAnswerList;

class CourseRoom extends StatefulWidget {
  final event;

  CourseRoom(this.event);
  @override
  _CourseRoomState createState() => _CourseRoomState();
}

class _CourseRoomState extends State<CourseRoom> {
  final totalLength = 50;

  @override
  void initState() {
    super.initState();
    // checked = 0;
    myAnswerList = List.generate(totalLength, (index) => null); // 50개 답안지 생성
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.event.courseName}-${widget.event.courseNumber}\n${widget.event.courseGrade}', style: TextStyle(color: Colors.blueGrey, fontSize: 15, fontWeight: FontWeight.bold)),
          centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 0.0,
          // iconTheme: IconThemeData.fallback(), // 뒤로 가기
          leading: InkWell(onTap: () => /* _onBackPressed() */{}, child: Icon(Icons.arrow_back_ios_outlined, color: Colors.blueGrey,)),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(3, 6, 26, 6),
              child: FlatButton(color: Colors.blueAccent, onPressed:() => checkSubmitPopup(), child: Text('제출', style: TextStyle(fontSize: 18, color: Colors.white))),
            ),
          ],
        ),
        body: answerList(),
      )
    );
  }

  // // back 버튼 클릭시 종료할건지 물어보는
  // Future<bool>?? _onBackPressed() async{
  //   return showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text("홈으로 이동"),
  //       content: Text("이동하시겠습니까? 입력된 자료는 저장되지 않습니다."),
  //       actions: <Widget>[
  //         FlatButton(
  //           child: Container(
  //             padding: const EdgeInsets.all(16),
  //             child: Text('확인',
  //                 style: GoogleFonts.montserrat(
  //                     color: Colors.blueAccent, fontSize: 20)),
  //           ),
  //           onPressed: () {
  //             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(0)));
  //           },
  //         ),
  //         FlatButton(
  //           child: Container(
  //             padding: const EdgeInsets.all(16),
  //             child: Text('취소',
  //                 style: GoogleFonts.montserrat(
  //                     color: Colors.grey, fontSize: 20)),
  //           ),
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ),
  //       ],
  //     ),
  //   ) ?? false;
  // }

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
          );
        });
  }

  void _submit() {
    // 몇차수 제출기간에 냈는지 체크
    var checkDegree;
    var firstDueDate = DateTime(widget.event.firstDueDate.year, widget.event.firstDueDate.month, widget.event.firstDueDate.day).microsecondsSinceEpoch;
    var secondDueDate = DateTime(widget.event.secondDueDate.year, widget.event.secondDueDate.month, widget.event.secondDueDate.day).microsecondsSinceEpoch;
    var today = DateTime.now().microsecondsSinceEpoch;

    // 오늘이 1차기간 이전이면 "1차", 1차기간 ~ 2차기간 사이면 "2차", 이외는 "3차"
    today < firstDueDate ? checkDegree = "1차"
        : firstDueDate < today && today < secondDueDate ? checkDegree = "2차"
        : checkDegree = "3차";

    courseReference.doc(widget.event.id).collection("SubmitUsers").doc(currentUser.id).set({
      "id": currentUser.id,
      "submitDegree": checkDegree,
      "answer": myAnswerList,
      "createdAt": DateTime.now(),
    });
  }
}

class AnswerTile extends StatefulWidget {
  final int index;
  AnswerTile({this.index});
  @override
  _AnswerTileState createState() => _AnswerTileState();
}

class _AnswerTileState extends State<AnswerTile> {
  String optionSelected = "";

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
                    setState(() {
                      optionSelected = "1";
                      myAnswerList[widget.index] = int.parse(optionSelected); // 정답지에 답 체크
                      // checked++;
                    });
                  // }
                },
                child: OptionTile(
                  option: "1",
                  optionSelected: optionSelected,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                    setState(() {
                      optionSelected = "2";
                      myAnswerList[widget.index] = int.parse(optionSelected); // 정답지에 답 체크
                      // checked++;
                    });
                },
                child: OptionTile(
                  option: "2",
                  optionSelected: optionSelected,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                    setState(() {
                      optionSelected = "3";
                      myAnswerList[widget.index] = int.parse(optionSelected); // 정답지에 답 체크
                      // checked++;
                    });
                },
                child: OptionTile(
                  option: "3",
                  optionSelected: optionSelected,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                    setState(() {
                      optionSelected = "4";
                      myAnswerList[widget.index] = int.parse(optionSelected); // 정답지에 답 체크
                      // checked++;
                    });
                  // }
                },
                child: OptionTile(
                  option: "4",
                  optionSelected: optionSelected,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                    setState(() {
                      optionSelected = "5";
                      myAnswerList[widget.index] = int.parse(optionSelected); // 정답지에 답 체크
                      // checked++;
                    });
                  // }
                },
                child: OptionTile(
                  option: "5",
                  optionSelected: optionSelected,
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                  width: 20,
                  color: optionSelected != "" ? Colors.green.withOpacity(0.7) : Colors.redAccent.withOpacity(0.7)
              ),
            ),
          ],
        ));
  }
}