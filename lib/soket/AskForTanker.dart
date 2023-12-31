import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_auth/soket/requsetTanker.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/material.dart';
import 'package:flutter_auth/repo/user_repositry.dart';
import '../../../components/designUI.dart';
import '../../../model/UserModel.dart';
import '../model/TankerModel.dart';

class AskForTanker extends StatefulWidget {
  @override
  _AskForTankerState createState() => _AskForTankerState();
}

class _AskForTankerState extends State<AskForTanker> {

  UserRepository userRepository = UserRepository();
  io.Socket? socket;
  String datare = "";
  String data2 = "";
  String userType = "Tanker";
  late UserModel userModel = UserModel();
  late TankerModel tanker = TankerModel();
  List<String> emails = [];
   String emailUser='';

  @override
  void initState() {
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
    socket!.emit('requestDisplayTankers', {
      'requestMessage': 'Hello, Tanker!',
    });
    socket!.on('displayTankers', (data) {
      print('displayTankers: $data');
      print('usermodel email: ${FirebaseAuth.instance.currentUser!.email}');

      setState(() {
        datare = 'displayTankers$data';

        // Extract emails from the data and store them in an array
        emails = data.keys.toList();
        // Now you can use the 'emails' array as needed in your application
        print('Emails: $emails');
      });
    });

    socket!.emit('customerRequest', {
      'tankerEmail': 'tank2@gmail.com',
      'customerEmail': userModel.email, // Use userModel.email here
      'requestMessage': 'Hello, Tanker!',
    });
    print('Emit done');
    socket!.on('customerResponse', (data) {
      print('Customer received response:$data');
      print('usermodel email :$userModel.email');
      setState(() {
        datare = 'displayTankers customerResponse:$data';
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: perfictBlue,
      appBar: customAppBar(context, 'Ask For Tanker'),
      body: FutureBuilder<Map<String, dynamic>>(
        future: UserRepository().getData(),
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
            userModel = UserModel(
              name: userData['name'],
              email: userData['email'],
            );

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: emails.length==0
                  ?Center(child: Text('No tanker Available Now..',style: TextStyle(fontSize: 20),))
                  :
              ListView.builder(
                itemCount: emails.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Tanker ${index + 1}'),
                      subtitle: Text(emails[index]),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestTank(email: '${emails[index]}'), // Replace with the actual email
                          ),
                        );

                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    socket?.disconnect();
    super.dispose();
  }


}
