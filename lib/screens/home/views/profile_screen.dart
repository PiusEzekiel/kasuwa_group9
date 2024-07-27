import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../cart/views/order_history.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //implementing fetch user profile
  late User? _user;
  String? _userName; //To store the user name
  String? _email; //To store the user email
  // bool _isLoading =
  //     false; //Flag for loading state while user wants to edit profile
  File? _selectedImage;
  String? _imageUrl; // To store the URL of the uploaded image

  // Cart related variables
  int _cartItemCount = 0; // Initialize with 0

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _fetchCartCount(); // Fetch the cart count on initialization
  }

  // Function to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Function to upload the image to Firebase Storage
  Future<void> _uploadImageToStorage() async {
    if (_selectedImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_profile_images')
          .child(_user!.uid); // Use the user's UID for the image path
      final uploadTask = storageRef.putFile(_selectedImage!);
      await uploadTask.whenComplete(() async {
        _imageUrl = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .update({'profileImageUrl': _imageUrl});
        setState(() {});
      });
    }
  }

// Edit Profile Functionality
  final _formKey = GlobalKey<FormState>();
  String? _newUserName;

//Function to update user profile in Firebase Firestore

  Future<void> _updateUserProfile(String newName) async {
    final userId = _user!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'name': newName});
    setState(() {
      _userName = newName;
    });
  }

//Function to update user profile ends

  // Function to fetch the cart count from Firestore
  Future<void> _fetchCartCount() async {
    final userId = _user!.uid;
    final cartDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .get();
    setState(() {
      _cartItemCount = cartDoc.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              color: Theme.of(context).colorScheme.primary,
              size: 30,
            ),
            const SizedBox(width: 8.0),
            Text('Profile',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24.0)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Add your edit functionality here
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text(
                          'Edit Profile',
                          style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.tertiary),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Form(
                              key: _formKey,
                              child: TextFormField(
                                initialValue: '$_userName',
                                decoration: const InputDecoration(
                                  // labelText: 'New Name',
                                  hintText: 'Enter new name...',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _newUserName = value;
                                },
                              ),
                            ),
                            // const SizedBox(height: 10),
                            Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Your email: $_email",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                //Button to pick image from gallery
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.tertiary,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(250, 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    _pickImageFromGallery();
                                  },
                                  child: const Text('Select Profile Picture',
                                      style: TextStyle(fontSize: 12)),
                                ),
                                if (_selectedImage != null)
                                  Image.file(_selectedImage!,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover),
                              ],
                            )
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel',
                                style: TextStyle(
                                  color: Colors.red,
                                )),
                          ),
                          TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await _updateUserProfile(_newUserName!);
                                if (_selectedImage != null) {
                                  await _uploadImageToStorage();
                                }
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                        ],
                      ));
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final userDoc = snapshot.data!;
            if (userDoc.exists) {
              _userName = userDoc.get('name') as String?;
              _email = userDoc.get('email') as String?;
              // Check if the field exists before accessing it
              if (userDoc.data() != null &&
                  (userDoc.data() as Map).containsKey('profileImageUrl')) {
                _imageUrl = userDoc.get('profileImageUrl') as String?;
              } else {
                _imageUrl = null; // Or set it to a default image URL
              }
              return Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, top: 20, right: 30.0, bottom: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          radius: 100.0,
                          backgroundImage: _imageUrl != null
                              ? NetworkImage(_imageUrl!)
                              : _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : Image.asset(
                                      'images/profile_image.png',
                                      fit: BoxFit.cover,
                                    ).image, // Use const AssetImage
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      // if (_userName != null)
                      Text(
                        'Hi, $_userName',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      // const SizedBox(height: 8.0),
                      Divider(
                        color: Theme.of(context).colorScheme.tertiary,
                        thickness: 2,
                      ),

                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.shopping_cart,
                                size: 30,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                'Cart: $_cartItemCount', // Display cart item count
                                style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                size: 30,
                                color: Colors.red.shade600,
                              ),
                              const SizedBox(width: 8.0),
                              Text('Likes: 7',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        children: [
                          Icon(
                            Icons.credit_card,
                            size: 30,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          const SizedBox(width: 8.0),
                          Text('Saved Card:',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color:
                                      Theme.of(context).colorScheme.tertiary)),
                          const Spacer(),
                          Text('474 xxxx xxx xxx',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color:
                                      Theme.of(context).colorScheme.tertiary)),
                        ],
                      ),

                      const SizedBox(height: 25.0),
                      Row(
                        children: [
                          Icon(
                            Icons.message,
                            size: 30,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          const SizedBox(width: 8.0),
                          Text('Receive messages',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color:
                                      Theme.of(context).colorScheme.tertiary)),
                          const Spacer(),
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        children: [
                          Icon(
                            Icons.notifications,
                            size: 30,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          const SizedBox(width: 8.0),
                          Text('Notifications',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color:
                                      Theme.of(context).colorScheme.tertiary)),
                          const Spacer(),
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      // Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push<void>(context,
                              MaterialPageRoute(builder: (context) {
                            return const OrderHistoryScreen(); // Use const here
                          }));
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 30,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            const SizedBox(width: 8.0),
                            Text('View All Orders',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('User not found'));
            }
          }
          return Container();
        },
      ),
    );
  }
}
