import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              HapticFeedback
                  .lightImpact(); // Provide haptic feedback for back button
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'About Us',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 10),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Demo Application',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Team Members:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('John Doe\nJane Smith\nBob Johnson'),
            SizedBox(height: 20),
            Text(
              'Organization:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Demo Organization'),
            SizedBox(height: 20),
            Text(
              'Version:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('1.0.0'),
            SizedBox(height: 20),
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'This is a demo application for sign language recognition and speech to video. Here, you can connect to a server for sign language recognition or use speech-to-text to play corresponding videos.',
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
