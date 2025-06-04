import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {
        'question': 'How do I create a travel trail?',
        'answer': 'Go to the Home screen and click "Create Your Trail" to start adding your journey.'
      },
      {
        'question': 'Can I edit or delete my trails?',
        'answer': 'Yes, navigate to "My Trails" in the menu to manage your created trails.'
      },
      {
        'question': 'How do I contact support?',
        'answer': 'Use the contact form below or email us at support@traveltrace.com.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),

          ...faqs.map((faq) => ExpansionTile(
                title: Text(faq['question']!, style: TextStyle(fontWeight: FontWeight.w600)),
                children: [Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(faq['answer']!),
                )],
              )),

          Divider(height: 30),

          Text(
            'Contact Us',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),

          TextField(
            decoration: InputDecoration(
              labelText: 'Your Email',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Your Message',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            icon: Icon(Icons.send),
            label: Text('Send Message'),
            onPressed: () {
              // TODO: implement send message logic (e.g., via backend or email API)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Message sent. We will contact you soon.')),
              );
            },
          ),
        ],
      ),
    );
  }
}
