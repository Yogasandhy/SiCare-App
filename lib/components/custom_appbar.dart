import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Auth.dart';
import '../screens/profile/profileScreen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.isAdmin = false,
  });

  final isAdmin;

  @override
  Widget build(BuildContext context) {
    final authP = Provider.of<Auth>(context);
    return AppBar(
      title: Image.asset('assets/mainlogobiru.png', fit: BoxFit.cover),
      automaticallyImplyLeading: false,
      actions: [
        isAdmin
            ? Padding(
                padding: const EdgeInsets.only(right: 16),
                child: authP.user.photoURL != null
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(),
                              ));
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(authP.user.photoURL!),
                          radius: 20,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(),
                              ));
                        },
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/user.png'),
                          radius: 20,
                        ),
                      ),
              )
            : Container(),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
