import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../components/custom_appbar.dart';
import '../../providers/userDataProvider.dart';

class PatientScreen extends StatelessWidget {
  const PatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isAdmin: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return StreamBuilder<QuerySnapshot>(
              stream: userProvider.usersStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data?.docs ?? [];

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final userData = user.data() as Map<String, dynamic>;

                    return UserCard(
                      displayName: userData['displayName'] ?? 'No Name',
                      photoURL: userData['photoURL'] ??
                          'https://via.placeholder.com/150',
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final String displayName;
  final String photoURL;

  const UserCard({
    required this.displayName,
    required this.photoURL,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: photoURL.isNotEmpty
                      ? Image.network(
                          photoURL,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/people.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    displayName,
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: ButtonBar(
                    buttonPadding: EdgeInsets.zero,
                    alignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          minimumSize: Size(100, 36),
                        ),
                        child: Text('Edit'),
                      ),
                      SizedBox(width: 10.0,),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          minimumSize: Size(100, 36),
                        ),
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
