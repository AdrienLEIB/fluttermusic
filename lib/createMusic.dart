import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttermusic/Func/firestoreHelper.dart';
import 'package:fluttermusic/Listen.dart';
import 'package:fluttermusic/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';// For Image Picker
import 'package:path/path.dart' as Path;
import 'Model/music.dart';


class createMusic extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return createMusicState();
  }

}


class createMusicState extends State<createMusic>{
  String author='';
  String image='';
  String path_song='';
  String title='';
  String title_album = '';
  double time= 0.0;
  String type_music='';
  bool _loadingPath = false;
  String? _fileName;
  List<PlatformFile>? _paths;
  List<PlatformFile>? _paths_song;
  String? _directoryPath;
  String? _extension;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late File  _image;
  String _uploadedFileURL = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Music'),
      ),
      body: bodyPage(),
    );
  }



  Widget bodyPage(){
    return SingleChildScrollView(child:
    Container(
      padding: EdgeInsets.all(20),
      child: Column(

        children: [
          //nom
          TextField(
            onChanged: (String value){
              setState(() {

                author=value;
              });
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),

                ),
                fillColor: Colors.white,
                filled: true,
                hintText: "Author"
            ),

          ),
          SizedBox(height: 20,),
          //prenom
          TextField(
            onChanged: (String value){
              setState(() {
                title=value;

              });
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),

                ),
                fillColor: Colors.white,
                filled: true,
                hintText: "Title"
            ),

          ),
          SizedBox(height: 20,),
          //pseudo
          TextField(
            onChanged: (String value){
              setState(() {
                title_album=value;

              });
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),

                ),
                fillColor: Colors.white,
                filled: true,
                hintText: "Title Album"
            ),

          ),
          //adresse
          SizedBox(height: 20,),
          TextField(
            onChanged: (String value){
              setState(() {
                type_music=value;

              });
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),

                ),
                fillColor: Colors.white,
                filled: true,
                hintText: "Type Music"
            ),

          ),
          SizedBox(height: 20,),
          TextFormField(
            keyboardType: TextInputType.number,
            onChanged: (value){
              setState(() {
                time=double.parse(value);

              });
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: "Time"
            ),

          ),
          Semantics(
            label: 'import Img',
            child: FloatingActionButton(
              onPressed: () {
                _openFileExplorer();
              },
              heroTag: 'image0',
              tooltip: 'Pick Image from gallery',
              child: const Icon(Icons.photo),
            ),
          ),

          Semantics(
            label: 'import MP3',
            child: FloatingActionButton(
              onPressed: () {
                _openFileExplorer2();
              },
              heroTag: 'mp3',
              tooltip: 'Pick Song of gallery',
              child: const Icon(Icons.album),
            ),
          ),
          ElevatedButton(

              onPressed: (){
                uploadProfileImage();
                uploadSong();
                Map<String,dynamic> map ={
                  "author":author,
                  "title":title,
                  "title_album":title_album,
                  "time": time,
                  "image":  image,
                  "path_song": path_song,
                  "type_music":type_music,
                };

                //Enregistrement dans la base du donnée
                firestoreHelper().addMusic(map);
                int index = 0;
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context){
                      return MyApp();
                      //return Listen(music: Music(map),index: index);
                    }
                ));

              },
              child: Text('Enregistrer')
          ),

        ],
      ),
    )

    );

  }


  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      print(_paths!.first.extension);
      _fileName =
      _paths != null ? _paths!.map((e) => e.name).toString() : '...';

    });
  }

  uploadProfileImage() async {
    File file = File(_paths!.first.path.toString());
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('img/${Path.basename(_paths!.first.path.toString())}');
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    image = await snapshot.ref.getDownloadURL();
  }



  void _openFileExplorer2() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths_song = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      print(_paths_song!.first.extension);
      _fileName =
      _paths != null ? _paths_song!.map((e) => e.name).toString() : '...';

    });
  }

  uploadSong() async {
    File file = File(_paths_song!.first.path.toString());
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('music/${Path.basename(_paths_song!.first.path.toString())}');
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    path_song = await snapshot.ref.getDownloadURL();
  }
}