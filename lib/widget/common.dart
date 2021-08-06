import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:seaoil/model/store_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Common {
  Future<StoreResponse> getLocationList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("accessKey");
    String url = "https://stable-api.pricelocq.com/mobile/stations?all";
    Map<String, String> header = {"Authorization": token};
    Response response = await get(Uri.parse(url), headers: header);
    Map responseMap = jsonDecode(response.body);
    print(response.body);
    return StoreResponse.fromJson(responseMap);
  }

  Future<LocationData> getCurrentLocation() async {
    Location location = new Location();
    LocationData _locationData = await location.getLocation();
    return _locationData;
  }

  Future<String> getDistance(double lat, double lang) async {
    LocationData _locationData = await Common().getCurrentLocation();
    double distanceInMeters = await Geolocator.distanceBetween(
        _locationData.latitude, _locationData.longitude, lat, lang);
    return (distanceInMeters * 0.001).toStringAsFixed(0);
  }
}
