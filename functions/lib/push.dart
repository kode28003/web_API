import 'package:http/http.dart' as http;

Future<String> sendPushNotification(
  String showTitle,
  String showBodyText,
  String toFcmToken,
) async {
  String result = "";
  var headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer AAAApJD7-so:APA91bGvTpH3H7vGBnZEgzX6VQXSCFzcNukcYieYwx0r0LeiCGrPA7nH0XMs0I-62gZXE9jqN_jSS7qu3hFFPn4BjwEpchIOAUVAuGOtt0dBvSD9TJ8i8rVDQ3IlT0871vLLdT9tq2KR',
  };
  var data =
      '{ "to": "$toFcmToken", "data": {}, "notification": { "title": "$showTitle", "body": "$showBodyText" }}';
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  var res = await http.post(url, headers: headers, body: data);

  result = res.statusCode.toString();
  return (result);
}
