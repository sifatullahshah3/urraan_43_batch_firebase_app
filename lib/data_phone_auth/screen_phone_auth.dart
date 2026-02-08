import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urraan_firebase_app/data_auth/screen_home.dart';

class ScreenPhoneAuth extends StatefulWidget {
  const ScreenPhoneAuth({super.key});

  @override
  State<ScreenPhoneAuth> createState() => _ScreenPhoneAuthState();
}

class _ScreenPhoneAuthState extends State<ScreenPhoneAuth> {
  bool isCodeSent = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  var _controllerSmeCode = TextEditingController();
  var _controllerPhone = TextEditingController();

  String verificationId = "";

  @override
  void initState() {
    super.initState();
  }

  loadData(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (builder) => ScreenHome()),
        );
      },
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId = verificationId;
        setState(() {
          isCodeSent = true;
        });
      },
      timeout: Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Phone Login")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: !isCodeSent
            ? Column(
                children: [
                  const Icon(Icons.phone_android, size: 80, color: Colors.blue),
                  const SizedBox(height: 24),
                  const Text(
                    "Enter your phone number to receive a verification code.",
                  ),
                  const SizedBox(height: 32),

                  // Phone Field
                  TextFormField(
                    controller: _controllerPhone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: "+1 123 456 7890",
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        String phoneNumber = _controllerPhone.text.toString();

                        loadData(phoneNumber);
                      },
                      child: const Text("SEND CODE"),
                    ),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Verify Phone",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text("Code sent to +1 123 **** 890"),
                    const SizedBox(height: 30),

                    // 4/6 Digit OTP Row
                    TextFormField(
                      controller: _controllerSmeCode,
                      decoration: InputDecoration(hintText: "Enter OTP"),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        String smeCode = _controllerSmeCode.text.toString();

                        // Create a PhoneAuthCredential with the code
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                              verificationId: verificationId,
                              smsCode: smeCode,
                            );

                        if (credential != null) {
                          UserCredential? userCredential = await auth
                              .signInWithCredential(credential);

                          if (userCredential.user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => ScreenHome(),
                              ),
                            );
                          } else {
                            print("Something went wrong");
                          }
                        }
                      },
                      child: const Text("VERIFY & PROCEED"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
