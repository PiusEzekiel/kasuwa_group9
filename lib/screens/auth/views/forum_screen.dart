import 'package:flutter/material.dart';

import '../../../components/my_text_field.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final List<Map<String, dynamic>> messages = [
    {
      'message':
          'Hey everyone, I\'m new to Kasuwa and just wanted to get some advice from the other farmers on here. What has your experience been like selling through the platform so far?',
      'sender': 'Tunde',
      'isSender': false,
    },
    {
      'message':
          'I\'ve been using the platform for about a year now and it\'s been a total game-changer for my small organic vegetable farm. The direct connection with customers in my local area has allowed me to earn much better prices compared to working with wholesalers and middlemen.',
      'sender': 'Aisha',
      'isSender': true,
    },
    {
      'message':
          'That\'s great to hear! I\'m really looking forward to getting my products in front of more consumers.',
      'sender': 'Baba',
      'isSender': false,
    },
    {
      'message':
          'Thanks so much for sharing your experience - I\'m feeling much more confident about getting started on Family now.',
      'sender': 'Chioma',
      'isSender': true,
    },
  ];

  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        messages.add({
          'message': _messageController.text,
          'sender': 'You',
          'isSender': true,
        });
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Flexible(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.forum_outlined,
                color: Theme.of(context).colorScheme.primary, size: 28.0),
            const SizedBox(width: 8.0),
            Text('Forum',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24.0)),
          ],
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: message['isSender']
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!message['isSender'])
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.7),
                                child: Text(message['sender'][0]),
                              ),
                              Text(
                                message['sender'],
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(width: 15.0),
                        Flexible(
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.9,
                            ),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: message['isSender']
                                  ? Theme.of(context)
                                      .colorScheme
                                      .tertiary
                                      .withOpacity(0.3)
                                  : Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.0),
                            ),

                            //message container
                            child: Text(
                              message['message'],
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700]),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        if (message['isSender'])
                          Column(
                            children: [
                              // SizedBox(height: 15.0),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor:
                                    Theme.of(context).colorScheme.tertiary,
                                child: Text(message['sender'][0]),
                              ),
                              Text(
                                message['sender'],
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: MyTextField(
                        controller: _messageController,
                        hintText: 'Send chat...',
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          }
                          return null;
                        })),
                const SizedBox(width: 16),
                // ElevatedButton(
                //   onPressed: _sendMessage,
                //   child: const Text('Send'),
                // ),

                IconButton(
                    onPressed: _sendMessage,
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
