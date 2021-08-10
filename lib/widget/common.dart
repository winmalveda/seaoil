import 'dart:collection';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:seaoil/model/store_response.dart';
import 'package:seaoil/widget/errorMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

class Common {
  static Map<int, int> distance = {};
  static double currentLat = 0.0;
  static double currentLong = 0.0;

  checkPermission() async {
    Location location = new Location();
    bool _serviceEnabled;

    if (await perm.Permission.location.request().isGranted) {
      if (!await perm.Permission.locationWhenInUse.serviceStatus.isEnabled) {
        _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          await location.requestService().then((value) => value);
        } else {
          errorMessage("Please turn on location to use this feature!");
        }
      }
    }
  }

  Future<StoreResponse> getLocationList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("accessKey");
    String url = "https://stable-api.pricelocq.com/mobile/stations?all";
    Map<String, String> header = {"Authorization": token};
    Response response = await get(Uri.parse(url), headers: header);
    Map responseMap = jsonDecode(response.body);
    return StoreResponse.fromJson(responseMap);
  }

  Future<LocationData> getCurrentLocation() async {
    Location location = new Location();
    LocationData _locationData = await location.getLocation();
    currentLat = _locationData.latitude;
    currentLong = _locationData.longitude;
    return _locationData;
  }

  String getDistance(double lat, double lang) {
    double distanceInMeters =
        Geolocator.distanceBetween(currentLat, currentLong, lat, lang);
    return (distanceInMeters * 0.001).toStringAsFixed(0);
  }

  LinkedHashMap sortDistance(Map<int, int> listDistance) {
    var sortedKeys = listDistance.keys.toList(growable: false)
      ..sort((k1, k2) => listDistance[k1].compareTo(listDistance[k2]));
    LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => listDistance[k]);
    return sortedMap;
  }
}
