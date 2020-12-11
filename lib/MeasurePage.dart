import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:digifarm/main.dart';
import 'package:digifarm/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class MeasurePage extends StatefulWidget {

  String descriptiveHeading;
  String descriptiveSubHeading;
  String monthDescription;
  String yearDescription;
  String collectionName;
  String floatingButtonLabel;
  String infoButtonLabel;
  String appBarTitle;
  MeasurePage({this.collectionName,this.descriptiveHeading,this.descriptiveSubHeading,this.monthDescription,this.yearDescription,this.floatingButtonLabel,this.infoButtonLabel,this.appBarTitle});


  @override
  _MeasurePageState createState() => _MeasurePageState();
}

class _MeasurePageState extends State<MeasurePage> {


  static Widget _presentIcon(String day) => Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(
            Radius.circular(1000),
          ),
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );

  static Widget _absentIcon(String day) => Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(
            Radius.circular(1000),
          ),
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

  CalendarCarousel _calendarCarouselNoHeader;
  var len = 9;
  double cHeight;


  Container miniCard(String txt, String text) {
    return Container(
      margin: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.10,
      width: MediaQuery.of(context).size.width * 0.42,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey.shade100,
                Colors.white
              ]),
          border: Border.all(color: Colors.grey.shade300, width: 1)),
      child: Center(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              txt,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 8,fontFamily: "Poppins"),
            ),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19,fontFamily: "Poppins"),
            )

          ],
        ),
      ),
    );
  }

  Widget markerRepresent(Color color, String data) {
    return new ListTile(
      leading: new CircleAvatar(
        backgroundColor: color,
        radius: cHeight * 0.015,
      ),
      title: new Text(
        data,
      ),
    );
  }

  List<int> values = new List(12);

  var black = Colors.black;
  var month= ["January","February","March","April","May","June","July", "August","September","October","November","December"];
  bool isLoading = true;
  void getData() async {

    DocumentSnapshot  x =await FirebaseFirestore.instance.collection('Users').doc(u.uid).collection(widget.collectionName).doc(DateTime.now().year.toString()).get();
    for(int i = 0; i<month.length; i++){
      values[i] = x[month[i]];
      print(values[i]);
    }
    setState(() {
      isLoading = false;
    });
  }
  int sum(List<int> x){
    int sum=0;
    for(int i=0;i<x.length; i++ ){
      sum = sum + x[i];
    }
    return sum;
  }
  void updater() {
    int x =DateTime.now().month.toInt() - 1;
    FirebaseFirestore.instance.collection('Users').doc(u.uid).collection(widget.collectionName).doc(DateTime.now().year.toString()).update(
        {
          month[DateTime
              .now()
              .month
              .toInt() - 1]: values[x]
        });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var grad1 = BoxDecoration(
        gradient: SweepGradient(
          colors: <Color>[Colors.grey.shade50, Colors.white],
          transform: GradientRotation(3.1415926535897932 / 6),
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200, width: 1));

    var grad2 = BoxDecoration(
      border: Border.all(color: Colors.grey.shade300,width: 1),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade100
            ]),
        borderRadius: BorderRadius.circular(8)
    );

    var grad3 = BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.shade100,
              Colors.grey.shade100.withOpacity(0.75)
            ]),
        border: Border.all(color: Colors.greenAccent.shade100, width: 1));

    var data= [
      new ClicksPerYear("Jan", values[0], black),
      new ClicksPerYear("Feb", values[1], black),
      new ClicksPerYear("Mar", values[2], black),
      new ClicksPerYear('Apr', values[3], black),
      new ClicksPerYear("May", values[4], black),
      new ClicksPerYear("Jun", values[5], black),
      new ClicksPerYear("July", values[6], black),
      new ClicksPerYear('Aug', values[7], black),
      new ClicksPerYear("Sept", values[8], black),
      new ClicksPerYear("Oct", values[9], black),
      new ClicksPerYear("Nov", values[10], black),
      new ClicksPerYear('Dec', values[11], black ),

    ];
    var series = [
      new charts.Series(
        id: 'Clicks',
        domainFn: (ClicksPerYear clickData, _) => clickData.year,
        measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
        colorFn: (ClicksPerYear clickData, _) => clickData.color,
        data: data,
      ),
    ];
    var chart = charts.BarChart(
      series,
      animate: true,
    );
    var chartWidget = Padding(
      padding: EdgeInsets.all(32.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        child: chart,
      ),
    );


    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent.shade200,
        onPressed: () {
          var x = new DateTime.now().month.toInt();
          setState(() {
            values[x - 1]++;
          });
          updater();
        },
        label: Text(
          widget.floatingButtonLabel,
          style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 12,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ), // 3
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ), // 4
      ),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text(widget.appBarTitle,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black,fontFamily: "Poppins"),),
        centerTitle: true,
      ),
      body: isLoading==false?SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left:10,right: 10),
              height: MediaQuery.of(context).size.height * 0.12,
              width: MediaQuery.of(context).size.width,
              decoration: grad1,
              child: Center(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.descriptiveHeading,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Poppins"),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              child: Text(
                                widget.descriptiveSubHeading,
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.black, fontSize: 12 ),
                              )),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 8.0),
              child: Divider(color: Colors.greenAccent.shade100,thickness: 1,),
            ),
            Container(
              margin: EdgeInsets.only(left: 8,right: 8.0),
              height: MediaQuery.of(context).size.height * 0.23,
              width: MediaQuery.of(context).size.width,
              decoration: grad2,
              child:Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                            miniCard(widget.monthDescription, "${values[DateTime.now().month - 1]}"),
                        miniCard(widget.yearDescription, "${sum(values)}")
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 8,
                      decoration: grad3,
                      child: Center(
                          child: Text(widget.infoButtonLabel,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Poppins",fontSize: 12),),
                      ),
                      ),

                  ],
                ),
              ) ,
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 8.0),
              child: Divider(color: Colors.greenAccent.shade100,thickness: 1,),
            ),
            Container(

              width: MediaQuery.of(context).size.width * 0.95,
              decoration: grad2 ,
                child: chartWidget),

          ],
        ),
      ):Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;



  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);


}