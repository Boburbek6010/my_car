import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_car/services/db_service.dart';
import 'package:my_car/services/rt_db_service.dart';
import 'package:my_car/services/store_service.dart';
import 'package:my_car/services/util_service.dart';

import '../models/car_model.dart';

class DetailPage extends StatefulWidget {
  final DetailState state;
  final Post? post;
  static const id = "/detail_page";

  const DetailPage({this.state = DetailState.create, this.post, Key? key})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool isLoading = false;
  Post? updatePost;
  final ImagePicker _picker = ImagePicker();
  File? file;

  @override
  void initState() {
    super.initState();
    _detectState();
  }

  void _detectState() {
    if (widget.state == DetailState.update && widget.post != null) {
      updatePost = widget.post;
      nameController.text = updatePost!.name;
      contentController.text = updatePost!.content;
      setState(() {});
    }
  }

  void _getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        file = File(image.path);
      });
    } else {
      if (mounted) Utils.fireSnackBar("Please select image for post", context);
    }
  }

  void _addPost() async {
    String name = nameController.text.trim();
    String content = contentController.text.trim();
    String? imageUrl;

    if (name.isEmpty || content.isEmpty) {
      Utils.fireSnackBar("Please fill all fields", context);
      return;
    }
    isLoading = true;
    setState(() {});

    String? userId = await DBService.loadUserId();

    if (file != null) {
      imageUrl = await StoreService.uploadImage(file!);
    }

    Post post = Post(
        postKey: "",
        userId: userId ?? 'my',
        content: content,
        image: imageUrl,
        name: name);


    await RTDBService.storePost(post).then((value) {
      Navigator.of(context).pop('jjj');
      setState(() {});
    });

    isLoading = false;
    setState(() {});

  }

  void _updatePost() async {
    String name = nameController.text.trim();
    String content = contentController.text.trim();
    String? imageUrl;

    if (name.isEmpty || content.isEmpty) {
      Utils.fireSnackBar("Please fill all fields", context);
      return;
    }
    isLoading = true;
    setState(() {});

    if (file != null) {
      imageUrl = await StoreService.uploadImage(file!);
    }

    Post post = Post(
        postKey: updatePost!.postKey,
        userId: updatePost!.userId,
        content: content,
        image: imageUrl,
        name: name);

    await RTDBService.updatePost(post).then((value) {
      Navigator.of(context).pop();
    });

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        title: const Text('Detail Page'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: _getImage,
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      height: 170,
                      width: 200,
                      child: updatePost != null &&
                              updatePost!.image != null &&
                              file == null
                          ? Image.network(updatePost!.image!)
                          : file == null
                              ? const Image(
                                  image: AssetImage('assets/images/logo.png'))
                              : Image.file(file!),
                    ),
                  ),
                ),
                const SizedBox(height: 30,),

                Container(
                  height: 300,
                  width: double.infinity,
                  margin: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      //name of the car
                      TextField(
                        keyboardType: TextInputType.name,
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: "Name of the Car",
                        ),
                        style: const TextStyle(fontSize: 18, color: Colors.black),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 30,),
                      TextField(
                        controller: contentController,
                        decoration: const InputDecoration(
                          hintText: "Description",
                        ),
                        style: const TextStyle(fontSize: 18, color: Colors.black),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 20,),
                      ElevatedButton(
                        onPressed: () {
                          if (widget.state == DetailState.update) {
                            _updatePost();
                            print("updated");
                          } else {
                            print(('object'));
                            _addPost();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50)),
                        child: Text(
                          widget.state == DetailState.update ? "Update" : "Add",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: isLoading,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

enum DetailState {
  create,
  update,
}
