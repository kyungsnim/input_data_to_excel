import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:input_data_to_excel/models/CurrentUser.dart';
import 'package:input_data_to_excel/res/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:input_data_to_excel/LoginPage/SignUpPageWithUserId.dart';
import 'package:input_data_to_excel/views/HomePage.dart';
import 'package:input_data_to_excel/widgets/JJHBody.dart';
import 'package:input_data_to_excel/widgets/LoginButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPageWithUserId extends StatefulWidget {
  @override
  SignInPageWithUserIdState createState() => SignInPageWithUserIdState();
}

class SignInPageWithUserIdState extends State<SignInPageWithUserId> {
  DatabaseService ds = DatabaseService();
  TextEditingController _userIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String userId, password, resetPwEmail;
  bool doRemember = false;
  var isLoading;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // 저장된 비밀번호 가져오기
    getRememberInfo();
    // 로그아웃으로 빠져나온게 아니면 자동로그인 시켜줌
    checkFirebaseAndSignIn();
    isLoading = false;
  }

  checkFirebaseAndSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Firebase.initializeApp().whenComplete(() {
      print("completed");

      if (prefs.getString('signOut') == 'NO') {
        signIn();
      }
    });
  }

  @override
  void dispose() {
    setRememberInfo();
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  getRememberInfo() async {
    // logger.d(doRemember);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      doRemember = (prefs.getBool('doRemember') ?? false);
    });
    if (doRemember) {
      setState(() {
        _userIdController.text = (prefs.getString('userId') ?? "");
        userId = _userIdController.text;
        _passwordController.text = (prefs.getString('userPassword') ?? "");
        password = _passwordController.text;
      });
    }
  }

  setRememberInfo() async {
    // logger.d(doRemember);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('doRemember', doRemember);
    if (doRemember) {
      prefs.setString('userId', _userIdController.text);
      prefs.setString('userPassword', _passwordController.text);
      prefs.setString('signOut', 'NO');
    }
  }

  signIn() async {
    String dbPassword;
    DocumentSnapshot dbUserData;
    // dbUserData = await ds.getUserLoginInfo(userId);
    print('userId : $userId');
    dbPassword = await ds.getUserLoginInfo(userId);
    // print('dbUserData.password : ${dbUserData.data()["password"]}');
    if (password == dbPassword) {
      // 해당 정보 다시 가져오기
      dbUserData = await userReference.doc(userId).get();
      // 현재 유저정보에 값 셋팅하기
      setState(() {
        currentUser = CurrentUser.fromDocument(dbUserData);
      });

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage(0)));
    }
  }

  @override
  Widget build(BuildContext context) {
    var leftPaddingSize = MediaQuery.of(context).size.width * 0.1;
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
          color: Colors.black.withOpacity(0.2),
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 1,
        ),
        Container(
          alignment: Alignment.topCenter,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              jjhBody(context),
              Spacer(),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.blue.withOpacity(0.5)),
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
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: _userIdController,
                          cursorColor: Colors.blue,
                          validator: (val) {
                            if (val.isEmpty) {
                              return '수험번호를 입력하세요';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.perm_contact_cal, color: Colors.blue),
                              hintText: '수험번호',
                              hintStyle: GoogleFonts.montserrat(fontSize: 18)),
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
                          border:
                              Border.all(color: Colors.blue.withOpacity(0.5)),
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
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          cursorColor: Colors.blue,
                          validator: (val) {
                            if (val.length < 1) {
                              return '1자 이상의 비밀번호를 사용하세요.';
                            } else {
                              return val.isEmpty ? '비밀번호를 입력하세요' : null;
                            }
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.vpn_key, color: Colors.blue),
                              hintText: 'password',
                              hintStyle: GoogleFonts.montserrat(fontSize: 18)),
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                      ),
                    ),
                    // Remember me
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 25, 5),
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: leftPaddingSize),
                            // checkbox 체크안했을 때 색상 설정하기 (매우 유용하군.....)
                            Theme(
                              data: ThemeData(unselectedWidgetColor: Colors.white),
                              child: Checkbox(
                                activeColor: Colors.blue,
                                value: doRemember,
                                onChanged: (newValue) {
                                  setState(() {
                                    doRemember = newValue;
                                  });
                                },
                              ),
                            ),
                            Text('수험번호 기억하기',
                                style: TextStyle(color: Colors.white, fontSize: 18))
                          ],
                        )),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    // Alert Box
                    isLoading == true ? Column(
                      children: [
                        CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                          strokeWidth: 10,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                      ],
                    )
                        : Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              isLoading = true;
                            });
                            FocusScope.of(context)
                                .requestFocus(new FocusNode()); // 키보드 감추기
                            signIn();
                          },
                          child: userIdLoginButton(context, '로그인', Colors.white,
                              Colors.blue.withOpacity(0.7), Colors.blue),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode()); // 키보드 감추기
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPageWithUserId()));
                            // signIn();
                          },
                          child: userIdLoginButton(context, '회원가입', Colors.black,
                              Colors.white.withOpacity(0.7), Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text('© Copyright ${DateTime.now().year} by 조지형 국어학원',
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
              SizedBox(height: 40),
            ],
          ),
        ),
      ]),
    );
  }
}
