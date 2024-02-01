import 'package:flutter/material.dart';
import 'SignupScreen.dart';
import 'databaseHelper.dart';
import 'loginAndRegister.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if the user is already logged in
  Map<String, dynamic>? loggedInUser = await DatabaseHelper.instance.getLoggedInUser();

  runApp(MyApp(loggedInUser: loggedInUser));
}

class MyApp extends StatelessWidget {
  final Map<String, dynamic>? loggedInUser;

  const MyApp({Key? key, this.loggedInUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login and Signup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Use a ternary operator to conditionally set the initialRoute
      initialRoute: loggedInUser != null ? '/home' : '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {

  Future<void> updateLoggedInStatus(int userId, int status) async {
    await DatabaseHelper.instance.updateLoggedInStatus(userId, status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              // Get the logged-in user's data
              Map<String, dynamic>? loggedInUser = await DatabaseHelper.instance.getLoggedInUser();

              if (loggedInUser != null) {
                // Update 'is_logged_in' status when logging out
                updateLoggedInStatus(loggedInUser['id'], 0);

              }

              Navigator.pushReplacementNamed(context, '/login');

              // Navigate to login screen
            },          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: DatabaseHelper.instance.getLoggedInUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.hasData) {
              // Display user information
              Map<String, dynamic> user = snapshot.data!;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Logged In User: ${user['username']}'),
                    Text('Password: ${user['password']}'),
                  ],
                ),
              );
            } else {
              // No logged-in user
              return Center(child: Text('No logged-in user'));
            }
          } else {
            // Future is still loading
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
