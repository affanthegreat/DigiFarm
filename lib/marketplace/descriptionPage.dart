import 'package:flutter/material.dart';

class DescriptionPage extends StatefulWidget {
  String url;
  String condition;
  String itemName;
  String quantity;

  DescriptionPage({this.url, this.condition, this.quantity, this.itemName});

  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  @override
  Widget build(BuildContext context) {
    RichText textshow(String str1, String str2) {
      return RichText(
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
                        fontSize: 15))
              ]));
    }




    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    bool isContactClicked = false;
    Container imageCard(String url){
      return Container(
        height: height * 0.2,
        width:  width * 0.54,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade100,width: 1),
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.cover
          )
        ),
      );

    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [

          Stack(children: [
            Container(
              height: height * 0.40,
              width: width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.url), fit: BoxFit.cover)),

            ),
            Container(
                height: height * 0.40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topRight,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ]),
                ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                InkWell(
                  onTap: (){
                    setState(() {
                    Navigator.of(context).push(PageRouteBuilder(opaque: false,pageBuilder:  (BuildContext context,_,__)=> Contact()));
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text("Contact Seller",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 14,fontFamily: "Poppins"),),
                    ),
                  ),
                )
              ],


            ),
            ),
            Container(
                height: height * 0.37,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(widget.itemName,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontFamily: "Poppins",fontSize: 33),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textshow("Condition : ", widget.condition),
                      textshow("Quantity :", widget.quantity),
                      textshow("Owned by : ", "Random"),
                    ],
                  )


                ],

              ),
            )
          ]),

          Container(
            height: height * 0.60,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(50)),
              color: Colors.white
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("About Crop",style: TextStyle(color: Colors.black,fontFamily: "Poppins",fontSize: 20,fontWeight: FontWeight.w600),),
                    ),
                  ],
                ),
                Container(
                  width: width * 0.85,
                  height:  height * 0.20,
                  child: SingleChildScrollView(
                    child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras imperdiet efficitur blandit. Vestibulum et eleifend purus. Donec convallis mauris fringilla, vulputate quam congue, interdum velit. Mauris mattis ullamcorper velit. Nam eu justo et turpis pharetra ultrices finibus et nulla. Donec tincidunt mattis odio ac posuere. Proin tincidunt felis id turpis ullamcorper pellentesque. Fusce facilisis laoreet diam. Mauris rhoncus sit amet nibh ut placerat. Curabitur molestie, felis ut bibendum posuere, velit nisl pellentesque erat, a mattis libero arcu sit amet tellus.",style: TextStyle(fontWeight: FontWeight.w400,fontFamily: "Poppins",color: Colors.black,fontSize: 12),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8.0,bottom: 2.0,left: 30,right: 50),
                  child: Divider(color: Colors.grey.shade400,thickness: 1,),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,top: 4,bottom: 4),
                      child: Text("Images",style: TextStyle(color: Colors.black,fontFamily: "Poppins",fontSize: 20,fontWeight: FontWeight.w600),),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:Row(
                    children: [
                      imageCard(widget.url),
                      imageCard('https://images.pexels.com/photos/1058401/pexels-photo-1058401.jpeg')
                    ],
                  ),
                )


              ],
            ),
          )
        ],
      ),
    );
  }
}

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {


    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.55),
      body: Center(
        child: Container(
          height: height * 0.3,
          width: width *0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Random",style: TextStyle(color: Colors.black,fontFamily: "Poppins",fontSize: 24,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Dharmapuri, Forest Colony, Tajganj, Agra, Uttar Pradesh 282001",style: TextStyle(color: Colors.black,fontFamily: "Poppins",fontSize: 16,fontWeight: FontWeight.w500),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("8555639160",style: TextStyle(color: Colors.black,fontFamily: "Poppins",fontSize: 17,fontWeight: FontWeight.w600),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
