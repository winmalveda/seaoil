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

class StoreDetails extends StatefulWidget {
  final StoreData storeData;
  final String distance;
  const StoreDetails(
      {Key key, @required this.storeData, @required this.distance})
      : super(key: key);
  @override
  _StoreDetailsState createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  GoogleMapController _controller;

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition currentPosition = CameraPosition(
      target: LatLng(double.parse(widget.storeData.lat),
          double.parse(widget.storeData.lng)),
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
                              Navigator.pushReplacementNamed(
                                  context, "/search");
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
                    _markers.add(Marker(
                      markerId: MarkerId("Your Location"),
                      position: LatLng(double.parse(widget.storeData.lat),
                          double.parse(widget.storeData.lng)),
                    ));
                    _controller.animateCamera(
                      CameraUpdate.newLatLngZoom(
                          LatLng(double.parse(widget.storeData.lat),
                              double.parse(widget.storeData.lng)),
                          14.4746),
                    );
                  });
                },
              ),
            ),
            SizedBox(height: 150)
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      "Back to List",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(color: Colors.blue),
                        ))
                  ],
                ),
                SizedBox(height: 10),
                Text(widget.storeData.businessName,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                Text(widget.storeData.address,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    )),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.car_rental),
                        Text(widget.distance + " km away")
                      ],
                    )),
                    Expanded(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.car_rental), Text("Open 24 hours")],
                    )),
                  ],
                )
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
}
