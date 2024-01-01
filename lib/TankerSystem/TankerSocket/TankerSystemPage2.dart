import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth/repo/Tanker_repositry.dart';
import 'package:flutter_auth/soket/requsetTanker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/repo/user_repositry.dart';
import '../../../components/designUI.dart';
import '../../../model/UserModel.dart';
import '../../model/TankerModel.dart';
import '../../soket/SocketConnection.dart';
import '../components/NavBarTanker.dart';
import 'answerRequsetTanker.dart';


class TankerPage2 extends StatefulWidget {
  @override
  _TankerPage2State createState() => _TankerPage2State();
}

class _TankerPage2State extends State<TankerPage2> {
  bool _isMounted = false;
  UserRepository userRepository = UserRepository();

  String tankerEmailM = "";
  String customerEmailM = "";
  String requestMessageM = "";
  String userType = "Tanker";
  late UserModel userModel = UserModel();
  late TankerModel tanker = TankerModel();
  List<String> emails = [];
  String emailUser='';

  Future<void> initializeSocket() async {
    //socket = SocketConnection.socket;
    await SocketConnection.saveSocketEmail('Tanker');

  }
  @override
  void initState() {
    super.initState();
    initializeSocket();


    SocketConnection.socket!.on('customerRequestedYou', (data) {

        print('displayTankers: $data');
        print('usermodel email: ${FirebaseAuth.instance.currentUser!.email}');

        setState(() {

          emails.add('new request');
          print('Emails from customerRequestedYou _isMounted: $emails');
          handleReceivedData( data);
        });

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: TankerPageColor,
      appBar: customAppBarTanker(context, 'TANKER'),
      drawer: NavBarTanker(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: TankerRepository().getDataTanker(),
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

            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(
                      Icons.propane_tank,
                      size: 50.0,
                      color: TankerPageColorDark,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: Text(
                      'tanker request',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: TankerPageColorDark,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: Padding(
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
                              title: Text('$customerEmailM ${index + 1}'),
                              subtitle: Text(emails[index]),
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AnswerRequestTank(email: customerEmailM), // Replace with the actual email
                                  ),
                                );

                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();


  }
  void handleReceivedData(dynamic data) {
    // Assuming data is a Map<String, dynamic>
    if (data != null && data is Map<String, dynamic>) {
      // Extract information from the received data
      String tankerEmail = data['tankerEmail'];
      String customerEmail = data['customerEmail'];
      String requestMessage = data['requestMessage'];

      print('Tanker Email: $tankerEmail');
      print('Customer Email: $customerEmail');
      print('Request Message: $requestMessage');

      setState(() {
        tankerEmailM='$tankerEmail';
        customerEmailM='$customerEmail';
        requestMessageM='$requestMessage';


      });
    }

}}
