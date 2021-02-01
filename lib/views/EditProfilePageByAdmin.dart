// import 'package:input_data_to_excel/models/CurrentUser.dart';
// import 'package:input_data_to_excel/widgets/ProgressWidget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//
// import 'HomePage.dart';
//
// class EditProfilePageByAdmin extends StatefulWidget {
//   final String currentOnlineUserId;
//
//   EditProfilePageByAdmin({this.currentOnlineUserId});
//
//   @override
//   _EditProfilePageByAdminState createState() => _EditProfilePageByAdminState();
// }
//
// class _EditProfilePageByAdminState extends State<EditProfilePageByAdmin> {
//   TextEditingController usernameTextEditingController = TextEditingController();
//   TextEditingController profileNameTextEditingController =
//       TextEditingController();
//   TextEditingController emailTextEditingController = TextEditingController();
//   TextEditingController phoneNumberTextEditingController =
//       TextEditingController();
//   final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
//   bool loading = false;
//   CurrentUser editUser;
//   bool _usernameValid = true;
//   bool _profileNameValid = true;
//   bool _emailValid = true;
//   bool _phoneNumberValid = true;
//   DateTime _expireDate;
//   DateTime _freeExpireDate;
//   final _userPointList = [
//     0,
//     1,
//     2,
//     3,
//     4,
//     5,
//     6,
//     7,
//     8,
//     9,
//     10,
//     11,
//     12,
//     13,
//     14,
//     15,
//     16,
//     17,
//     18,
//     19,
//     20,
//     21,
//     22,
//     23,
//     24,
//     25,
//     26,
//     27,
//     28,
//     29,
//     30,
//     31,
//     32,
//     33,
//     34,
//     35,
//     36,
//     37,
//     38,
//     39,
//     40,
//     41,
//     42,
//     43,
//     44,
//     45,
//     46,
//     47,
//     48,
//     49,
//     50
//   ];
//   final _userFreePointList = [0, 1, 2, 3, 4, 5, 6];
//   final _userLevelList = ['All', 'Starter', 'Beginner', 'Waystage', 'Low Threshold', 'High Threshold'];
//   var _userLevel;
//   var _userPoint;
//   var _userFreePoint;
//
//   @override
//   void initState() {
//     super.initState();
//     // 화면 빌드 전 미리 해당 사용자의 값들로 셋팅해주자
//     getAndDisplayUserInformation();
//   }
//
//   @override
//   void dispose() {
//     usernameTextEditingController.dispose();
//     profileNameTextEditingController.dispose();
//     phoneNumberTextEditingController.dispose();
//     emailTextEditingController.dispose();
//     super.dispose();
//   }
//
//   getAndDisplayUserInformation() async {
//     setState(() {
//       loading = true;
//     });
//
//     // DB에서 사용자 정보 가져오기
//     DocumentSnapshot documentSnapshot =
//         await userReference.doc(widget.currentOnlineUserId).get();
//     editUser = CurrentUser.fromDocument(documentSnapshot);
//
//     // 입력란에 사용자 정보로 채워주기
//     usernameTextEditingController.text = editUser.username;
//     profileNameTextEditingController.text = editUser.profileName;
//     emailTextEditingController.text = editUser.email;
//     phoneNumberTextEditingController.text = editUser.phoneNumber;
//     _userPoint = editUser.points != null ? editUser.points : 1;
//     _userFreePoint = editUser.freePoints != null ? editUser.freePoints : 1;
//     _userLevel = editUser.level != null ? editUser.level : "";
//     _expireDate = editUser.expireDate != null ? editUser.expireDate : DateTime.now();
//     _freeExpireDate = editUser.freeExpireDate != null ? editUser.freeExpireDate : DateTime.now();
//     // 셋팅 끝나면 loading은 false로 바뀌고 화면에 값들이 보임
//     setState(() {
//       loading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         key: _scaffoldGlobalKey,
//         body: loading
//             ? circularProgress()
//             : ListView(
//                 children: [
//                   Container(
//                       child: Column(
//                     children: [
//                       currentUser.role == 'admin'
//                           ? Container()
//                           : Padding(
//                               padding: EdgeInsets.only(top: 16, bottom: 7),
//                               child: CircleAvatar(
//                                 radius: 54,
//                                 backgroundImage:
//                                     CachedNetworkImageProvider(editUser.url),
//                               ),
//                             ),
//                       Padding(
//                         padding: EdgeInsets.all(16),
//                         child: Column(
//                           children: [
//                             createUsernameTextFormField('English name',
//                                 'Write English name here', _usernameValid),
//                             createProfileNameTextFormField(
//                                 'Korea name',
//                                 'Write Korean name here',
//                                 _profileNameValid),
//                             createEmailTextFormField('Email address',
//                                 'Write email here', _emailValid),
//                             createPhoneNumberTextFormField('Phone number',
//                                 'Write phone number here', _phoneNumberValid),
//                             currentUser.role == 'admin'
//                                 ? createPointsTextFormField(
//                                     'Points', 'Select points')
//                                 : Container(),
//                             currentUser.role == 'admin'
//                                 ? createFreePointsTextFormField(
//                                     'Free Points', 'Select free points')
//                                 : Container(),
//                             currentUser.role == 'admin'
//                                 ? createUserLevelTextFormField(
//                                 'User Level', 'Select user level')
//                                 : Container(),
//                           ],
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           InkWell(
//                             onTap: () => Navigator.pop(context),
//                             child: Container(
//                               padding: const EdgeInsets.all(16),
//                               child: Text('Cancel',
//                                       style: GoogleFonts.montserrat(
//                                           color: Colors.grey, fontSize: 15))
//                                   .tr(),
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () {
//                               updateUserData();
//                               Navigator.pop(context, "Edit user info");
//                               // Navigator.pushReplacement(
//                               //     context,
//                               //     MaterialPageRoute(
//                               //         builder: (context) =>
//                               //             HomePage(4) // ProfilePage
//                               //         ));
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.all(16),
//                               child: Text('OK',
//                                       style: GoogleFonts.montserrat(
//                                           color: Colors.blue, fontSize: 15))
//                                   .tr(),
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ))
//                 ],
//               ));
//   }
//
//   createUsernameTextFormField(title, hintText, isVaild) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(top: 10),
//           child: Text(
//             title,
//             style: GoogleFonts.montserrat(
//                 color: Colors.grey, fontWeight: FontWeight.bold),
//           ),
//         ),
//         TextField(
//           style: GoogleFonts.montserrat(color: Colors.blue),
//           controller: usernameTextEditingController,
//           decoration: InputDecoration(
//               hintText: hintText,
//               enabledBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.grey)),
//               focusedBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue)),
//               hintStyle: GoogleFonts.montserrat(color: Colors.grey),
//               errorText: isVaild ? null : 'Input text is too short'),
//         ),
//         SizedBox(height: 10),
//       ],
//     );
//   }
//
//   createProfileNameTextFormField(title, hintText, isVaild) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(top: 10),
//           child: Text(
//             title,
//             style: GoogleFonts.montserrat(
//                 color: Colors.grey, fontWeight: FontWeight.bold),
//           ),
//         ),
//         TextField(
//           style: GoogleFonts.montserrat(color: Colors.blue),
//           controller: profileNameTextEditingController,
//           decoration: InputDecoration(
//               hintText: hintText,
//               enabledBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.grey)),
//               focusedBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue)),
//               hintStyle: GoogleFonts.montserrat(color: Colors.grey),
//               errorText: isVaild ? null : 'Input text is too short'),
//         ),
//         SizedBox(height: 10),
//       ],
//     );
//   }
//
//   createEmailTextFormField(title, hintText, isVaild) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(top: 10),
//           child: Text(
//             title,
//             style: GoogleFonts.montserrat(
//                 color: Colors.grey, fontWeight: FontWeight.bold),
//           ),
//         ),
//         TextField(
//           style: GoogleFonts.montserrat(color: Colors.blue),
//           controller: emailTextEditingController,
//           decoration: InputDecoration(
//               hintText: hintText,
//               enabledBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.grey)),
//               focusedBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue)),
//               hintStyle: GoogleFonts.montserrat(color: Colors.grey),
//               errorText: isVaild ? null : 'Input text is too short'),
//         ),
//         SizedBox(height: 10),
//       ],
//     );
//   }
//
//   createPhoneNumberTextFormField(title, hintText, isVaild) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(top: 10),
//           child: Text(
//             title,
//             style: GoogleFonts.montserrat(
//                 color: Colors.grey, fontWeight: FontWeight.bold),
//           ),
//         ),
//         TextField(
//           style: GoogleFonts.montserrat(color: Colors.blue),
//           controller: phoneNumberTextEditingController,
//           decoration: InputDecoration(
//               hintText: hintText,
//               enabledBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.grey)),
//               focusedBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.blue)),
//               hintStyle: GoogleFonts.montserrat(color: Colors.grey),
//               errorText: isVaild ? null : 'Input text is too short'),
//           onChanged: (value) {
//             phoneNumberTextEditingController.text = value;
//           },
//         ),
//         SizedBox(height: 10),
//       ],
//     );
//   }
//
//   createPointsTextFormField(title, hintText) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(top: 10),
//           child: Text(
//             title,
//             style: GoogleFonts.montserrat(
//                 color: Colors.grey, fontWeight: FontWeight.bold),
//           ),
//         ),
//         Container(
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: DropdownButton(
//                     value: _userPoint,
//                     icon: Icon(Icons.arrow_downward),
//                     underline: Container(
//                       height: 1,
//                       color: Colors.grey,
//                     ),
//                     items: _userPointList.map((value) {
//                       return DropdownMenuItem(
//                         value: value,
//                         child: Text("$value Point(s)",
//                             style: GoogleFonts.montserrat(fontSize: 15)),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _userPoint = value;
//                       });
//                     }),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 10),
//         Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Expanded(
//                     flex: 1,
//                     child: Container(
//                         child: Text('Expire Date',
//                             style: GoogleFonts.montserrat(
//                                 color: Colors.grey,
//                                 fontWeight: FontWeight.bold)))),
//               ],
//             ),
//             SizedBox(height: 3),
//             Container(
//               decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.grey,
//                     width: 1,
//                   ),
//                   borderRadius: BorderRadius.circular(10)),
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: ListTile(
//                       title: Row(
//                         children: [
//                           // Text(
//                           //     "${_expireDate.year}-${_expireDate.month}-${_expireDate.day}"),
//                           SizedBox(width: 5),
//                           Icon(Icons.calendar_today,
//                               color: Colors.blue),
//                           SizedBox(width: 10),
//                           Text(_expireDate.toString().substring(0, 10), style: GoogleFonts.montserrat(color: Colors.blue),)
//                         ],
//                       ),
//                       onTap: () async {
//                         DateTime picked = await showDatePicker(
//                             context: context,
//                             initialDate: _expireDate,
//                             firstDate: DateTime(_expireDate.year - 5),
//                             lastDate: DateTime(_expireDate.year + 5));
//                         if (picked != null) {
//                           setState(() {
//                             _expireDate = picked;
//                           });
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   createFreePointsTextFormField(title, hintText) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(top: 10),
//           child: Text(
//             title,
//             style: GoogleFonts.montserrat(
//                 color: Colors.grey, fontWeight: FontWeight.bold),
//           ),
//         ),
//         Container(
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: DropdownButton(
//                     value: _userFreePoint,
//                     icon: Icon(Icons.arrow_downward),
//                     underline: Container(
//                       height: 1,
//                       color: Colors.grey,
//                     ),
//                     items: _userFreePointList.map((value) {
//                       return DropdownMenuItem(
//                         value: value,
//                         child: Text("$value Point(s)",
//                             style: GoogleFonts.montserrat(fontSize: 15)),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _userFreePoint = value;
//                       });
//                     }),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 10),
//         Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Expanded(
//                     flex: 1,
//                     child: Container(
//                         child: Text('Free Expire Date',
//                             style: GoogleFonts.montserrat(
//                                 color: Colors.grey,
//                                 fontWeight: FontWeight.bold)))),
//               ],
//             ),
//             SizedBox(height: 3),
//             Container(
//               decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.grey,
//                     width: 1,
//                   ),
//                   borderRadius: BorderRadius.circular(10)),
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: ListTile(
//                       title: Row(
//                         children: [
//                           // Text(
//                           //     "${_expireDate.year}-${_expireDate.month}-${_expireDate.day}"),
//                           SizedBox(width: 5),
//                           Icon(Icons.calendar_today,
//                               color: Colors.blue),
//                           SizedBox(width: 10),
//                           Text(_freeExpireDate.toString().substring(0, 10), style: GoogleFonts.montserrat(color: Colors.blue),)
//                         ],
//                       ),
//                       onTap: () async {
//                         DateTime picked = await showDatePicker(
//                             context: context,
//                             initialDate: _freeExpireDate,
//                             firstDate: DateTime(_freeExpireDate.year - 5),
//                             lastDate: DateTime(_freeExpireDate.year + 5));
//                         if (picked != null) {
//                           setState(() {
//                             _freeExpireDate = picked;
//                           });
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   createUserLevelTextFormField(title, hintText) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(top: 10),
//           child: Text(
//             title,
//             style: GoogleFonts.montserrat(
//                 color: Colors.grey, fontWeight: FontWeight.bold),
//           ),
//         ),
//         Container(
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: DropdownButton(
//                     value: _userLevel,
//                     icon: Icon(Icons.arrow_downward),
//                     underline: Container(
//                       height: 1,
//                       color: Colors.grey,
//                     ),
//                     items: _userLevelList.map((value) {
//                       return DropdownMenuItem(
//                         value: value,
//                         child: Text("$value",
//                             style: GoogleFonts.montserrat(fontSize: 15)),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _userLevel = value;
//                       });
//                     }),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 10),
//       ],
//     );
//   }
//
//   updateUserData() async {
//     setState(() {
//       usernameTextEditingController.text.trim().length < 3 ||
//               usernameTextEditingController.text.isEmpty
//           ? _usernameValid = false
//           : _usernameValid = true;
//       profileNameTextEditingController.text.trim().length < 3 ||
//               profileNameTextEditingController.text.isEmpty
//           ? _profileNameValid = false
//           : _profileNameValid = true;
//       emailTextEditingController.text.trim().length < 3 ||
//               emailTextEditingController.text.isEmpty
//           ? _emailValid = false
//           : _emailValid = true;
//       phoneNumberTextEditingController.text.trim().length < 3 ||
//               phoneNumberTextEditingController.text.isEmpty
//           ? _phoneNumberValid = false
//           : _phoneNumberValid = true;
//     });
//     print('>>>>>>>>>>>>>>>>>>>>>>>> userLevel : $_userLevel');
//     if (_usernameValid &&
//         _profileNameValid &&
//         _emailValid &&
//         _phoneNumberValid) {
//       await userReference.doc(editUser.id).update({
//         'username': usernameTextEditingController.text,
//         'profileName': profileNameTextEditingController.text,
//         'email': emailTextEditingController.text,
//         'phoneNumber': phoneNumberTextEditingController.text,
//         'points': _userPoint,
//         'expireDate': _expireDate,
//         'freePoints': _userFreePoint,
//         'freeExpireDate': _freeExpireDate,
//         'level': _userLevel,
//       });
// //      SnackBar successSnackBar = SnackBar(content: Text('Profile has been updated successfully.'),);
// //      _scaffoldGlobalKey.currentState.showSnackBar(successSnackBar);
//     }
//   }
// }
