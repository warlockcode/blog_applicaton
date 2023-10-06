
import 'dart:developer';

import 'package:blog_applicaton/Favorite.dart';
import 'package:blog_applicaton/connection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'BlogView.dart';
import 'blogsModel.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  ConnectivityResult connectivityResult = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();
  @override
  void initState() {
    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        connectivityResult = result;
      });
      log(result.name);
    });
    super.initState();

  }
  bool checker = false;
  bool connectivityCheck(ConnectivityResult result) {
    if (result == ConnectivityResult.wifi) {
      return false;
    } else if (result == ConnectivityResult.mobile) {
      return false;
    } else if (result == ConnectivityResult.ethernet) {
      return false;
    } else if (result == ConnectivityResult.bluetooth) {
      return false;
    } else if (result == ConnectivityResult.none) {
      return true;
    } else {
      return true;
    }
  }
  @override
  Widget build(BuildContext context) {
    checker = (connectivityCheck(connectivityResult));
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          actions: [
            GestureDetector(
              onTap:() async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Favorite()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.favorite,color: Colors.white,size: 40,)),
            )
          ],
          backgroundColor:Colors.black,
          title: Center(child: Text(widget.title,style: TextStyle(color: Colors.white),)),
        ),
        body :checker? Center(child: Container(

          padding: EdgeInsets.all(10),
          color: Colors.grey,
          alignment: Alignment.center,
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Whoops! no Connection..do not worry you can still access your favorites click on button below or connect to the internet',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),

           ElevatedButton(onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=> Favorite()));
           }, child: Icon(Icons.favorite,size:60,))
            ],
          ),

        ),

        ) :FutureBuilder<List<blogs>>(
          future: fetchBlogs(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('An error has occurred!'),
              );
            } else if (snapshot.hasData) {
              return blogsList(blogslist: snapshot.data!);
            } else {
              return const Center(
                child:SpinKitDoubleBounce(
                  color: Colors.white,
                ),
              );
            }
          },
        )
    );
  }
}