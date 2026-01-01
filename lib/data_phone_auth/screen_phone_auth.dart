import 'package:flutter/material.dart';
import 'package:urraan_firebase_app/data_phone_auth/screen_otp_verification.dart';

class ScreenPhoneAuth extends StatelessWidget {
  const ScreenPhoneAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Phone Login")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.phone_android, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            const Text(
              "Enter your phone number to receive a verification code.",
            ),
            const SizedBox(height: 32),

            // Phone Field
            TextFormField(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OtpVerificationScreen(),
                    ),
                  );
                  // Navigate to OTP Screen
                },
                child: const Text("SEND CODE"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
