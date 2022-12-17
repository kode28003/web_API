import 'package:firedart/firedart.dart';
import 'package:functions_framework/functions_framework.dart';
import 'package:shelf/shelf.dart';

@CloudFunction()
Response function(Request request) {
  main();
  print("function done");
  return Response.ok("succeeded");
}

void main() async {
 Firestore.initialize( [FirebaseのプロジェクトId] );
  print("Firebase initialized");
  List<Document> allScheduleList =await Firestore.instance.collection("schedules").get();
  List<Document> scheduleList = [];
  
  print("実行環境日時: ${DateTime.now().toString()}");
  print("時差修正後日時: ${DateTime.now().add(Duration(hours: 9))}");
  print("日本時刻");
  print("Schedule documents got : スケジュール数: ${allScheduleList.length}");

  for (final Document schedule in allScheduleList) {
    DateTime startTime = schedule["start_time"];
    if (DateTime.now().add(Duration(hours: -9)).day == startTime.day &&
        DateTime.now().add(Duration(hours: -9)).month == startTime.month) {
      scheduleList.add(schedule);
    }
  }
  print("function done");
}

//参考 : https://zenn.dev/heavenosk/scraps/a557a119bb1ab5 
//ローカルでの時間とクラウドでの時間がずれるため、上記のようにずらす必要がある。
//デプロイ : cloud run deploy dartcloudfn --allow-unauthenticated --source=.
