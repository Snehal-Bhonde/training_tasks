import 'package:flutter/material.dart';
import 'package:training_tasks/blocs/CounterBLoC.dart';
import 'package:training_tasks/blocs/CounterEvent.dart';

class StreamBuild extends StatefulWidget {

  @override
  _StreamBuildState createState() => _StreamBuildState();
}
class _StreamBuildState extends State<StreamBuild> {
  UserBLoC userBLoC = new UserBLoC();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        actions: [
          Chip(
            label: StreamBuilder<int>(
                stream: userBLoC.userCounter,
                builder: (context, snapshot) {
                  return Text(
                    (snapshot.data ?? 0).toString(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  );
                }),
            backgroundColor: Colors.red,
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
          )
        ],
      ),
      body: StreamBuilder(
          stream: userBLoC.usersList,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError)
                  return Text('There was an error : ${snapshot.error}');
                List<User>? users = snapshot.data;

                return ListView.separated(
                  itemCount: users?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    User _user = users![index];
                    return ListTile(
                      title: Text(_user.name),
                      subtitle: Text(_user.email),
                      leading: CircleAvatar(
                        child: Text(_user.symbol),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                );
            }
          }),
    );
  }
}