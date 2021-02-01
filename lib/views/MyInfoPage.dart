import 'package:input_data_to_excel/LoginPage/SignInPageWithUserId.dart';
import 'package:input_data_to_excel/models/CurrentUser.dart';
import 'package:input_data_to_excel/widgets/CllangeduAppBar.dart';
import 'package:input_data_to_excel/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:kakao_flutter_sdk/all.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

// import 'package:image_picker/image_picker.dart';
import 'EditProfilePage.dart';
import 'HomePage.dart';
import 'SettingUserInfoPage.dart';

enum langSetting { Ko, En }

class MyInfoPage extends StatefulWidget {
  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  final String currentOnlineUserId = currentUser?.id; //
  final _userPointList = ['8', '24', '80'];
  var _userPoint;

// // 카메라로 찍거나 갤러리에서 가져온 사진 컨트롤하기 위한 변수
//   PickedFile _imageFile;
// // 카메라/갤러리에서 사진 가져올 때 사용함 (image_picker)
//   final ImagePicker _picker =
//       ImagePicker(); // 카메라/갤러리에서 사진 가져올 때 사용함 (image_picker)
  final noticePictureList = [
    'assets/images/coin.jpg',
    // 'assets/images/book.jpg',
  ];

  @override
  void initState() {
    _userPoint = '8';
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
                    Text("User info",
                        style: GoogleFonts.montserrat(
                            fontSize: 20, fontWeight: FontWeight.bold))
                        .tr(),
                    Spacer(),
                    // Container(
                    //     width: 50,
                    //     child: RaisedButton(
                    //       color: Colors.blue,
                    //       child: Text(
                    //         'T',
                    //         style: GoogleFonts.montserrat(
                    //             fontSize: 15,
                    //             color: Colors.white,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //       onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyTestPage())),
                    //     )),
                    // SizedBox(width: 10),
                    Container(
                        width: 100,
                        child: RaisedButton(
                          color: Colors.blue,
                          child: Text(
                            'Edit',
                            style: GoogleFonts.montserrat(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ).tr(),
                          onPressed: () => _showEditProfileDialog(context),
                        )),
                    SizedBox(width: 5)
                  ],
                ),
              ),
              topProfile(user),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text('Point',
                        style: GoogleFonts.montserrat(
                            fontSize: 20, fontWeight: FontWeight.bold))
                        .tr(),
                    SizedBox(width: 10),
                  ],
                ),
              ),
              noticeArea(),
              // pointProfile(user),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      logoutUser();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Text('로그아웃',
                            style: GoogleFonts.montserrat(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              currentUser.role == 'admin'
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      // 회원정보 설정 페이지로 이동하기
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             SettingUserInfoPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Text('회원 정보 설정',
                            style: GoogleFonts.montserrat(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  )
                ],
              )
                  : Container(),
              currentUser.role == 'admin' ? SizedBox(height: 20) : Container(),
              currentUser.role == 'admin'
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      // 강의내역 (강사별 검색) 페이지로 이동하기
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             CourseHistoryForAdminPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Text('강의 내역 History (Admin)',
                            style: GoogleFonts.montserrat(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  )
                ],
              )
                  : currentUser.role == 'teacher'
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      // 내 강의내역 페이지로 이동하기
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             CourseHistoryForTeacherPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Text('강의 내역 History (Teacher)',
                            style: GoogleFonts.montserrat(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  )
                ],
              )
                  : Container(),
            ],
          );
        });
  }

  noticeArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () =>
          //     Navigator.push(
          //   context, MaterialPageRoute(builder: (context) => WhatIsPointPage()),
          // )
          {},
          child: Stack(
            children: [
              ClipRRect(
                // 이미지 테두리반경 등 설정시 필요
                borderRadius: BorderRadius.circular(10),
                child: Image.asset("assets/images/coin.jpg",
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.06,
                    fit: BoxFit.cover),
              ),
              Container(
                alignment: Alignment.centerRight,
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.95,
                child: Text('강의 패키지 및 포인트에 대해 알려 드립니다.   ', style: GoogleFonts.montserrat(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  noticeAreaWithSlider() {
    return CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.06,
          autoPlay: false,
        ),
        items: noticePictureList.map((url) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Stack(
                      children: [
                        ClipRRect(
                          // 이미지 테두리반경 등 설정시 필요
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(url,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 1,
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.06,
                              fit: BoxFit.fill),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.06,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 1,
                          child: Text(
                            '강의 패키지 및 포인트에 대해 알려 드립니다.   ', style: GoogleFonts
                              .montserrat(color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black.withOpacity(0.4)
                          ),
                        )
                      ]
                  )
              );
            },
          );
        }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: currentUser != null ? Stack(children: [
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  cllangeduAppBar(),
                  Spacer(),
                  InkWell(
                    onTap: () async => await launch(
                        'https://pf.kakao.com/_xkNnJxb', forceWebView: false,
                        forceSafariVC: false),
                    child: Icon(
                      Icons.live_help,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 15),
                  InkWell(
                      onTap: () => _showLanguageDialog(context),
                      child: Icon(
                          Icons.settings, color: Colors.grey, size: 30)),
                  SizedBox(width: 20)
                ]),
                Expanded(
                  child: ListView(
                    children: [
                      createProfileTopView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]) : Center(child: CircularProgressIndicator()));
  }

  logoutUser() async {
    try {
      // switch (currentUser.loginType) {
      //   case "Google" :
      //   // 구글 사용자 로그아웃
      //     bool isGoogleSignedIn = await googleSignIn.isSignedIn();
      //     if (isGoogleSignedIn) {
      //       await googleSignIn.signOut();
      //       setState(() {
      //         currentUser = null;
      //       });
      //     }
      //     break;
      //   case "Apple" :
      //   // 애플 로그아웃 구현 필요....
      //   // ㅓㄴㅇ리ㅏㅣㅓㅏㄴㅁ이ㅏㅓㅇㄹ니ㅏㅓㅇㄴ리ㅏㅓㄴㄹㅇ미ㅏㅓㄹㅇㄴ미ㅏㅁㄴㅇ라ㅏㅓ
      //     break;
      //   // case "Kakao" :
      //   // // 카카오 사용자 로그아웃
      //   //   var code = await UserApi.instance.logout();
      //   //   print(code.toString());
      //   //   setState(() {
      //   //     currentUser = null;
      //   //   });
      //   //   break;
      //   case "Email" :
      //     // fp.signOut();
      //     setState(() {
      //       currentUser = null;
      //     });
      //     break;
      // }

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignInPageWithUserId()));
    } catch (e) {
      print(e);
    }

    // Navigator.pushReplacement(context, MaterialPageRoute(
    //     builder: (context) => HomePage(0)
    // ));
  }

  // 카메라 찍거나 갤러리에서 가져오는 메소드
  // takePhoto(ImageSource source) async {
  //   final pickedFile = await _picker.getImage(source: source);
  //   setState(() {
  //     _imageFile = pickedFile;
  //   });
  // }

  // 카메라 아이콘 클릭시 띄울 모달 팝업
  Widget bottomSheet() {
    return Container(
        height: 100,
        width: MediaQuery
            .of(context)
            .size
            .width,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: <Widget>[
            Text(
              'Choose Profile photo',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton.icon(
                  icon: Icon(
                    Icons.camera,
                    size: 50,
                  ),
                  onPressed: () {
                    // takePhoto(ImageSource.camera);
                  },
                  label: Text(
                    'Camera',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                FlatButton.icon(
                  icon: Icon(
                    Icons.photo_library,
                    size: 50,
                  ),
                  onPressed: () {
                    // takePhoto(ImageSource.gallery);
                  },
                  label: Text(
                    'Gallery',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            )
          ],
        ));
  }

  topProfile(CurrentUser user) {
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
              child: Stack(children: [
                Row(
                  children: [
                    Stack(children: [
                      CircleAvatar(
                        radius: 45,
                        // backgroundImage:
                        // user.url != "" && user != null
                        //     ? CachedNetworkImageProvider(user.url)
                        //     : AssetImage("assets/images/no_image.jpg"),
                      ),
                      // Positioned(
                      //     bottom: 20,
                      //     right: 20,
                      //     child: InkWell(
                      //       onTap: () {
                      //         showModalBottomSheet(
                      //             context: context,
                      //             builder: ((builder) => bottomSheet()));
                      //       },
                      //       child: Icon(
                      //         Icons.camera_alt,
                      //         color: Colors.grey,
                      //         size: 40,
                      //       ),
                      //     ))
                    ]),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Row(
                              // 사용자 이름
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "", //user.userId,
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                          ],
                        )),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Language setting",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 20))
              .tr(),
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
                .height * 0.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(context.locale == Locale('en', 'US') ? 'English' : '한국어',
                      style: GoogleFonts.montserrat(fontSize: 20)),
                  Spacer(),
                  RaisedButton(
                      color: Colors.blue,
                      onPressed: () {
                        setState(() {
                          if (context.locale == Locale('ko', 'KR')) {
                            context.locale = Locale('en', 'US');
                          } else {
                            context.locale = Locale('ko', 'KR');
                          }
                        });
                      },
                      child: Text('Translate',
                          style: GoogleFonts.montserrat(
                              fontSize: 20, color: Colors.white))
                          .tr()),
                ]),
          ),
          actions: <Widget>[
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text('OK',
                        style: GoogleFonts.montserrat(
                            color: Colors.blue, fontSize: 20))
                        .tr(),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void _showEditProfileDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit info',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 20))
              .tr(),
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
                  .height * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              // child: EditProfilePage(currentOnlineUserId: currentOnlineUserId)
          ),
        );
      },
    );
  }
}
