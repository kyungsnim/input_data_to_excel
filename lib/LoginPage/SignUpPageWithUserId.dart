import 'package:input_data_to_excel/res/database.dart';
import 'package:input_data_to_excel/widgets/JJHBody.dart';
import 'package:input_data_to_excel/widgets/LoginButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

SignUpPageWithUserIdState pageState;

class SignUpPageWithUserId extends StatefulWidget {
  @override
  SignUpPageWithUserIdState createState() {
    pageState = SignUpPageWithUserIdState();
    return pageState;
  }
}

class SignUpPageWithUserIdState extends State<SignUpPageWithUserId> {
  DatabaseService ds = DatabaseService();
  TextEditingController _userIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final gradeList = ["중학교 1학년", "중학교 2학년","중학교 3학년","고등학교 1학년","고등학교 2학년","고등학교 3학년",];
  String userId, password; // 수험번호, 비밀번호;
  var grade; // 학년
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // ignore: unnecessary_statements
    grade == null ? "중학교 1학년" : grade;
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  signUpWithUserIdPassword() async {
    // {this.id,
    // this.grade,
    // this.validateByAdmin,
    // this.role,
    // this.createdAt})
    try {
      Map<String, dynamic> userMap = {
        "id": userId,
        "password": password,
        "grade": grade,
        "validateByAdmin": false, // 최초 회원가입시 관리자 검증 false
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
        body: Stack(
          children: [
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
                alignment: Alignment.topCenter,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      jjhBody(),
                      Spacer(),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(offset: Offset(1, 1), blurRadius: 5, color: Colors.white24)
                                  ]
                              ),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  controller: _userIdController,
                                  cursorColor: Colors.green,
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return '수험번호를 입력하세요';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(Icons.email, color: Colors.green),
                                      hintText: '수험번호',
                                      hintStyle: GoogleFonts.montserrat(fontSize: 15)),
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
                                  border: Border.all(color: Colors.green.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(offset: Offset(1, 1), blurRadius: 5, color: Colors.white24)
                                  ]
                              ),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  cursorColor: Colors.green,
                                  validator: (val) {
                                    if (val.length < 2) {
                                      return '2자 이상의 비밀번호를 사용하세요.';
                                    } else {
                                      return val.isEmpty ? '비밀번호를 입력하세요' : null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(Icons.vpn_key, color: Colors.green),
                                      hintText: '비밀번호',
                                      hintStyle: GoogleFonts.montserrat(fontSize: 15)),
                                  onChanged: (val) {
                                    password = val;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(offset: Offset(1, 1), blurRadius: 5, color: Colors.white24)
                            ]
                        ),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Icon(Icons.perm_contact_cal_outlined, color: Colors.green),
                              SizedBox(width: 15),
                              Expanded(
                                flex: 1,
                                child: DropdownButton(
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
                      SizedBox(height: 10),
                      InkWell(
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode()); // 키보드 감추기
                            signUpWithUserIdPassword();
                          },
                          child: userIdLoginButton(context, '회원 가입', Colors.white, Colors.green.withOpacity(0.7), Colors.green)),
                      SizedBox(height: 10),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: userIdLoginButton(context, '돌아가기', Colors.black, Colors.white.withOpacity(0.7), Colors.white)),
                      SizedBox(height: 50),
                      Text('© Copyright ${DateTime.now().year} by 조지형 국어학원', style: TextStyle(color: Colors.white54, fontSize: 12)),
                      SizedBox(height: 50),
                    ]
                )
            ),
          ]
        )
    );
  }
}
