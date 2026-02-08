import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urraan_firebase_app/data_auth/screen_email_auth.dart';
import 'package:urraan_firebase_app/data_auth/screen_guest.dart';
import 'package:urraan_firebase_app/data_phone_auth/screen_phone_auth.dart';

class AuthSelectionScreen extends StatelessWidget {
  const AuthSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade800, Colors.blue.shade500],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Placeholder
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(Icons.developer_mode, size: 50, color: Colors.blue),
            ),
            const SizedBox(height: 40),
            const Text(
              "IT Solutions Portal",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Secure access to your services",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 60),

            // Email Login Button
            _buildAuthButton(
              context,
              label: "Continue with Email",
              icon: Icons.email_outlined,
              onPressed: () {
                // Navigate to Email Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScreenEmailAuth(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            _buildAuthButton(
              context,
              label: "Continue as Guest",
              icon: Icons.email_outlined,
              onPressed: () async {
                try {
                  final credential = await FirebaseAuth.instance
                      .signInAnonymously();

                  if (credential.user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScreenGuest()),
                    );
                  } else {
                    print("Something went wrong");
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),

            const SizedBox(height: 20),

            // Phone Login Button
            _buildAuthButton(
              context,
              label: "Continue with Phone",
              icon: Icons.phone_android_outlined,
              isSecondary: true,
              onPressed: () {
                // Navigate to Phone Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScreenPhoneAuth(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool isSecondary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: isSecondary ? Colors.blue : Colors.white),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary ? Colors.white : Colors.transparent,
          foregroundColor: isSecondary ? Colors.blue : Colors.white,
          side: const BorderSide(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isSecondary ? 2 : 0,
        ),
      ),
    );
  }
}
