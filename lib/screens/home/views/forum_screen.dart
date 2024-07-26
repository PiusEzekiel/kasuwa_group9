import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../components/my_text_field.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController _messageController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  late String currentUsername; // Store the current username
  final _formKey = GlobalKey<FormState>();
  String? _editedMessage; // To store the edited message

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getMessages() {
    _firestore
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        messages.clear();
        for (var doc in snapshot.docs) {
          messages.add({
            'id': doc.id, // Add the document ID to the message map
            'message': doc['message'],
            'sender': doc['senderUsername'], // Use 'senderUsername' field
            'isSender': doc['senderUsername'] == currentUsername,
          });
        }
      });
    });
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final newMessage = {
        'senderUsername': currentUsername, // Use 'senderUsername' field
        'message': _messageController.text,
        'timestamp': DateTime.now(),
      };
      await _firestore.collection('messages').add(newMessage);
      _messageController.clear();

      // Add the new message to the messages list
      setState(() {
        messages
            .add(newMessage); // Insert at the beginning for chronological order
      });
    }
  }

  void _editMessage(String messageId, String message) {
    setState(() {
      _editedMessage = message;
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Message'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              initialValue: message,
              decoration: const InputDecoration(labelText: 'Enter Message'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a message';
                }
                return null;
              },
              onSaved: (value) {
                _editedMessage = value;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _updateMessage(messageId, _editedMessage!);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateMessage(String messageId, String updatedMessage) async {
    await _firestore.collection('messages').doc(messageId).update({
      'message': updatedMessage,
    });
  }

  void _deleteMessage(String messageId) async {
    await _firestore.collection('messages').doc(messageId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.forum_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 28.0,
            ),
            const SizedBox(width: 8.0),
            Text(
              'Forum',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontSize: 24.0),
            ),
          ],
        ),
      ),
      body: FutureBuilder<String>(
          future: _getCurrentUser(), // Call _getCurrentUser() here
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              currentUsername = snapshot.data!; // Assign the username

              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('messages')
                            .orderBy('timestamp', descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final messages = snapshot.data!.docs.map((doc) {
                            return {
                              'id': doc.id, // Add the document ID
                              'message': doc['message'],
                              'sender': doc['senderUsername'],
                              'isSender':
                                  doc['senderUsername'] == currentUsername,
                            };
                          }).toList();

                          return ListView.builder(
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              return Dismissible(
                                key: Key(message['id']),
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                onDismissed: (direction) {
                                  _deleteMessage(message['id']);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              child: Text(
                                                message['sender'][0],
                                                style: const TextStyle(
                                                    fontSize: 20),
                                              ),
                                            ),
                                            Text(
                                              message['sender'],
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      const SizedBox(width: 15.0),
                                      Flexible(
                                        child: GestureDetector(
                                          onTap: () {
                                            _editMessage(message['id'],
                                                message['message']);
                                          },
                                          child: Container(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
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
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            child: Text(
                                              message['message'],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[700]),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15.0),
                                      if (message['isSender'])
                                        Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                              child: Text(
                                                message['sender'][0],
                                                style: const TextStyle(
                                                    fontSize: 20),
                                              ),
                                            ),
                                            Text(
                                              message['sender'],
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
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
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: _sendMessage,
                          icon: Icon(
                            Icons.send,
                            color: Theme.of(context).colorScheme.primary,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  Future<String> _getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      return userDoc.get('name') as String;
    }
    throw Exception('User not found'); // Handle the case where the user is null
  }
}
