import 'package:flutter/material.dart';


class Listen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ListenState();
  }

}


class ListenState extends State<Listen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.blueAccent,
        title: Text('Jean Ragnarock'),
      ),
      body:
        BodyState(),
    );
  }

}

Widget BodyState(){
  return Text(
    "Angeme"
  );
}