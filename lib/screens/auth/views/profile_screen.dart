import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Add your edit functionality here
            },
          ),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 30.0, top: 20, right: 30.0, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 100.0,
                child: Icon(Icons.person, size: 150.0),
                // child: Image(image: AssetImage('images/kasuwa_logo.png')),

                // style: TextStyle(fontSize: 24.0),
              ),
            ),
            const SizedBox(height: 40.0),
            Text(
              'Name',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8.0),
            Divider(
              color: Theme.of(context).colorScheme.primary,
              thickness: 2,
            ),
            // const SizedBox(height: 8.0),
            // const Text('Bio', style: TextStyle(fontSize: 20.0)),
            // const Text('Bio', style: TextStyle(fontSize: 16.0)),
            const SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      size: 30,
                      color: Colors.red.shade600,
                    ),
                    const SizedBox(width: 8.0),
                    const Text('Cart: 3', style: TextStyle(fontSize: 18)),
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
                    const Text('Likes: 7', style: TextStyle(fontSize: 18)),
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
                  color: Colors.red.shade600,
                ),
                const SizedBox(width: 8.0),
                const Text('Saved Card:', style: TextStyle(fontSize: 18.0)),
                const Spacer(),
                const Text('474 xxxx xxx xxx',
                    style: TextStyle(fontSize: 18.0)),
              ],
            ),
            const SizedBox(height: 25.0),
            Row(
              children: [
                Icon(
                  Icons.message,
                  size: 30,
                  color: Colors.red.shade600,
                ),
                const SizedBox(width: 8.0),
                const Text('Receive messages',
                    style: TextStyle(fontSize: 18.0)),
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
                  color: Colors.red.shade600,
                ),
                const SizedBox(width: 8.0),
                const Text('Notifications', style: TextStyle(fontSize: 18.0)),
                const Spacer(),
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
