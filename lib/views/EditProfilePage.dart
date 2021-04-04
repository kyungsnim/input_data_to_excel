// @dart=2.9
import 'package:flutter/services.dart';
import 'package:input_data_to_excel/models/CurrentUser.dart';
import 'package:input_data_to_excel/widgets/ProgressWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';
import 'package:toast/toast.dart';

import 'HomePage.dart';

class EditProfilePage extends StatefulWidget {
  final String currentUserId;
  final bool byAdmin;

  EditProfilePage({this.currentUserId, this.byAdmin});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  CurrentUser currentUser;
  final gradeList = [
    "중학교 1학년",
    "중학교 2학년",
    "중학교 3학년",
    "고등학교 1학년",
    "고등학교 2학년",
    "고등학교 3학년",
  ];
  var grade; // 학년
  var userId; // 수험번호
  var name; // 이름
  var phoneNumber; // 휴대폰번호
  TextEditingController userIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    print('>>>>>>>>>>>>> currentUserId : ${widget.currentUserId}');
    // 화면 빌드 전 미리 해당 사용자의 값들로 셋팅해주자
    getAndDisplayUserInformation();
  }

  @override
  void dispose() {
    super.dispose();
    userIdController.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
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
      userIdController.text = currentUser.id;
      userId = userIdController.text;
      nameController.text = currentUser.name == "-"
          ? ""
          : currentUser.name; // 이름 설정 안한 상태면 비어두고 설정 해두었으면 설정값 불러오기
      phoneNumberController.text = currentUser.phoneNumber == "-"
          ? ""
          : currentUser.phoneNumber; // 휴대폰번호 설정 안한 상태면 비어두고 설정 해두었으면 설정값 불러오기
      name = nameController.text;
      phoneNumber = phoneNumberController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.d('EditUserInfoPage : 정보 수정 페이지');
    return Scaffold(
        key: _scaffoldGlobalKey,
        body: loading
            ? circularProgress()
            : Container(
                color: Colors.white,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      widget.byAdmin
                          ? Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          Colors.blueAccent.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 5,
                                        color: Colors.white24)
                                  ]),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Icon(Icons.perm_contact_cal_outlined,
                                        color: Colors.blueAccent),
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
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 15)),
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
                            )
                          : Container(),
                      SizedBox(height: 10),
                      widget.byAdmin
                          ? Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          Colors.blueAccent.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 5,
                                        color: Colors.white24)
                                  ]),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  controller: userIdController,
                                  cursorColor: Colors.blueAccent,
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return '수험번호를 입력하세요';
                                    } else if (val.length != 6) {
                                      return '수험번호는 6자리여야 합니다.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(Icons.perm_contact_cal,
                                          color: Colors.blueAccent),
                                      hintText: '수험번호',
                                      hintStyle:
                                          GoogleFonts.montserrat(fontSize: 18)),
                                  onChanged: (val) {
                                    userId = val;
                                  },
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blueAccent.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 5,
                                  color: Colors.white24)
                            ]),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Icon(Icons.person, color: Colors.blueAccent),
                              SizedBox(width: 15),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: nameController,
                                  cursorColor: Colors.blue,
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return '이름을 입력하세요';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '이름',
                                      hintStyle:
                                          GoogleFonts.montserrat(fontSize: 15)),
                                  onChanged: (val) {
                                    name = val;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blueAccent.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 5,
                                  color: Colors.white24)
                            ]),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Icon(Icons.phone, color: Colors.blueAccent),
                              SizedBox(width: 15),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  inputFormatters: [
                                    MultiMaskedTextInputFormatter(masks: [
                                      'xxx-xxxx-xxxx',
                                      'xxx-xxx-xxxx'
                                    ], separator: '-')
                                  ],
                                  keyboardType: TextInputType.number,
                                  controller: phoneNumberController,
                                  cursorColor: Colors.blue,
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return '휴대폰 번호을 입력하세요';
                                    } else {
                                      print('changed phoneNumber : $val');
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '휴대폰번호',
                                      hintStyle:
                                          GoogleFonts.montserrat(fontSize: 15)),
                                  onChanged: (val) {
                                    phoneNumber = val;
                                    // if(phoneNumberController.text.length == 3) {
                                    //   setState(() {
                                    //     phoneNumberController.text = val + '-';
                                    //   });
                                    // }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // 회원삭제 보이도록 변경 ('21.03.21)
                          widget.byAdmin
                              ? InkWell(
                                  onTap: () {
                                    checkDeletePopup(currentUser.id);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Text('회원삭제',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.redAccent,
                                            fontSize: 18)),
                                  ),
                                )
                              : Container(),
                          InkWell(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                updateUserData();
                                widget.byAdmin
                                    ? Navigator.pop(context)
                                    : Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomePage(1) // ProfilePage
                                            ));
                              }
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
                  ),
                )));
  }

  checkDeletePopup(id) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('회원 삭제'),
            content: Text("해당 학생을 삭제하시겠습니까?",
                style: TextStyle(color: Colors.redAccent)),
            actions: [
              FlatButton(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text('확인',
                      style: GoogleFonts.montserrat(
                          color: Colors.blueAccent, fontSize: 20)),
                ),
                onPressed: () async {
                  await userReference.doc(id).delete();
                  showToast("회원 삭제 완료");
                  Navigator.pop(context); // 회원 삭제 확인 팝업 닫기
                  Navigator.pop(context); // 회원 정보 수정 팝업 닫기
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

  updateUserData() async {
    await userReference.doc(widget.currentUserId).update({
      'id': userId,
      'grade': grade,
      'name': name,
      'phoneNumber': phoneNumber
    });
    if (mounted) {
      showToast('정보 수정 완료', duration: 2);
    }
  }

  showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
