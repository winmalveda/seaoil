import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:seaoil/model/store_model.dart';
import 'package:seaoil/screen/homepage.dart';
import 'package:seaoil/screen/store_details.dart';
import 'package:seaoil/widget/common.dart';

class StoreList extends StatelessWidget {
  final StoreData storeName;

  const StoreList({Key key, @required this.storeName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      return Container(
          height: 90,
          child: TextButton(
            child: Row(children: [
              SizedBox(width: 10),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(
                      storeName.businessName,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    SizedBox(height: 5),
                    Text(
                        Common().getDistance(double.parse(storeName.lat),
                                double.parse(storeName.lng)) +
                            " km away from you",
                        style: TextStyle(fontSize: 12, color: Colors.black))
                  ])),
              SizedBox(width: 10),
              Icon(
                Icons.radio_button_off_outlined,
                color: Colors.black.withAlpha(50),
              ),
              SizedBox(width: 10)
            ]),
            onPressed: () async {
              String distance = Common().getDistance(
                  double.parse(storeName.lat), double.parse(storeName.lng));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StoreDetails(
                            storeData: storeName,
                            distance: distance,
                          )));
            },
          ));
    } catch (Exception) {
      return Container();
    }
  }
}
