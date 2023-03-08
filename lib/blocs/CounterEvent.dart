import 'dart:convert' as convert;
import 'package:dio/dio.dart';

class UserService {
  static String _url = 'https://jsonplaceholder.typicode.com/users';
  static Future browse() async {
    List collection;
    List<User>? _contacts;
    Dio dio=new Dio();
    var response = await dio.get(_url);
    if (response.statusCode == 200) {
      collection = convert.jsonDecode(response.data);
      _contacts = collection.map((json) => User.fromJson(json)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return _contacts;
  }
}



class User {
  final String name;
  final String email;
  final String symbol;
  final String phone;

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        symbol = json['username'].toString().substring(0, 1),
        phone = json['phone'];
}
