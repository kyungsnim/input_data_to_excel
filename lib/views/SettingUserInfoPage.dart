// import 'package:input_data_to_excel/models/CurrentUser.dart';
// import 'package:input_data_to_excel/res/database.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:easy_localization/easy_localization.dart';
//
// import 'EditProfilePageByAdmin.dart';
//
// enum SelectedRadio { username, phoneNumber }
//
// class SettingUserInfoPage extends StatefulWidget {
//   @override
//   _SettingUserInfoPageState createState() => _SettingUserInfoPageState();
// }
//
// class _SettingUserInfoPageState extends State<SettingUserInfoPage> {
//   DatabaseService databaseService = new DatabaseService();
//   // 유저목록
//   QuerySnapshot userInfoSnapshot;
//   Stream userInfoStream;
//   // 유저 수
//   var userInfoCount = 0;
//   bool isLoading = false;
//   TextEditingController _searchValueController = TextEditingController();
//   SelectedRadio _selectedRadio = SelectedRadio.username;
//
// // 새로고침용
//   var refreshKey = GlobalKey<RefreshIndicatorState>();
//
//   //async wait 을 쓰기 위해서는 Future 타입을 이용함
//   // Future<Null> refreshList() async {
//   //   refreshKey.currentState?.show(atTop: false);
//   //   await Future.delayed(Duration(seconds: 0)); //thread sleep 같은 역할을 함.
//   //   //새로운 정보를 그려내는 곳
//   //   setState(() {
//   //     isLoading = true;
//   //   });
//   //   databaseService.getUserInfoList(_searchValueController.text).then((val) {
//   //     if (mounted) {
//   //       setState(() {
//   //         userInfoSnapshot = val;
//   //         userInfoCount = userInfoSnapshot.docs.length;
//   //         isLoading = false;
//   //       });
//   //     }
//   //   });
//   //   return null;
//   // }
//
//   @override
//   void initState() {
//     _selectedRadio = SelectedRadio.username;
//     super.initState();
//   }
//
//   // User Info List 불러오기
//   viewUserInfoList() {
//     return userInfoSnapshot != null
//         ? Container(
//             child: Scrollbar(
//                 child: Column(
//             children: [
//               userInfoSnapshot == null
//                   ? Center(child: CircularProgressIndicator())
//                   : userInfoCount == 0
//                       ? Container()
//                       : ListView.builder(
//                           // padding: EdgeInsets.symmetric(horizontal: 24),
//                           shrinkWrap: true,
//                           // 'visible' was called on null 방지
//                           physics: ClampingScrollPhysics(),
//                           itemCount: userInfoCount,
//                           itemBuilder: (context, index) {
//                             return UserInfoTile(
//                               currentUser: getUserModelFromDataSnapshot(
//                                   userInfoSnapshot.docs[index], index),
//                               index: index,
//                             );
//                           },
//                         )
//             ],
//           )))
//         : Container(
//           child: Center(
//               child: Text('No Data', style: GoogleFonts.montserrat())),
//         );
//   }
//
//   // User Info List 불러오기
//   viewUserInfoListStream() {
//     return userInfoStream != null
//         ? Container(
//         child: Scrollbar(
//             child: Column(
//               children: [
//                 userInfoStream == null
//                     ? Center(child: CircularProgressIndicator())
//                     : StreamBuilder<QuerySnapshot>(
//                   stream: userInfoStream,
//                   builder: (context, stream) {
//                     if(stream.hasError) {
//                       return Center(
//                         child: Text(stream.error.toString()));
//                     }
//
//                     QuerySnapshot querySnapshot = stream.data;
//
//                     if(!stream.hasData) {
//                       return Center(child: CircularProgressIndicator());
//                     } else {
//                       return ListView.builder(
//                         shrinkWrap: true,
//                         physics: ClampingScrollPhysics(),
//                         itemCount: querySnapshot.docs.length,
//                         itemBuilder: (context, index) {
//                           return UserInfoTile(
//                             currentUser: getUserModelFromDataSnapshot(
//                                 querySnapshot.docs[index], index),
//                             index: index,
//                           );
//                         },
//                       );
//                     }
//                   }
//                 )
//               ],
//             )))
//         : Center(
//         child: Container(
//             child: Text('No Data', style: GoogleFonts.montserrat())));
//   }
//
//   CurrentUser getUserModelFromDataSnapshot(
//       DocumentSnapshot userInfoSnapshot, int index) {
//     CurrentUser userModel = new CurrentUser();
//
//     userModel.id = userInfoSnapshot.data()['id'];
//     userModel.profileName = userInfoSnapshot.data()['profileName'];
//     userModel.username = userInfoSnapshot.data()['username'];
//     userModel.phoneNumber = userInfoSnapshot.data()['phoneNumber'];
//     userModel.url = userInfoSnapshot.data()['url'];
//     userModel.email = userInfoSnapshot.data()['email'];
//     userModel.level = userInfoSnapshot.data()['level'];
//     userModel.points = userInfoSnapshot.data()['points'];
//     userModel.role = userInfoSnapshot.data()['role'];
//     userModel.freePoints = userInfoSnapshot.data()['freePoints'];
//     userModel.expireDate = userInfoSnapshot.data()['expireDate'].toDate();
//     userModel.freeExpireDate =
//         userInfoSnapshot.data()['freeExpireDate'].toDate();
//     userModel.createdAt = userInfoSnapshot.data()['createdAt'].toDate();
//     userModel.updatedAt = userInfoSnapshot.data()['updatedAt'].toDate();
//
//     return userModel;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             title: Text(
//           'Setting User Info',
//           style: GoogleFonts.montserrat(),
//         )),
//         body: Container(
//             height: MediaQuery.of(context).size.height * 1,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                     child: ListView(shrinkWrap: false, children: [
//                   searchUserInfo(),
//                   viewUserInfoListStream(),
//                   Container(),
//                 ]))
//               ],
//             )));
//   }
//
//   searchUserInfo() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Row(
//                 children: [
//                   Text('검색 타입', style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
//                   SizedBox(width: 20),
//                   Text('이름', style: TextStyle(fontSize: 15,)),
//                   Radio(
//                     value: SelectedRadio.username,
//                     groupValue: _selectedRadio,
//                     activeColor: Colors.blue,
//                     onChanged: (SelectedRadio value) {
//                       setState(() {
//                         _selectedRadio = value;
//                       });
//                     },
//                   ),
//                   SizedBox(width: 20),
//                   Text('휴대폰번호', style: TextStyle(fontSize: 15,)),
//                   Radio(
//                     value: SelectedRadio.phoneNumber,
//                     groupValue: _selectedRadio,
//                     activeColor: Colors.blue,
//                     onChanged: (SelectedRadio value) {
//                       setState(() {
//                         _selectedRadio = value;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Text('검색어', style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
//               SizedBox(width: 20),
//               Expanded(
//                   child: TextFormField(
//                 controller: _searchValueController,
//               )),
//               SizedBox(width: 20),
//               RaisedButton(
//                 color: Colors.blue,
//                 child: Text('검색', style: TextStyle(color: Colors.white),),
//                 onPressed: () {
//                   setState(() {
//                     isLoading = true;
//                   });
//                   // databaseService.getUserInfoList(_searchValueController.text).then((val) {
//                   //     if (mounted) {
//                   //       setState(() {
//                   //         userInfoStream = val;
//                   //         isLoading = false;
//                   //       });
//                   //     }
//                   //   });
//                   if(_selectedRadio == SelectedRadio.username) {
//                     databaseService.getUserInfoListByUsername(_searchValueController.text.toString()).then((val) {
//                       if (mounted) {
//                         setState(() {
//                           userInfoStream = val;
//                           isLoading = false;
//                         });
//                       }
//                     });
//                   } else {
//                     databaseService.getUserInfoListByPhoneNumber(_searchValueController.text).then((val) {
//                       if (mounted) {
//                         setState(() {
//                           userInfoStream = val;
//                           isLoading = false;
//                         });
//                       }
//                     });
//                   }
//                 },
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class UserInfoTile extends StatefulWidget {
//   final CurrentUser currentUser;
//   final int index;
//
//   UserInfoTile({this.currentUser, this.index});
//
//   @override
//   _UserInfoTileState createState() => _UserInfoTileState();
// }
//
// class _UserInfoTileState extends State<UserInfoTile> {
//   void _showEditProfileDialog(context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Edit info',
//                   style: GoogleFonts.montserrat(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue,
//                       fontSize: 20))
//               .tr(),
//           actionsPadding: EdgeInsets.only(right: 10),
//           elevation: 0.0,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
//           content: Container(
//               width: MediaQuery.of(context).size.width * 1,
//               height: MediaQuery.of(context).size.height * 0.8,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               alignment: Alignment.center,
//               child: EditProfilePageByAdmin(
//                   currentOnlineUserId: widget.currentUser.id)),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
//       child: ListTile(
//         tileColor: Colors.grey.withOpacity(0.1),
//         title: Container(
//           child: Padding(
//             padding: const EdgeInsets.only(top: 5, bottom: 10),
//             child: Container(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     widget.currentUser.username,
//                     style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
//                   ),
//                   Spacer(),
//                   Text(
//                     widget.currentUser.profileName == null
//                         ? ""
//                         : widget.currentUser.profileName,
//                     style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
//                   ),
//                   Spacer(),
//                   RaisedButton(
//                       color: Colors.blue,
//                       onPressed: () async {
//                         // 유저 정보 상세페이지로 이동 (수정 가능토록)
//                         // _showEditProfileDialog(context);
//                         final result = await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => EditProfilePageByAdmin(
//                                   currentOnlineUserId: widget.currentUser.id)),
//                         );
//                         // 선택 창으로부터 결과 값을 받은 후, 이전에 있던 snackbar는 숨기고 새로운 결과 값을
//                         // 보여줍니다.
//                         // ScaffoldMessenger.of(context).showSnackBar(
//                         //   SnackBar(
//                         //     content: Text("$result").tr(),
//                         //   ),
//                         // );
//                       },
//                       child: Text('Edit',
//                               style:
//                                   GoogleFonts.montserrat(color: Colors.white))
//                           .tr())
//                 ],
//               ),
//             ),
//           ),
//         ),
//         subtitle: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(
//                   'email : ',
//                   style: GoogleFonts.montserrat(),
//                 ),
//                 Text(
//                   widget.currentUser.email,
//                   style: GoogleFonts.montserrat(),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(
//                   'Level : ',
//                   style: GoogleFonts.montserrat(),
//                 ),
//                 Text(
//                   widget.currentUser.level,
//                   style: GoogleFonts.montserrat(),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(
//                   'Point(s) : ',
//                   style: GoogleFonts.montserrat(color: Colors.red),
//                 ),
//                 Text(
//                   widget.currentUser.points.toString(),
//                   style: GoogleFonts.montserrat(color: Colors.red),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(
//                   'Point(s) expire date : ',
//                   style: GoogleFonts.montserrat(color: Colors.red),
//                 ),
//                 Text(
//                   widget.currentUser.expireDate
//                       .toIso8601String()
//                       .substring(0, 10),
//                   style: GoogleFonts.montserrat(color: Colors.red),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(
//                   'Free point(s) : ',
//                   style: GoogleFonts.montserrat(color: Colors.green),
//                 ),
//                 Text(
//                   widget.currentUser.freePoints.toString(),
//                   style: GoogleFonts.montserrat(color: Colors.green),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(
//                   'Free point(s) expire date : ',
//                   style: GoogleFonts.montserrat(color: Colors.green),
//                 ),
//                 Text(
//                   widget.currentUser.freeExpireDate
//                       .toIso8601String()
//                       .substring(0, 10),
//                   style: GoogleFonts.montserrat(color: Colors.green),
//                 ),
//               ],
//             ),
//             SizedBox(height: 5)
//           ],
//         ),
//       ),
//     );
//   }
// }
