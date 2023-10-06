import 'package:blog_applicaton/databseModel.dart';
import 'package:flutter/cupertino.dart';

import 'blogsModel.dart';

class DetailsProvider extends ChangeNotifier {
  DatabaseModel databaseModel = DatabaseModel();
  late  DatabaseModel _items =DatabaseModel();

   DatabaseModel get items =>_items;

  Future<int> addnetworkblog(blogs blog) async {

    _items.id = blog.id;
    _items.title = blog.title;
    _items.image = await databaseModel.saveImage(blog.urlLink);
    notifyListeners();
    return 1;

  }

  void adddatabaseblog(DatabaseModel blog)  {

    _items  = blog;
    notifyListeners();
  }
}