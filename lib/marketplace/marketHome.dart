import 'package:digifarm/main.dart';
import 'package:digifarm/marketplace/newListingAdder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'descriptionPage.dart';

class MarketHome extends StatefulWidget {
  @override
  _MarketHomeState createState() => _MarketHomeState();
}

class _MarketHomeState extends State<MarketHome> {
  void updateKeyWord(String newKeyword) {
    print(newKeyword);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var gradDesign = BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade100]),
        borderRadius: BorderRadius.circular(8));

    RichText textshow(String str1, String str2) {
      return RichText(
          textScaleFactor: 0.9,
          text: TextSpan(
              text: str1,
              style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
              children: [
            TextSpan(
                text: "$str2",
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14))
          ]));
    }

    RichText textshow2(String str1, String str2) {
      return RichText(
          textScaleFactor: 0.7,
          text: TextSpan(
              text: " $str1",
              style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
              children: [
            TextSpan(
                text: "$str2",
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 14))
          ]));
    }

  Widget listingCard(
        String url, String itemName, int quantity, String condition) {
      return Padding(
        padding: EdgeInsets.all(height * 0.0014),
        child: Stack(children: [
          Container(

            height: height * 0.224,
            width: width * 0.55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200, width: 1),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(url),
              ),
            ),
          ),
          Container(

              height: height * 0.226,
              width: width * 0.55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topRight,
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.transparent,
                    ]),
              )),
          Container(

            height: height * 0.224,
            width: width * 0.55,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        itemName,
                        textScaleFactor: 0.7,
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:  EdgeInsets.only(bottom:height * 0.001 ,left: height * 0.001),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      textshow("Quantity : ", quantity.toString()),
                      textshow("Condition : ", condition),
                    ],
                  ),
                )
              ],
            ),
          )
        ]),
      );
    }

    Padding innerDiv() {
      return Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 30),
        child: Divider(
          color: Colors.grey.shade400,
          thickness: 1,
        ),
      );
    }

    Container currentListing() {
      return Container(
        margin: EdgeInsets.all(8),
        height: height * 0.295,
        width: width * 0.96,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 9.0, top: 4),
              child: Row(
                children: [
                  Text(
                    "Recent Listings",
                    textScaleFactor: 0.9,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            innerDiv(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DescriptionPage(
                                    url:
                                        "https://cdn.pixabay.com/photo/2013/11/01/19/31/rice-fields-204139_960_720.jpg",
                                    itemName: "Paddy",
                                    quantity: 200.toString(),
                                    condition: "Excellent",
                                  )));
                    },
                    child: listingCard(
                        "https://cdn.pixabay.com/photo/2013/11/01/19/31/rice-fields-204139_960_720.jpg",
                        "Paddy",
                        200,
                        "Excellent"),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DescriptionPage(
                                    url:
                                        "https://images.pexels.com/photos/1459331/pexels-photo-1459331.jpeg",
                                    itemName: "Corn",
                                    quantity: 100.toString(),
                                    condition: "Good",
                                  )));
                    },
                    child: listingCard(
                        "https://images.pexels.com/photos/1459331/pexels-photo-1459331.jpeg",
                        "Corn",
                        100,
                        "Good"),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DescriptionPage(
                                    url:
                                        "https://images.pexels.com/photos/735540/pexels-photo-735540.jpeg",
                                    itemName: "Pumpkin",
                                    quantity: 100.toString(),
                                    condition: "Great",
                                  )));
                    },
                    child: listingCard(
                        "https://images.pexels.com/photos/735540/pexels-photo-735540.jpeg",
                        "Pumpkin",
                        100,
                        "Great"),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }

    Padding thinDiv() {
      return Padding(
        padding: EdgeInsets.only(left: height * 0.06, right: 4),
        child: Divider(
          color: Colors.grey.shade400,
          thickness: 0.1,
        ),
      );
    }

    Container listing(
        String url, String itemName, int quantity, String condition) {
      return Container(
        margin: EdgeInsets.all(4),
        height: height * 0.064,
        width: width * 0.91,
        decoration: BoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(children: [
              Container(
                height: height * 0.064,
                width: width * 0.15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(url),
                  ),
                ),
              ),
              Container(
                height: height * 0.064,
                width: width * 0.15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                    gradient: LinearGradient(colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.5)
                    ])),
              )
            ]),
            Container(
              width: width * 0.62,
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(width: 1, color: Colors.grey.shade300))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          itemName,
                          textScaleFactor: 0.9,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: [
                        textshow2("Quantity : ", quantity.toString()),
                        textshow2("Condition : ", condition)
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

    Container row(List<String> urls, List<String> descriptions,
        List<int> quantities, List<String> conditions) {
      return Container(
        height: height * 0.298,
        width: width * 0.81,
        margin: EdgeInsets.all(3),
        child: Stack(children: [
          Column(
            children: [
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DescriptionPage(
                                  url: urls[0],
                                  itemName: descriptions[0],
                                  quantity: quantities[0].toString(),
                                  condition: conditions[0],
                                )));
                  },
                  child: listing(
                      urls[0], descriptions[0], quantities[0], conditions[0])),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DescriptionPage(
                                  url: urls[1],
                                  itemName: descriptions[1],
                                  quantity: quantities[1].toString(),
                                  condition: conditions[1],
                                )));
                  },
                  child: listing(
                      urls[1], descriptions[1], quantities[1], conditions[1])),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DescriptionPage(
                                  url: urls[2],
                                  itemName: descriptions[2],
                                  quantity: quantities[2].toString(),
                                  condition: conditions[3],
                                )));
                  },
                  child: listing(
                      urls[2], descriptions[2], quantities[2], conditions[2])),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DescriptionPage(
                                  url: urls[3],
                                  itemName: descriptions[3],
                                  quantity: quantities[3].toString(),
                                  condition: conditions[3],
                                )));
                  },
                  child: listing(
                      urls[3], descriptions[3], quantities[3], conditions[3])),
            ],
          ),
        ]),
      );
    }

    Widget CircleButton(){
      return Container(

        height: height * 0.075,
        width: width* 0.95,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height * 0.006),
            border: Border.all(color: Colors.grey.shade700,width: 0.5),
            gradient: LinearGradient(
            colors:[
              Colors.grey.shade50,
              Colors.grey.shade100,
            ]
        )
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              
              Text(
                "Add New Listing",
                textScaleFactor: 0.9,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Poppins"
                ),
              ),
            ],
          ),
        ),


      );



    }


    Widget similarListings() {
      return Stack(children: [
        Container(
          margin: EdgeInsets.all(10),
          height: height * 0.40,
          width: width * 0.96,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 9.0, top: 2),
                child: Row(
                  children: [
                    Text(
                      "Nearby Listings",
                      textScaleFactor: 0.9,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              innerDiv(),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    row([
                      'https://cdn.pixabay.com/photo/2017/05/19/15/16/countryside-2326787_960_720.jpg',
                      'https://cdn.pixabay.com/photo/2016/11/21/16/40/agriculture-1846358_960_720.jpg',
                      'https://cdn.pixabay.com/photo/2011/08/17/12/52/wheat-8762_960_720.jpg',
                      'https://cdn.pixabay.com/photo/2013/08/20/15/47/poppies-174276_960_720.jpg'
                    ], [
                      'Wheat',
                      'Lemons',
                      'Barley',
                      'Roses'
                    ], [
                      150,
                      170,
                      90,
                      80
                    ], [
                      "Great",
                      "Good",
                      "Good",
                      "Good"
                    ]),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Divider(
                        color: Colors.grey.shade600,
                        thickness: 22,
                      ),
                    ),
                    row([
                      'https://cdn.pixabay.com/photo/2017/05/19/15/16/countryside-2326787_960_720.jpg',
                      'https://cdn.pixabay.com/photo/2016/11/21/16/40/agriculture-1846358_960_720.jpg',
                      'https://cdn.pixabay.com/photo/2011/08/17/12/52/wheat-8762_960_720.jpg',
                      'https://cdn.pixabay.com/photo/2013/08/20/15/47/poppies-174276_960_720.jpg'
                    ], [
                      'Wheat',
                      'Lemons',
                      'Barley',
                      'Roses'
                    ], [
                      150,
                      170,
                      90,
                      80
                    ], [
                      "Great",
                      "Good",
                      "Good",
                      "Good"
                    ]),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Divider(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    row([
                      'https://cdn.pixabay.com/photo/2017/05/19/15/16/countryside-2326787_960_720.jpg',
                      'https://cdn.pixabay.com/photo/2016/11/21/16/40/agriculture-1846358_960_720.jpg',
                      'https://cdn.pixabay.com/photo/2011/08/17/12/52/wheat-8762_960_720.jpg',
                      'https://cdn.pixabay.com/photo/2013/08/20/15/47/poppies-174276_960_720.jpg'
                    ], [
                      'Wheat',
                      'Lemons',
                      'Barley',
                      'Roses'
                    ], [
                      150,
                      170,
                      90,
                      80
                    ], [
                      "Great",
                      "Good",
                      "Good",
                      "Good"
                    ]),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: height * 0.04,
                    width: width * 0.15,
                    decoration:
                        BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                        Colors.grey.shade100,
                              Colors.grey.shade200
                            ]
                          ),
                          borderRadius: BorderRadius.circular(12)
                        
                        ),
                    child: Center(
                      child: Text("View All",style: TextStyle(color: Colors.black,fontFamily: "Poppins",fontWeight: FontWeight.w600,fontSize: 11),),
                    ),
                  ),
                ],
              ),


            ],
          ),
        ),
      ]);
    }


    Padding div() {
      return Padding(
        padding: const EdgeInsets.all(5),
        child: Divider(
          color: Colors.grey.shade300,
          thickness: 1,
        ),
      );
    }

    return Scaffold(
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: Colors.greenAccent.shade200,
      //   isExtended: true,
      //   label: Text(
      //     "Create New Listing",
      //     style: TextStyle(
      //         color: Colors.black,
      //         fontSize: 12,
      //         fontFamily: "Poppins",
      //         fontWeight: FontWeight.w700),
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        automaticallyImplyLeading: true,
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
        title: Text("Marketplace",
            style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold)),
      ),
      backgroundColor: Colors.grey.shade50,
      endDrawer: SearchFilter(updateKeyWord),
      body: Stack(
        children:[ SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [currentListing(), div(), similarListings(),InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct()));
                  },
                  child: CircleButton())],
            ),
          ),
        ),
      ]),
    );
  }
}
