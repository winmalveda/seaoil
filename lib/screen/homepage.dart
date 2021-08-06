import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:seaoil/model/store_model.dart';
import 'package:seaoil/model/store_response.dart';
import 'package:seaoil/widget/common.dart';
import 'package:seaoil/widget/errorMessage.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:seaoil/widget/nearby_list.dart';
import 'package:seaoil/widget/store_list.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  GoogleMapController _controller;

  double currentLocationlat = 14.7264;
  double currentLocationlong = 120.9893;
  Set<Marker> _markers = {};
  Map<int, int> distance = {};
  StoreResponse _storeResponse = null;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    checkPermission();
    getTopNearbyStore();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition currentPosition = CameraPosition(
      target: LatLng(currentLocationlat, currentLocationlong),
      zoom: 14.4746,
    );
    return Scaffold(
      body: Container(
          child: Stack(children: [
        Column(
          children: <Widget>[
            Container(
              color: Colors.deepPurpleAccent,
              height: 150,
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Row(
                    children: [
                      SizedBox(width: 40),
                      Expanded(
                          child: Text(
                        "Search Station",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                        textAlign: TextAlign.center,
                      )),
                      SizedBox(
                        width: 40,
                        child: IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "/search");
                            }),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Which PriceLOCQ station will you likely visit?",
                        style: TextStyle(color: Colors.white),
                      )),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: GoogleMap(
                markers: _markers,
                mapType: MapType.normal,
                initialCameraPosition: currentPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                  setState(() {
                    if (currentLocationlat != null) {
                      _markers.add(Marker(
                        markerId: MarkerId("Your Location"),
                        position:
                            LatLng(currentLocationlat, currentLocationlong),
                      ));
                      _controller.animateCamera(
                        CameraUpdate.newLatLngZoom(
                            LatLng(currentLocationlat, currentLocationlong),
                            14.4746),
                      );
                    }
                  });
                },
              ),
            ),
            SizedBox(height: 100)
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 230,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Nearby Stations",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "Done",
                          style: TextStyle(color: Colors.grey),
                        ))
                  ],
                ),
                distance.length == 0
                    ? Expanded(
                        child: Center(child: CircularProgressIndicator()))
                    : Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount:
                                distance.length > 5 ? 5 : distance.length,
                            itemBuilder: (context, i) {
                              var sortedKeys = distance.keys
                                  .toList(growable: false)
                                    ..sort((k1, k2) =>
                                        distance[k1].compareTo(distance[k2]));
                              LinkedHashMap sortedMap =
                                  new LinkedHashMap.fromIterable(sortedKeys,
                                      key: (k) => k, value: (k) => distance[k]);
                              StoreData storeData = _storeResponse.data
                                  .elementAt(sortedMap.keys.elementAt(i));
                              print(sortedMap);
                              return NearbyList(
                                  storeName: storeData,
                                  distance:
                                      sortedMap.values.elementAt(i).toString());
                            }),
                      ),
              ],
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 10,
              color: Colors.deepPurpleAccent,
            )),
      ])),
    );
  }

  checkPermission() async {
    Location location = new Location();
    bool _serviceEnabled;

    if (await perm.Permission.location.request().isGranted) {
      if (await perm.Permission.locationWhenInUse.serviceStatus.isEnabled) {
      } else {
        _serviceEnabled = await location.serviceEnabled();
        if (!_serviceEnabled) {
          await location.requestService().then((value) => value);
        } else {
          errorMessage("Please turn on location to use this feature!");
        }
      }
    } else {
      errorMessage("Please enable location permission!");
    }
  }

  Future<void> getCurrentLocation() async {
    LocationData _locationData = await Common().getCurrentLocation();
    if (_locationData != null) {
      setState(() {
        currentLocationlat = _locationData.latitude;
        currentLocationlong = _locationData.longitude;
      });
    }
  }

  Future<Map<int, int>> getTopNearbyStore() async {
    try {
      _storeResponse = await Common().getLocationList();
      for (int i = 0; i < _storeResponse.data.length; i++) {
        String d = await Common().getDistance(
            double.parse(_storeResponse.data.elementAt(i).lat),
            double.parse(_storeResponse.data.elementAt(i).lng));
        distance[i] = int.parse(d);
        setState(() {});
      }
    } catch (Exception) {}
  }
}
