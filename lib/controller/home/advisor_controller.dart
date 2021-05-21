import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:vipc_app/model/member.dart';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:vipc_app/model/news.dart';
import 'package:vipc_app/model/prospect.dart';

class AdvisorController extends ControllerMVC {
  factory AdvisorController() {
    if (_this == null) _this = AdvisorController._();
    return _this;
  }
  static AdvisorController _this;
  AdvisorController._();

  static AdvisorController get con => _this;
  int selectedIndex;
  List<News> newsList;
  List<Prospect> prospectList;
  List<Prospect> prospectCardList;
  List<double> weeklyPoint = [0, 0, 0, 0];
  List<int> monthlyPoint = [];
  int currentMonthPoint = 0;
  int currentWeekPoint = 0;
  DateTime minimumDate;
  DateTime fromDate, toDate;
  Map<String, int> rangePoint = {};
  List<DateTime> rangeTime;
  int numIndex;
  bool weekPoint = false;

  String dropdownValue = 'Sort by Time';
  String sort = 'up';

  Future<void> getNews(BuildContext context) async {
    List<News> newsListTemp = [];

    try {
      final news = await FirebaseFirestore.instance.collection("news").get();

      news.docs.forEach((oneNew) {
        if (oneNew.data()['images'] == null) {
          newsListTemp.add(News(
            newsId: oneNew.id,
            title: oneNew.data()['title'],
            content: oneNew.data()['content'],
          ));
        } else {
          newsListTemp.add(News(
            newsId: oneNew.id,
            title: oneNew.data()['title'],
            content: oneNew.data()['content'],
            imageUrl: oneNew.data()['images'],
          ));
        }
      });
      newsList = newsListTemp.reversed.toList();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }

  Future<void> getProspect(BuildContext context) async {
    List<Prospect> newsProspectListTemp = [];
    minimumDate = DateTime.now();
    try {
      String userId = FirebaseAuth.instance.currentUser.uid;
      var prospects;
      if (dropdownValue == 'Sort by Time')
        prospects = await FirebaseFirestore.instance
            .collection("prospect")
            .doc(userId)
            .collection('prospects')
            .orderBy('lastUpdate', descending: sort != 'up')
            .get();
      else if (dropdownValue == 'Sort by Step')
        prospects = await FirebaseFirestore.instance
            .collection("prospect")
            .doc(userId)
            .collection('prospects')
            .orderBy('lastStep', descending: sort != 'up')
            .get();

      prospects.docs.forEach((oneProspect) {
        if (DateTime.parse(oneProspect.data()['steps']['0Time'])
                .difference(minimumDate)
                .inSeconds <=
            0)
          minimumDate = DateTime.parse(oneProspect.data()['steps']['0Time']);

        if (oneProspect.data()['done'] == 0)
          newsProspectListTemp.add(Prospect(
            prospectId: oneProspect.id,
            prospectName: oneProspect.data()['prospectName'],
            phoneNo: oneProspect.data()['phone'],
            email: oneProspect.data()['email'],
            type: oneProspect.data()['type'],
            steps: oneProspect.data()['steps'],
            lastUpdate: oneProspect.data()['lastUpdate'],
            lastStep: oneProspect.data()['lastStep'],
            done: oneProspect.data()['done'],
          ));
      });
      prospectList = newsProspectListTemp;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }

  Future<void> getProspectCard(BuildContext context) async {
    List<Prospect> newsProspectListTemp = [];
    DateTime present = DateTime.now();
    DateTime time;

    try {
      String userId = FirebaseAuth.instance.currentUser.uid;
      var prospects;
      prospects = await FirebaseFirestore.instance
          .collection("prospect")
          .doc(userId)
          .collection('prospects')
          .orderBy('lastUpdate', descending: false)
          .get();

      prospects.docs.forEach((oneProspect) {
        if (oneProspect.data()['done'] == 0 &&
            oneProspect.data()['lastStep'] != 0) {
          time = DateTime.parse(oneProspect.data()['lastUpdate']);
          if (time.difference(present).inSeconds > 0)
            newsProspectListTemp.add(Prospect(
              prospectId: oneProspect.id,
              prospectName: oneProspect.data()['prospectName'],
              phoneNo: oneProspect.data()['phone'],
              email: oneProspect.data()['email'],
              type: oneProspect.data()['type'],
              steps: oneProspect.data()['steps'],
              lastUpdate: oneProspect.data()['lastUpdate'],
              lastStep: oneProspect.data()['lastStep'],
              done: oneProspect.data()['done'],
            ));
        }
      });
      prospectCardList = newsProspectListTemp;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }

  Future<void> getCurrentMonthPoint(BuildContext context) async {
    DateTime present = DateTime.now();
    int currentYear = present.year;
    int currentMonth = present.month;
    currentMonthPoint = 0;

    try {
      String userId = FirebaseAuth.instance.currentUser.uid;
      var prospects;
      prospects = await FirebaseFirestore.instance
          .collection("prospect")
          .doc(userId)
          .collection('prospects')
          .get();

      TimeOfDay t;
      var now;
      var time;
      prospects.docs.forEach((oneProspect) {
        DateTime createdTime =
            DateTime.parse(oneProspect.data()['steps']['0Time']);
        if (createdTime.difference(present).inSeconds <= 0 &&
            createdTime.year == currentYear &&
            createdTime.month == currentMonth) currentMonthPoint++;
        for (int i = 1; i < oneProspect.data()['steps']['length']; i++) {
          if (oneProspect.data()['steps']['${i}meetingTime'] != '')
            t = TimeOfDay(
                hour: int.parse(oneProspect
                    .data()['steps']['${i}meetingTime']
                    .substring(0, 2)),
                minute: int.parse(oneProspect
                    .data()['steps']['${i}meetingTime']
                    .substring(3, 5)));
          else
            t = TimeOfDay(hour: 0, minute: 0);
          now = DateTime.parse(oneProspect.data()['steps']['${i}meetingDate']);
          time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
          if (time.difference(present).inSeconds <= 0 &&
              now.year == currentYear &&
              now.month == currentMonth)
            currentMonthPoint += oneProspect.data()['steps']['${i}Point'];
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }

  // Future<void> getCurrentWeekPoint(BuildContext context) async {
  //   DateTime present = DateTime.now();
  //   currentWeekPoint = 0;

  //   if (present.day >= 1 && present.day <= 7)
  //     currentWeekPoint = weeklyPoint[0].toInt();
  //   else if (present.day >= 8 && present.day <= 14)
  //     currentWeekPoint = weeklyPoint[1].toInt();
  //   else if (present.day >= 15 && present.day <= 21)
  //     currentWeekPoint = weeklyPoint[2].toInt();
  //   else
  //     currentWeekPoint = weeklyPoint[3].toInt();
  //   currentWeekPoint = 30;
  // }

  Future<void> getWeeklyPoint(BuildContext context) async {
    DateTime present = DateTime.now();
    int currentYear = present.year;
    int currentMonth = present.month;
    currentWeekPoint = 0;

    try {
      String userId = FirebaseAuth.instance.currentUser.uid;
      var prospects;
      prospects = await FirebaseFirestore.instance
          .collection("prospect")
          .doc(userId)
          .collection('prospects')
          .get();

      for (int i = 0; i < 4; i++) {
        weeklyPoint[i] = 0.0;
      }

      TimeOfDay t;
      var now;
      var time;
      prospects.docs.forEach((oneProspect) {
        DateTime createdTime =
            DateTime.parse(oneProspect.data()['steps']['0Time']);
        if (createdTime.difference(present).inSeconds <= 0 &&
            createdTime.year == currentYear &&
            createdTime.month ==
                currentMonth) if (createdTime.day >= 1 && createdTime.day <= 7)
          weeklyPoint[0]++;
        else if (createdTime.day >= 8 && createdTime.day <= 14)
          weeklyPoint[1]++;
        else if (createdTime.day >= 15 && createdTime.day <= 21)
          weeklyPoint[2]++;
        else
          weeklyPoint[3]++;

        print('test');
        for (int i = 0; i < 4; i++) {
          print(weeklyPoint[i]);
        }
        for (int i = 1; i < oneProspect.data()['steps']['length']; i++) {
          if (oneProspect.data()['steps']['${i}meetingTime'] != '')
            t = TimeOfDay(
                hour: int.parse(oneProspect
                    .data()['steps']['${i}meetingTime']
                    .substring(0, 2)),
                minute: int.parse(oneProspect
                    .data()['steps']['${i}meetingTime']
                    .substring(3, 5)));
          else
            t = TimeOfDay(hour: 0, minute: 0);
          now = DateTime.parse(oneProspect.data()['steps']['${i}meetingDate']);
          time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
          if (time.difference(present).inSeconds <= 0 &&
              now.year == currentYear &&
              now.month == currentMonth) if (time.day >= 1 && time.day <= 7)
            weeklyPoint[0] += oneProspect.data()['steps']['${i}Point'];
          else if (time.day >= 8 && time.day <= 14)
            weeklyPoint[1] += oneProspect.data()['steps']['${i}Point'];
          else if (time.day >= 15 && time.day <= 21)
            weeklyPoint[2] += oneProspect.data()['steps']['${i}Point'];
          else
            weeklyPoint[3] += oneProspect.data()['steps']['${i}Point'];
        }
      });
      if (present.day >= 1 && present.day <= 7)
        currentWeekPoint = weeklyPoint[0].toInt();
      else if (present.day >= 8 && present.day <= 14)
        currentWeekPoint = weeklyPoint[1].toInt();
      else if (present.day >= 15 && present.day <= 21)
        currentWeekPoint = weeklyPoint[2].toInt();
      else
        currentWeekPoint = weeklyPoint[3].toInt();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }

  Future<void> getMonthlyPoint(BuildContext context) async {
    DateTime present = DateTime.now();
    int currentYear = present.year;
    int currentMonth = present.month;
    print(currentMonth);
    // for (int i = 0; i < 12; i++) monthlyPoint.add(0);
// monthlyPoint = 0

    try {
      String userId = FirebaseAuth.instance.currentUser.uid;
      var prospects;
      prospects = await FirebaseFirestore.instance
          .collection("prospect")
          .doc(userId)
          .collection('prospects')
          .get();

      for (int i = 0; i < 12; i++) {
        monthlyPoint[i] = 0;
      }

      TimeOfDay t;
      var now;
      var time;
      prospects.docs.forEach((oneProspect) {
        // time = DateTime.parse(oneProspect.data()['lastUpdate']);
        // if (time.difference(present).inSeconds > 0)
        //   newsProspectListTemp.add(Prospect(
        //     prospectId: oneProspect.id,
        //     prospectName: oneProspect.data()['prospectName'],
        //     phoneNo: oneProspect.data()['phone'],
        //     email: oneProspect.data()['email'],
        //     type: oneProspect.data()['type'],
        //     steps: oneProspect.data()['steps'],
        //     lastUpdate: oneProspect.data()['lastUpdate'],
        //     lastStep: oneProspect.data()['lastStep'],
        //     done: oneProspect.data()['done'],
        //   ));
        // print(oneProspect.data()['steps']['length']);

        DateTime createdTime =
            DateTime.parse(oneProspect.data()['steps']['0Time']);
        if (createdTime.difference(present).inSeconds <= 0 &&
            createdTime.year == currentYear)
          monthlyPoint[createdTime.month - 1]++;
        for (int i = 1; i < oneProspect.data()['steps']['length']; i++) {
          if (oneProspect.data()['steps']['${i}meetingTime'] != '')
            t = TimeOfDay(
                hour: int.parse(oneProspect
                    .data()['steps']['${i}meetingTime']
                    .substring(0, 2)),
                minute: int.parse(oneProspect
                    .data()['steps']['${i}meetingTime']
                    .substring(3, 5)));
          else
            t = TimeOfDay(hour: 0, minute: 0);
          now = DateTime.parse(oneProspect.data()['steps']['${i}meetingDate']);
          time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
          if (time.difference(present).inSeconds <= 0 &&
              now.year == currentYear &&
              now.month <= currentMonth)
            monthlyPoint[now.month - 1] +=
                oneProspect.data()['steps']['${i}Point'];
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }

  Future<void> getRangePoint(BuildContext context) async {
    DateTime present = DateTime.now();

    print(fromDate);
    print(toDate);
    double numIndexD = toDate.difference(fromDate).inDays / 30;
    numIndex = numIndexD.toInt();
    int month = toDate.month;
    print(month);
    rangePoint = {};
    rangeTime = [];
    String date;
    for (int i = 0; i <= numIndex; i++) {
      date = DateFormat('MM/yyyy')
          .format(DateTime(fromDate.year, fromDate.month + i, 1, 0, 0, 0))
          .toString();
      rangeTime.add(DateTime(fromDate.year, fromDate.month + i));
      print('alo');
      print(rangeTime[i]);
      print(date);
      rangePoint['$date'] = 0;
      // print(rangePoint[i]['$date']);
      // rangePoint.add(0);
    }

    try {
      String userId = FirebaseAuth.instance.currentUser.uid;
      var prospects;
      prospects = await FirebaseFirestore.instance
          .collection("prospect")
          .doc(userId)
          .collection('prospects')
          .get();

      TimeOfDay t;
      var now, now2;
      var time, time2;
      prospects.docs.forEach((oneProspect) {
        DateTime createdTime =
            DateTime.parse(oneProspect.data()['steps']['0Time']);
        // print('created time');
        // print(DateTime(createdTime.year, createdTime.month, 1, 0, 0, 0)
        //     .toString());
        // print(DateTime(fromDate.year, fromDate.month, 1, 0, 0, 0).toString());
        // print(DateTime(toDate.year, toDate.month, 1, 0, 0, 0).toString());
        // print(DateTime(createdTime.year, createdTime.month, 1, 0, 0, 0)
        //         .difference(DateTime(fromDate.year, fromDate.month, 1, 0, 0, 0))
        //         .inSeconds >=
        //     0);
        // print(DateTime(createdTime.year, createdTime.month, 1, 0, 0, 0)
        //         .difference(DateTime(toDate.year, toDate.month, 1, 0, 0, 0))
        //         .inSeconds <=
        //     0);

        if (DateTime(createdTime.year, createdTime.month, 1, 0, 0, 0)
                    .difference(
                        DateTime(fromDate.year, fromDate.month, 1, 0, 0, 0))
                    .inSeconds >=
                0 &&
            DateTime(createdTime.year, createdTime.month, 1, 0, 0, 0)
                    .difference(DateTime(toDate.year, toDate.month, 1, 0, 0, 0))
                    .inSeconds <=
                0) {
          date = DateFormat('MM/yyyy')
              .format(DateTime(createdTime.year, createdTime.month, 1, 0, 0, 0))
              .toString();
          rangePoint['$date'] += 1;
        }

        for (int i = 1; i < oneProspect.data()['steps']['length']; i++) {
          // now = DateTime.parse(oneProspect.data()['steps']['${i}meetingDate']);
          // time = DateTime(now.year, now.month, 1, 0, 0, 0);

          if (oneProspect.data()['steps']['${i}meetingTime'] != '')
            t = TimeOfDay(
                hour: int.parse(oneProspect
                    .data()['steps']['${i}meetingTime']
                    .substring(0, 2)),
                minute: int.parse(oneProspect
                    .data()['steps']['${i}meetingTime']
                    .substring(3, 5)));
          else
            t = TimeOfDay(hour: 0, minute: 0);
          now = DateTime.parse(oneProspect.data()['steps']['${i}meetingDate']);
          time = DateTime(now.year, now.month, now.day, t.hour, t.minute);
          date = DateFormat('MM/yyyy')
              .format(
                  DateTime(time.year, time.month, now.day, t.hour, t.minute))
              .toString();
          if (time
                      .difference(
                          DateTime(fromDate.year, fromDate.month, 1, 0, 0, 0))
                      .inSeconds >=
                  0 &&
              time
                      .difference(
                          DateTime(toDate.year, toDate.month + 1, 0, 0, 0, 0))
                      .inSeconds <=
                  0 &&
              time.difference(present).inSeconds <= 0)
            rangePoint['$date'] += oneProspect.data()['steps']['${i}Point'];
        }
        print(rangePoint);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).errorColor),
      );
    }
  }
}
