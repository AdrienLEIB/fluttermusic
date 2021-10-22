import 'package:cloud_firestore/cloud_firestore.dart';

class Music{
  late String title;
  late String author;
  late String title_album;
  late String type_music;
  late String image;
  late double time;
  late String path_song;

  Music(DocumentSnapshot snapshot){
    String identifiant = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    title = map["title"];
    author  = map["author"];
    title_album  = map["title_album"];
    type_music   = map["type_music"];
    image  = map["image"];
    time  = map["time"];
    path_song  = map["path_song"];

  }

}