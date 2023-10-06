import 'dart:io';

import 'package:blog_applicaton/DetailsProvider.dart';
import 'package:blog_applicaton/databseModel.dart';
import 'package:flutter/material.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:provider/provider.dart';

class BlogDetailsClass extends StatefulWidget {

  @override
  State<BlogDetailsClass> createState() => _BlogDetailsClassState();
}

class _BlogDetailsClassState extends State<BlogDetailsClass> {
  late DatabaseModel databaseModel;
  void deletePhoto() async
  {
    try
    {
      if(await File(databaseModel.image).exists())
    {
    await  File(databaseModel.image).delete();
    }
    }
    catch(e)
    {

    }
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    deletePhoto();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseModel =DatabaseModel();
  }
  @override
  Widget build(BuildContext context) {
    databaseModel = Provider.of<DetailsProvider>(context,listen: false).items;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Center(child: Text("BlogDetailView",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w500),)),
        backgroundColor: Colors.black,
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
            children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(databaseModel.title,
                    style: const TextStyle(fontSize: 35,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500),),
                ),
                const SizedBox(height: 20,),
                Image.file(File(databaseModel.image), fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
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
                const SizedBox(height: 20,),
                const  Text("Description",
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                ),
                Text(loremIpsum(words: 200),style:const TextStyle(fontSize : 20,color: Colors.white,),textAlign: TextAlign.justify),
              ]),
       ] ),
      )
    );

  }
}
