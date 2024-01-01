import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Signup/components/choose_tank_photo/sliderTank/models.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../model/UserModel.dart';
class UserRepository {
  Future createAuthWithEmailAndPassword(BuildContext context,_emailController,_passwordController )async{
   try {
     await FirebaseAuth.instance.createUserWithEmailAndPassword(
       email: _emailController.text.trim(),
       password: _passwordController.text.trim(),
     );
     await FirebaseAuth.instance.currentUser!.sendEmailVerification();

     print('22FirebaseAuth.instance.currentUser!.emailVerified');

   }catch(e){
     print('33FirebaseAuth.instance.currentUser!.emailVerified');

     AwesomeDialog(
       context: context,
       dialogType: DialogType.error,
       animType: AnimType.rightSlide,
       title: 'Error',
       desc: 'not valid email, try anther one.',
     ).show();
   }
  }
  Future registerUser(BuildContext context,_nameController, _emailController, TankModel tankModel, _phoneController, double longitude,double latitude) async {

      final user = UserModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        tank: Tank(
          cmRoof: '0',
          cmGround: '0',
        ),
        isAutomaticMode: false,
        isTurnedOnSolar: false,
        isTurnedOnTank: false,
        tankName:tankModel.tankName,//CacheHelper.getTankModel(key: 'TankModel')!.tankName ?? 'Default',
        height: tankModel.height,//CacheHelper.getTankModel(key: 'TankModel')!.height ?? 20,
        width: tankModel.width,//CacheHelper.getTankModel(key: 'TankModel')!.width ?? 30,
        length: tankModel.length,//CacheHelper.getTankModel(key: 'TankModel')!.width ?? 30,
        waterTemp:50.1,
        currentBills:0.1,
        isAutomaticModeSolar:false,
        userType: 'defaultUserType',
        roofAutoMode: 20.1,
        groundAutoMode: 20.1,
        tempPercentageAutoMode: 50.1,
        phoneNumber: _phoneController.text.trim(),
        waterTimeArrival: '',
        oneSignalId: null,
        so1: '',
        so2: '',
        do1: 0.1,
        do2: 0.1,
        longitude: longitude ??0.1,
        latitude: latitude ?? 0.1,
      );
      // If createUserWithEmailAndPassword is successful, proceed to create the user in Firestore
      createUser(context, user);
      Navigator.of(context).pushNamed('loginScreen');
       print('11FirebaseAuth.instance.currentUser!.emailVerified');
       AwesomeDialog(
         context: context,
         dialogType: DialogType.info,
         animType: AnimType.rightSlide,
         title: 'Verification',
         desc: 'check your email to Verification',
       ).show();


