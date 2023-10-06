import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:io';

class DatabaseModel
{
 late  String id ;
 late  String image;
 late  String title;
DatabaseModel(){}
 DatabaseModel.name({required this.id, required this.image, required this.title});

  Map<String,Object> toMap()
  {
    return {
      'id' : id,
      'image' : image,
      'title' : title,
    };
  }
 DatabaseModel.fromMap(Map<String, dynamic> result)
     : id = result["id"],
       image = result["image"],
       title = result["title"];

 Future<String> saveImage( String url) async {
   var response = await http.get(Uri.parse(url));
   if(response.statusCode ==200) {
     Directory directory = await getApplicationDocumentsDirectory();
     File file = File(path.join(directory.path, path.basename(url)));
     await file.writeAsBytes(response.bodyBytes);
     return file.path;
   }
   else
     {
       return "unvalid Path";
     }
 }
}