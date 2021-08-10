import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:seaoil/model/store_model.dart';
import 'package:seaoil/model/store_response.dart';
import 'package:seaoil/widget/common.dart';
import 'package:seaoil/widget/store_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchLocation extends StatefulWidget {
  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
              height: 210,
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
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Which PriceLOCQ station will you likely visit?",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: TextFormField(
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        controller: _searchController,
                        cursorColor: Colors.black,
                        onFieldSubmitted: (value) {
                          setState(() {});
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.deepPurpleAccent,
                          ),
                          counterText: '',
                          hintText: "Search Location",
                          hintStyle: TextStyle(
                              fontSize: 14, color: Colors.black.withAlpha(80)),
                          contentPadding: EdgeInsets.fromLTRB(20, 5, 50, 5),
                          disabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      )),
                  SizedBox(height: 10),
                ],
              ),
            ),
            FutureBuilder<StoreResponse>(
              future: Common().getLocationList(),
              builder: (BuildContext context,
                  AsyncSnapshot<StoreResponse> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                      child: Center(
                    child: CircularProgressIndicator(),
                  ));
                } else {
                  return Expanded(
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: snapshot.data.data.length,
                          itemBuilder: (context, i) {
                            LinkedHashMap sortedDistance =
                                Common().sortDistance(Common.distance);
                            StoreData storeData = snapshot.data.data
                                .elementAt(sortedDistance.keys.elementAt(i));
                            if (storeData.businessName.toLowerCase().contains(
                                _searchController.text.toLowerCase())) {
                              return StoreList(storeName: storeData);
                            } else {
                              return Container();
                            }
                          }));
                }
              },
            ),
          ],
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
