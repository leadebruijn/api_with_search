import 'package:api_with_search/search_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'post_model.dart';
import 'dart:convert';
import 'user.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<User> _users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Users'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => SearchPage(users:_users,)
                ));
              },
            )
          ]
      ),
      body: FutureBuilder(
        future: _getData(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();


          return ListView.builder(
            itemBuilder: (ctx, i) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(_users[i].name),
                    subtitle: Text(_users[i].number),
                  ),
                  Divider(height: 0,)
                ],
              );
            },
            itemCount: _users.length,
          );
        },
      ),
    );
  }

  Future<void> _getData() async {
    // var url = 'https://jsonplaceholder.typicode.com/posts';
    var url = 'http://192.168.56.1/database.php';
    http.get(Uri.parse(url)).then((data) {
      return json.decode(data.body);
    }).then((data) {
      for (var json in data) {
        _users.add(User.fromJson(json));
      }
      print(_users);
    })
        .catchError((e){
      print(e);
    });
  }
}
