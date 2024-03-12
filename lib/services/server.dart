import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://144.91.106.164:8000";


Future startSession(year, dept, sec) async {
  var base = "$baseUrl/start-session";

  var url = "$base/$year/$dept/$sec";
  print(url);

  await http.get(Uri.parse(url));
}


Future postNearbyDevices(List<Map> nearby, Map class_) async {
  var base = "$baseUrl/pp-verify";
  var url =
      '$base/${class_["year"]}/${class_["dept"]}/${class_["sec"]}';

  print("Url");
  print(url);
  print("Nearby");
  print(nearby);

  await http.post(Uri.parse(url),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(nearby));
}