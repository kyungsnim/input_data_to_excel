// @dart=2.9
import 'package:input_data_to_excel/models/CurrentUser.dart';
import 'package:input_data_to_excel/widgets/ProgressWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';

import 'HomePage.dart';

class EditProfilePage extends StatefulWidget {
  final String currentUserId;

  EditProfilePage({this.currentUserId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  CurrentUser currentUser;
  final gradeList = ["중학교 1학년", "중학교 2학년","중학교 3학년","고등학교 1학년","고등학교 2학년","고등학교 3학년",];
  var grade; // 학년

  @override
  void initState() {
    super.initState();

    // 화면 빌드 전 미리 해당 사용자의 값들로 셋팅해주자
    getAndDisplayUserInformation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getAndDisplayUserInformation() async {
    setState(() {
      loading = true;
    });

    // DB에서 사용자 정보 가져오기
    DocumentSnapshot documentSnapshot =
        await userReference.doc(widget.currentUserId).get();
    currentUser = CurrentUser.fromDocument(documentSnapshot);

    setState(() {
      loading = false;
      grade = currentUser.grade;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldGlobalKey,
        body: loading
            ? circularProgress()
            : Container(
          color: Colors.white,
                child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(offset: Offset(1, 1), blurRadius: 5, color: Colors.white24)
                      ]
                  ),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Icon(Icons.perm_contact_cal_outlined, color: Colors.blueAccent),
                        SizedBox(width: 15),
                        Expanded(
                          flex: 1,
                          child: DropdownButton(
                              hint: Text('학년 선택'),
                              value: grade,
                              icon: Icon(Icons.arrow_downward),
                              underline: Container(
                                height: 1,
                                color: Colors.white,
                              ),
                              items: gradeList.map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text("$value",
                                      style: GoogleFonts.montserrat(fontSize: 15)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  grade = value;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        updateUserData();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePage(1) // ProfilePage
                                ));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Text('수정',
                            style: GoogleFonts.montserrat(
                                color: Colors.blueAccent, fontSize: 18)),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Text('취소',
                            style: GoogleFonts.montserrat(
                                color: Colors.grey, fontSize: 18)),
                      ),
                    ),
                  ],
                )
              ],
            )));
  }

  updateUserData() async {
    await userReference.doc(widget.currentUserId).update({
      'grade': grade,
    });
    showToast('정보 수정 완료', duration: 2);
  }

  showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
