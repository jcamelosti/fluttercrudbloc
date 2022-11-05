import 'dart:convert';

import 'package:crudblocsqlite/utils/db/entity.dart';

List<Client> clientFromJson(String str) =>
    List<Client>.from(json.decode(str).map((x) => Client.fromJson(x)));

String clientToJson(List<Client> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Client extends Entity {
  Client({
    this.id,
    required this.name,
    required this.phone,
    required this.price
  });

  int? id;
  late String name;
  late String phone;
  late double price;

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json["id"],
        name: json["title"],
        phone: json["phone"],
        price: json["price"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "price": price,
      };

  Client copy({
    int? id,
    String? name,
    String? phone,
    double? price,
  }) =>
      Client(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        price: price ?? this.price
      );

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['price'] = price;

    return data;
  }

  Client.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    phone = map['phone'];
    price = map["price"];
  }
}
