import 'dart:convert';

import 'package:firebasewithflutter/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebasewithflutter/note.dart';

class CategoryList extends StatefulWidget {
  CategoryList({Key key, this.email});

  final String email;


  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int _currentIndex = 0;
  List<Note> _notes = List<Note>();

  List<String> category;
  bool _isloading=true;
  Future<List<Note>> fetchNotes() async {
    var url = 'http://www.neurongsm.com/android/movies.php?id='+widget.email;
    var response = await http.get(url);

    var notes = List<Note>();
    category = List<String>();
    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(Note.fromJson(noteJson));
      }
      int i;
      for(i=0;i<notes.length;i++)
      {
        category.add(notes[i].text);

      }
      category=category.toSet().toList();
      print(category);
      _isloading=false;
    }
    return notes;
  }

  @override
  void initState() {
    fetchNotes().then((value) {
      setState(() {
        _notes.addAll(value);
      });
    });
    super.initState();
  }
  void _incrementTab(index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return _isloading?Center(
      child: CircularProgressIndicator(),):
    Scaffold(
        appBar: AppBar(
          title: Text(widget.email),

        ),
      body: Container(
      color:Colors.white,
        child: GridView.builder(

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2

          ),
          itemCount: _notes.length, itemBuilder: (context, index) {
          return Container(

            child: Card(
              elevation: 3.0,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(10),),
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Container(
                    width: double.maxFinite,
                    height: 130,
                    decoration: BoxDecoration(image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(_notes[index].image))),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _notes[index].title,

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,


                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: Text(
                      _notes[index].text,
                      style: TextStyle(
                          color: Colors.grey.shade600
                      ),
                    ),
                  )
                ],
              ),

            ),
          );
        },
        ))

    );
  }

}


