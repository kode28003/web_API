import 'package:firedart/firedart.dart';
import 'package:functions_framework/functions_framework.dart';
import 'package:send_mail/send_email.dart';
import 'package:send_mail/send_push_notification.dart';
import 'package:shelf/shelf.dart';

@CloudFunction()
Response function(Request request) {
  main();
  print("function done");
  return Response.ok("succeeded");
}

void main() async {
  Firestore.initialize("contractcalendar-52cfe");
  print("Firebase initialized");

  //List<Document> normalScheduleList = [];
  List<Document> notRepeatPdfScheduleList = [];
  List<Document> repeatPdfScheduleList = [];
  // List<Document> allScheduleList =
  //     await Firestore.instance.collection("schedules").get();

  List<Document> allScheduleList = await Firestore.instance
      .collection("schedules")
      .where('pdf_check', isEqualTo: true)
      .get();
  List<Document> allUsers = await Firestore.instance.collection("users").get();

  print("実行環境日時: ${DateTime.now().toString()}");
  print("時差修正後日時: ${DateTime.now().add(Duration(hours: 9))}");
  print("Schedule documents got : スケジュール数: ${allScheduleList.length}");

  // for (final Document schedule in allScheduleList) {
  //   if (schedule['pdf_check'] == false) {
  //     DateTime startTime = schedule["start_time"];
  //     startTime = startTime.add(Duration(hours: 9));
  //     if (DateTime.now().add(Duration(hours: 9)).day == startTime.day &&
  //         DateTime.now().add(Duration(hours: 9)).month == startTime.month) {
  //       normalScheduleList.add(schedule); //同じ月と日付のノーマルスケジュールを追加
  //     }
  //   }
  // }

  for (final Document schedule in allScheduleList) {
    if (schedule['pdf_check'] == true) {
      if (schedule['sf_pdf_repeat_check'] == true) {
        //リピートあり
        DateTime startTime = schedule["start_time"];
        startTime = startTime.add(Duration(hours: 9));
        int? repeatInterval = schedule['sf_pdf_interval_year'];
        repeatInterval ??= 1;
        if (DateTime.now().add(Duration(hours: 9)).day == startTime.day &&
            DateTime.now().add(Duration(hours: 9)).month == startTime.month) {
          for (int i = 0; i <= 50; i += repeatInterval) {
            final futureYear = startTime.year + i;
            if (DateTime.now().add(Duration(hours: 9)).year == futureYear) {
              repeatPdfScheduleList.add(schedule); //同じ日付かつリピートされたpdfを追加
              print("リピートするpdfを追加");
              // print(
              //     " $futureYearに追加しました。${repeatPdfScheduleList[repeatPdfScheduleList.length - 1]["event_title"]}");
            }
          }
        }
      }
    }
  }

  for (final Document schedule in allScheduleList) {
    if (schedule['pdf_check'] == true) {
      if (schedule['sf_pdf_repeat_check'] == false) {
        //リピートなし
        DateTime startTime = schedule["start_time"];
        startTime = startTime.add(Duration(hours: 9));
        if (DateTime.now().add(Duration(hours: 9)).day == startTime.day &&
            DateTime.now().add(Duration(hours: 9)).month == startTime.month) {
          notRepeatPdfScheduleList.add(schedule); //同じ日付のpdfを追加
        }
      }
    }
  }

  //print("ノーマルのスケジュール数: ${normalScheduleList.length}");
  print("リピート対象スケジュール数: ${repeatPdfScheduleList.length}");
  print("リピートなしスケジュール数: ${notRepeatPdfScheduleList.length}");

  for (final schedule in repeatPdfScheduleList) {
    final shareUsers = schedule["share_user"] as List<dynamic>;
    final startTime = schedule['start_time'] as DateTime;

    print("startTime ");
    print(startTime.add(Duration(hours: 9)));
    print("");
    if (schedule['sf_pdf_repeat_check'] == true) {
      print("  リピートありです  ");
      //毎年送る
      final sendUserList = schedule["email_send_user"];
      final senderRef = schedule['create_by'];
      String sender1 = '';
      String groupName1 = '';
      for (final Document user in allUsers) {
        if (user["uid"] == senderRef) {
          sender1 = user["display_name"];
          groupName1 = user["group_name"];
          print(sender1);
          print(groupName1);
        }
      }
      for (final String sendUser in sendUserList) {
        String token = "";
        sendEmailBySendGrid(
            sendUser,
            schedule['sf_pdf_file'],
            schedule['start_time'].toString(),
            schedule['event_title'],
            schedule['event_detail'],
            sender1,
            groupName1,
            startTime);
        print("メール送信完了");
        for (final DocumentReference user in shareUsers) {
          final userData = await user.get();
          if (sendUser == userData["email"]) {
            token = userData["token"].toString();
          }
        }
        final senderRef = schedule['create_by'];
        for (final Document user in allUsers) {
          if (user["uid"] == senderRef) {
            final sender = user["display_name"];
            print(sender);
            sendPushNotification(
                '書類が送付されました', '$sender様より書類が送付されました。ご確認ください', token);
            print('sent push');
            break;
          }
        }
      }
    }
  }

  for (final schedule in notRepeatPdfScheduleList) {
    final shareUsers = schedule["share_user"] as List<dynamic>;
    final startTime = schedule['start_time'] as DateTime;
    if (schedule['sf_pdf_repeat_check'] == false) {
      print("  リピートなしです  "); //毎年送らない
      if (DateTime.now().year == startTime.year) {
        final sendUserList = schedule["email_send_user"];
        final senderRef = schedule['create_by'];
        String sender2 = '';
        String groupName2 = '';
        for (final Document user in allUsers) {
          if (user["uid"] == senderRef) {
            sender2 = user["display_name"];
            groupName2 = user["group_name"];
            print(sender2);
            print(groupName2);
          }
        }
        for (final String sendUser in sendUserList) {
          String token = "";
          print('↓');
          print(sendUser);
          print("");
          sendEmailBySendGrid(
              sendUser,
              schedule['sf_pdf_file'],
              schedule['start_time'].toString(),
              schedule['event_title'],
              schedule['event_detail'],
              sender2,
              groupName2,
              startTime);
          print("メール送信完了");
          for (final DocumentReference user in shareUsers) {
            final userData = await user.get();
            if (sendUser == userData["email"]) {
              token = userData["token"].toString();
            }
          }
          final senderRef = schedule['create_by'];
          for (final Document user in allUsers) {
            if (user["uid"] == senderRef) {
              final sender = user["display_name"];
              print(sender);
              sendPushNotification(
                  '書類が送付されました', '$sender様より書類が送付されました。ご確認ください', token);
              print('sent push');
              break;
            }
          }
        }
      }
    }
  }
  print("function done");
}
