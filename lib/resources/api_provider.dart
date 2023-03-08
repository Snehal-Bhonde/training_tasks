import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../Emp_Model.dart';

class ApiProvider{
  final Dio _dio=Dio();

  final String url="https://dummy.restapiexample.com/api/v1/employees";

  Future<EmpList> fetchEmpList() async{
    // bool result = await InternetConnectionChecker().hasConnection;
    // late Response response;
    // if(result == true) {
    //   response= await _dio.get(url);
    //
    // } else {
    //   AlertDialog(
    //     title: new Text('No Internet Connection'),
    //     content: new Text('Please check your Internet Connection'),
    //     actions: [
    //       ElevatedButton(onPressed: (){fetchEmpList();}, child: new Text('Retry'))
    //     ],
    //   );
    // }
    //return EmpList.fromJson(response.data);

     late Response response;
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        response= await _dio.get(url);
        //return EmpList.fromJson(response.data);
      }
    } on SocketException catch (_) {
      print('not connected');
      AlertDialog(
        title: new Text('No Internet Connection'),
        content: new Text('Please check your Internet Connection'),
        actions: [
          ElevatedButton(onPressed: (){fetchEmpList();}, child: new Text('Retry'))
        ],
      );
    } catch(error,stacktrace){
      print("Exception occured :$error stacktrace :$stacktrace");
      return EmpList.withError("Data not found");
    }
    return EmpList.fromJson(response.data);
  }

}