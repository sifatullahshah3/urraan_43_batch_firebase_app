import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urraan_firebase_app/data_auth/screen_home.dart';

class ScreenEmailAuth extends StatefulWidget {
  const ScreenEmailAuth({super.key});

  @override
  State<ScreenEmailAuth> createState() => _ScreenEmailAuthState();
}

class _ScreenEmailAuthState extends State<ScreenEmailAuth> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isLogin ? "Welcome Back" : "Create Account",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isLogin ? "Sign in to continue" : "Join our IT community today",
              ),
              const SizedBox(height: 32),

              // Email Field
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () async {
                  String emailAddress = emailController.text.toString();
                  String password = passwordController.text.toString();

                  print("isLoginisLogin ${isLogin}");

                  if (isLogin) {
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                            email: emailAddress,
                            password: password,
                          );

                      print("credential.user ${credential.user}");
                      if (credential.user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ScreenHome()),
                        );
                      } else {
                        print("Something went wrong");
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                      } else {
                        print(e.code);
                        print(e.message);
                      }
                    } catch (e) {
                      print(e);
                    }
                  } else {
                    try {
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                            email: emailAddress,
                            password: password,
                          );

                      if (credential.user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ScreenHome()),
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
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(isLogin ? "SIGN IN" : "SIGN UP"),
              ),

              TextButton(
                onPressed: () => setState(() => isLogin = !isLogin),
                child: Text(
                  isLogin
                      ? "Don't have an account? Register"
                      : "Already have an account? Login",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
