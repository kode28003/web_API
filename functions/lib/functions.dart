import 'package:functions/push.dart';
import 'package:functions_framework/functions_framework.dart';
import 'package:shelf/shelf.dart';
import 'package:firedart/firedart.dart';

@CloudFunction()
Response function(Request request) {
  main();
  print("function done");
  sendPushNotification("", "", "");
  return Response.ok("succeeded");
}

void main() async {
  Firestore.initialize("carnri");
  print("Firebase initialized");
  List<Document> userList = await Firestore.instance.collection("users").get();
  for (final Document user in userList) {
    DateTime deadline = user["carInspectionDeadline"];
    String token = user["token"];
    print("");
    print("deadline");
    print(deadline);
    print("object");
    print(DateTime.now());
    final a = DateTime.now().add(Duration(hours: -33));
    print(a);
    print("");
    //標準で9時間の差がある
    if (DateTime.now().add(Duration(hours: -33)).day == deadline.day &&
        DateTime.now().add(Duration(hours: -33)).month == deadline.month &&
        DateTime.now().add(Duration(hours: -33)).year == deadline.year) {
      sendPushNotification("お知らせ", "車検証の失効まであと1日です", token);
      print("1日前を送った");
    }
    if (DateTime.now().add(Duration(hours: -177)).day == deadline.day &&
        DateTime.now().add(Duration(hours: -177)).month == deadline.month &&
        DateTime.now().add(Duration(hours: -177)).year == deadline.year) {
      sendPushNotification("お知らせ", "車検証の失効まであと7日です", token);
      print("7日前を送った");
    }
    if (DateTime.now().add(Duration(hours: -513)).day == deadline.day &&
        DateTime.now().add(Duration(hours: -513)).month == deadline.month &&
        DateTime.now().add(Duration(hours: -513)).year == deadline.year) {
      sendPushNotification("お知らせ", "車検証の失効まであと21日です", token);
      print("21日前を送った");
    }
  }
}
