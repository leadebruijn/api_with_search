import 'package:api_with_search/post_model.dart';
import 'package:flutter/material.dart';
import 'package:api_with_search/user.dart';


class SearchPage extends StatefulWidget {
final List<User> users;

SearchPage({@required required this.users});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<User> _searchedPost = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search User Number',
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none
          ),
        onChanged: (val){
          setState(() {
            _searchedPost = widget.users.where(
                (el)=>el.number.contains(val)
            ).cast<User>().toList();
          });
        }
      ),
    ),

      body: _searchedPost.isEmpty ?
      Center(
        child: Text('No match',),
      ):
      ListView.builder(
        itemCount: _searchedPost.length,
        itemBuilder: (ctx,i){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(_searchedPost[i].name),
                // subtitle: Text(_searchedPost[i].number),
              ),
              Divider(height: 0,)
            ],
          );
        },
      ),
    );
  }
}
