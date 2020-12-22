import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digifarm/Login.dart';
import 'package:digifarm/MeasurePage.dart';
import 'package:digifarm/growth.dart';
import 'package:digifarm/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'data/error.dart';
import 'data/place_response.dart';
import 'data/result.dart';
import 'general/infoPage.dart';
import 'marketplace/marketHome.dart';
import 'my_flutter_app_icons.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

String username;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new MyHomePage(),
        '/marketScreen': (BuildContext context) => new MarketHome(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController mapController;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // Move camera to the specified latitude & longitude
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            // Will be fetching in the next step
            _currentPosition.latitude,
            _currentPosition.longitude,
          ),
          zoom: 18.0,
        ),
      ),
    );
  }

  void details() {
    final User currentUser = _auth.currentUser;
    username = currentUser.displayName;
  }

  final LatLng _center = const LatLng(45.521563, -122.677433);
  final Geolocator _geolocator = Geolocator();

// For storing the current position
  Position _currentPosition;

  Widget card(String imgUrl, String text, String url) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Webpage(url)));
      },
      child: Container(
        child: Stack(children: [
          Container(
            margin: EdgeInsets.all(7),
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imgUrl),
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          Container(
            margin: EdgeInsets.all(7),
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topRight,
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                    ]),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey.shade200, width: 1)),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    text,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                        fontSize: 12),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  bool isLoading = true;
  var pos;

  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        // Store the position in the variable
        _currentPosition = position;
        pos = position;
        print('CURRENT POS: $_currentPosition');
        searchNearby(position.latitude, position.longitude);

        // For moving the camera to current location
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 10.0,
            ),
          ),
        );

        print(isLoading);
      });
    }).catchError((e) {
      print(e);
    });
  }

  String address1, address2;
  List<Marker> markers = <Marker>[];
  static const String baseUrl =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json";
  static const String _API_KEY = 'AIzaSyAJfYofMKLW4oklVtl87q5OEjsUfAORnow';
  List<Result> places;
  bool searching = true;
  Error error;
  String _keyword = "Vegetable wholesale market";
  String placeName1, placeName2;

  void _handleResponse(data) {
    // bad api key or otherwise
    stateLoc = data['results'][0]['plus_code']['compound_code'];
    if (data['status'] == "REQUEST_DENIED") {
      setState(() {
        error = Error.fromJson(data);
      });
      // success
    } else if (data['status'] == "OK") {
      setState(() {
        places = PlaceResponse.parseResults(data['results']);
        helper(places);
        for (int i = 0; i < places.length; i++) {
          markers.add(
            Marker(
              markerId: MarkerId(places[i].placeId),
              position: LatLng(places[i].geometry.location.lat,
                  places[i].geometry.location.long),
              infoWindow: InfoWindow(
                  title: places[i].name, snippet: places[i].vicinity),
              onTap: () {},
            ),
          );
        }
      });
    } else {
      print(data);
    }
  }

  var stateLoc;

  helper(List<Result> places) {
    setState(() {
      placeName1 = places[0].name;
      placeName2 = places[1].name;
      address1 = "${places[0].vicinity}";
      address2 = "${places[1].vicinity}";
    });
  }

  QuerySnapshot news() {
    var result = FirebaseFirestore.instance.collection('News').get();
  }

  var p = 0.8;

  void searchNearby(double latitude, double longitude) async {
    setState(() {
      markers.clear();
    });
    String url =
        '$baseUrl?key=$_API_KEY&location=$latitude,$longitude&radius=30000&keyword=${_keyword}';
    print(url);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _handleResponse(data);
    } else {
      throw Exception('An error occurred getting places nearby');
    }

    // make sure to hide searching
    setState(() {
      searching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    details();
    loadingAnimation(false);
  }

  Widget miniCard(IconData icon, String text) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        height: MediaQuery.of(context).size.height * 0.11,
        width: MediaQuery.of(context).size.width * 0.271,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.height * 0.023),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey.shade100,
                  Colors.white,
                ]),
            border: Border.all(color: Colors.grey.shade300, width: 1)),
        child: Center(
          child: Column(
            children: [
              IconButton(
                icon: Icon(
                  icon,
                  color: Colors.black,
                ),
              ),
              Text(
                text,
                textScaleFactor: 0.8,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    fontFamily: "Poppins"),
              )
            ],
          ),
        ),
        // );
      ),
    );
  }

  Container aboutCrop() {
    return Container(
      margin: EdgeInsets.all(7),
      height: MediaQuery.of(context).size.height * 0.331,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Row(
              children: [
                Text(
                  "About your crop",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 50.0),
            child: Divider(
              color: Colors.black,
              thickness: 0.2,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GrowthAndDemand()));
                      },
                      child: miniCard(MyFlutterApp.grow, "Demand & growth")),
                  InkWell(
                      onTap: () {},
                      child: miniCard(Icons.wb_sunny, "Weather Forecasts")),
                  InkWell(
                      onTap: () {
                        // Navigator.of(context).push(PageRouteBuilder(
                        //     opaque: false,
                        //     pageBuilder: (BuildContext context, _, __) =>
                        //         informationPage(
                        //           titles: [
                        //             "Agriculture - Selection and Sowing of Seeds",
                        //             "Selection of Seeds",
                        //             "Sowing of Seeds"
                        //           ],
                        //           Paragraphs: [
                        //             "Agriculture is the art and ability to cultivate plants and other livestock. There are different types of agriculture, and it plays a crucial role in the life of an economy. The main purpose of agriculture is not only to cultivate crops, but it also provides employment for the large proportion of the population, and it is the backbone of our economic system.As we all are aware of, there are multiple steps to be followed in the agricultural process.The first and the initial stage is the selection of the seeds. Seeds are the fundamental requirement in most of the agricultural process. Before beginning with the cultivation, selecting the best quality seeds is a challenging task for the farmers. Because only the good quality of seeds give an expected result or yield. Therefore, farmers have to choose suitable seeds from the variety of options available in the market.Let us know more in detail about the selection and sowing of seeds.Selection and sowing of seeds are two agricultural practices which demand extreme attention and care.",
                        //             "Healthy and good quality seeds are the roots of a healthy crop. The seeds that are used to cultivate new crops have to be selected very carefully and of high quality. The good quality seeds can either be bought from different sources or farmers can produce by their own. The selection of seeds is used to improve the quality of yields. There are several diseases that are transmitted via the seeds. If the selected seeds are from the infected fields then the seed-borne diseases will cause severe problems in the agricultural process. Thus, always obtain seeds from healthy plants. Along with the diseases free and healthy seeds, farmers also need to check the germination period of the seeds, nutrients required and other benefits in terms of yield and finance. Overall, selecting good quality seeds are essential for growing strong and healthy crops.",
                        //             "Sowing seeds is an essential part of crop production. After the preparation of soil, the previously selected seeds are scattered in the field. This process is called sowing. Sowing should be done carefully and evenly. If seeds are not sown uniformly, overcrowding of crops happens. For sufficient sunlight, water and other requirements congestion need to be prevented.  There are two different methods of sowing the seeds.  Traditionally, sowing is done manually by hands and in some places, seed drilling machines are used."
                        //           ],
                        //         )));

                        Navigator.of(context).push(TransparentRoute(
                            builder: (BuildContext context) => informationPage(
                                  titles: [
                                    "Agriculture - Selection and Sowing of Seeds",
                                    "Selection of Seeds",
                                    "Sowing of Seeds"
                                  ],
                                  Paragraphs: [
                                    "Agriculture is the art and ability to cultivate plants and other livestock. There are different types of agriculture, and it plays a crucial role in the life of an economy. The main purpose of agriculture is not only to cultivate crops, but it also provides employment for the large proportion of the population, and it is the backbone of our economic system.As we all are aware of, there are multiple steps to be followed in the agricultural process.The first and the initial stage is the selection of the seeds. Seeds are the fundamental requirement in most of the agricultural process. Before beginning with the cultivation, selecting the best quality seeds is a challenging task for the farmers. Because only the good quality of seeds give an expected result or yield. Therefore, farmers have to choose suitable seeds from the variety of options available in the market.Let us know more in detail about the selection and sowing of seeds.Selection and sowing of seeds are two agricultural practices which demand extreme attention and care.",
                                    "Healthy and good quality seeds are the roots of a healthy crop. The seeds that are used to cultivate new crops have to be selected very carefully and of high quality. The good quality seeds can either be bought from different sources or farmers can produce by their own. The selection of seeds is used to improve the quality of yields. There are several diseases that are transmitted via the seeds. If the selected seeds are from the infected fields then the seed-borne diseases will cause severe problems in the agricultural process. Thus, always obtain seeds from healthy plants. Along with the diseases free and healthy seeds, farmers also need to check the germination period of the seeds, nutrients required and other benefits in terms of yield and finance. Overall, selecting good quality seeds are essential for growing strong and healthy crops.",
                                    "Sowing seeds is an essential part of crop production. After the preparation of soil, the previously selected seeds are scattered in the field. This process is called sowing. Sowing should be done carefully and evenly. If seeds are not sown uniformly, overcrowding of crops happens. For sufficient sunlight, water and other requirements congestion need to be prevented.  There are two different methods of sowing the seeds.  Traditionally, sowing is done manually by hands and in some places, seed drilling machines are used."
                                  ],
                                )));
                      },
                      child: miniCard(Icons.info_outlined, "Seed Selection")),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10.0),
            child: Divider(
              color: Colors.black,
              thickness: 0.1,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new MeasurePage(
                                  collectionName: 'timesWatered',
                                  descriptiveHeading:
                                  "Track record of Water supply",
                                  appBarTitle: "Irrigation",
                                  descriptiveSubHeading:
                                  "Measure how frequently you are supplying water to your crop.",
                                  monthDescription:
                                  "Number of Times water supplied this month",
                                  yearDescription:
                                  "Total Water Supplied this year",
                                  infoButtonLabel:
                                  "Want to know about Irrigation and Water resources?",
                                  floatingButtonLabel:
                                  "Supplied Water Today",
                                )));
                      },
                      child: miniCard(MyFlutterApp.drop, "Irrigation")),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new MeasurePage(
                                  collectionName: 'timesFertilized',
                                  descriptiveHeading:
                                  "Track record of Fertilizer supply",
                                  appBarTitle: "Fertilizers",
                                  descriptiveSubHeading:
                                  "Measure how frequently you are supplying fertilizers to your crop.",
                                  monthDescription:
                                  "Number of times water supplied this month",
                                  yearDescription:
                                  "Total No. of times Fertilizers Supplied this year",
                                  infoButtonLabel:
                                  "Want to know about Fertilizers and Soil?",
                                  floatingButtonLabel:
                                  'Added fertilizers today!',
                                )));
                      },
                      child: miniCard(Icons.wb_incandescent, "Fertilizers")),
                  InkWell(
                      onTap: () {},
                      child: miniCard(Icons.car_rental, "Transport"))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10.0),
            child: Divider(
              color: Colors.black,
              thickness: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  RichText textshow(String str1, String str2) {
    return RichText(
        textScaleFactor: 1,
        text: TextSpan(
            text: str1,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontFamily: "Poppins"),
            children: [
              TextSpan(
                  text: ",$str2",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 9,
                      fontFamily: "Poppins"))
            ]));
  }

  String _currentAddress;
  final startAddressController = TextEditingController();

  void updateKeyWord(String newKeyword) {
    print(newKeyword);
    setState(() {});
  }

  bool loadingAnimation(bool value) {
    setState(() {
      isLoading = value;
    });
    return value;
  }

  Container marketplace() {
    return Container(
      margin: EdgeInsets.all(5),
      height: MediaQuery.of(context).size.height * 0.354,
      width: MediaQuery.of(context).size.width * 1,
      // decoration: BoxDecoration(
      //     gradient: SweepGradient(
      //       colors: <Color>[Colors.grey.shade100, Colors.white],
      //       transform: GradientRotation(3.1415926535897932 / 12),
      //     ),
      //     borderRadius: BorderRadius.circular(8),
      //     border: Border.all(color: Colors.grey.shade300, width: 1)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Text(
                    "Nearby Marketplaces",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: Divider(
                color: Colors.black,
                thickness: 0.4,
              ),
            ),
            (placeName1 != null &&
                address1 != null &&
                placeName1 != null &&
                address1 != null)
                ? Container(
              child: Column(children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(children: [
                            Container(
                                width: MediaQuery.of(context).size.width *
                                    0.85,
                                child: textshow(placeName1, address1)),
                          ])),
                      Padding(
                        padding: const EdgeInsets.only(right: 50.0),
                        child: Divider(
                          color: Colors.grey.shade500,
                          thickness: 0.2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width *
                                    0.85,
                                child: textshow(placeName2, address2)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: Divider(
                    color: Colors.grey.shade500,
                    thickness: 0.2,
                  ),
                ),
              ]),
            )
                : Container(
                height: MediaQuery.of(context).size.height * 0.15,
                child: Center(
                  child: CircularProgressIndicator(),
                )),
            Container(
              height: MediaQuery.of(context).size.height * 0.190,
              width: MediaQuery.of(context).size.width * 0.966,
              decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 30.0,
                  ),
                  markers: Set<Marker>.of(markers),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScrollPhysics physics;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                    color: Colors.black,
                    tooltip: 'Filter Search',
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    });
              },
            ),
          ],
          title: Text(
            "Home",
            style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w700,
                fontFamily: "Poppins"),
          ),
          backgroundColor: Colors.grey.shade50,
          elevation: 0,
        ),
        endDrawer: SearchFilter(updateKeyWord),
        body: isLoading == true
            ? Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 13.0),
                      child: Text(
                        "Trending in Farming",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("News")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        return Container(
                          height:
                          MediaQuery.of(context).size.height * 0.2,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot ds =
                                snapshot.data.documents[index];
                                return card(ds["photourl"],
                                    ds["description"], ds["url"]);
                              }),
                        );
                      }
                    }),
                SingleChildScrollView(
                    scrollDirection: Axis.vertical, child: aboutCrop()),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Divider(
                    thickness: 0.7,
                    color: Colors.greenAccent,
                  ),
                ),
                marketplace(),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Divider(
                    thickness: 0.7,
                    color: Colors.greenAccent,
                  ),
                ),
                Container(
                    child: Text(
                      "Affan The Great's Creation",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 8,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
        )
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SearchFilter extends StatefulWidget {
  final Function updateKeyword;

  SearchFilter(this.updateKeyword);

  @override
  State<StatefulWidget> createState() {
    return _SearchFilter(updateKeyword);
  }
}

class _SearchFilter extends State<SearchFilter> {
  static final List<String> filterOptions = <String>[
    "Home",
    "Sell your crop",
    "Helpline",
    "Settings"
  ];

  int _selectedPosition = 0;
  final Function updateKeyword;

  _SearchFilter(this.updateKeyword);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Container listmenu(String text, String text2) {
      return Container(
        margin: EdgeInsets.all(6),
        height: MediaQuery.of(context).size.height * 0.145,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300, width: 1)),
        child: Column(
          children: [
            Padding(
              padding:
              EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
              child: Row(
                children: [
                  Text(
                    text,
                    textScaleFactor: 0.8,
                    style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 30.0),
              child: Divider(
                thickness: 1,
                color: Colors.grey.shade400,
              ),
            ),
            Padding(
              padding:
              EdgeInsets.all(MediaQuery.of(context).size.height * 0.007),
              child: Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.60,
                      child: Text(
                        text2,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: "Poppins"),
                      )),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade50,
          automaticallyImplyLeading: false,
          title: Text(
            'Hey ${username}!',
            style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
          elevation: 0,
        ),
        body: Stack(children: [
          ListView(
            physics:
            BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: InkWell(
                  onTap: () {
                    previous = 0;
                    if (pageLocation == 0 && previous == 0) {
                      Navigator.of(context).pop();
                    }
                    if (pageLocation != 0)
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                  },
                  child: listmenu("${filterOptions[0]}",
                      "Quick access latest Agriculture News, Info about your crop and see all nearby Marketplaces."),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: InkWell(
                  onTap: () {
                    if (instack1 == true) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => MyHomePage()));
                    }
                    pageLocation = 1;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MarketHome()));
                  },
                  child: listmenu(filterOptions[1],
                      "Get an Estimate for your produce and Sell your crop to the nearby market."),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: InkWell(
                  onTap: () {
                    if (pageLocation == 2) {
                      Navigator.pop(context);
                    }
                    pageLocation = 2;
                  },
                  child: listmenu(filterOptions[2],
                      "Get Support regarding the app, crops and more."),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: InkWell(
                  onTap: () {
                    pageLocation = 3;
                  },
                  child: listmenu(
                      filterOptions[3], "See your account details and more."),
                ),
              ),
              Container(
                child: Center(
                  child: Text(
                    "Alpha 0.2",
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w200,
                        color: Colors.grey.shade600),
                  ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }

  Widget _getIcon(int value) {
    return Builder(
      builder: (BuildContext context) {
        if (value == _selectedPosition) {
          return Icon(Icons.check);
        } else {
          return SizedBox(
            width: 50,
          );
        }
      },
    );
  }
}

class Webpage extends StatefulWidget {
  String url;

  Webpage(this.url);

  @override
  _WebpageState createState() => _WebpageState();
}

class _WebpageState extends State<Webpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey.shade800),
        backgroundColor: Colors.grey.shade50,
        title: Text(
          widget.url,
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        elevation: 2,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: InAppWebView(
              initialUrl: widget.url,
            ),
          ),
        ),
      ),
    );
  }
}
