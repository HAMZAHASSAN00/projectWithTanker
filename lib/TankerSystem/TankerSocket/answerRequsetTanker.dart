import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/repo/Tanker_repositry.dart';
import 'package:flutter_auth/repo/user_repositry.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../components/designUI.dart';
import '../../model/TankerModel.dart';
import '../../soket/SocketConnection.dart';
import '../components/NavBarTanker.dart';

class AnswerRequestTank extends StatefulWidget {
  final String email;

  // Constructor to take email as a required parameter
  AnswerRequestTank({required this.email});
  @override
  _AnswerRequestTankState createState() => _AnswerRequestTankState();
}

class _AnswerRequestTankState extends State<AnswerRequestTank> {

  String messageTankerResponseToYou='';
@override

@override
  void initState()  {
    // TODO: implement initState
    super.initState();

     SocketConnection.saveSocketEmail('Tanker');

    SocketConnection.socket!.on('tankerResponseToYou', (data) {
      print('tankerResponseToYou:$data');
      setState(() {
        messageTankerResponseToYou = '${data}';
      });

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TankerPageColor,
      appBar: customAppBarTanker(context, "Answer tanker"),
      drawer: NavBarTanker(),
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
              future: UserRepository().getDataUserWithEmail(widget.email),
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
                    phoneNumber: userData['phoneNumber'],
                    pricePerL: userData['pricePerL'],
                    isAvailable: userData['isAvailable'],
                    latitude: userData['latitude'],
                    longitude: userData['longitude'],
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
                        'MY EMAIL IS : ${tankerModel.email}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Phone Number : ${tankerModel.phoneNumber}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),

                Text(messageTankerResponseToYou.length == 0 ? 'no response until now' : '${messageTankerResponseToYou}',),

                      SizedBox(height: 8.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TankerPageColorDark,
                        ),
                        child:Text("accept"),
                        onPressed: () async {
print('hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii');
                          SocketConnection.tankerAnswer(widget.email);
print('hiiiiiiiii55555555');
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.rightSlide,
                            title: 'success',
                            desc: 'request tank done successfully',
                          ).show();
print('6666666666');
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(height: 8.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TankerPageColorDark,
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
