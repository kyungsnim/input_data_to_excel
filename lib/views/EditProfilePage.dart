import 'package:input_data_to_excel/models/CurrentUser.dart';
import 'package:input_data_to_excel/widgets/ProgressWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import 'HomePage.dart';
import 'MyInfoPage.dart';

class EditProfilePage extends StatefulWidget {
  final String currentOnlineUserId;

  EditProfilePage({this.currentOnlineUserId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController profileNameTextEditingController =
      TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneNumberTextEditingController =
      TextEditingController();
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  CurrentUser currentUser;
  bool _usernameValid = true;
  bool _profileNameValid = true;
  bool _emailValid = true;
  bool _phoneNumberValid = true;

  @override
  void initState() {
    super.initState();
    // 화면 빌드 전 미리 해당 사용자의 값들로 셋팅해주자
    getAndDisplayUserInformation();
  }

  @override
  void dispose() {
    usernameTextEditingController.dispose();
    profileNameTextEditingController.dispose();
    phoneNumberTextEditingController.dispose();
    emailTextEditingController.dispose();
    super.dispose();
  }

  getAndDisplayUserInformation() async {
    setState(() {
      loading = true;
    });

    // DB에서 사용자 정보 가져오기
    DocumentSnapshot documentSnapshot =
        await userReference.doc(widget.currentOnlineUserId).get();
    currentUser = CurrentUser.fromDocument(documentSnapshot);

    // 입력란에 사용자 정보로 채워주기
    // usernameTextEditingController.text = currentUser.username;
    // profileNameTextEditingController.text = currentUser.profileName;
    // emailTextEditingController.text = currentUser.email;
    // phoneNumberTextEditingController.text = currentUser.phoneNumber;
    // 셋팅 끝나면 loading은 false로 바뀌고 화면에 값들이 보임
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldGlobalKey,
        body: loading
            ? circularProgress()
            : ListView(
                children: [
                  Container(
                      child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            createUsernameTextFormField('User name(English)',
                                'Write English name here', _usernameValid),
                            createProfileNameTextFormField(
                                'Profile name(Korean)',
                                'Write Korean name here',
                                _profileNameValid),
                            createEmailTextFormField('Email address',
                                'Write email here', _emailValid),
                            createPhoneNumberTextFormField('Phone number',
                                'Write phone number here', _phoneNumberValid),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Text('Cancel',
                                      style: GoogleFonts.montserrat(
                                          color: Colors.grey, fontSize: 15)),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              updateUserData();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage(3) // ProfilePage
                                      ));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Text('OK',
                                      style: GoogleFonts.montserrat(
                                          color: Colors.blue, fontSize: 15)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ))
                ],
              ));
  }

  createUsernameTextFormField(title, hintText, isVaild) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            title,
            style: GoogleFonts.montserrat(
                color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        TextField(
          style: GoogleFonts.montserrat(color: Colors.blue),
          controller: usernameTextEditingController,
          decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
              hintStyle: GoogleFonts.montserrat(color: Colors.grey),
              errorText: isVaild ? null : 'Input text is too short'),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  createProfileNameTextFormField(title, hintText, isVaild) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            title,
            style: GoogleFonts.montserrat(
                color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        TextField(
          style: GoogleFonts.montserrat(color: Colors.blue),
          controller: profileNameTextEditingController,
          decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
              hintStyle: GoogleFonts.montserrat(color: Colors.grey),
              errorText: isVaild ? null : 'Input text is too short'),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  createEmailTextFormField(title, hintText, isVaild) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            title,
            style: GoogleFonts.montserrat(
                color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        TextField(
          style: GoogleFonts.montserrat(color: Colors.blue),
          controller: emailTextEditingController,
          decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
              hintStyle: GoogleFonts.montserrat(color: Colors.grey),
              errorText: isVaild ? null : 'Input text is too short'),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  createPhoneNumberTextFormField(title, hintText, isVaild) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            title,
            style: GoogleFonts.montserrat(
                color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        TextField(
          style: GoogleFonts.montserrat(color: Colors.blue),
          controller: phoneNumberTextEditingController,
          decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue)),
              hintStyle: GoogleFonts.montserrat(color: Colors.grey),
              errorText: isVaild ? null : 'Input text is too short'),
          onChanged: (value) {
            phoneNumberTextEditingController.text = value;
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }

  updateUserData() async {
    setState(() {
      usernameTextEditingController.text.trim().length < 3 ||
              usernameTextEditingController.text.isEmpty
          ? _usernameValid = false
          : _usernameValid = true;
      profileNameTextEditingController.text.trim().length < 3 ||
              profileNameTextEditingController.text.isEmpty
          ? _profileNameValid = false
          : _profileNameValid = true;
      emailTextEditingController.text.trim().length < 3 ||
              emailTextEditingController.text.isEmpty
          ? _emailValid = false
          : _emailValid = true;
      phoneNumberTextEditingController.text.trim().length < 3 ||
              phoneNumberTextEditingController.text.isEmpty
          ? _phoneNumberValid = false
          : _phoneNumberValid = true;
    });

    if (_usernameValid &&
        _profileNameValid &&
        _emailValid &&
        _phoneNumberValid) {
      await userReference.doc(widget.currentOnlineUserId).update({
        'username': usernameTextEditingController.text,
        'profileName': profileNameTextEditingController.text,
        'email': emailTextEditingController.text,
        'phoneNumber': phoneNumberTextEditingController.text,
      });
//      SnackBar successSnackBar = SnackBar(content: Text('Profile has been updated successfully.'),);
//      _scaffoldGlobalKey.currentState.showSnackBar(successSnackBar);
    }
  }
}
