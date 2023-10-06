import 'dart:io';
import 'package:blog_applicaton/DetailsProvider.dart';
import 'package:blog_applicaton/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'BlogDetailClass.dart';
import 'databseModel.dart';

class Favorite extends StatefulWidget {

  const Favorite({Key? key}) : super(key: key);
  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  late DatabaseClass handler;
  @override
  void initState() {
    super.initState();
    handler = DatabaseClass();
    handler.initializedDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Your Favorites",
        style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.white),),),backgroundColor: Colors.black,),
      backgroundColor: Colors.black,
      body: FutureBuilder(
          future: handler.getBlogs(),
          builder: (BuildContext context,
              AsyncSnapshot<List<DatabaseModel>> snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {

              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap:
                        (){
                          Provider.of<DetailsProvider>(context,listen: false).adddatabaseblog(snapshot.data![index]);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BlogDetailsClass()),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [

                               Image.file(File(snapshot.data![index].image),fit: BoxFit.fill,errorBuilder: (context, error, stackTrace) {
                                 return Container(
                                   height: 250,
                                   color: Colors.amber,
                                   alignment: Alignment.center,
                                   child: const Text(
                                     'Whoops! sorry for inconvenience',
                                     style: TextStyle(fontSize: 30),
                                   ),
                                 );
                               },),
                                const SizedBox(height: 10,),
                                Text(snapshot.data![index].title, style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                ),

                              ],),
                            const SizedBox(height: 10),
                            Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                    onTap: () async{

                                      handler.removeBlog(snapshot.data![index].id);
                                      Fluttertoast.showToast(
                                          msg: "Removed From Favorite",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.white,
                                          textColor: Colors.black,
                                          fontSize: 20.0);
                                      try
                                      {
                                        if(await File(snapshot.data![index].image).exists())
                                        {
                                          await  File(snapshot.data![index].image).delete();
                                        }
                                      }
                                      catch(e)
                                      {

                                      }
                                      setState(() {

                                      });
                                    },
                                    child: const Icon(
                                      Icons.delete, color: Colors.white,
                                      size: 30,))),
                            Container(color: Colors.grey, width: MediaQuery
                                .of(context)
                                .size
                                .width, height: 2),
                          ],
                        ),
                      ),
                    );
                  }
              );
            }
            else {
              return Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 250,
                  color: Colors.grey,
                  alignment: Alignment.center,
                  child: const Text(
                    'Whoops! no favorite added till now.. add some to enjoy reading even offline',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
              );
            }
          },
      ),
    );
  }
}

