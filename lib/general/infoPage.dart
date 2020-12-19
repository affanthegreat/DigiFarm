
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



  @override
  Widget build(BuildContext context) {




    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;


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

      body:SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height,
              decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(height * 0.03),
                      topLeft: Radius.circular(height * 0.03))
              ),
              child: ListView.builder(

                itemCount: widget.Paragraphs.length,
                itemBuilder: (context,index){
                  return Column(
                    children: [
                      heading(widget.titles[index]),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 30),
                        child: Divider(
                          thickness: 1, color: Colors.greenAccent,),
                      ),
                      Paragraph(widget.Paragraphs[index]),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Divider(thickness: 0.5, color: Colors.black,),
                      ),
                    ]);
                },
              ),
            )
          ],
        ),
      )
    );
  }
}
