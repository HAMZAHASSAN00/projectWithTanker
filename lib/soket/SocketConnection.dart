import 'dart:async';


import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketConnection {
 static io.Socket? socket;
 static String messageTankerResponseToYou='';

 static Future<void> initializeAppSocket() async {
    print('Connecting to the server...');
    socket = io.io('https://handlerequests.onrender.com/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();
    print(socket!.connected);
    print('Connected to the server.');
    print('Emitting a chat message...');

 }


 static requestDisplayTankers() {
   socket!.emit('requestDisplayTankers', {
     'requestMessage': 'Hello, Tanker!',
   });}
      static saveSocketEmail(String Usertype){
  socket!.emit('saveSocketEmail', {
    'userType': '${Usertype}',
    'userEmail': '${FirebaseAuth.instance.currentUser!.email}', // Use userModel.email here
    'Message': 'Hello, saving my email! Customer',
  });
 }


    static void customerRequest(tankerEmail)  {
      socket!.emit('customerRequest', {
        'tankerEmail': '${tankerEmail}',
        'customerEmail': '${FirebaseAuth.instance.currentUser!.email}', // Use userModel.email here
        'requestMessage': 'Hello, Tanker !',
      });
 }
 static void tankerResponseToYou() {
   socket!.on('tankerResponseToYou', (data) {
     print('tankerResponseToYou:$data');
     messageTankerResponseToYou = '${data}';
     // Add this line to push the message to the stream

   });
 }



 static void tankerAnswer(customerEmail)  {
   socket!.emit('tankerResponse', {
     'tankerEmail': '${FirebaseAuth.instance.currentUser!.email}',
     'customerEmail': '${customerEmail}', // Use userModel.email here
     'requestMessage': 'Hello, Tanker from hamza!',
   });
 }
 static void customerRequestedYou() {
   socket!.on('customerRequestedYou', (data) {
     print('Customer received response:$data');

   });
 }

  static  List<String> displayTankers() {
      List<String> emails = [];

     socket!.on('displayTankers', (data) {
        emails = data.keys.toList();
        print('Emails 1233: $emails');

      });
      print(' outside Emails: $emails');
      return emails;
    }


}
