import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/TankerModel.dart';
class TankerRepository {

  Future signUpTanker(BuildContext context,_nameController, _emailController, _passwordController,_phoneController,longitude,latitude) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ).then((value) {
        final user = TankerModel(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          userType: 'TankerUser',
          phoneNumber: _phoneController.text.trim(),
          longitude: longitude ?? 0.1,
          latitude: latitude ?? 0.1,
          isAvailable: false,
          arrivalTime: '1 hour',
          pricePerL: 11.5,

        );
        // If createUserWithEmailAndPassword is successful, proceed to create the user in Firestore
        createUser(context, user);
        // Additional logic or navigation if needed after both operations
        Navigator.of(context).pushNamed('loginScreen');
      } );

    } catch (error) {
      print('Error creating user: $error');

      // Handle error and show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The email address is already used. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  Future<void> createUser(BuildContext context, TankerModel user) async {
    try {
      await FirebaseFirestore.instance.collection('Tankers').doc(user.email).set(user.toJson());
      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your account has been created.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error, stackTrace) {
      print('Error: $error');
      print('StackTrace: $stackTrace');

      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something wrong. Try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<Map<String, dynamic>> getDataTanker() async {

    User? tankerUser = FirebaseAuth.instance.currentUser;

    final DocumentSnapshot TankerDoc =
    await FirebaseFirestore.instance.collection('Tankers').doc(tankerUser!.email).get();

    // Retrieve data from the main document
    Map<String, dynamic> tankerData = {
      'name': TankerDoc.get('name'),
      'email': TankerDoc.get('email'),
      'userType':TankerDoc.get('userType'),
      'phoneNumber':TankerDoc.get('phoneNumber'),
      'longitude':TankerDoc.get('longitude'),
      'latitude':TankerDoc.get('latitude'),
      'pricePerL':TankerDoc.get('pricePerL'),
      'arrivalTime':TankerDoc.get('arrivalTime'),

    };
    print('form tankerData : ${tankerData}');

    return tankerData;
  }
  Future<Map<String, dynamic>> getDataTankerWithEmail(email) async {

    final DocumentSnapshot TankerDoc =
    await FirebaseFirestore.instance.collection('Tankers').doc(email).get();

    // Retrieve data from the main document
    Map<String, dynamic> tankerData = {
      'name': TankerDoc.get('name'),
      'email': TankerDoc.get('email'),
      'userType':TankerDoc.get('userType'),
      'phoneNumber':TankerDoc.get('phoneNumber'),
      'longitude':TankerDoc.get('longitude'),
      'latitude':TankerDoc.get('latitude'),
      'pricePerL':TankerDoc.get('pricePerL'),
      'arrivalTime':TankerDoc.get('arrivalTime'),
    };
    print('form tankerData : ${tankerData}');

    return tankerData;
  }
  void updateFirestoreData(String fieldName, dynamic value,String collectionName,String documentEmail) async {
    try {
      // Replace 'your_collection' and 'your_document_id' with your actual collection and document ID
      DocumentReference documentReference = FirebaseFirestore.instance.collection(collectionName).doc(documentEmail);

      // Update the field
      await documentReference.update({
        fieldName: value,
      });

      print('Document updated successfully');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

}
