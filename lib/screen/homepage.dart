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
import 'package:seaoil/widget/nearby_list.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  CameraPosition currentPosition;
  GoogleMapController _controller;

  Set<Marker> _markers = {};
  StoreResponse _storeResponse = null;

  @override
  void initState() {
    super.initState();
    Common().checkPermission();
    getCurrentLocation();
    getNearbyStore();
    currentPosition = CameraPosition(
      target: LatLng(Common.currentLat, Common.currentLong),
      zoom: 14.4746,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  _controller = (controller);
                  _markers.add(Marker(
                    markerId: MarkerId("Your Location"),
                    position: LatLng(Common.currentLat, Common.currentLong),
                  ));
                  _controller.animateCamera(
                    CameraUpdate.newLatLngZoom(
                        LatLng(Common.currentLat, Common.currentLong), 14.4746),
                  );
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
                Common.distance.length == 0
                    ? Expanded(
                        child: Center(
                            child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text("Getting nearby station..")
                        ],
                      )))
                    : Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: Common.distance.length > 5
                                ? 5
                                : Common.distance.length,
                            itemBuilder: (context, i) {
                              LinkedHashMap sortedDistance =
                                  Common().sortDistance(Common.distance);
                              StoreData storeData = _storeResponse.data
                                  .elementAt(sortedDistance.keys.elementAt(i));
                              return NearbyList(
                                  storeName: storeData,
                                  distance: sortedDistance.values
                                      .elementAt(i)
                                      .toString());
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

  Future<void> getCurrentLocation() async {
    LocationData _locationData = await Common().getCurrentLocation();
    if (_locationData != null) {
      setState(() {
        try {
          _markers.add(Marker(
            markerId: MarkerId("Your Location"),
            position: LatLng(Common.currentLat, Common.currentLong),
          ));
          _controller.animateCamera(
            CameraUpdate.newLatLngZoom(
                LatLng(Common.currentLat, Common.currentLong), 14.4746),
          );
        } catch (Exception) {}
      });
    } else {
      errorMessage("Failed to get your location");
    }
  }

  Future<Map<int, int>> getNearbyStore() async {
    try {
      _storeResponse = await Common().getLocationList();
      for (int i = 0; i < _storeResponse.data.length; i++) {
        print(
            Common.currentLat.toString() + " " + Common.currentLong.toString());
        String d = Common().getDistance(
            double.parse(_storeResponse.data.elementAt(i).lat),
            double.parse(_storeResponse.data.elementAt(i).lng));
        Common.distance[i] = int.parse(d);
      }
      setState(() {});
    } catch (Exception) {}
  }
}
