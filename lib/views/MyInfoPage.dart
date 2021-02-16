// @dart=2.9
import 'package:input_data_to_excel/LoginPage/SignInPageWithUserId.dart';
import 'package:input_data_to_excel/models/CurrentUser.dart';
import 'package:input_data_to_excel/views/SettingUserInfoPage.dart';
import 'package:input_data_to_excel/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'EditProfilePage.dart';
import 'HomePage.dart';
import 'SettingUserGradeInfoPage.dart';

class MyInfoPage extends StatefulWidget {
  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  final String currentUserId = currentUser.id; //
  final noticePictureList = [
    'assets/images/coin.jpg',
  ];

  @override
  void initState() {
  }

  createProfileTopView() {
    return StreamBuilder(
      // 현재 로그인한 유저의 정보로 DB 데이터 가져오기
        stream: userReference.doc(currentUser.id).get().asStream(),
        builder: (context, dataSnapshot) {
          // 가져오는 동안 Progress bar
          if (!dataSnapshot.hasData) {
            return circularProgress();
          }

          // 가져온 데이터로 User 인스턴스에 담기
          CurrentUser user = CurrentUser.fromDocument(dataSnapshot.data);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text("수험번호",
                        style: GoogleFonts.montserrat(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              userInfo(user.id),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text("학년",
                        style: GoogleFonts.montserrat(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              userInfo(user.grade),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text("이름",
                        style: GoogleFonts.montserrat(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              userInfo(user.name),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text("휴대폰번호",
                        style: GoogleFonts.montserrat(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              userInfo(user.phoneNumber),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text("가입일",
                        style: GoogleFonts.montserrat(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              userInfo("${user.createdAt.year}년 ${user.createdAt.month}월 ${user.createdAt.day}일"),
              SizedBox(height: 10),
              Center(
                child: Container(
                    width: 200,
                    child: RaisedButton(
                      color: Colors.blueAccent,
                      child: Text(
                        '정보 수정',
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => _showEditProfileDialog(context),
                    )),
              ),
              SizedBox(height: 10),
              Center(
                child: Container(
                    width: 200,
                    child: RaisedButton(
                      color: Colors.blueGrey,
                      child: Text(
                        '로그아웃',
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => signOut(),
                    )),
              ),
              SizedBox(height: 10),
              Center(
                child: Container(
                    width: 200,
                    child: RaisedButton(
                      color: Colors.redAccent,
                      child: Text(
                        '회원 탈퇴',
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => deleteCheckPopup(),
                    )),
              ),
              SizedBox(height: 10),
              currentUser.role == 'admin' ? Center(
                child: Container(
                    width: 200,
                    child: RaisedButton(
                      color: Colors.redAccent,
                      child: Text(
                        '가입 승인 (관리자용)',
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingUserInfoPage())),
                    )),
              ) : Container(),
              SizedBox(height: 10),
              currentUser.role == 'admin' ? Center(
                child: Container(
                    width: 200,
                    child: RaisedButton(
                      color: Colors.teal,
                      child: Text(
                        '학년 일괄수정 (관리자용)',
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingUserGradeInfoPage())),
                    )),
              ) : Container(),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: currentUser != null ? Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  Padding(padding: const EdgeInsets.all(10.0),
                    child: Text("내 정보",
                        style: GoogleFonts.montserrat(
                            fontSize: 30,
                            fontWeight: FontWeight.bold))
                    ,
                  ),
                  Spacer(),
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    createProfileTopView(),
                  ],
                ),
              ),
            ],
          ),
        ) : Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          strokeWidth: 10,)));
  }

  signOut() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('signOut', 'YES');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPageWithUserId()));
    } catch (e) {
      print(e);
    }

  }

  userInfo(userInfo) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.withOpacity(0.2)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Row(
                            // 사용자 이름
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                userInfo, //user.userId,
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  deleteCheckPopup() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('회원 탈퇴'),
            content: Text("탈퇴하시겠습니까?"),
            actions: [
              FlatButton(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text('확인',
                      style: GoogleFonts.montserrat(
                          color: Colors.blueAccent, fontSize: 20)),
                ),
                onPressed: () async {
                  userReference.doc(currentUserId).delete();
                  signOut();
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

  void _showEditProfileDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('정보 수정',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  fontSize: 18))
              ,
          actionsPadding: EdgeInsets.only(right: 10),
          elevation: 0.0,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 1,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: EditProfilePage(currentUserId: currentUserId)
          ),
        );
      },
    );
  }
}
