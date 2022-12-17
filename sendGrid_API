import 'package:http/http.dart' as http;

Future<String> sendEmailBySendGrid(
  String sendTo,
  String pdfUrl,
  String date,
  String showTitle,
  String showDetail,
) async {
  try {
    String result = "";
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer [sendGrid_web_API_KEY]'
    };
    var data =
        '{ "personalizations": [ { "to": [ { "email": "$sendTo" }  ], "subject": "PDFファイルを送信します" } ], "content": [ { "type": "text/plain", "value": " $showTitle が行われます。 $pdfUrl"  } ], "from": { "email": "[送信元アドレス]", "name": "" } }';
    var url = Uri.parse('https://api.sendgrid.com/v3/mail/send');
    var res = await http.post(url, headers: headers, body: data);

    result = res.statusCode.toString();
    return (result);
  } catch (e) {
    print(e.toString());
    return "";
  }
}
