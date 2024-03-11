import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://144.91.106.164:8000";

Future postNearbyDevices(List<Map> nearby, Map class_) async {
  var base = "$baseUrl/pp-verify";
  var url =
      '$base/${class_["year"]}/${class_["department"]}/${class_["section"]}';

  await http.post(Uri.parse(url),
      headers: {"Content-type": "application/json"}, body: jsonEncode(nearby));
}
