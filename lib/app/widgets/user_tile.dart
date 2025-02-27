import 'package:flutter/material.dart';

class UserListTile extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const UserListTile({super.key, required this.user, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(child: Text(user['name'][0])),
        title: Text(user['name']),
        subtitle: Text(user['email']),
        onTap: onTap,
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
