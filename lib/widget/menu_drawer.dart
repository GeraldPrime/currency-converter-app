
import 'package:currency_converter_app/screens/faq_screen.dart';
import 'package:currency_converter_app/screens/set_base_currency_screen.dart';
import 'package:flutter/material.dart';
import '../screens/history_screen.dart';
import '../screens/login.dart';
import '../screens/news_screen.dart';
import '../screens/set_rate_alert_screen.dart'; // Ensure this import matches your file structure
import 'package:url_launcher/url_launcher.dart';

import '../service/auth.dart'; // Import url_launcher package

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final authMethods = AuthMethods(); // Assuming this is your authentication class
    final Future<dynamic> userFuture = authMethods.getCurrentUser(); // Replace with actual method to get the user


    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/app_img.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'CurrenSee',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text('Loading user information...'),
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text('Error loading user information'),
                  );
                } else if (snapshot.hasData) {
                  final user = snapshot.data;
                  final String userName = user.displayName ?? 'User';
                  final String userEmail = user.email ?? 'Email not available';

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 9.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          blurRadius: 1,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Signed in as:',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          userName,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'with email:',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          userEmail,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text('No user information available'),
                  );
                }
              },
            ),
            Divider(),

            ListTile(
              onTap: () async {
                await signOut(context); // Call the sign out function
                // Navigate to the login page after signing out
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LogIn()),
                );
              },
              horizontalTitleGap: 0.0,
              leading: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 22,
                  minHeight: 22,
                  maxWidth: 22,
                  maxHeight: 22,
                ),
                child: Icon(Icons.person_remove, size: 22), // Sign Up icon
              ),
              title: Text('Logout'),
            ),
            ListTile(
              // onTap: _launchWhatsApp,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SetBaseCurrencyScreen()),
                );
              },
              horizontalTitleGap: 0.0,
              leading: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 22,
                  minHeight: 22,
                  maxWidth: 22,
                  maxHeight: 22,
                ),
                child: Icon(Icons.monetization_on, size: 22), // WhatsApp icon
              ),
              title: Text('Set base currencies'),
            ),

            ListTile(
              onTap: () {
                // Navigate to the HistoryScreen when "View history" is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()),
                );
              },
              horizontalTitleGap: 0.0,
              leading: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 22,
                  minHeight: 22,
                  maxWidth: 22,
                  maxHeight: 22,
                ),
                child: Icon(Icons.history, size: 22), // History icon
              ),
              title: Text('View history'),
            ),
            ListTile(
              onTap: () {
                // Navigate to the SetRateAlertScreen when "Set rate alert" is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SetRateAlertScreen()),
                );
              },
              horizontalTitleGap: 0.0,
              leading: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 22,
                  minHeight: 22,
                  maxWidth: 22,
                  maxHeight: 22,
                ),
                child: Icon(Icons.alarm_add, size: 22), // Set rate alert icon
              ),
              title: Text('Set rate alert'),
            ),

            ListTile(
              onTap: () {
                // Navigate to the NewsScreen when "News and Trends" is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewsScreen()),
                );
              },
              horizontalTitleGap: 0.0,
              leading: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 22,
                  minHeight: 22,
                  maxWidth: 22,
                  maxHeight: 22,
                ),
                child: Icon(Icons.newspaper_rounded, size: 22), // News icon
              ),
              title: Text('News and Trends'),
            ),
            ListTile(
              onTap: () {
                // Navigate to the FAQScreen when "FAQs" is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQScreen()),
                );
              },
              horizontalTitleGap: 0.0,
              leading: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 22,
                  minHeight: 22,
                  maxWidth: 22,
                  maxHeight: 22,
                ),
                child: Icon(Icons.question_answer, size: 22), // FAQs icon
              ),
              title: Text('FAQs'),
            ),
            ListTile(
              // onTap: _launchWhatsApp,
              onTap: () {
                launch('mailto:geraldokeke68@gmail.com?subject=Support Request');
              },
              horizontalTitleGap: 0.0,
              leading: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 22,
                  minHeight: 22,
                  maxWidth: 22,
                  maxHeight: 22,
                ),
                child: Icon(Icons.chat_bubble_outline, size: 22), // WhatsApp icon
              ),
              title: Text('Help, Support and Feedback (message us directly)'),
            ),
            // Add other menu items here
          ],
        ),
      ),
    );
  }
}
