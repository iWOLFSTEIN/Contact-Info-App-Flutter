import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    UserModel({
        this.record1,
    });

    Record1? record1;

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        record1: Record1.fromJson(json["Record 1"]),
    );

    Map<String, dynamic> toJson() => {
        "Record 1": record1!.toJson(),
    };
}

class Record1 {
    Record1({
        this.number,
        this.date,
        this.name,
        this.address,
        this.city,
        this.cnic,
        this.otherphone,
    });

    String? number;
    String? date;
    String? name;
    String? address;
    String? city;
    String? cnic;
    String? otherphone;

    factory Record1.fromJson(Map<String, dynamic> json) => Record1(
        number: json["number"],
        date: json["date"],
        name: json["name"],
        address: json["address"],
        city: json["city"],
        cnic: json["cnic"],
        otherphone: json["otherphone"],
    );

    Map<String, dynamic> toJson() => {
        "number": number,
        "date": date,
        "name": name,
        "address": address,
        "city": city,
        "cnic": cnic,
        "otherphone": otherphone,
    };
}
