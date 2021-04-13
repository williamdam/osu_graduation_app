import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../model/postDTO.dart';
import '../view/details_view.dart';

class ShowPhotoCards extends StatefulWidget {
  @override
  _ShowPhotoCardsState createState() => _ShowPhotoCardsState();
}

class _ShowPhotoCardsState extends State<ShowPhotoCards> {

  // Returns ListView in single-column layout for vertical orientation
  Widget oneColumn() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('grads').orderBy('time', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.documents != null && snapshot.data.documents.length > 0) {
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(height: 1, color: Colors.grey),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                var post = snapshot.data.docs[index];
                return GestureDetector(
                  child: ListTile(
                    title: Text('${post['firstName']} ${post['lastName']}', style: TextStyle(fontSize: 18)),
                  ),
                  onTap: () {
                    
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => DetailsView(firstName: post['firstName'], lastName: post['lastName'], id: post.id)
                      )
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    return oneColumn();
  }
}