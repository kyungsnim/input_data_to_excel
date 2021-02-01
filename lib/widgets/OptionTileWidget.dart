import 'package:flutter/material.dart';

// 문제 푸는 사람이 어떤 보기 체크하는지 파악이 필요하므로 stful widget으로 생성
class OptionTile extends StatefulWidget {
  final String option, optionSelected; // description, correctAnswer,
  // final bool isViewAnswer;

  OptionTile({
    @required this.option,
    @required this.optionSelected,
    // @required this.correctAnswer,
    // @required this.description,
    // @required this.isViewAnswer
  });

  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white10)), // 보기박스 테두리
        child: Row(
          children: <Widget>[
            Container(
              // A,B,C,D 보기 동그라미
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: widget.option == widget.optionSelected ? Colors.blueAccent : Colors.black87,
                      width: 1)),
              child: Text("${widget.option}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.option == widget.optionSelected ? Colors.blueAccent : Colors.black87,
                    fontSize: 20
                  )),
            ),
          ],
        ));
  }
}