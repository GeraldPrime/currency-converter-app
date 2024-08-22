import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          FAQItem(
            question: 'How do I use the app?',
            answer: 'To use the app, simply navigate through the different sections using the menu drawer and select the options you are interested in.',
          ),
          FAQItem(
            question: 'How can I reset my password?',
            answer: 'To reset your password, go to the settings page and select "Reset Password". Follow the instructions to reset your password.',
          ),
          FAQItem(
            question: 'Where can I find the terms of service?',
            answer: 'The terms of service can be found in the settings page under "Terms of Service".',
          ),
          FAQItem(
            question: 'Where can I find the terms of service?',
            answer: 'The terms of service can be found in the settings page under "Terms of Service".',
          ),
          FAQItem(
            question: 'How do I set a rate alert?',
            answer: 'To set a rate alert, navigate to the "Set Rate Alert" section, select the currencies and the threshold rate, and then tap "Set Alert."',
          ),
          FAQItem(
            question: 'How do I view my conversion history?',
            answer: 'Your conversion history can be viewed by going to the "Conversion History" section in the app. It displays all your past currency conversions.',
          ),
          FAQItem(
            question: 'How can I change the base currency?',
            answer: 'You can change your base currency by going to the "Set Base Currency" option in the menu, selecting your preferred currency, and saving the changes.',
          ),
          FAQItem(
            question: 'Why aren\'t my rate alerts triggering?',
            answer: 'Ensure that notifications are enabled for the app and that your alert\'s threshold rate has been met. Also, double-check your internet connection for real-time updates.',
          ),
          FAQItem(
            question: 'How do I update the exchange rates?',
            answer: 'Exchange rates are updated automatically when you open the app. You can also refresh the rates manually by pulling down on the screen in the currency converter section.',
          ),
          FAQItem(
            question: 'Can I use the app offline?',
            answer: 'The app requires an internet connection to fetch the latest exchange rates. However, you can view your conversion history and set rate alerts offline.',
          ),
          FAQItem(
            question: 'How do I log out of my account?',
            answer: 'To log out, open the menu drawer, scroll down to the bottom, and tap "Logout."',
          ),
          FAQItem(
            question: 'How can I delete a rate alert?',
            answer: 'To delete a rate alert, go to the "Set Rate Alert" section, and you’ll see a list of your alerts. Tap the delete icon next to the alert you wish to remove.',
          ),
          FAQItem(
            question: 'What do I do if the app crashes or freezes?',
            answer: 'If the app crashes or freezes, try restarting it. If the issue persists, consider reinstalling the app or contacting support.',
          ),
          FAQItem(
            question: 'How can I change the language of the app?',
            answer: 'Currently, the app supports only one language. Future updates may include multi-language support.',
          ),
          // Add more FAQ items as needed
        ],
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(question),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(answer),
        ),
      ],
    );
  }
}
