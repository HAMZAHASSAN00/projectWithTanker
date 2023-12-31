import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/repo/Tanker_repositry.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../components/designUI.dart';
import '../model/TankerModel.dart';

class RequestTank extends StatefulWidget {
  final String email;

  // Constructor to take email as a required parameter
  RequestTank({required this.email});
  @override
  _RequestTankState createState() => _RequestTankState();
}

class _RequestTankState extends State<RequestTank> {
  io.Socket? socket;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Connecting to the server...');
    // Replace 'http://localhost:3000/' with your Socket.IO server URL
    socket = io.io('https://handlerequests.onrender.com/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();
    print(socket!.connected);
    print('Connected to the server.');
    print('Emitting a chat message...');
    socket!.emit('saveSocketEmail', {
      'userType': 'Customer',
      'userEmail': '${FirebaseAuth.instance.currentUser!.email}', // Use userModel.email here
      'Message': 'Hello, saving my email! Customer',
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: perfictBlue,
      appBar: customAppBar(context, "About Us"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<Map<String, dynamic>>(
              future: TankerRepository().getDataTankerWithEmail(widget.email),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error} ');
                } else {
                  Map<String, dynamic> userData = snapshot.data!;
                  print('tanker data $userData');
                  TankerModel tankerModel= TankerModel(
                    name: userData['name'],
                    email: userData['email'],
                  );

                  return ListView(
                    children: [
                      Text('i am ${tankerModel.name}',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Divider(),
                      SizedBox(height: 16.0),
                      Text(
                        'MY EMAIL IS:${tankerModel.email}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Our project aims to create a sustainable and efficient water pumping system using automation technology and solar cells. This innovative solution is designed to provide a reliable and eco-friendly water supply.',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 8.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: perfictBlue,
                        ),
                        child:Text("request Tanker"),
                        onPressed: () async {
                          socket!.emit('customerRequest', {
                            'tankerEmail': '${widget.email}',
                            'customerEmail': '${FirebaseAuth.instance.currentUser!.email}', // Use userModel.email here
                            'requestMessage': 'Hello, Tanker from hamza!',
                          });
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.rightSlide,
                            title: 'success',
                            desc: 'request tank done successfully',
                          ).show();
                        },
                      ),
                      SizedBox(height: 8.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: perfictBlue,
                        ),
                        child:Text("cancel"),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
