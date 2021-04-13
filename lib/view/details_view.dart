import 'package:flutter/material.dart';
import '../widgets/grad_details.dart';

class DetailsView extends StatelessWidget {

  DetailsView({this.firstName, this.lastName, this.id});
  final String firstName;
  final String lastName;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$firstName $lastName'),
      ),
      body: GradDetails(documentID: id),
    );
  }
}