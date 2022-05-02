import 'dart:io';
import 'package:api_with_search/search_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'post_model.dart';
import 'dart:convert';
import 'user.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<User> _users = [];
  File? _image;

  Future getImage() async {
    File image;
    image = (await ImagePicker().getImage(source: ImageSource.camera)) as File;
    // if(isCamera){
    //  image = (await ImagePicker().getImage(source: ImageSource.camera)) as File;
    //  //image = await _picker.pickImage(source: imageSource.camera);
    // }
    // else {
    //   image = (await ImagePicker().getImage(source: ImageSource.gallery)) as File;
    //   //image = await _picker.pickImage(source: imageSource.gallery);
    // }
    setState(() {
      _image = image;
    });
  }

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
      body: Column(
        children: [
          FloatingActionButton(
              child: Icon(Icons.camera_alt),
              onPressed: () {getImage();}
          ),
          FutureBuilder(
            future: _getData(),
            builder: (ctx, snapshot) { //ctx = context
              if (snapshot.connectionState == ConnectionState.waiting)
                return CircularProgressIndicator();

              return ListView.builder(
                itemBuilder: (ctx, i) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
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
                shrinkWrap: true,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _getData() async {
    // var url = 'https://jsonplaceholder.typicode.com/posts';
    // var url = 'http://192.168.56.1/database.php'; //EMULATOR
    var url = 'http://192.168.1.9:80/database.php'; //MOBILE

    http.get(Uri.parse(url)).then((data) {
      return json.decode(data.body);
    }).then((data) {
      _users.clear();
      for (var json in data) {
        print(json);
        if(!_users.contains(json)){
          _users.add(User.fromJson(json));
        }
      }
    })
        .catchError((e){ // user kan steeds aangaan al is daar error..
      print(e);
    });
  }
}
