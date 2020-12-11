import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

int pageLocation = 0;
int previous = -13123;
var instack1 = true;
var u ;
class NewsArticles{
  String description;
  String url;
  String photoUrl;
  NewsArticles(String description, String url,String photoUrl){
    this.description = description;
    this.url = url;
    this.photoUrl = photoUrl;
  }
  getDescription(){
    return description;
  }
  getUrl(){
    return url;
  }
  getPhotoUrl(){
    return photoUrl;
  }

  uploadNews(List<NewsArticles> genericNews) async{
    for(int i = 0; i < genericNews.length ; i++){
      await FirebaseFirestore.instance
          .collection('News')
          .doc(i.toString())
          .set({
        'description': genericNews[i].description,
        'url': genericNews[i].url,
        'photourl':genericNews[i].photoUrl
      });
    }

  }
}

