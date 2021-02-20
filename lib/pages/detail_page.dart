import 'package:firepost/model/post_model.dart';
import 'package:firepost/services/prefs_service.dart';
import 'package:firepost/services/rtdb_service.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  static final String id = "detail_page";
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  var titleController = TextEditingController();
  var contentController = TextEditingController();

  _addPost() async {
    String title = titleController.text.toString();
    String content = contentController.text.toString();
    if(title.isEmpty || content.isEmpty) return;

    _apiAddPost(title, content);
  }

  _apiAddPost(String title, String content) async{
    var id = await Prefs.loadUserId();
    RTDBService.addPost(new Post(id, title, content)).then((response) => {
      print(response),
      _respAddPost(),
    });
  }

  _respAddPost(){
    Navigator.of(context).pop({"data":"done"});
    // Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 15,),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Title"
                ),
              ),
              SizedBox(height: 15,),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                    hintText: "Content"
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: double.infinity,
                height: 50,
                child: FlatButton(
                  color: Colors.blue,
                  child: Text("Add", style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    _addPost();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
