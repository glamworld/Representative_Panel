import 'package:flutter/material.dart';

import 'custom_clipper.dart';

// ignore: missing_return
Widget customAppBarDesign(BuildContext context, String appBarName){
  return PreferredSize(
    preferredSize: Size.fromHeight(90),
    child: AppBar(
      // leading: IconButton(
      //     onPressed: ()=>Navigator.of(context).pop(),
      //     icon: Icon(Icons.arrow_back_ios_outlined,color: Colors.grey[800],),
      //   ),
      title: Text(appBarName,style: TextStyle(color: Colors.black),),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipPath(
        clipper: MyCustomClipperForAppBar(),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Color(0xffBCEDF2),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                tileMode: TileMode.clamp,
              )
          ),
        ),
      ),
    ),
  );
}