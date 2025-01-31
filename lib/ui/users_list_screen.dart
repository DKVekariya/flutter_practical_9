import 'package:flutter/material.dart';
import 'package:flutter_practical_9/ui/user_detail_screen.dart';
import '../data/models/user.dart';
import '../data/services/api_services.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});
  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  late Future<List<User>> futureUsers;
  late List<User> users;

  @override
  void initState() {
    super.initState();
    futureUsers = ApiService().fetchUsers();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final user = users.removeAt(oldIndex);
      users.insert(newIndex, user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found.'));
          } else {
            users = snapshot.data!;

            return ReorderableListView(
              onReorder: _onReorder,
              children: [
                for (int index = 0; index < users.length; index++)
                  Card(
                    key: ValueKey(users[index].id),
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    elevation: 4.0,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          users[index].name[0],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(users[index].name),
                      subtitle: Text(users[index].email),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDetailScreen(user: users[index]),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
