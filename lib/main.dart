import 'dart:convert';

import 'package:firebasewithflutter/category.dart';
import 'package:firebasewithflutter/login.dart';
import 'package:firebasewithflutter/note.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

Map<int, Color> color =
{
  50:Color.fromRGBO(136,14,79, .1),
  100:Color.fromRGBO(136,14,79, .2),
  200:Color.fromRGBO(136,14,79, .3),
  300:Color.fromRGBO(136,14,79, .4),
  400:Color.fromRGBO(136,14,79, .5),
  500:Color.fromRGBO(136,14,79, .6),
  600:Color.fromRGBO(136,14,79, .7),
  700:Color.fromRGBO(136,14,79, .8),
  800:Color.fromRGBO(136,14,79, .9),
  900:Color.fromRGBO(136,14,79, 1),
};
void main() => runApp(App());
class App extends StatelessWidget {
  MaterialColor colorCustom = MaterialColor(0xFF880E4F, color);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bala Grocery',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          bottomAppBarColor: Colors.purple
      ),
      home: LoginPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.email});

  final String email;


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Note> _notes = List<Note>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<String> category;
  bool _isloading=true;
  Future<List<Note>> fetchNotes() async {
    var url = 'http://www.neurongsm.com/android/movies.php';
    var response = await http.get(url);

    var notes = List<Note>();
    category = List<String>();
    if (response.statusCode == 200)
    {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson)
      {
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
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // _showItemDialog(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //_navigateToItemDetail(message);
      },
    );
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
    Widget child;
    switch (_currentIndex) {
      case 0:
        child = Container(
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
          ),


        );

        break;
      case 1:
        child = ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left:16.0,right: 16.0,top:10 ),
              child: Card(
                elevation: 3.0,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(10),),
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[


                    ListTile(
                        leading: Icon(Icons.ac_unit),onTap:() {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => CategoryList(email: category[index])));

                    }, title: Text( category[index])

                    ),
/*
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        category[index],

                        style:TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,



                        ),
                      ),
                    ),*/
                  ],
                ),

              ),
            );

          },
          itemCount: category.length,
        )
        ;
        break;
    }
    return  Scaffold(

/*
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
           child: const Icon(Icons.category), onPressed: () { },),*/
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Welcome"),
                accountEmail: Text(widget.email),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Text(
                    widget.email.substring(0,1),
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home), title: Text("Home"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings), title: Text("Settings"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.contacts), title: Text("Contact Us"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),

        appBar: AppBar(
          title: Text("Bala Grocery"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: DataSearch()
                  );
                })
          ],
        ),
        //   drawer: Drawer(),


        body:_isloading?Center(
          child: CircularProgressIndicator(),):
        SizedBox.expand(child: child),
        bottomNavigationBar:BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.shifting ,
          items: [
            BottomNavigationBarItem(

                icon: Icon(Icons.home,),
                title: new Text('Home')
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.category,),
                title: new Text('Category')
            ),

          ],
          onTap: (index){
            _incrementTab(index);
          },
        )
    );

/*
       bottomNavigationBar: BottomAppBar(

         shape: CircularNotchedRectangle(),
         notchMargin: 6.0,
         child: new Row(
           mainAxisSize: MainAxisSize.max,
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: <Widget>[

             IconButton(icon: Icon(Icons.home), color: Colors.white,onPressed: (      ) {},),
             IconButton(icon: Icon(Icons.help),color: Colors.white, onPressed: () {},),
           ],
         ),
       ),
      */


  }
}

class DataSearch extends SearchDelegate<String> {

  final cities = ['Ankara', 'izmir', 'istanbul', 'Samsun', 'Sakarya'];
  var recentCities = ['Ankara'];

  List<Note> _notes = List<Note>();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();

    /*final suggestionList = query.isEmpty
          ? recentCities
          : cities.where((p) => p.startsWith(query)).toList();

      return ListView.builder(
        itemBuilder: (context, index) =>
            ListTile(
              onTap: () {
                showResults(context);
              },
              leading: Icon(Icons.location_city),
              title: RichText(
                text: TextSpan(
                  text: suggestionList[index].substring(0, query.length),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: suggestionList[index].substring(query.length),
                    ),
                  ],
                ),
              ),
            ),
        itemCount: suggestionList.length,
      );*/
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Note>>(
      future: fetchNotes(query),
      builder: (context, _notes)
      {
        if(_notes.hasData)
        {
          return ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
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
                        height: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    _notes.data[index].image))),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _notes.data[index].title,

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,


                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, bottom: 10),
                        child: Text(
                          _notes.data[index].text,
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
            itemCount: _notes.data.length,
          );
        }
        else if(_notes.connectionState==ConnectionState.done){
          return Center(
            child: Text("Sorry! No Details Found"),
          );
        }
        else
        {
          return Center(
            child: CircularProgressIndicator(),);
        }

      },
    );
  }

  Future<List<Note>> fetchNotes(String query) async {
    var url = 'http://www.neurongsm.com/android/movies.php?id='+query;
    var response = await http.get(url);
    var notes = List<Note>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(Note.fromJson(noteJson));
      }
      //  _isloading=false;
    }
    else{}
    return notes;
  }
}
// Navigator.push(context, MaterialPageRoute(builder: (context) => Login(query)));
//return Container();

