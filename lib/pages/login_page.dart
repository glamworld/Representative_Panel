import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:representative_panel/providers/auth_provider.dart';
import 'package:representative_panel/providers/firebase_provider.dart';
import 'package:representative_panel/utils/form_decoration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';
import '../notification_widget.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _otpController = TextEditingController();
  bool _isConnected = true;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  void _checkConnectivity() async {
    var result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.none) {
      setState(() => _isConnected = false);
      showSnackBar(_scaffoldKey, "No internet connection !", Colors.deepOrange);
    } else if (result == ConnectivityResult.mobile) {
      setState(() => _isConnected = true);
    } else if (result == ConnectivityResult.wifi) {
      setState(() => _isConnected = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseProvider operation = Provider.of<FirebaseProvider>(context);
    final AuthProvider regAuth = Provider.of<AuthProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffF4F7F5),
      //resizeToAvoidBottomInset: false,
      body: _isConnected ? _bodyUI(regAuth, operation) : _noInternetUI(),
    );
  }

  Widget _bodyUI(AuthProvider regAuth, FirebaseProvider operation) {
    final Size size = MediaQuery.of(context).size;
    final Color colorPrimaryAccent = Color(0xffBCEDF2);
    return Container(
      height: size.height,
      width: size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            //Heading Section
            Container(
              height: size.height * .40,
              width: size.width,
              color: colorPrimaryAccent,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ///Logo Icon...
                  Positioned(
                      top: size.height * .09,
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: Image.asset(
                            "assets/logo.png",
                            height: 50,
                            //width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )),

                  Positioned(
                    bottom: -(size.height * .04),
                    child: Container(
                        alignment: Alignment.center,
                        width: size.width,
                        child: Image.asset(
                          "assets/manufacturer_representative.png",
                          height: 170,
                          fit: BoxFit.cover,
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),

            //Phone number field
            Container(
              width: size.width * .90,
              child: Material(
                color: Colors.white,
                elevation: 2,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Row(
                  children: [
                    Container(
                      width: size.width * .54,
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        onChanged: (val) => setState(() =>
                            regAuth.representativeDetails.phoneNumber = val),
                        decoration: FormDecoration.copyWith(
                          labelText: 'Phone number',
                          prefixIcon: null,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            //password field
            Container(
              width: size.width * .90,
              //height: 50,
              alignment: Alignment.center,
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: TextFormField(
                  obscureText: _obscure,
                  keyboardType: TextInputType.text,
                  onChanged: (val) => setState(
                      () => regAuth.representativeDetails.password = val),
                  decoration: FormDecoration.copyWith(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.security),
                      suffixIcon: IconButton(
                          icon: _obscure
                              ? Icon(Icons.visibility_off_rounded)
                              : Icon(Icons.remove_red_eye),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure))),
                ),
              ),
            ),
            SizedBox(height: 20),

            //Continue Button...
            Consumer<FirebaseProvider>(
              builder: (context, operation, child) {
                return Container(
                  width: size.width * .90,
                  child: GestureDetector(
                    onTap: () => _checkValidity(regAuth, operation),
                    child: Button(context, "Continue"),
                  ),
                );
              },
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _noInternetUI() {
    return Container(
      color: Colors.white70,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/logo.png",
            height: 50,
            //width: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 40),
          Icon(
            CupertinoIcons.wifi_exclamationmark,
            color: Colors.orange[300],
            size: 150,
          ),
          Text(
            'No Internet Connection !',
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
          Text(
            'Connect your device with wifi or cellular data',
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
          SizedBox(height: 20),
          Text(
            "For emergency call 16263",
            style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () => _checkConnectivity(),
            splashColor: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
                width: MediaQuery.of(context).size.width * .25,
                child: miniOutlineIconButton(
                    context, 'Refresh', Icons.refresh, Colors.grey)),
          )
        ],
      ),
    );
  }

  void _checkValidity(AuthProvider regAuth, FirebaseProvider operation) async {
    if (regAuth.representativeDetails.phoneNumber.isNotEmpty ||
        regAuth.representativeDetails.password.isNotEmpty) {
      regAuth.loadingMgs = "Logging in...";
      showLoadingDialog(context, regAuth);

      //Firebase querySnapshot
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Representative')
          .where('phoneNumber',
              isEqualTo: regAuth.representativeDetails.phoneNumber)
          .get();
      final List<QueryDocumentSnapshot> user = snapshot.docs;
      if (user.isNotEmpty) {
        if (user[0].get('password') == regAuth.representativeDetails.password) {
          // SharedPreferences pref =
          // await SharedPreferences.getInstance();
          // pref.setString('id', regAuth.representativeDetails.phoneNumber);
          //
          // await operation.getRepresentative().then((value) {
          //   Navigator.pop(context);
          //   Navigator.pop(context);
          //   regAuth.representativeDetails = null;
          //   Navigator.pushAndRemoveUntil(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => HomePage()),
          //           (route) => false);
          // });
          _OTPVerification(regAuth, operation);
        } else {
          Navigator.pop(context);
          showSnackBar(_scaffoldKey, "Incorrect password", Colors.deepOrange);
        }
      } else {
        Navigator.pop(context);
        showSnackBar(_scaffoldKey, "No Representative is registered with this phone", Colors.deepOrange);
      }
    } else {
      Navigator.pop(context);
      showSnackBar(_scaffoldKey, "Field can't be empty", Colors.deepOrange);
    }
  }

  void _OTPDialog(AuthProvider regAuth) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.all(20),
            title: Text("Phone Verification", textAlign: TextAlign.center),
            content: Container(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    child: Text(
                      "We've sent OTP verification code on your given number.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(height: 25),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    decoration: FormDecoration.copyWith(
                        labelText: "Enter OTP here",
                        fillColor: Color(0xffF4F7F5),
                        prefixIcon: Icon(Icons.security)),
                  ),
                  SizedBox(height: 10),
                  Consumer<FirebaseProvider>(
                    builder: (context, operation, child) {
                      return GestureDetector(
                        onTap: () async {
                          regAuth.loadingMgs = 'Verifying OTP...';
                          showLoadingDialog(context, regAuth);
                          try {
                            await FirebaseAuth.instance
                                .signInWithCredential(
                                    PhoneAuthProvider.credential(
                                        verificationId:
                                            regAuth.verificationCode,
                                        smsCode: _otpController.text))
                                .then((value) async {
                              if (value.user != null) {
                                //Save data to local
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                pref.setString('id',
                                    regAuth.representativeDetails.phoneNumber);

                                await operation
                                    .getRepresentative()
                                    .then((value) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  regAuth.representativeDetails = null;
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()),
                                      (route) => false);
                                });
                              } else {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                showSnackBar(
                                    _scaffoldKey,
                                    'Something went wrong. try again',
                                    Colors.deepOrange);
                              }
                            });
                          } catch (e) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            showSnackBar(
                                _scaffoldKey, 'Invalid OTP', Colors.deepOrange);
                          }
                        },
                        child: Button(context, 'Submit'),
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  Text('OTP will expired after 2 minutes',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]))
                ],
              ),
            ),
          );
        });
  }

  // ignore: non_constant_identifier_names
  Future<void> _OTPVerification(
      AuthProvider regAuth, FirebaseProvider operation) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
      phoneNumber: '+88' + regAuth.representativeDetails.phoneNumber,
      //Automatic verify....
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential).then((value) async {
          if (value.user != null) {
            //Save data to local
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setString('id', regAuth.representativeDetails.phoneNumber);

            await operation.getRepresentative().then((value) async {
              Navigator.pop(context);
              regAuth.representativeDetails = null;
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false);
            });
          } else {
            Navigator.pop(context);
            showSnackBar(
                _scaffoldKey, 'Error verifying Admin', Colors.deepOrange);
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          Navigator.pop(context);
          showSnackBar(_scaffoldKey, 'The provided phone number is not valid',
              Colors.deepOrange);
        }
      },
      codeSent: (String verificationId, int resendToken) {
        regAuth.verificationCode = verificationId;
        Navigator.pop(context);
        _OTPDialog(regAuth);
        //_startTimer();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        regAuth.verificationCode = verificationId;
        Navigator.pop(context);
        _OTPDialog(regAuth);
        //_startTimer();
      },
      timeout: Duration(seconds: 120),
    );
  }
}
