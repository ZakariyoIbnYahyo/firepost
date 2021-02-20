import 'package:firepost/model/post_model.dart';
import 'package:firepost/pages/detail_page.dart';
import 'package:firepost/pages/signIn_page.dart';
import 'package:firepost/services/auth_service.dart';
import 'package:firepost/services/prefs_service.dart';
import 'package:firepost/services/rtdb_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static final String id= "home_page";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: deprecated_member_use
  List<Post> items = new List();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetPosts();
  }

  _openDetail() async{
    Map result = await Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context){
          return new DetailPage();
        }
    ));
    if(result != null && result.containsKey("data")){
      // print(result['data']);
      _apiGetPosts();
    }
  }

  _apiGetPosts()async{
    var id = await Prefs.loadUserId();
    RTDBService.getPosts(id).then((posts) => {
      _respPosts(posts),
    });
  }

  _respPosts(List<Post> posts){
    setState(() {
      items = posts;
    });
  }

  void _doSignOut(){
    AuthService.signOutUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app), color: Colors.white,
              onPressed: (){
                _doSignOut();
                Navigator.pushReplacementNamed(context, SignInPage.id);
              }
          )
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, i){
          return itemOfPost(items[i]);
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _openDetail();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget itemOfPost(Post post){
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.title, style: TextStyle(fontSize: 22, color: Colors.black),),
          Text(post.content, style: TextStyle(fontSize: 16, color: Colors.black),),
        ],
      ),
    );
  }
}
