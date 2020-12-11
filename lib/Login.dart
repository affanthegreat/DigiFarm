import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:digifarm/main.dart';
import 'package:digifarm/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user;
    u =user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      print('signInWithGoogle succeeded: $user');
      await dataHandler(user);
      return '$user';
    }

    return null;
  }


  var genericNews = [
  NewsArticles("Micro-level planning to help boost agriculture in Tiruvallur district", "https://www.thehindu.com/news/national/tamil-nadu/micro-level-planning-to-help-boost-agriculture-in-tiruvallur-district/article33148920.ece","https://th.thgim.com/news/national/tamil-nadu/tktzb8/article33148919.ece/ALTERNATES/FREE_960/21NOVTH--Agrijpg"),
  NewsArticles("Agriculture and rural sector can jump-start economy if we fix its ills","https://indianexpress.com/article/opinion/columns/agriculture-gdp-growth-economy-7055240/", "https://images.indianexpress.com/2020/11/Bina-Agarwal.jpg"),
  NewsArticles("Development, Deployment Of Technology Needed To Transform Agriculture Sector", "https://www.timesnownews.com/business-economy/industry/article/development-deployment-of-technology-needed-to-transform-agriculture-sector/684920", "https://imgk.timesnownews.com/story/images_1_1.jpg")
  ];





  void dataHandler(User user) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance.collection('Users').doc(user.uid).collection('Details').where('id', isEqualTo: user.uid).get();

      final List<DocumentSnapshot> documents = result.docs;


      if(documents.isEmpty) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid).collection('Details').doc('info')
            .set({
          'id': user.uid,
          'name': user.displayName,
          'email': user.email,
        });
      timesSetter(user.uid);
      }
      else{
        String year = DateTime.now().year.toString();
        DocumentSnapshot  x =await FirebaseFirestore.instance.collection('Users').doc(user.uid).collection('timesWatered').doc(year).get();
        DocumentSnapshot y = await FirebaseFirestore.instance.collection('Users').doc(user.uid).collection('timesFertilized').doc(year).get();
        if(x.exists != true && y.exists != true){
          timesSetter(user.uid);
        }
      }
    }
    catch(e){
      print(e);
    }
  }

  timesSetter(String uid) async{
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid).collection('timesWatered').doc(DateTime.now().year.toString())
        .set({
      'January':0,
      'February':0,
      'March':0,
      'April':0,
      'May':0,
      'June':0,
      'July':0,
      'August':0,
      'September':0,
      'October':0,
      'November':0,
      'December':0,
    });
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid).collection('timesFertilized').doc(DateTime.now().year.toString())
        .set({
      'January':0,
      'February':0,
      'March':0,
      'April':0,
      'May':0,
      'June':0,
      'July':0,
      'August':0,
      'September':0,
      'October':0,
      'November':0,
      'December':0,
    });
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "DigiFarm",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.black,
                      fontSize: 47,
                      fontWeight: FontWeight.bold),
                  textScaleFactor: 1,
                ),

              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[



              Container(
                height: MediaQuery.of(context).size.height * 0.11,

                child: Column(
                  children: <Widget>[
                    Center(
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              signInWithGoogle().then((result) {
                                if(result!=null)
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return MyHomePage();
                                    },
                                  ),
                                );
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height:
                                MediaQuery.of(context).size.height * 0.06,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.grey.shade600,
                                        width: 0.7)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset('assets/google_logo.png',height: 25,width: 25,),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Center(
                                        child: Text(
                                          "Sign in with Google",
                                          textScaleFactor: 0.8,
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                              color: Colors.black,
                                              fontSize: 19,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),


                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
