import 'dart:convert';
import 'package:flutter/services.dart';

class UserInfo {
  String userId;
  String sex;
  String birthday;
  String name;
  String lastname;
  String patronymic;
  String address;
  String phone;
  String city;
  String photo;
 String get getPhoto => photo;

 set setPhoto(String photo) => this.photo = photo;

  UserInfo(
      {this.userId,
      this.sex,
      this.birthday,
      this.name,
      this.lastname,
      this.patronymic,
      this.address,
      this.phone,
      this.city,
      this.photo});

  String get getSex => sex;

  set setSex(String sex) => this.sex = sex;

  String get getUserId => userId;

  set setUserId(String userId) => this.userId = userId;

  String get getName => name;

  set setName(String name) => this.name = name;

  String get getLastname => lastname;

  set setLastname(String lastname) => this.lastname = lastname;

  String get getPatronymic => patronymic;

  set setPatronymic(String patronymic) => this.patronymic = patronymic;

  String get getAddress => address;

  set setAddress(String address) => this.address = address;

  String get getPhone => phone;

  set setPhone(String phone) => this.phone = phone;

  String get getCity => city;

  set setCity(String city) => this.city = city;

  String get getBirthday => birthday;
  
  set setBirthday(String birthday) => this.birthday = birthday;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'sex': sex,
      'birthday': birthday,
      'name': name,
      'lastname': lastname,
      'patronymic': patronymic,
      'address': address,
      'phone': phone,
      'city': city,
      'photo': photo,
    };
  }

  static UserInfo fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    var birthday = jsonEncode(map['birthday']).substring(1,11);
    return UserInfo(
      userId: map['userId'],
      sex: map['sex'],
      birthday: birthday,
      name: map['name'],
      lastname: map['lastname'],
      patronymic: map['patronymic'],
      address: map['address'],
      phone: map['phone'],
      city: map['city'],
      photo: map['photo'],
    );
  }

  String toJson() => json.encode(toMap());

  static UserInfo fromJson(String source) => fromMap(json.decode(source));
}
