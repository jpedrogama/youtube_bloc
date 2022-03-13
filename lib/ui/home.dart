import 'package:flutter/material.dart';
import 'package:youtube_bloc/delegates/data_search.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(height: 25, child: Image.asset("assets/images/youtube_transparent_logo.png"),),
        elevation: 0,
        backgroundColor: Colors.black12,
        actions: [
          IconButton(icon: Icon(Icons.stars), onPressed: (){}),
          IconButton(icon: Icon(Icons.search), onPressed: () async {
            String? result = await showSearch(context: context, delegate: DataSearch());
          }),
        ],
      ),
      body: const Center(
        child: Text('Home'),
      ),
    );
  }
}