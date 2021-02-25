import 'package:input_data_to_excel/models/CurrentUser.dart';
import 'package:input_data_to_excel/res/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:input_data_to_excel/views/HomePage.dart';
import 'package:toast/toast.dart';

class SettingUserGradeInfoPage extends StatefulWidget {
  @override
  _SettingUserGradeInfoPageState createState() =>
      _SettingUserGradeInfoPageState();
}

class _SettingUserGradeInfoPageState extends State<SettingUserGradeInfoPage> {
  DatabaseService databaseService = new DatabaseService();

  // 학년별 유저목록 (j2: 중2, j3: 중3, g1: 고1, g2: 고2)
  QuerySnapshot j2Snapshot,
      j3Snapshot,
      g1Snapshot,
      g2Snapshot,
      g3Snapshot,
      tmpSnapshot;
  Stream j2Stream, j3Stream, g1Stream, g2Stream, g3Stream;

  // 학년별 유저 수
  var j2Count = 0, j3Count = 0, g1Count = 0, g2Count = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    databaseService.getJ2List().then((val) {
      setState(() {
        j2Snapshot = val;
      });
    });
    databaseService.getJ3List().then((val) {
      setState(() {
        j3Snapshot = val;
      });
    });
    databaseService.getG1List().then((val) {
      setState(() {
        g1Snapshot = val;
      });
    });
    databaseService.getG2List().then((val) {
      setState(() {
        g2Snapshot = val;
      });
    });
    databaseService.getG3List().then((val) {
      setState(() {
        g3Snapshot = val;
      });
    });
  }

  toUpperGrade() {
    databaseService.getUserGradeList().then((tmpSnapshot) {
      // batch 생성
      WriteBatch writeBatch = firestoreReference.batch();

      if (mounted) {
        for (int i = 0; i < tmpSnapshot.docs.length; i++) {
          switch (tmpSnapshot.docs[i].data()['grade']) {
            case '중학교 2학년':
              writeBatch.update(userReference.doc(tmpSnapshot.docs[i].id),
                  {'grade': '중학교 3학년'});
              break;
            case '중학교 3학년':
              writeBatch.update(userReference.doc(tmpSnapshot.docs[i].id),
                  {'grade': '고등학교 1학년'});
              break;
            case '고등학교 1학년':
              writeBatch.update(userReference.doc(tmpSnapshot.docs[i].id),
                  {'grade': '고등학교 2학년'});
              break;
            case '고등학교 2학년':
              writeBatch.update(userReference.doc(tmpSnapshot.docs[i].id),
                  {'grade': '고등학교 3학년'});
              break;
            case '고등학교 3학년':
              writeBatch.update(
                  userReference.doc(tmpSnapshot.docs[i].id), {'grade': '졸업'});
              break;
          }
        }
      }

      writeBatch.commit();
    });
  }

  toLowerGrade() {
    databaseService.getUserGradeList().then((tmpSnapshot) {
      // batch 생성
      WriteBatch writeBatch = firestoreReference.batch();

      if (mounted) {
        for (int i = 0; i < tmpSnapshot.docs.length; i++) {
          switch (tmpSnapshot.docs[i].data()['grade']) {
            case '중학교 3학년':
              writeBatch.update(userReference.doc(tmpSnapshot.docs[i].id),
                  {'grade': '중학교 2학년'});
              break;
            case '고등학교 1학년':
              writeBatch.update(userReference.doc(tmpSnapshot.docs[i].id),
                  {'grade': '중학교 3학년'});
              break;
            case '고등학교 2학년':
              writeBatch.update(userReference.doc(tmpSnapshot.docs[i].id),
                  {'grade': '고등학교 1학년'});
              break;
            case '고등학교 3학년':
              writeBatch.update(userReference.doc(tmpSnapshot.docs[i].id),
                  {'grade': '고등학교 2학년'});
              break;
            case '졸업':
              writeBatch.update(userReference.doc(tmpSnapshot.docs[i].id),
                  {'grade': '고등학교 3학년'});
              break;
          }
        }
      }

      writeBatch.commit();
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.d('SettingUserGradeInfoPage : 학년 일괄수정 페이지');
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              centerTitle: false,
              backgroundColor: Colors.white,
              elevation: 0.0,
              leading: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.blueGrey,
                  )),
              title: Text(
                '학년 일괄변경',
                style: GoogleFonts.montserrat(color: Colors.blueGrey),
              )),
          body: j2Snapshot != null &&
                  j3Snapshot != null &&
                  g1Snapshot != null &&
                  g2Snapshot != null &&
                  g3Snapshot != null
              ? Container(
                  height: MediaQuery.of(context).size.height * 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text("중학교 2학년",
                                style: GoogleFonts.montserrat(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      userInfo(j2Snapshot.docs.length.toString()),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text("중학교 3학년",
                                style: GoogleFonts.montserrat(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      userInfo(j3Snapshot.docs.length.toString()),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text("고등학교 1학년",
                                style: GoogleFonts.montserrat(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      userInfo(g1Snapshot.docs.length.toString()),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text("고등학교 2학년",
                                style: GoogleFonts.montserrat(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      userInfo(g2Snapshot.docs.length.toString()),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text("고등학교 3학년",
                                style: GoogleFonts.montserrat(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      userInfo(g3Snapshot.docs.length.toString()),
                      Center(
                        child: Container(
                            width: 200,
                            child: RaisedButton(
                              color: Colors.blueAccent,
                              child: Text(
                                '학년 일괄 올리기 (관리자용)',
                                style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                checkGradeUpperPopup();
                              },
                            )),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Container(
                            width: 200,
                            child: RaisedButton(
                              color: Colors.redAccent,
                              child: Text(
                                '학년 일괄 내리기 (관리자용)',
                                style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                checkGradeLowerPopup();
                                // toLowerGrade();
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => HomePage(1)));
                              },
                            )),
                      ),
                      SizedBox(height: 10),
                    ],
                  ))
              : Center(child: CircularProgressIndicator())),
    );
  }

  checkGradeUpperPopup() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('학년 일괄 올리기'),
            content: Text(
                "학년 일괄 변경은 매년 3월경 일회성으로 필요한 작업입니다. 신중히 판단하여 일괄 변경을 해주시기 바랍니다. 모든 사용자에 대하여 한 학년을 올리시겠습니까?"),
            actions: [
              FlatButton(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text('확인',
                      style: GoogleFonts.montserrat(
                          color: Colors.blueAccent, fontSize: 20)),
                ),
                onPressed: () async {
                  toUpperGrade();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage(1)));
                  showToast('학년 일괄 올리기 완료', duration: 2, gravity: 3);
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

  showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  checkGradeLowerPopup() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('학년 일괄 내리기'),
            content: Text(
                "해당 기능은 실수로 모든 사용자의 학년을 올렸을 때 사용하는 기능입니다. 모든 사용자에 대하여 한 학년을 내리시겠습니까?"),
            actions: [
              FlatButton(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text('확인',
                      style: GoogleFonts.montserrat(
                          color: Colors.blueAccent, fontSize: 20)),
                ),
                onPressed: () async {
                  toLowerGrade();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage(1)));
                  showToast('학년 일괄 내리기 완료', duration: 2, gravity: 3);
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

  userInfo(userInfo) {
    return j2Snapshot != null &&
            j3Snapshot != null &&
            g1Snapshot != null &&
            g2Snapshot != null &&
            g3Snapshot != null
        ? Padding(
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
          )
        : Center(child: CircularProgressIndicator());
  }
}
