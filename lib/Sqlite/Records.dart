

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_tasks/Sqlite/FormPage.dart';
import 'package:training_tasks/Sqlite/RegModel.dart';
import 'package:training_tasks/Sqlite/data_base.dart';

import '../Emp_Model.dart';

class RecordsPage extends StatefulWidget {

  @override
  _RecordsPageState createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
 // final EmpListBloc _newsBloc = EmpListBloc();
  List<RegisterForm> myRegForms = [];


  @override
  void initState() {
    //_newsBloc.add(GetEmpList());
    getRecords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Records')),
     // body: _buildListEmpList(),
        body: myRegForms.isEmpty
            ? const Center(child: const Text('You don\'t have any records yet'))
            :
/*        SizedBox(
             height: double.infinity,
              child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
              height: 20,
          ),
          padding: EdgeInsets.all(16),
          itemBuilder: (context, index) {
              return _buildCard(context);
          },
          itemCount: myRegForms.length,
        ),
            ),*/
        ListView.builder(
          itemCount: myRegForms.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("ID: ${myRegForms[index].userId}"),
                      Text(
                          "First Name: ${myRegForms[index].firstName}"),
                      Text("Last Name: ${myRegForms[index].lastName}",textAlign: TextAlign.start,),
                      Text("Mobile: ${myRegForms[index].mobNo}",textAlign: TextAlign.start,),
                      Text("Email: ${myRegForms[index].email}",textAlign: TextAlign.start,),
                      Text("Date: ${myRegForms[index].dateTime}",textAlign: TextAlign.start,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return RegisterForms(
                                    registerForm: myRegForms[index],
                                  );
                                }));
                              },
                              child: Text("Edit")),
                          SizedBox(width: 20,),
                          ElevatedButton(
                              onPressed: () {
                                print("delete clicked");
                                showAlertDialog(context,myRegForms[index]);
                                print("end");
                              },
                              child: Text("Delete")),

                        ],
                      ),

                    ],

                  ),
                ),
              ),
            );
          },
        ),
    );
  }


  Widget _buildCard(BuildContext context) {
    return Wrap(
      children: [
       ListView.builder(
        itemCount: myRegForms.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("ID: ${myRegForms[index].userId}"),
                    Text(
                        "First Name: ${myRegForms[index].firstName}"),
                    Text("Last Name: ${myRegForms[index].lastName}",textAlign: TextAlign.start,),
                    Text("Mobile: ${myRegForms[index].mobNo}",textAlign: TextAlign.start,),
                    Text("Email: ${myRegForms[index].email}",textAlign: TextAlign.start,),
                    Text("Email: ${myRegForms[index].dateTime}",textAlign: TextAlign.start,),
                    // Text("Total Recovered: ${model.data![index].profileImage}"),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {

                              },
                            child: Text("Edit")),
                        SizedBox(width: 20,),
                        ElevatedButton(
                            onPressed: () {
                              print("delete clicked");
                              showAlertDialog(context,myRegForms[index]);
                              print("end");
                            },
                            child: Text("Delete")),

                      ],
                    ),

                  ],

                ),
              ),
            ),
          );
        },
      ),
    ]);
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());


  showAlertDialog(BuildContext context, RegisterForm myRegForm) {
    // set up the buttons
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed:  () {
        delete(registerForm: myRegForm, context: context);
      },
    );
    Widget noButton = TextButton(
      child: Text("No"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      //title: Text("AlertDialog"),
      content: Text("Do you want to delete this record?"),
      actions: [
        yesButton,
        noButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void getRecords() async {
    await DatabaseRepository.instance.getAllTodos().then((value) {
      setState(() {
        myRegForms = value;
      });
    }).catchError((e) => debugPrint(e.toString()));
  }

  void delete({required RegisterForm registerForm, required BuildContext context}) async {
    DatabaseRepository.instance.delete(registerForm.userId!).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deleted')));
      Navigator.pop(context);
      setState(() {
        getRecords();
      });
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }
}