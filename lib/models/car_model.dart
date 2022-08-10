class Post {
  late String postKey;
  late String userId;
  late String name;
  late String content;
  String? image;

  Post({
    required this.postKey,
    required this.userId,
    required this.name,
    required this.content,
    this.image});

  Post.fromJson(Map<String, dynamic> json) {
    postKey = json['postKey'];
    userId = json['userId'];
    name = json['name'];
    content = json['content'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() => {
    'postKey': postKey,
    'userId': userId,
    'name': name,
    'content': content,
    'image': image,
  };
}