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
        'Bearer [Cloud_Messaging_API_KEY]',
  };
  var data =
      '{ "to": "$toFcmToken", "data": {}, "notification": { "title": "$showTitle", "body": "$showBodyText" }}';
  var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  var res = await http.post(url, headers: headers, body: data);

  result = res.statusCode.toString();
  return (result);
}
