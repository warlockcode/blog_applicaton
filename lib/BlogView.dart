import 'package:blog_applicaton/BlogDetailClass.dart';
import 'package:blog_applicaton/DetailsProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'blogsModel.dart';
import 'database.dart';
import 'databseModel.dart';

class blogsList extends StatefulWidget {
  const blogsList({super.key, required this.blogslist});

  final List<blogs> blogslist;


  @override
  State<blogsList> createState() => _blogsListState();
}

class _blogsListState extends State<blogsList> {

  DatabaseModel databaseModel = DatabaseModel();
  late DatabaseClass handler ;
  Future<DatabaseModel> convertBlog(blogs list) async{
    DatabaseModel databaseModel = DatabaseModel();
     databaseModel.id = list.id;
     databaseModel.title = list.title;
     databaseModel.image = await databaseModel.saveImage(list.urlLink);
     return databaseModel;

  }

  int current_count = 0;
  int allowed_item = 5;
  List<blogs> items =[];
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    handler = DatabaseClass() ;
    handler.initializedDB();
    items.addAll(widget.blogslist.getRange(0, allowed_item));
    setState(() {
      current_count = current_count+allowed_item;
    });
    scrollController.addListener(() {
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent)
      {
        addMoreBlogs();
      }
    });
  }
  var isLoading = false;

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        itemCount:isLoading ? 1 :items.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.all(5),
            child: isLoading ?  const Center(child: SpinKitDoubleBounce(color: Colors.white,size: 80,)):Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                GestureDetector(
                  onTap:() async {
                    setState(() {
                      isLoading =true;
                    });
                    await Provider.of<DetailsProvider>(context,listen: false).addnetworkblog(items[index]);
                    setState(() {
                      isLoading =false;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BlogDetailsClass()),
                    );


                  },

                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      getImage(items[index].urlLink),
                      const SizedBox(height: 10,),
                      Text(items[index].title,
                        style: const TextStyle(fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                      ),
                      ),

                    ],),
                ),
                const SizedBox(height: 10),
                Padding(
                    padding: const EdgeInsets.all(5.0),
                    child:GestureDetector(
                        onTap: () async {
                          Fluttertoast.showToast(msg: "Adding to Favorite please wait",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black26,
                              fontSize: 20.0);
                          int result = await handler.insertFavorite(await convertBlog(items[index]));
                          print(result);

                          Fluttertoast.showToast(msg: "Added to Favorite",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black26,
                              fontSize: 20.0);
                        },
                        child: const Icon(Icons.favorite,color: Colors.white,size:40,))),
                Container(color: Colors.grey,width: MediaQuery.of(context).size.width,height:2),
              ],
            ),
          );
        }
    );
  }

  Widget getImage(String urlLink) {
    try{
      return Image.network(urlLink,fit: BoxFit.contain, loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child:


          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
                Center(child: Text(
                      '${(loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!* 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    )
                ),
              ],
            ),
          ),

        );
      },errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 250,
          color: Colors.amber,
          alignment: Alignment.center,
          child: const Text(
            'Whoops! sorry for inconvenience',
            style: TextStyle(fontSize: 30),
          ),
        );
      },);
    }
    on Exception
    {
      return Container(
        height: 250,
        color: Colors.black,
        alignment: Alignment.center,
        child: const Text(
          'Whoops! sorry for inconvenience',
          style: TextStyle(color:Colors.white,fontSize: 30),
        ),
      );
    }
  }

  void addMoreBlogs() {
    if(current_count+allowed_item <= widget.blogslist.length) {
      items.addAll(widget.blogslist.getRange(
          current_count, current_count + allowed_item));
      current_count = current_count+allowed_item;
    }
    else
    {
      items.addAll(widget.blogslist.getRange(
          current_count, widget.blogslist.length));
      current_count = widget.blogslist.length;
    }
    setState(() {


    });
  }
}