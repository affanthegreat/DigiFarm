
import 'package:flutter/material.dart';


class informationPage extends StatefulWidget {

  List<String> titles;
  List<String> Paragraphs;
  List<String> imageLocs;

  informationPage({this.Paragraphs,this.titles});



  @override
  _informationPageState createState() => _informationPageState();
}
//
class _informationPageState extends State<informationPage> {
var x = 0.1;

  @override
  void initState() {
    // TODO: implement initState
    blurrAnimation();
    super.initState();
  }

  blurrAnimation() async {
    for (var i = 0.1; i < 0.6; i = i + 0.1) {
      await Future.delayed(const Duration(milliseconds: 75), () {});
      setState(() async {
        x = i;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    Widget Card() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: height * 0.20,
          width: width * 0.6,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400, width: 0.6)),
        ),
      );
    }

    Padding community() {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 40, top: 20, bottom: 5),
        child: Container(
          height: height * 0.274,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "What Our Community Uses",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        fontSize: 18),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey.shade600,
                thickness: 0.5,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Card(), Card(), Card()],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Padding heading(String x) {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 40, top: 20, bottom: 5),
        child: Row(
          children: [
            Container(
                width: width * 0.8,
                child: Text(x,
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Padding Paragraph(String x) {
    return Padding(
      padding:
      const EdgeInsets.only(left: 20.0, right: 20, top: 5, bottom: 10),
      child: Text(x,
          style: TextStyle(
              fontSize: 16,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w400)),
    );
  }

  return Scaffold(
      backgroundColor: Colors.black.withOpacity(x),
      body: GestureDetector(


        child: ListView.builder(

          itemCount: widget.Paragraphs.length,
          itemBuilder: (context, index) {
            return Container(
              margin: index == 0
                  ? EdgeInsets.only(top: height * 0.03)
                  : EdgeInsets.all(0),
              decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.only(
                      topRight: index == 0
                          ? Radius.circular(height * 0.03)
                          : Radius.circular(0),
                      topLeft: index == 0
                          ? Radius.circular(height * 0.03)
                          : Radius.circular(0)
                  )
              ),
              child: Column(
                  children: [
                    heading(widget.titles[index]),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 30),
                      child: Divider(
                        thickness: 1, color: Colors.greenAccent,),
                    ),
                    index == 0 ? community() : Container(),
                    Paragraph(widget.Paragraphs[index]),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Divider(thickness: 0.5, color: Colors.black,),
                    ),
                  ]),
            );
          },
        ),
      )
  );
}
}
