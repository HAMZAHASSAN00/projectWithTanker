import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/repo/Tanker_repositry.dart';
import '../components/designUI.dart';
import '../model/TankerModel.dart';
import 'SocketConnection.dart';

class RequestTank extends StatefulWidget {
  final String email;

  // Constructor to take email as a required parameter
  RequestTank({required this.email});
  @override
  _RequestTankState createState() => _RequestTankState();
}

class _RequestTankState extends State<RequestTank> {

  String messageTankerResponseToYou='';
@override

@override
  void initState()  {
    // TODO: implement initState
    super.initState();

     SocketConnection.saveSocketEmail('Customer');

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
      backgroundColor: perfictBlue,
      appBar: customAppBar(context, "Request tanker"),
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
                          backgroundColor: perfictBlue,
                        ),
                        child:Text("request Tanker"),
                        onPressed: () async {

                          SocketConnection.customerRequest(widget.email);
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
