import 'package:flutter/material.dart';
import '../../components/designUI.dart';
import '../../model/UserModel.dart';
import '../../repo/Tanker_repositry.dart';

class SettingsPageTanker extends StatefulWidget {
  @override
  _SettingsPageTankerState createState() => _SettingsPageTankerState();
}

class _SettingsPageTankerState extends State<SettingsPageTanker> {
  bool notificationEnabled = true;
  bool darkModeEnabled = false;
  double textSize = 16.0;
  String selectedLanguage = 'English';
  String selectedTheme = 'Light';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: perfictBlue,
      appBar: customAppBar(context, 'Setting'),
      body: FutureBuilder<Map<String, dynamic>>(
        future: TankerRepository().getDataTanker(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                child: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error} ');
          } else {
            Map<String, dynamic> UserData = snapshot.data!;
            print('tanker data ${UserData}');
            UserModel userModel = UserModel(
              name: UserData['name'],
              email: UserData['email'],
            );

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Username'),
                      subtitle: Text(
                        userModel?.name ?? '',
                      ),
                      onTap: () {
                        // Open a dialog or navigate to a screen for editing the username
                      },
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Email'),
                      subtitle: Text(
                        userModel?.email ?? '',
                      ),
                      onTap: () {
                        // Open a dialog or navigate to a screen for editing the email
                      },
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Rest password'),
                      onTap: () {
                        Navigator.of(context).pushNamed('PasswordResetPage');
                      },
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Enable Notifications'),
                      trailing: Switch(
                        value: notificationEnabled,
                        onChanged: (value) {
                          setState(() {
                            notificationEnabled = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Enable Dark Mode'),
                      trailing: Switch(
                        value: darkModeEnabled,
                        onChanged: (value) {
                          setState(() {
                            darkModeEnabled = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Text Size'),
                      trailing: DropdownButton<double>(
                        value: textSize,
                        onChanged: (value) {
                          setState(() {
                            textSize = value!;
                          });
                        },
                        items: [16.0, 18.0, 20.0, 22.0, 24.0]
                            .map<DropdownMenuItem<double>>(
                              (double value) => DropdownMenuItem<double>(
                            value: value,
                            child: Text(value.toString()),
                          ),
                        )
                            .toList(),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Language'),
                      trailing: DropdownButton<String>(
                        value: selectedLanguage,
                        onChanged: (value) {
                          setState(() {
                            selectedLanguage = value!;
                          });
                        },
                        items: ['English', 'Spanish', 'French', 'German']
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                            .toList(),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text('Theme'),
                      trailing: DropdownButton<String>(
                        value: selectedTheme,
                        onChanged: (value) {
                          setState(() {
                            selectedTheme = value!;
                          });
                        },
                        items: ['Light', 'Dark', 'System']
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                            .toList(),
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
}
