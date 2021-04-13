
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/postDTO.dart';

class GradDetails extends StatefulWidget {

  // Get Firebase document ID via constructor
  GradDetails({Key key, this.documentID}) : super(key: key);
  final String documentID;

  @override
  _GradDetailsState createState() => _GradDetailsState();
}

//////////////////////////////////////////////////////////////////////
// Description: Loads data from Firestore and returns column of 
// information to display in post_details_view.
//////////////////////////////////////////////////////////////////////
class _GradDetailsState extends State<GradDetails> {

  // Initialize Firestore instance
  final FirebaseFirestore post = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getFirestoreData();
  }

  // Initialize data object to hold post details
  PostDTO postedItem;

  // Get post details from firestore and save to object
  void getFirestoreData() async {
    await post.collection('grads').doc(widget.documentID).get().then((DocumentSnapshot snapshot) {
      
      setState(() {
        postedItem = PostDTO(
          firstName: snapshot.data()['firstName'], 
          lastName: snapshot.data()['lastName'],
          message: snapshot.data()['message'],
          filepath: snapshot.data()['filepath']
        );

      });
    });
  }

  // Returns Column widget of post details
  @override
  Widget build(BuildContext context) {

    if (postedItem != null) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Semantics(
                  image: true,
                  label: 'Photo portrait of graduate',
                  child: Image.network(
                    postedItem.filepath,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        Text('Couldn\'t load image.'),
                  ),
                ),
                SizedBox(height: 20),
                Text('${postedItem.message}', style: TextStyle(fontSize: 24)),
              ],
            ),
          ),
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
    
  }
}