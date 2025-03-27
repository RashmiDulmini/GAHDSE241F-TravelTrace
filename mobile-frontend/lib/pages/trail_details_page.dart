import 'dart:io';
import 'package:flutter/material.dart';

class TrailDetailsPage extends StatefulWidget {
  final String name;
  final String trailName;
  final String description;
  final File mediaFile;

  TrailDetailsPage({
    required this.name,
    required this.trailName,
    required this.description,
    required this.mediaFile,
  });

  @override
  _TrailDetailsPageState createState() => _TrailDetailsPageState();
}

class _TrailDetailsPageState extends State<TrailDetailsPage> {
  int selectedTabIndex = 0; // 0: Images, 1: Videos, 2: Posts

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.file(
                  widget.mediaFile,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 30,
                  left: 20,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.trailName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [Shadow(blurRadius: 5, color: Colors.black)],
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Text(
                          widget.description,
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 15),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Trail Created By: ${widget.name}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.description,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.green[700]),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTabButton("Images", 0),
                buildTabButton("Videos", 1),
                buildTabButton("Posts", 2),
              ],
            ),

            SizedBox(height: 20),
            getSelectedContent(),
          ],
        ),
      ),
    );
  }

  Widget buildTabButton(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: selectedTabIndex == index ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selectedTabIndex == index ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget getSelectedContent() {
    if (selectedTabIndex == 0) {
      return buildImagesSection();
    } else if (selectedTabIndex == 1) {
      return buildVideosSection();
    } else {
      return buildPostsSection();
    }
  }

  Widget buildImagesSection() {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          imageCard(widget.mediaFile.path),
        ],
      ),
    );
  }

  Widget imageCard(String imagePath) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(image: FileImage(File(imagePath)), fit: BoxFit.cover),
      ),
    );
  }

  Widget buildVideosSection() {
    return Center(
      child: Icon(Icons.play_circle_fill, size: 80, color: Colors.blue),
    );
  }

  Widget buildPostsSection() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          postCard("Amazing sunset at this trail! 🌅"),
          postCard("Best place for an adventure! 🏄‍♂️"),
        ],
      ),
    );
  }

  Widget postCard(String text) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Text(text, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
