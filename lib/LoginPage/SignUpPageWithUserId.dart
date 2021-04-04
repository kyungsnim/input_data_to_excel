import 'dart:io';

import 'package:input_data_to_excel/res/database.dart';
import 'package:input_data_to_excel/widgets/LoginButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';

class SignUpPageWithUserId extends StatefulWidget {
  @override
  SignUpPageWithUserIdState createState() => SignUpPageWithUserIdState();
}

class SignUpPageWithUserIdState extends State<SignUpPageWithUserId> {
  DatabaseService ds = DatabaseService();
  TextEditingController _userIdController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final gradeList = [
    "중학교 1학년",
    "중학교 2학년",
    "중학교 3학년",
    "고등학교 1학년",
    "고등학교 2학년",
    "고등학교 3학년",
  ];
  String userId, name, phoneNumber, password; // 수험번호, 비밀번호;
  var grade; // 학년
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading;

  @override
  void initState() {
    super.initState();
    setState(() {
      // grade = "중학교 1학년";
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  signUpWithUserIdPassword() async {
    try {
      Map<dynamic, dynamic> userMap = {
        "id": userId,
        "password": password,
        "grade": grade,
        "validateByAdmin": false, // 최초 회원가입시 관리자 검증 false
        "name": name,
        "phoneNumber": phoneNumber,
        "role": "student",
        "createdAt": DateTime.now()
      };
      await ds.addUser(userMap, userId);
    } catch (e) {
      print(e.toString());
    }
    Navigator.pop(context);
  }

  signUpWithUserIdPasswordInApple() async {
    try {
      Map<dynamic, dynamic> userMap = {
        "id": userId,
        "password": password,
        "grade": grade,
        "validateByAdmin": false, // 최초 회원가입시 관리자 검증 false
        "name": name != null && name != "" ? name : "",
        "phoneNumber":
            phoneNumber != null && phoneNumber != "" ? phoneNumber : "",
        "role": "student",
        "createdAt": DateTime.now()
      };
      await ds.addUser(userMap, userId);
    } catch (e) {
      print(e.toString());
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          ClipRRect(
            // 이미지 테두리반경 등 설정시 필요
            child: Image.asset("assets/images/login_background.jpg",
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 1,
                fit: BoxFit.fill),
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1,
          ),
          Container(
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    Center(
                      child: Text(
                        '회원 가입',
                        style: GoogleFonts.montserrat(
                            fontSize: MediaQuery.of(context).size.width * 0.1,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  offset: Offset(1, 2),
                                  blurRadius: 3,
                                  color: Colors.black)
                            ]),
                      ),
                    ),
                    // SizedBox(height: 40),
                    Spacer(),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.green.withOpacity(0.5)),
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
                                controller: _userIdController,
                                cursorColor: Colors.green,
                                validator: (val) {
                                  if (val.isEmpty) {
                                    setState(() {
                                      isLoading = false;
                                    });
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
                                        color: Colors.green),
                                    hintText: '수험번호',
                                    hintStyle:
                                        GoogleFonts.montserrat(fontSize: 18)),
                                onChanged: (val) {
                                  userId = val;
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.green.withOpacity(0.5)),
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
                                  Icon(Icons.person, color: Colors.green),
                                  SizedBox(width: 15),
                                  Expanded(
                                    flex: 1,
                                    child: TextFormField(
                                      controller: _nameController,
                                      cursorColor: Colors.green,
                                      validator: (val) {
                                        if (!Platform.isIOS && val.isEmpty) {
                                          return '이름을 입력하세요';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: Platform.isIOS ? '이름(선택사항)' : '이름',
                                          hintStyle: GoogleFonts.montserrat(
                                              fontSize: 18)),
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
                                    color: Colors.green.withOpacity(0.5)),
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
                                  Icon(Icons.phone, color: Colors.green),
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
                                      controller: _phoneNumberController,
                                      cursorColor: Colors.green,
                                      validator: (val) {
                                        if (!Platform.isIOS && val.isEmpty) {
                                          return '휴대폰 번호을 입력하세요';
                                        } else {
                                          print('val : $val');
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: Platform.isIOS ? '휴대폰번호(선택사항)' : '휴대폰번호',
                                          hintStyle: GoogleFonts.montserrat(
                                              fontSize: 18)),
                                      onChanged: (val) {
                                        phoneNumber = val;
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
                                    color: Colors.green.withOpacity(0.5)),
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
                                      color: Colors.green),
                                  SizedBox(width: 15),
                                  Expanded(
                                    flex: 1,
                                    child: DropdownButton(
                                        hint: Text(
                                          '학년 선택',
                                          style: TextStyle(fontSize: 18),
                                        ),
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
                          ),
                          SizedBox(height: 10),
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.green.withOpacity(0.5)),
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
                                controller: _passwordController,
                                obscureText: true,
                                cursorColor: Colors.green,
                                validator: (val) {
                                  if (val.length < 4) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    return '4자 이상의 비밀번호를 사용하세요.';
                                  } else {
                                    return val.isEmpty ? '비밀번호를 입력하세요' : null;
                                  }
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(Icons.vpn_key,
                                        color: Colors.green),
                                    hintText: '비밀번호',
                                    hintStyle:
                                        GoogleFonts.montserrat(fontSize: 18)),
                                onChanged: (val) {
                                  password = val;
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.green.withOpacity(0.5)),
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
                                controller: _confirmPasswordController,
                                obscureText: true,
                                cursorColor: Colors.green,
                                validator: (val) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (val.length < 4) {
                                    return '4자 이상의 비밀번호를 사용하세요.';
                                  } else if (_passwordController.text !=
                                      _confirmPasswordController.text) {
                                    return '비밀번호 입력이 잘못되었습니다.';
                                  } else {
                                    return val.isEmpty ? '비밀번호를 입력하세요' : null;
                                  }
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    icon: Icon(Icons.vpn_key_outlined,
                                        color: Colors.green),
                                    hintText: '비밀번호 확인',
                                    hintStyle:
                                        GoogleFonts.montserrat(fontSize: 18)),
                                onChanged: (val) {
                                  password = val;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    isLoading == true
                        ? Column(
                            children: [
                              CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.blueAccent),
                                strokeWidth: 10,
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.07),
                            ],
                          )
                        : Column(
                            children: [
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    FocusScope.of(context).requestFocus(
                                        new FocusNode()); // 키보드 감추기
                                    ds.getUserInfoList(userId).then((val) {
                                      if (!val.exists) {
                                        if (grade == null) {
                                          checkIdPasswordPopup(
                                              '학년 선택', '학년을 선택하세요.');
                                        } else if (_formKey.currentState
                                            .validate()) {
                                          signUpWithUserIdPassword();
                                        }
                                      } else {
                                        checkIdPasswordPopup('중복 수험번호',
                                            '해당 수험번호는 이미 가입되어 있습니다.');
                                      }
                                    });
                                  },
                                  child: userIdLoginButton(
                                      context,
                                      '회원 가입',
                                      Colors.white,
                                      Colors.green.withOpacity(0.7),
                                      Colors.green)),
                              SizedBox(height: 10),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: userIdLoginButton(
                                      context,
                                      '돌아가기',
                                      Colors.black,
                                      Colors.white.withOpacity(0.7),
                                      Colors.white)),
                            ],
                          ),
                    SizedBox(height: 50),
                    Text('© Copyright ${DateTime.now().year} by 조지형 국어학원',
                        style: TextStyle(color: Colors.white54, fontSize: 12)),
                    SizedBox(height: 20),
                  ])),
        ]));
  }

  checkIdPasswordPopup(title, content) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              FlatButton(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text('확인',
                      style: GoogleFonts.montserrat(
                          color: Colors.grey, fontSize: 20)),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
            ],
          );
        });
  }
}
