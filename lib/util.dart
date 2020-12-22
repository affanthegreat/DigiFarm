import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        'photourl': genericNews[i].photoUrl
      });
    }
  }
}

class TransparentRoute extends PageRoute<void> {
  TransparentRoute({
    @required this.builder,
    RouteSettings settings,
  })  : assert(builder != null),
        super(settings: settings, fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;
  var curve = Curves.linear;

  @override
  Duration get transitionDuration => Duration(milliseconds: 350);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return SlideTransition(
      transformHitTests: false,
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: curve,
        ),
      ),
      child: new SlideTransition(
        position: new Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0.0, -1.0),
        ).animate(
          CurvedAnimation(
            parent: secondaryAnimation,
            curve: curve,
          ),
        ),
        child: result,
      ),
    );
  }
}
