import 'package:firebase_database/firebase_database.dart';

import '../models/car_model.dart';

class RTDBService{
  //giving value
  static final database = FirebaseDatabase.instance.ref();

  //store
  static Future<Stream<DatabaseEvent>>storePost(Post post)async{
    String? key = database.child("cars").push().key;
    post.postKey = key!;
    await database.child("cars").child(post.postKey).set(post.toJson());
    return database.onChildAdded;
  }

  //load
  static Future<List<Post>>loadPost(String id)async{
    List<Post>items =[];
    Query query = database.child("cars").orderByChild("userId").equalTo('my');
    var snapShot = await query.once();
    var result = snapShot.snapshot.children;
    for(DataSnapshot item in result){
      if(item.value != null){
        items.add(Post.fromJson(Map<String, dynamic>.from(item.value as Map)));
      }
    }
    print(items.map((e) => e.toJson()));
    return items;
  }

  static Future<void>deletePost(String postKey)async{
    await database.child("cars").child(postKey).remove();
  }

  static Future<Stream<DatabaseEvent>>updatePost(Post post)async{
    await database.child("posts").child(post.postKey).set(post.toJson());
    return database.onChildAdded;
  }



}