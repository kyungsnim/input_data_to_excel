import 'package:input_data_to_excel/models/CurrentUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:logger/logger.dart';

import 'CourseSubmitPage.dart';
import 'MyInfoPage.dart';

// variable for firestore collection 'users'
final userReference =
    FirebaseFirestore.instance.collection('users'); // 사용자 정보 저장을 위한 ref
final courseReference = FirebaseFirestore.instance.collection('courses'); // 과제 정보 저장을 위한 ref

final DateTime timestamp = DateTime.now();
CurrentUser currentUser;
Logger logger;

class HomePage extends StatefulWidget {
  final getPageIndex;
  HomePage(this.getPageIndex);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 페이지 컨트롤
  PageController pageController;
  int getPageIndex;
  var validateToken;
  DocumentSnapshot documentSnapshot;

  @override
  void initState() {
    super.initState();
    setState(() {
      getPageIndex = widget.getPageIndex;
    });
    pageController = PageController(
      // 다른 페이지에서 넘어올 때도 controller를 통해 어떤 페이지 보여줄 것인지 셋팅
      initialPage: getPageIndex != null ? this.getPageIndex : 0
    );
  }

  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  whenPageChanges(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  onTapChangePage(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
          body: PageView(
            children: <Widget>[
              CourseSubmitPage(), // 0번 pageIndex
              MyInfoPage(), // 1번 pageIndex
            ],
            controller: pageController, // controller를 지정해주면 각 페이지별 인덱스로 컨트롤 가능
            onPageChanged:
            whenPageChanges, // page가 바뀔때마다 whenPageChanges 함수가 호출되고 현재 pageIndex 업데이트해줌
            // physics: NeverScrollableScrollPhysics(),
          ),
          // resizeToAvoidBottomPadding: true,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: this.getPageIndex,
            onTap: onTapChangePage,
            selectedItemColor: Colors.blueAccent,
            selectedIconTheme: IconThemeData(color: Colors.blueAccent, size: 35),
            selectedLabelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.blueAccent),
            unselectedItemColor: Colors.grey,
            unselectedFontSize: 12,
            showUnselectedLabels: true,
            iconSize: 25,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_sharp,), label: '과제목록', ),
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.free_breakfast), label: '무료\n수업'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: '내정보'),
            ],
          ),
        ),
      ),
    );
  }

  // back 버튼 클릭시 종료할건지 물어보는
  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("종료하시겠습니까?",
                    style: GoogleFonts.montserrat(fontSize: 18)),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "확인",
                  style:
                      GoogleFonts.montserrat(fontSize: 18, color: Colors.blue),
                ),
                onPressed: () {
                  SystemNavigator.pop();
                },
              ),
              FlatButton(
                child: Text(
                  "취소",
                  style:
                      GoogleFonts.montserrat(fontSize: 18, color: Colors.grey),
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
            ],
          ),
        ) ??
        false;
  }
}
