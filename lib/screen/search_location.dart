import 'dart:async';
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
  StoreResponse _storeResponse = null;

  @override
  void initState() {
    super.initState();
    getLocationList();
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
            _storeResponse == null
                ? Expanded(
                    child: Center(
                    child: CircularProgressIndicator(),
                  ))
                : Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: _storeResponse.data.length,
                        itemBuilder: (context, i) {
                          StoreData storeData =
                              _storeResponse.data.elementAt(i);
                          if (storeData.businessName
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase())) {
                            return StoreList(storeName: storeData);
                          } else {
                            return Container();
                          }
                        }))
          ],
        ),
      ])),
    );
  }

  Future getLocationList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("accessKey");
    String url = "https://stable-api.pricelocq.com/mobile/stations?all";
    Map<String, String> header = {"Authorization": token};
    Response response = await get(Uri.parse(url), headers: header);
    Map responseMap = jsonDecode(response.body);
    setState(() {
      _storeResponse = StoreResponse.fromJson(responseMap);
    });
  }
}