      // Additional logic or navigation if needed after both operations



  }
  Future signUp(
      BuildContext context,
      _nameController,
      _emailController,
      _passwordController,
      TankModel tankModel,
      _phoneController,
      double longitude,
      double latitude,
  ) async {
    try {
      createAuthWithEmailAndPassword(context,_emailController,_passwordController ).then((value){
        registerUser(context,_nameController, _emailController,  tankModel,_phoneController,longitude,latitude);
      });

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



  Future<void> createUser(BuildContext context, UserModel user) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(user.email).set(user.toJson());

    } catch (error, stackTrace) {
      print('Error: $error');
      print('StackTrace: $stackTrace');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Something wrong. Try again.',
      ).show();
      // Show error snackbar
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Something wrong. Try again.'),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    }
  }

  Future<Map<String, dynamic>> getData() async {
    User? user = FirebaseAuth.instance.currentUser;
    print('form getData() : ${OneSignal.User.pushSubscription.id}');
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(user!.email).get();

    // Retrieve data from the main document
    Map<String, dynamic> userData = {
      'name': userDoc.get('name'),
      'email': userDoc.get('email'),
      'isAutomaticMode': userDoc.get('isAutomaticMode'),
      'isTurnedOnSolar': userDoc.get('isTurnedOnSolar'),
      'isTurnedOnTank': userDoc.get('isTurnedOnTank'),

      'height': userDoc.get('height'),
      'width': userDoc.get('width'),
      'length': userDoc.get('length'),


      'waterTemp': userDoc.get('waterTemp'),
      'currentBills': userDoc.get('currentBills'),
      'isAutomaticModeSolar': userDoc.get('isAutomaticModeSolar'),
      'userType': userDoc.get('userType'),
      'roofAutoMode': userDoc.get('roofAutoMode'),
      'groundAutoMode': userDoc.get('groundAutoMode'),
      'tempPercentageAutoMode': userDoc.get('tempPercentageAutoMode'),
      'phoneNumber':userDoc.get('phoneNumber') ,
      'waterTimeArrival': userDoc.get('waterTimeArrival'),
      'oneSignalId':userDoc.get('oneSignalId'),
      'phoneNumber':userDoc.get('phoneNumber'),
      'longitude':userDoc.get('longitude'),
          'latitude':userDoc.get('latitude'),

    };

    // Access tank -> cmRoof and cmGround fields
    Map<String, dynamic> tankData = userDoc.get('tank') ?? {} ;
    String cmRoof = tankData['cmRoof'] ?? '0';
    String cmGround = tankData['cmGround'] ?? '0';

    userData['cmRoof'] = cmRoof;
    userData['cmGround'] = cmGround;
    updateOneSignalUserPushSubscriptionId(user!.email.toString());
    return userData;
  }
  Future<Map<String, dynamic>> getDataUserWithEmail(String email) async {
    print('gg');
    User? user = FirebaseAuth.instance.currentUser;
    print('form getData() : ${OneSignal.User.pushSubscription.id}');
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(email).get();

    // Retrieve data from the main document
    Map<String, dynamic> userData = {
      'name': userDoc.get('name'),
      'email': userDoc.get('email'),
      'isAutomaticMode': userDoc.get('isAutomaticMode'),
      'isTurnedOnSolar': userDoc.get('isTurnedOnSolar'),
      'isTurnedOnTank': userDoc.get('isTurnedOnTank'),

      'height': userDoc.get('height'),
      'width': userDoc.get('width'),
      'length': userDoc.get('length'),


      'waterTemp': userDoc.get('waterTemp'),
      'currentBills': userDoc.get('currentBills'),
      'isAutomaticModeSolar': userDoc.get('isAutomaticModeSolar'),
      'userType': userDoc.get('userType'),
      'roofAutoMode': userDoc.get('roofAutoMode'),
      'groundAutoMode': userDoc.get('groundAutoMode'),
      'tempPercentageAutoMode': userDoc.get('tempPercentageAutoMode'),
      'phoneNumber':userDoc.get('phoneNumber') ,
      'waterTimeArrival': userDoc.get('waterTimeArrival'),
      'oneSignalId':userDoc.get('oneSignalId'),
      'phoneNumber':userDoc.get('phoneNumber'),
      'longitude':userDoc.get('longitude'),
      'latitude':userDoc.get('latitude'),

    };

    // Access tank -> cmRoof and cmGround fields
    Map<String, dynamic> tankData = userDoc.get('tank') ?? {} ;
    String cmRoof = tankData['cmRoof'] ?? '0';
    String cmGround = tankData['cmGround'] ?? '0';

    userData['cmRoof'] = cmRoof;
    userData['cmGround'] = cmGround;
    updateOneSignalUserPushSubscriptionId(user!.email.toString());
    return userData;
  }
  Text getImportantDataText(Map<String, dynamic> userData) {
    double roofCm = double.parse(userData['cmRoof']);
    double groundCm = double.parse(userData['cmGround']);

    if (roofCm < 50 && groundCm > 50) {
      return Text("You must turn on the pump",
        style: TextStyle(fontSize: 18, color: Colors.red),
        textAlign: TextAlign.center,);
    } else if(roofCm < 50 && groundCm < 50) {
      return Text("There is not enough water",
        style: TextStyle(fontSize: 18, color: Colors.amber),
        textAlign: TextAlign.center,);
    }else {
      return Text("No need to turn on the pump",
        style: TextStyle(fontSize: 18, color: Colors.green),
        textAlign: TextAlign.center,);
    }
  }
  void updateOneSignalUserPushSubscriptionId(email){
    print('updateOneSignalUserPushSubscriptionId ${OneSignal.User.pushSubscription.id}');
    updateFirestoreData('oneSignalId', OneSignal.User.pushSubscription.id, 'Users', email);
  }

  Future<Stream<Map<String, dynamic>>> getDataStream() async{
    User? user = FirebaseAuth.instance.currentUser;
    print('form getDataStream() : ${OneSignal.User.pushSubscription.id}');
    DocumentReference userDocRef = await FirebaseFirestore.instance.collection('Users').doc(user!.email);
    // Use snapshots to listen for changes in the document
    return userDocRef.snapshots().map((userDoc) {
      Map<String, dynamic> userData = {
        'name': userDoc.get('name'),
        'email': userDoc.get('email'),
        'isAutomaticMode': userDoc.get('isAutomaticMode'),
        'isTurnedOnSolar': userDoc.get('isTurnedOnSolar'),
        'isTurnedOnTank': userDoc.get('isTurnedOnTank'),
        'height': userDoc.get('height'),
        'width': userDoc.get('width'),
        'length': userDoc.get('length'),

        'isAutomaticModeSolar': userDoc.get('isAutomaticModeSolar'),
        'waterTemp': userDoc.get('waterTemp'),
        'currentBills': userDoc.get('currentBills'),
        'userType': userDoc.get('userType'),
        'roofAutoMode': userDoc.get('roofAutoMode'),
        'groundAutoMode': userDoc.get('groundAutoMode'),
        'tempPercentageAutoMode': userDoc.get('tempPercentageAutoMode'),
        'waterTimeArrival': userDoc.get('waterTimeArrival'),
        'oneSignalId':userDoc.get('oneSignalId'),
        'phoneNumber':userDoc.get('phoneNumber'),

      };

      Map<String, dynamic> tankData = userDoc.get('tank') ?? {};
      String cmRoof = tankData['cmRoof'] ?? '0';
      String cmGround = tankData['cmGround'] ?? '0';

      userData['cmRoof'] = cmRoof;
      userData['cmGround'] = cmGround;
      print('form getDataStream() : ${OneSignal.User.pushSubscription.id}');
      updateOneSignalUserPushSubscriptionId(user!.email.toString());

      return userData;
    });
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
