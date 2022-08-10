import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_car/models/car_model.dart';
class InfoPage extends StatefulWidget {
  static const id = 'info_page';
  final Post? post;
  const InfoPage({this.post, Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  Post? updatePost;
  File? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Info Page"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey,
              child: Center(
                child: Container(
                  color: Colors.red,
                  height: 200,
                  width: 230,
                  child: widget.post != null &&
                      widget.post!.image != null &&
                      file == null
                      ? Image.network(widget.post!.image!, fit: BoxFit.cover,)
                      : file == null
                      ? const Image(
                      image: AssetImage('assets/images/placeholder.jpeg'),
                  )
                      : Image.file(file!),
                ),
              ),
            ),
          ),
          const SizedBox(height: 25,),
          const Divider(
            color: Colors.black,
            thickness: 2,
          ),
          const SizedBox(height: 25,),
          Text("NAME:  ${widget.post!.name}", style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold
          ),),
          const SizedBox(height: 25,),
          const Divider(
            color: Colors.black,
            thickness: 2,
          ),
          const SizedBox(height: 25,),
          Text("DESCRIPTION:  ${widget.post!.content}", style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold
          ),),
          // Text(updatePost!.name),
        ],
      ),
    );
  }
}
