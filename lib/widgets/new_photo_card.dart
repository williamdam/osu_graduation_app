import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../model/postDTO.dart';

class NewPhotoForm extends StatefulWidget {

  @override
  _NewPhotoFormState createState() => _NewPhotoFormState();
}

class _NewPhotoFormState extends State<NewPhotoForm> {

  final _formKey = GlobalKey<FormState>();

  // Hold image filepath on local device
  File imageURL;
  final picker = ImagePicker();

  // Init data transfer object
  final PostDTO formData = PostDTO();

  // Var stores upload progress
  double progress;

  // Upload image to FirebaseStorage
  Future setImage() async {
    Reference storageReference = FirebaseStorage.instance.ref().child(imageURL.toString());
    UploadTask uploadTask = storageReference.putFile(imageURL);

    uploadTask.snapshotEvents.listen((event) {
      setState(() {
        progress = event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
      });
    }).onError((error) {
      print(error);
    });

    await uploadTask.whenComplete(() => null);
    final url = await storageReference.getDownloadURL();
    formData.filepath = url;
  }

  Future openGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imageURL = File(pickedFile.path);
        print(imageURL);
      } else {
        print('No image selected.');
      }
    });
  }

  Future openCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        imageURL = File(pickedFile.path);
      } else {
        print('No photo taken.');
      }
    });
  }

  Widget getImage() {
    if (imageURL != null) {
      formData.filepath = imageURL.path;
      return Image.file(File(imageURL.path));
    }
    else {
      return ElevatedButton(
        onPressed: () {
          openGallery();
        },
        child: Text('Upload Your Photo', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          primary: Color(0xFFc8c8c8)
        ),
      );
    }
    
  }
  
  // Show form submit button.  Change to progress bar on pressed.
  Widget showButton() {
    if (progress == null) {
      return ElevatedButton(
          onPressed: () async {
            // Validate returns true if the form is valid, or false otherwise.
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              print('button pressed: saved ${formData.firstName} ${formData.lastName} ${formData.email} ${formData.message} ${formData.filepath}');
              
              await setImage();
              FirebaseFirestore.instance.collection('grads').add({
                'firstName': formData.firstName,
                'lastName': formData.lastName,
                'email': formData.email,
                'message': formData.message,
                'filepath': formData.filepath,
                'time': FieldValue.serverTimestamp()
              });
              //_formKey.currentState.reset();
              
              setState(() {
                imageURL = null;
              });
            }
          },
          child: Text('Submit'),
        );
      } else {
        return Column(
          children: [
            LinearProgressIndicator(
              value: this.progress,
              minHeight: 20,
            ),
            Text('Uploading... ${this.progress}', style: TextStyle(fontSize: 18))
          ],
        );
      }
  }

  @override
  Widget build(BuildContext context) {

    if (progress != 1.0) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  getImage(),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'First name', 
                      hintText: 'Enter your first name',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      formData.firstName = value;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Last name', 
                      hintText: 'Enter your last name',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      formData.lastName = value;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'OSU Email Address', 
                      hintText: 'e.g. beaverj@oregonstate.edu',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      formData.email = value;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    minLines: 4,
                    maxLines: 4,
                    maxLength: 280,
                    keyboardType: TextInputType.multiline,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Add a message for the world to see!', 
                      hintText: 'Type a message or your favorite quote here.',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      formData.message = value;
                    },
                  ),
                  showButton(),
                ]
              )
            ),
          ),
        ),
      );
    } else {
      return Text('We\'ve received your card!');
    }
    
  }
}