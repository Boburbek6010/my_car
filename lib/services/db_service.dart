import 'package:shared_preferences/shared_preferences.dart';

enum StorageKey{uid}

class DBService{

  //save
  static Future<bool>saveUserId(String uid)async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(StorageKey.uid.name, uid);
  }

  //load
  static Future<String?>loadUserId()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(StorageKey.uid.name);
  }

  //remove
  static Future<bool>removeUserId()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.remove(StorageKey.uid.name);
  }
}