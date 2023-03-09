import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:training_tasks/Sqlite/Records.dart';
import 'package:training_tasks/Sqlite/RegModel.dart';
import 'package:training_tasks/Sqlite/data_base.dart';
import 'package:sqflite/sqflite.dart';


class RegisterForms extends StatefulWidget{
  RegisterForm? registerForm;
  RegisterForms({Key? key, this.registerForm}) : super(key: key);
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
    addRegData();
    super.initState();
  }
  void addRegData() {
    if (widget.registerForm != null) {
      if (mounted) {
        setState(() {
          firstNameController.text = widget.registerForm!.firstName!;
          lastNameController.text = widget.registerForm!.lastName!;
          mobNoController.text = widget.registerForm!.mobNo!.toString();
          emailController.text = widget.registerForm!.email!;
        });
      }
    }
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
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
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
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))

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
                    child: widget.registerForm==null?Text("Submit"):Text("Edit") ),
                Visibility(
                  visible: widget.registerForm==null?true:false,
                    child: ElevatedButton(
                    onPressed: () {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
    return RecordsPage();}));
                    },
                    child: Text("Show all Records")))
              ],
            ),
          ),
        )));
  }

  void addRecord() async {

      var now = new DateTime.now();
      var formatter = new DateFormat('MM/dd/yyyy hh:mm a');
      String formattedDate = formatter.format(now);
      print("date is $formattedDate");
    if(widget.registerForm!=null) {
      formattedDate=widget.registerForm!.dateTime.toString();
      print("date is $formattedDate");
    }

    RegisterForm regForm = RegisterForm(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        mobNo: int.parse(mobNoController.text),
        email: emailController.text,
        dateTime: formattedDate,
    );
    if(widget.registerForm==null){
      await DatabaseRepository.instance.insert(registerForm: regForm).then((value){
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Record Saved')));
        print("saved");
      }).catchError((e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
    else{
      print("update started");
      RegisterForm regForm = RegisterForm(
        userId: widget.registerForm!.userId,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        mobNo: int.parse(mobNoController.text),
        email: emailController.text,
        dateTime: formattedDate,
      );
      await DatabaseRepository.instance.update(regForm).then((value) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Updated')));
       // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => RecordsPage()),(route) => true,);
        Navigator.of(context).popAndPushNamed("/second");
      }).catchError((e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });

    }
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