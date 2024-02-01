// Login Screen
import 'package:flutter/material.dart';
import 'databaseHelper.dart';
import 'homeScreen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: usernameController, decoration: const InputDecoration(labelText: 'Username')),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 20),
// Inside LoginScreen class
// Inside LoginScreen class
            ElevatedButton(
              onPressed: () async {
                String username = usernameController.text;
                String password = passwordController.text;
                Map<String, dynamic>? user = await DatabaseHelper.instance.getUser(username, password);

                if (user != null) {
                  // Update 'is_logged_in' status with user's id
                  DatabaseHelper.instance.updateLoggedInStatus(user['id'], 1);

                  // Navigate to home screen when login successful and remove the back stack
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);

                } else {
                  // Invalid credentials
                  print('Invalid credentials');
                  //show snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid credentials'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: Text('Login'),
            ),

            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text(
                'Dont have account? Sign Up',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}



