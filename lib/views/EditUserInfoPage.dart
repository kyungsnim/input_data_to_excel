import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:input_data_to_excel/models/CurrentUser.dart';
import 'package:input_data_to_excel/res/database.dart';

import 'EditProfilePage.dart';
import 'HomePage.dart';

enum SelectedRadio { username, id }

class EditUserInfoPage extends StatefulWidget {
  @override
  _EditUserInfoPageState createState() => _EditUserInfoPageState();
}

class _EditUserInfoPageState extends State<EditUserInfoPage> {
  DatabaseService databaseService = new DatabaseService();
  //
  SelectedRadio _selectedRadio = SelectedRadio.username;
  // 유저목록
  QuerySnapshot userInfoSnapshot;
  Stream userInfoStream;

  // 유저 수
  var userInfoCount = 0;
  bool isLoading = false;
  TextEditingController _searchValueController = TextEditingController();

  @override
  void initState() {
    _selectedRadio = SelectedRadio.username;
    super.initState();
  }

  // User Info List 불러오기
  viewUserInfoListStream() {
    return userInfoStream != null
        ? Container(
            child: Scrollbar(
                child: Column(
            children: [
              userInfoStream == null
                  ? Center(child: CircularProgressIndicator())
                  : StreamBuilder<QuerySnapshot>(
                      stream: userInfoStream,
                      builder: (context, stream) {
                        if (stream.hasError) {
                          return Center(child: Text(stream.error.toString()));
                        }

                        QuerySnapshot querySnapshot = stream.data;

                        if (!stream.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: querySnapshot.docs.length,
                            itemBuilder: (context, index) {
                              return UserInfoTile(
                                searchUser: getUserModelFromDataSnapshot(
                                    querySnapshot.docs[index], index),
                                index: index,
                              );
                            },
                          );
                        }
                      })
            ],
          )))
        : Container(
            height: MediaQuery.of(context).size.height * 0.4,
            alignment: Alignment.center,
            child: Text('No Data',
                style:
                    GoogleFonts.montserrat(fontSize: 25, color: Colors.grey)));
  }

  CurrentUser getUserModelFromDataSnapshot(
      DocumentSnapshot userInfoSnapshot, int index) {
    CurrentUser userModel = new CurrentUser(
      id: userInfoSnapshot.data()['id'],
      grade: userInfoSnapshot.data()['grade'],
      name: userInfoSnapshot.data()['name'],
      phoneNumber: userInfoSnapshot.data()['phoneNumber'],
      password: userInfoSnapshot.data()['password'],
      role: userInfoSnapshot.data()['role'],
      validateByAdmin: userInfoSnapshot.data()['validateByAdmin'],
      createdAt: userInfoSnapshot.data()['createdAt'].toDate(),
    );
    return userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              '학생 정보수정',
              style: GoogleFonts.montserrat(color: Colors.blueGrey),
            )),
        body: Container(
            height: MediaQuery.of(context).size.height * 1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: ListView(shrinkWrap: false, children: [
                  searchUserInfo(),
                  viewUserInfoListStream(),
                ]))
              ],
            )));
  }

  searchUserInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text('검색타입', style: TextStyle(color: Colors.blueAccent, fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(width: 20),
              Text('이름', style: TextStyle(fontSize: 15,)),
              Radio(
                value: SelectedRadio.username,
                groupValue: _selectedRadio,
                activeColor: Colors.blueAccent,
                onChanged: (SelectedRadio value) {
                  setState(() {
                    _selectedRadio = value;
                  });
                },
              ),
              SizedBox(width: 20),
              Text('수험번호', style: TextStyle(fontSize: 15,)),
              Radio(
                value: SelectedRadio.id,
                groupValue: _selectedRadio,
                activeColor: Colors.blueAccent,
                onChanged: (SelectedRadio value) {
                  setState(() {
                    _selectedRadio = value;
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              Text('검색어',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              SizedBox(width: 20),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _searchValueController,
                ),
              )),
              SizedBox(width: 20),
              RaisedButton(
                color: Colors.blueAccent,
                child: Text(
                  '검색',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  FocusScope.of(context)
                      .requestFocus(new FocusNode()); // 키보드 감추기
                  print('_searchValueController.text : ${_searchValueController.text}');
                  if(_selectedRadio == SelectedRadio.username) {
                    databaseService
                        .getUserInfoListByUsername(_searchValueController.text)
                        .then((val) {
                      if (mounted) {
                        setState(() {
                          userInfoStream = val;
                          isLoading = false;
                        });
                      }
                    });
                  } else {
                    databaseService
                        .getUserInfoListById(_searchValueController.text)
                        .then((val) {
                      if (mounted) {
                        setState(() {
                          userInfoStream = val;
                          isLoading = false;
                        });
                      }
                    });
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}

class UserInfoTile extends StatefulWidget {
  final CurrentUser searchUser;
  final int index;

  UserInfoTile({this.searchUser, this.index});

  @override
  _UserInfoTileState createState() => _UserInfoTileState();
}

class _UserInfoTileState extends State<UserInfoTile> {

  void _showEditProfileDialog(context) {
    logger.d('_showEditProfileDialog : 정보 수정 팝업');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('정보 수정',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  fontSize: 18)),
          actionsPadding: EdgeInsets.only(right: 10),
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: EditProfilePage(
                  currentUserId: widget.searchUser.id, byAdmin: true)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      child: ListTile(
        tileColor: Colors.blueGrey.withOpacity(0.2),
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.searchUser.id,
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Spacer(),
              RaisedButton(
                color: Colors.blueGrey,
                onPressed: () async {
                  // 유저 정보 상세페이지로 이동 (수정 가능토록)
                  _showEditProfileDialog(context);
                },
                child: Icon(Icons.edit, color: Colors.white,),
              )
            ],
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.searchUser.name == null
                  ? ""
                  : widget.searchUser.name,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              widget.searchUser.grade == null ? "" : widget.searchUser.grade,
              style: GoogleFonts.montserrat(fontSize: 15),
            ),
            Text(
              widget.searchUser.phoneNumber == null
                  ? ""
                  : widget.searchUser.phoneNumber,
              style: GoogleFonts.montserrat(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
