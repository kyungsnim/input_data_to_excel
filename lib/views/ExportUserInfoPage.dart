import 'dart:async';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:input_data_to_excel/models/CurrentUser.dart';
import 'package:input_data_to_excel/res/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:input_data_to_excel/views/HomePage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';

enum SelectedRadio { username, phoneNumber }
File f;
String fileName;

class ExportUserInfoPage extends StatefulWidget {
  @override
  _ExportUserInfoPageState createState() => _ExportUserInfoPageState();
}

class _ExportUserInfoPageState extends State<ExportUserInfoPage> {
  DatabaseService databaseService = new DatabaseService();
  String filePath;
  // 유저 수
  var userInfoCount = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // f = File('');
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.d('ExportUserInfoPage : 학생 엑셀추출 페이지');
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
                '학생 엑셀추출',
                style: GoogleFonts.montserrat(color: Colors.blueGrey),
              )),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              selectExportUserInfo('전체', ' 추출', Colors.blueAccent),
              selectExportUserInfo('중학교 2학년', ' 추출', Colors.teal),
              selectExportUserInfo('중학교 3학년', ' 추출', Colors.teal),
              selectExportUserInfo('고등학교 1학년', ' 추출', Colors.blueGrey),
              selectExportUserInfo('고등학교 2학년', ' 추출', Colors.blueGrey),
              selectExportUserInfo('고등학교 3학년', ' 추출', Colors.blueGrey),
            ],
          )
      )
    );
  }

  selectExportUserInfo(grade, title, color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
            width: 200, child: RaisedButton(
          color: color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$grade $title',
                style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          onPressed: () {
            getExcel(grade);
            uploadExcelData();
          },
        )),
      ),
    );
  }

  getExcel(grade) async {
    var excel = Excel.createExcel();
    // excel.delete('Sheet1');
    Sheet sheetObject = excel['Sheet1'];

    // 10 이하인 경우 0 붙이기 (월, 일 계산)
    var todayMonth = DateTime.now().month < 10 ? '0' + DateTime.now().month.toString() : DateTime.now().month;
    var todayDay = DateTime.now().day < 10 ? '0' + DateTime.now().day.toString() : DateTime.now().day;
    var todayHour = DateTime.now().hour < 10 ? '0' + DateTime.now().hour.toString() : DateTime.now().hour;
    var todayMinute = DateTime.now().minute < 10 ? '0' + DateTime.now().minute.toString() : DateTime.now().minute;
    var todaySecond = DateTime.now().second < 10 ? '0' + DateTime.now().second.toString() : DateTime.now().second;
    // 파일 이름 설정
    fileName =
    '${grade}_${DateTime.now().year}$todayMonth$todayDay$todayHour$todayMinute$todaySecond.xlsx';
    
    // 최상단 꾸밀 raw
    List<dynamic> raw;
    var cloud =
    grade == '전체' ? await userReference.orderBy('name').get()
        : await userReference.where('grade', isEqualTo: grade).orderBy('name').get();

    raw = [
      "No.".toString(),
      "수험번호".toString(),
      "이름".toString(),
      "학년".toString(),
      "휴대폰".toString(),
    ];

    // 최상단에 셋팅
    sheetObject.insertRowIterables(raw, 0);

    if (cloud.docs != null) {
      for (int i = 0; i < cloud.docs.length; i++) {
        List<dynamic> row = List<dynamic>();
        
        // No. 넣기
        row.add(i+1);
        // 수험번호 넣기
        row.add(int.parse(cloud.docs[i].data()['id']));
        // 이름 넣기
        row.add(cloud.docs[i].data()['name'].toString());
        // 이름 넣기
        row.add(cloud.docs[i].data()['grade'].toString());
        // 휴대폰번호 넣기
        row.add(cloud.docs[i].data()['phoneNumber'].toString());
        
        // 해당 행 sheet에 추가
        sheetObject.insertRowIterables(row, i + 1);
      }

      // Save the Changes in file
      f = await _localFile;
      excel.encode().then((onValue) {
        f.createSync(recursive: true);
        f.writeAsBytesSync(onValue);
      });
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();
    return directory.absolute.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    filePath = '$path/$fileName';
    return File(filePath).create();
  }

  uploadExcelData() async {
    // if (Platform.isIOS) {
    Reference levelTestRef = FirebaseStorage.instance.ref().child(
        'userList/$fileName');
    // // upload Task는 제공되나 아직 실제 업로드 전
    showToast('엑셀 변환 중', duration: 3);
    Future.delayed(Duration(seconds: 2)).then((_) async {
      UploadTask uploadTask = levelTestRef.putFile(f);
      // 실제 파일 업로드 (중간에 중단, 취소 등 하지 않을 것이므로 최대한 심플하게 가보자.)
      await uploadTask.whenComplete(() => showToast('학생데이터 엑셀 업로드 완료', duration: 2));

      Navigator.pop(context);
    });
  }

  showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}