import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetEmail extends StatelessWidget{
  late final String documentId;

  GetEmail({required this.documentId});

  @override
  Widget build(BuildContext context){

    //get the collection

    CollectionReference emails = FirebaseFirestore.instance.collection('Users');

    return FutureBuilder<DocumentSnapshot>(builder: ((context, snapshot)
    {
      if(snapshot.connectionState == ConnectionState.done){
        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        return Text('${data['email']}');
      }
      return Text('loading');
    }),);
  }
}