import 'dart:convert';
// import 'dart:html';
import 'package:http/http.dart' as http;

const baseUrl =
    "https://adams-server.vercel.app";
// String? baseUrl;

Future startSession(ip, year, dept, sec) async {
  var base = "$baseUrl/start-session";

  var url = "$base/$year/$dept/$sec";
  print(url);

  await http.get(Uri.parse(url));
}

Future postNearbyDevices(List<Map> nearby, Map class_) async {
  var base = "$baseUrl/pp-verify";
  var url = '$base/${class_["year"]}/${class_["dept"]}/${class_["sec"]}';

  print("Url");
  print(url);
  print("Nearby");
  print(nearby);

  await http.post(Uri.parse(url),
      headers: {"Content-type": "application/json"}, body: jsonEncode(nearby));
}

Future<dynamic> getBeaconScan(String ip) async {
  print("Contacting beacon at: $ip");
  var url = "http://$ip/ble_scan";
  try {
    var response = await http.get(Uri.parse(url)).timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );
    print("PRINTING BEACON SCAN");
    print(response.body);
    return jsonDecode(response.body);
  } catch (e) {
    print('Error. Couldn\'t reach beacon.');
  }
}

Future postNearbyBeaconScanDetails(Map class_) async {
  var url =
      "$baseUrl/get-beacon-ips/${class_["year"]}/${class_["dept"]}/${class_["sec"]}";
  var response = await http.get(Uri.parse(url));
  List<dynamic> nearbyBeaconIPs = jsonDecode(response.body);
  // var outputScan = await getBeaconScan(nearbyBeaconIPs[0]);
  // return outputScan;
  var nearbyBeaconScanDetails =
      await Future.wait(nearbyBeaconIPs.map((ip) => getBeaconScan(ip)));
  url =
      "$baseUrl/bb-verify/${class_["year"]}/${class_["dept"]}/${class_["sec"]}";
  await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(nearbyBeaconScanDetails));
}
