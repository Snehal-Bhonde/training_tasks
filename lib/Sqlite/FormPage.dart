import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:training_tasks/Sqlite/RegModel.dart';
import 'package:training_tasks/Sqlite/data_base.dart';
import 'package:sqflite/sqflite.dart';


class RegisterForms extends StatefulWidget{
  @override
  State<RegisterForms> createState()=>RegisterFormState();
  }



class RegisterFormState extends State<RegisterForms> with InputValidationMixin {
  final formGlobalKey = GlobalKey < FormState > ();
  final firstNameController = TextEditingController();
  final mobNoController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  List<RegisterForm> myRegForms = [];

  @override
  void initState() {
    initDb();
    super.initState();
  }
  void initDb() async {
    await DatabaseRepository.instance.database;
  }
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobNoController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Registration'),
        ),
        body:
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formGlobalKey,
            child: ListView(

              children: [
                const SizedBox(height: 50),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'First Name'),
                  keyboardType: TextInputType.name,
                  controller: firstNameController,
                  //maxLength: 30,
                    inputFormatters:[
                      LengthLimitingTextInputFormatter(30),

                    ],
                  //validator: validateMobile,
                  validator: (val) {
                    // _mobile = val;
                    if (val!.length == 0) {
                      return 'Enter First Name';
                    } else
                      return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  keyboardType: TextInputType.name,
                  controller: lastNameController,
                  //validator: validateMobile,
                    inputFormatters:[
                      LengthLimitingTextInputFormatter(30),
                    ],
                  validator: (val) {
                    // _mobile = val;
                    if (val!.length == 0) {
                      return 'Enter Last Name';
                    } else
                      return null;
                  },
                ),

                TextFormField(
                  decoration: const InputDecoration(labelText: 'Mobile'),
                  keyboardType: TextInputType.phone,
                  controller: mobNoController,
                  //validator: validateMobile,
                  validator: (val) {
                   // _mobile = val;
                    if (val!.length != 10) {
                      return 'Mobile Number must be of 10 digit';
                    } else
                      return null;
                  },
                    inputFormatters:[
                      LengthLimitingTextInputFormatter(10),
                    ]
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Email"
                  ),
                    inputFormatters:[
                      LengthLimitingTextInputFormatter(40),
                    ],
                  controller: emailController,
                  validator: (email) {
                    if (isEmailValid(email!)) return null;
                    else
                      return 'Enter a valid email address';
                  },
                ),
                const SizedBox(height: 24),

                const SizedBox(height: 50),
                ElevatedButton(
                    onPressed: () {
                      if (formGlobalKey.currentState!.validate()) {
                        addRecord();
                        formGlobalKey.currentState!.save();

                        formGlobalKey.currentState!.reset();
                      }
                    },
                    child: Text("Submit")),
                Visibility(
                    child: ElevatedButton(
                    onPressed: () {

                    },
                    child: Text("Show all Records")))
              ],
            ),
          ),
        )));
  }

  void addRecord() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    print("date is $formattedDate");
    RegisterForm regForm = RegisterForm(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        mobNo: int.parse(mobNoController.text),
        email: emailController.text,
        dateTime: formattedDate,
    );
    await DatabaseRepository.instance.insert(registerForm: regForm);
  }

}

mixin InputValidationMixin {
  bool isPasswordValid(String password) => password.length == 6;

  bool isEmailValid(String email) {
    // Pattern patterns =
    //      '^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    // RegExp regex = RegExp(patterns);
    //return regex.hasMatch(email);

    final bool emailValid =
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

}