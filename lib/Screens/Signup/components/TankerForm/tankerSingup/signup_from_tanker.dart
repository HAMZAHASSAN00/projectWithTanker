
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/repo/user_repositry.dart';

import '../../../../../components/already_have_an_account_acheck.dart';
import '../../../../../constants.dart';
import '../../../../../repo/Tanker_repositry.dart';
import '../../../../Login/components/login_screen.dart';



class SignUpFormTanker extends StatefulWidget {
  const SignUpFormTanker({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpFormTanker> {
  TankerRepository tankerRepository = TankerRepository();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameControllerTanker = TextEditingController();
  final TextEditingController _emailControllerTanker = TextEditingController();
  final TextEditingController _passwordControllerTanker = TextEditingController();
  bool _isPasswordVisible = false;



  @override
  void initState() {
    super.initState();
    // Register UserRepository instance with GetX
    Get.put(UserRepository());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: defaultPadding),
            //name
            TextFormField(

              controller: _nameControllerTanker,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your name",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),


              ),

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: 10),

            //email
            TextFormField(
              controller: _emailControllerTanker,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.email),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!GetUtils.isEmail(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            //password
            TextFormField(
              controller: _passwordControllerTanker,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: kPrimaryColor,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            SizedBox(height: 10),




            //signup button
            GestureDetector(
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await tankerRepository.signUpTanker(
                      context,
                      _nameControllerTanker,
                      _emailControllerTanker,
                      _passwordControllerTanker,
                    );
                  }
                },
                child: Text("Sign Up".toUpperCase()),
              ),
            ),

            const SizedBox(height: defaultPadding),
            SizedBox(height: 10),

            //AlreadyHaveAnAccountCheck
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 30,),

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameControllerTanker.dispose();
    _emailControllerTanker.dispose();
    _passwordControllerTanker.dispose();

    // Dispose UserRepository instance when the widget is disposed
    Get.delete<UserRepository>();

    super.dispose();
  }
}
