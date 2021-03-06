import 'package:input_data_to_excel/models/CurrentUser.dart';
import 'package:input_data_to_excel/res/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:input_data_to_excel/views/HomePage.dart';

enum SelectedRadio { username, phoneNumber }

class SettingUserInfoPage extends StatefulWidget {
  @override
  _SettingUserInfoPageState createState() => _SettingUserInfoPageState();
}

class _SettingUserInfoPageState extends State<SettingUserInfoPage> {
  DatabaseService databaseService = new DatabaseService();

  // 유저목록
  QuerySnapshot userInfoSnapshot;
  Stream<QuerySnapshot> userInfoStream;

  // 유저 수
  var userInfoCount = 0;
  bool isLoading = false;
  TextEditingController _searchValueController = TextEditingController();

// 새로고침용
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    databaseService.getUserInfoListByNotValidate().then((val) {
      if (mounted) {
        setState(() {
          userInfoStream = val;
          isLoading = false;
        });
      }
    });
  }

  // User Info List 불러오기
  viewUserInfoListStream() {
    return userInfoStream != null
        ? Container(
            child: Scrollbar(
                child: Column(
            children: [
              userInfoStream == null
                  ? Center(
                      child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      strokeWidth: 10,
                    ))
                  : StreamBuilder<QuerySnapshot>(
                      stream: userInfoStream,
                      builder: (context, stream) {
                        if (stream.hasError) {
                          return Center(child: Text(stream.error.toString()));
                        }

                        QuerySnapshot querySnapshot = stream.data;

                        if (!stream.hasData) {
                          return Center(
                              child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.blueAccent),
                            strokeWidth: 10,
                          ));
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: querySnapshot.docs.length,
                            itemBuilder: (context, index) {
                              return UserInfoTile(
                                currentUser: getUserModelFromDataSnapshot(
                                    querySnapshot.docs[index], index),
                                index: index,
                              );
                            },
                          );
                        }
                      })
            ],
          )))
        : Center(
            child: Container(
                child: Text('No Data', style: GoogleFonts.montserrat())));
  }

  CurrentUser getUserModelFromDataSnapshot(
      DocumentSnapshot userInfoSnapshot, int index) {
    CurrentUser userModel = new CurrentUser(
      id: userInfoSnapshot.data()['id'],
      grade: userInfoSnapshot.data()['grade'],
      password: userInfoSnapshot.data()['password'],
      role: userInfoSnapshot.data()['role'],
      validateByAdmin: userInfoSnapshot.data()['validateByAdmin'],
      createdAt: userInfoSnapshot.data()['createdAt'].toDate(),
    );
    return userModel;
  }

  @override
  Widget build(BuildContext context) {
    logger.d('SettingUserInfoPage : 최초가입자 승인 페이지');
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
                '최초가입자 승인',
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
                    // searchUserInfo(),
                    viewUserInfoListStream(),
                  ]))
                ],
              ))),
    );
  }

  searchUserInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text('검색어',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              SizedBox(width: 20),
              Expanded(
                  child: TextFormField(
                controller: _searchValueController,
              )),
              SizedBox(width: 20),
              RaisedButton(
                color: Colors.blue,
                child: Text(
                  '검색',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  databaseService.getUserInfoListByNotValidate().then((val) {
                    if (mounted) {
                      setState(() {
                        userInfoStream = val;
                        isLoading = false;
                      });
                    }
                  });
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
  final CurrentUser currentUser;
  final int index;

  UserInfoTile({this.currentUser, this.index});

  @override
  _UserInfoTileState createState() => _UserInfoTileState();
}

class _UserInfoTileState extends State<UserInfoTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      child: ListTile(
        tileColor: Colors.grey.withOpacity(0.1),
        title: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 10),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.currentUser.id == null ? "" : widget.currentUser.id,
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    widget.currentUser.grade == null
                        ? ""
                        : widget.currentUser.grade,
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  RaisedButton(
                      color: Colors.blue,
                      onPressed: () async {
                        userReference
                            .doc(widget.currentUser.id)
                            .update({'validateByAdmin': true});
                      },
                      child: Text('승인',
                          style: GoogleFonts.montserrat(color: Colors.white)))
                ],
              ),
            ),
          ),
        ),
        subtitle: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '가입일 : ',
                  style: GoogleFonts.montserrat(),
                ),
                Text(
                  widget.currentUser.createdAt.toString().substring(0, 10),
                  style: GoogleFonts.montserrat(),
                ),
              ],
            ),
            SizedBox(height: 5)
          ],
        ),
      ),
    );
  }
}
