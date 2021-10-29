import 'dart:async';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'Func/firestoreHelper.dart';
import 'Model/music.dart';


class Listen extends StatefulWidget{
  Music music;
  int index;
  Listen({required Music this.music, required int this.index});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ListenState();
  }

}
class ListenState extends State<Listen>{

  //Variable

  statut lecture=statut.stopped;
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration position= Duration(seconds: 0);
  late StreamSubscription positionStream;
  late StreamSubscription stateStream;
  Random random = Random();














  Duration duree = Duration(seconds: 0);
  late PlayerState pointeur;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    configurationPlayer();
  }





  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.blueAccent,
        title: Text(widget.music.title),
      ),
      body: BodyState(),
    );
  }

  Widget BodyState(){
    return StreamBuilder<QuerySnapshot>(
    stream: firestoreHelper().firescloud_music.snapshots(),
    builder: ( context,  snapshots) {
      return Column(
        children: [
          SizedBox(height: 10,),
          Center(
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 1.2,
              height: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage(widget.music.image),
                      fit: BoxFit.fill
                  )
              ),
            ),
          ),
          Text(widget.music.title),
          Text(widget.music.author),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.fast_rewind),
                onPressed: () {
                  lecture = statut.playing;
                  List documents = snapshots.data!.docs;
                  rewind(documents);
                },

              ),
              (lecture == statut.stopped) ? IconButton(
                icon: Icon(Icons.play_arrow, size: 40),
                onPressed: () {
                  setState(() {
                    lecture = statut.paused;
                    play();
                  });
                },
              ) :
              IconButton(
                icon: Icon(Icons.pause, size: 40,),
                onPressed: () {
                  //musique en pause
                  setState(() {
                    lecture = statut.stopped;
                    pause();
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.fast_forward),
                onPressed: () {
                  List documents = snapshots.data!.docs;
                  int maxdoc = documents.length;
                  // int index = random.nextInt(maxdoc);
                  int index = widget.index +1;
                  if (index>=maxdoc){
                    index = 0;
                  }

                  Music music = Music(documents[index]);
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return Listen(music: music,index: index);
                  }));
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(duree.inMinutes.toString()),
              Text("0.0")

            ],
          ),
          Slider.adaptive(
              max: 100,
              min: 0,
              value: position.inSeconds.toDouble(),
              activeColor: Colors.blueAccent,
              inactiveColor: Colors.cyanAccent,
              onChanged: (va) {
                setState(() {
                  Duration duree = Duration(seconds: va.toInt());
                  position = duree;
                });
                print(position);
              }),
          IconButton(
            icon: Icon(Icons.mail, size: 40,),
            onPressed: () {
              //musique en pause
              NotificationProgramme();
            },
          ),

        ],
      );
    }
    );
  }



  Future play() async {
    if(position>Duration(seconds: 0)){
      await audioPlayer.play(widget.music.path_song,position: position);
    }
    else{
      await audioPlayer.play(widget.music.path_song,);
    }


    //configurationPlayer();

  }

  Future pause() async {
    await audioPlayer.pause();
    audioPlayer.seek(position);
    //configurationPlayer();

  }

  rewind(List documents){
    if(position>= Duration(seconds: 5)){
      setState(() {
        audioPlayer.stop();
        audioPlayer.seek(Duration(seconds: 0));
        position = new Duration(seconds: 0);
        audioPlayer.play(widget.music.path_song);
      });
    }else{


      int maxdoc = documents.length;
      int index = widget.index -1;
      if (index<0){
        index = maxdoc-1;
      }
      Music music = Music(documents[index]);
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return Listen(music: music,index: index);
      }
      )

      );
    }
  }



  configurationPlayer(){
    //audioPlayer = new AudioPlayer();
    positionStream = audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position =event;
      });
    });
    stateStream = audioPlayer.onPlayerStateChanged.listen((event) {
      if(event == statut.playing){
        setState(() async {

          duree = audioPlayer.getDuration() as Duration;
          print(duree);
        });



      } else if(event == statut.stopped){
        setState(() {
          lecture = statut.stopped;

        });
      }


    },onError: (message){
      print("erreur : $message");
      setState(() {
        lecture = statut.stopped;
        position = Duration(seconds: 0);
        duree = Duration(seconds: 0);
      });
    }
    );


  }

  NotificationProgramme() async {
    String localTimeZone =
    await AwesomeNotifications().getLocalTimeZoneIdentifier();
    print(localTimeZone);

    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: 'This is my notification 2',
            body: 'This is my message of my notification 2'),
        schedule: NotificationCalendar(
            second: 0,
            millisecond: 0,
            timeZone: localTimeZone,
            repeats: true));
  }

}






enum statut{
  playing,
  stopped,
  paused,
  rewind,
  forward
}