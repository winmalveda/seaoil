import 'package:seaoil/model/store_model.dart';

class StoreResponse {
  List<StoreData> data;

  StoreResponse({this.data});

  StoreResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<StoreData>();
      json['data'].forEach((v) {
        data.add(new StoreData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
