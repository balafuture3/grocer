import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebasewithflutter/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget
{
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
{

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
 final TextEditingController emailController = new TextEditingController();
 final TextEditingController passwordController = new TextEditingController();
bool loading=false;
 bool _validateP = false;
 bool _validateE = false;

  Future<http.Response> fetchData() async
  {
    var url = 'http://www.neurongsm.com/android/tst.php';

    Map data = {
      'username': emailController.text,
      'password': passwordController.text
    };
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body
    );
    print("${response.statusCode}");
    //print("${response.body}");

    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        loading=false;
      });
      // If server returns an OK response, parse the JSON.
      if(response.body!='"failed"') {
        String body=response.body.replaceAll('"', '');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage(email: body)));
      }
      else
        showDialog(context: context,
            builder: (_)=> AlertDialog(title: Text("Login "+response.body.replaceAll('"', '')),content: Text("Please Check details......"),));

      // return response;
    } else {
      setState(() {
        loading=false;
      });
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
    return response;
  }
/*
 Future<http.Response> fetchData() {
   return http.post(
     'http://www.neurongsm.com/android/tst.php',
     headers: <String, String>{
       'Content-Type': 'application/json',
     },
     body: jsonEncode(<String, String>{
       'title': 'balakumar',
     }),
   );
 }
   if (response.statusCode == 201) {
     print(response.body);
     setState(() {
       loading=false;
     });
     // If server returns an OK response, parse the JSON.
     if(response.body!='"failed"') {
       String body=response.body.replaceAll('"', '');
       Navigator.pushReplacement(
           context, MaterialPageRoute(builder: (context) => HomePage(email: body)));
     }
     else
     showDialog(context: context,
         builder: (_)=> AlertDialog(title: Text("Login "+response.body.replaceAll('"', '')),content: Text("Please Check details......"),));

    // return response;
   } else {
     setState(() {
       loading=false;
     });
     // If that response was not OK, throw an error.
     throw Exception('Failed to load post');
   }
 }*/
  Widget _submitButton() {
    return InkWell(
        //borderRadius: BorderRadius.all(Radius.circular(10)),
      onTap:()        {      FocusScope.of(context).requestFocus(new FocusNode());
         setState(() {
           emailController.text.isEmpty ? _validateE = true : _validateE = false;
           passwordController.text.isEmpty ? _validateP = true : _validateP = false;

         });
         if(_validateP==false&&_validateE==false) {
           loading = true;
           fetchData();
         }


      },
      child:Container(

      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,

      decoration: BoxDecoration(
        color:Colors.purple,
          borderRadius: BorderRadius.all(Radius.circular(15)),
/*
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xfffbb448), Color(0xfff7892b)])*/),
      child: Text(
        'Login',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ));
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
       // Navigator.push(
           // context, MaterialPageRoute(builder: (context) => HomePage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Colors.purple,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
Widget _logo()
{
  return  Image(image: AssetImage('images/fv.jpg'),width:100,height:80);
}
  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'G',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.purple,
          ),
          children: [
            TextSpan(
              text: 'ro',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'cery',
              style: TextStyle(color: Colors.purple, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
           Text(
                'Username or Email',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
               ),
           SizedBox(
           height: 10,
                   ),
           TextField(
                   controller: emailController,
                   obscureText: false,
                   decoration: InputDecoration(
                       //labelText: 'Enter the Value',
                       errorText: _validateE ? 'Username or Email Can\'t Be Empty' : null,
                   border: InputBorder.none,
                   fillColor: Color(0xfff3f3f4),
                   filled: true))
    ],
    ),
    ),
        Container(
         margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        Text(
        'Password',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        SizedBox(
        height: 10,
        ),
        TextField(

        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
            //labelText: 'Enter the Value',
            errorText: _validateP ? 'Password Can\'t Be Empty' : null,
        border: InputBorder.none,
        fillColor: Color(0xfff3f3f4),
        filled: true))
        ],
        ),
        ),
      ],
    );
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

   super.initState();
 }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          height: height,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .15),
                      _logo(),
                      SizedBox(height: height * .01),
                      _title(),
                      SizedBox(height: height * .009),
                      Padding(
                        padding: const EdgeInsets.only(left:50.0),
                        child: Text("by Bala"),
                      ),
                      SizedBox(height: 30),
                      _emailPasswordWidget(),
                      SizedBox(height: 50),
                    _submitButton(),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: Text('Forgot Password ?',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                      _divider(),
                      _createAccountLabel(),
                    ],
                  ),

                ),
              ),
            loading
          ? Container(
        child: Center(
          child: CircularProgressIndicator(
          ),
        ),
        color: Colors.white.withOpacity(0.8),
      ):Container()
            ],
          ),
        ));
  }
}
