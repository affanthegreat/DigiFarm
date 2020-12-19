
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


   Container heading(String x){
      return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 40,right: 40,top: 20,bottom: 20),
            child: Text(x.toUpperCase(),style: TextStyle(fontSize:20,fontFamily: "Poppins",fontWeight: FontWeight.bold)),
          ));
    }
  Padding Paragraph(String x){
      return Padding(
        padding: const EdgeInsets.only(left:20.0,right: 20,top: 10,bottom: 10),
        child: Text(x,style: TextStyle(fontSize:16,fontFamily: "Poppins",fontWeight: FontWeight.w400)),
      );
    }


    return Scaffold(

      body:SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(height * 0.03),topLeft: Radius.circular(height * 0.03))
              ),
              child: ListView.builder(

                itemCount: widget.Paragraphs.length,
                itemBuilder: (context,index){
                  return Column(
                    children:[
                    heading(widget.titles[index]),
                    Paragraph(widget.Paragraphs[index])
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
