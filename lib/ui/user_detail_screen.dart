import 'package:flutter/material.dart';
import '../data/services/api_services.dart';
import '../data/models/user.dart';

class UserDetailScreen extends StatefulWidget {
  final User user;

  const UserDetailScreen({required this.user, super.key});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late Future<List<Album>> futureAlbums;

  @override
  void initState() {
    super.initState();
    futureAlbums = ApiService().fetchAlbums(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      widget.user.name[0],
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.name,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '@${widget.user.username}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${widget.user.email}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Phone: ${widget.user.phone}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Website: ${widget.user.website}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                  Text('Address:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('${widget.user.address.street}, ${widget.user.address.suite}', style: TextStyle(fontSize: 16)),
                  Text('${widget.user.address.city}, ${widget.user.address.zipcode}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                  Text('Company:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Name: ${widget.user.company.name}', style: TextStyle(fontSize: 16)),
                  Text('Catchphrase: ${widget.user.company.catchPhrase}', style: TextStyle(fontSize: 16)),
                  Text('Business: ${widget.user.company.bs}', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),

            SizedBox(height: 24),

            FutureBuilder<List<Album>>(
              future: futureAlbums,
              builder: (context, albumSnapshot) {
                if (albumSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (albumSnapshot.hasError) {
                  return Center(child: Text('Error: ${albumSnapshot.error}'));
                } else if (!albumSnapshot.hasData || albumSnapshot.data!.isEmpty) {
                  return Center(child: Text('No albums found.'));
                } else {
                  List<Album> albums = albumSnapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                      ),
                      itemCount: albums.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(16.0)),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blueAccent.withValues(alpha: 0.7),
                                  Colors.purpleAccent.withValues(alpha: 0.7),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/image_placeholder.png',
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),

                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        albums[index].title,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
