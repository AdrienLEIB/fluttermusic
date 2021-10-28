import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'Model/music.dart';


class Listen extends StatefulWidget{
  Music music;
  Listen({required Music this.music});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ListenState();
  }

}


class ListenState extends State<Listen>{
  // double position= 0.0;
  bool isPlay = false;
  statut lecture=statut.rewind;
  // AudioPlayer audioPlayer = AudioPlayer();
  Duration position = Duration(seconds: 0);
  late StreamSubscription positionStream;
  late StreamSubscription stateStream;
  late AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.blueAccent,
        title: Text(widget.music.title_album),
      ),
      body:
        BodyState(),
    );
  }

  Widget BodyState(){
    return Column(
      children: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width/2,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(
                  widget.music.image
                ),
                fit: BoxFit.fill,
              )
            )
          ),
        ),
        Text('${widget.music.author} : ${widget.music.title_album}'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fast_rewind),
            // (lecture==statut.stopped)?Icon(Icons.play_arrow, size:40):Icon(Icons.stop_circle),
            IconButton(
              icon:(isPlay) ?   Icon(Icons.pause, size: 40) : Icon(Icons.play_arrow, size: 40),
              onPressed: (){
                setState(()
                {
                 isPlay = !isPlay;
                 lecture == statut.playing ? pause() : lecture==statut.rewind ? play() : print('toto');
                });
              },
            ),
            Icon(Icons.fast_forward)
          ],
        ),
        Slider.adaptive(
            value: position.inSeconds.toDouble(),
            min: 0.0,
            max: widget.music.time,
            activeColor: Colors.blueAccent,
            inactiveColor: Colors.cyanAccent,
            onChanged: (va){
              setState(() {
                Duration time = Duration(seconds: va.toInt());
                position = time;
              });
            }),
      ],
    );
  }

  play() async{
    configurationPlayer();
    // await audioPlayer.stop();
    int result = await audioPlayer.play(widget.music.path_song);
    if (result == 1){
      setState(() {
        lecture = statut.playing;
      });
    };

  }

  pause() async{
    int result = await audioPlayer.stop();
    if (result == 1) {
      setState(() {
        lecture = statut.rewind;
      });
    };

  }

  configurationPlayer(){
    audioPlayer = AudioPlayer();
    audioPlayer.setVolume(1.0);
    positionStream = audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
      stateStream = audioPlayer.onPlayerStateChanged.listen((event) {
        setState(() {
          if(event == statut.playing){

          }
        });
      });
    });
  }
}


enum statut{
  playing,
  stopped,
  rewind,
  forward,
}


