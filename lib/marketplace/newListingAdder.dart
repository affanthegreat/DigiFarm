import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String productName;
  String description;
  String phoneNumber;
  String address;




  @override
  Widget build(BuildContext context) {



    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;



    File _image1;
    File _image2;
    File _image3;
    int imagesIndex = 0;
    final picker = ImagePicker();


    Widget imgCard(File filename){
      return InkWell(
        onTap: ()async{
          final pickedFile = await picker.getImage(source: ImageSource.gallery);

          setState(() {
            if (pickedFile != null) {
              filename = File(pickedFile.path);
            } else {
              print('No image selected.');
            }
          });
        },
        child: Container(
          height: height * 0.22,
          width: width * 0.65,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400,width: 0.8),
            borderRadius: BorderRadius.circular(8),
              color: Colors.white
          ),
          child:  Center(
            child: filename==null
                ? Text('+',style: TextStyle(color: Colors.black,fontFamily: "Poppins", fontWeight: FontWeight.w400,fontSize: 34),)
                : Image.file(filename),
          ),
        ),
      );

    }
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.grey.shade50,
        title: Text("Add New Product",style: TextStyle(
          color: Colors.black,fontFamily: "Poppins",fontWeight: FontWeight.bold,
          fontSize: 20
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(

                padding: const EdgeInsets.only(bottom:8.0),
                child: Row(
                  children: [
                    Center(
                      child: Text("Select your Crop Name from the List.",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600,fontFamily: "Poppins"),)
                    ),
                  ],
                ),
              ),

              Container(
                color: Colors.white,
                child: SimpleAutoCompleteTextField(
                  textChanged: (text) => productName = text,
                  suggestions: [
                    "Apple",
                    "Armidillo",
                    "Actual",
                    "Actuary",
                    "America",
                    "Argentina",
                    "Australia",
                    "Antarctica",
                    "Blueberry",],
                  style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500,fontFamily: "Poppins"),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey.shade50,
                      hintText: 'Crop Name',
                      hintStyle:TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.w500,fontFamily: "Poppins")
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 1,
                  color: Colors.greenAccent,
                ),
              ),
              Padding(

                padding: const EdgeInsets.only(bottom:8.0),
                child: Row(
                  children: [
                    Center(
                        child: Text("Your Address",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600,fontFamily: "Poppins"),)
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                child: SimpleAutoCompleteTextField(
                  textChanged: (text) => productName = text,
                  style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500,fontFamily: "Poppins"),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey.shade50,
                      hintText: 'Crop Name',
                      hintStyle:TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.w500,fontFamily: "Poppins")
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 1,
                  color: Colors.greenAccent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom:8.0),
                child: Row(
                  children: [
                    Center(
                        child: Text("Phone Number",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600,fontFamily: "Poppins"),)
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                child: SimpleAutoCompleteTextField(
                  textChanged: (text) => productName = text,
                  style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500,fontFamily: "Poppins"),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey.shade50,
                      hintText: 'Crop Name',
                      hintStyle:TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.w500,fontFamily: "Poppins")
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 1,
                  color: Colors.greenAccent,
                ),
              ),
              Padding(

                padding: const EdgeInsets.only(bottom:8.0),
                child: Row(
                  children: [
                    Center(
                        child: Text("Describe about your crop.",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600,fontFamily: "Poppins"),)
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                child: TextField(
                  maxLines: 7,
                  style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500,fontFamily: "Poppins"),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey.shade50,
                      hintText: 'General description and tell your methods of irrigation and things such as you follow organic farming or not.',
                      hintStyle:TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.w500,fontFamily: "Poppins")
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 1,
                  color: Colors.greenAccent,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom:8.0),
                child: Row(
                  children: [
                    Center(
                        child: Text("Upload few images of your crop.",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600,fontFamily: "Poppins"),)
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                  children: [
                      imgCard(_image1),
                    VerticalDivider(),
                    imgCard(_image2),
                    VerticalDivider(),
                    imgCard(_image3)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 1,
                  color: Colors.greenAccent,
                ),
              ),
              Container(
                height: height * 0.07,
                width: width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade500),
                  color:Colors.white
                ),
                child: Center(child: Text("Save and Add Listing",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600,fontFamily: "Poppins"),)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
