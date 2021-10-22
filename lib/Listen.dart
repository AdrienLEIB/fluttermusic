import 'package:flutter/material.dart';

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
  double position= 0.0;
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
            Icon(Icons.play_arrow, size:40),
            Icon(Icons.fast_forward)
          ],
        ),
        Slider.adaptive(
            value: position,
            activeColor: Colors.blueAccent,
            inactiveColor: Colors.cyanAccent,
            onChanged: (va){
              setState(() {
                position = va;
              });
              print(position);
            })
      ],
    );
  }

}



