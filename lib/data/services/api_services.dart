import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';


class ApiService {
  final String userUrl = 'http://jsonplaceholder.typicode.com/users';
  final String albumUrl = 'https://jsonplaceholder.typicode.com/albums?userId=';

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(userUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<Album>> fetchAlbums(int userId) async {
    final response = await http.get(Uri.parse('$albumUrl$userId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((album) => Album.fromJson(album)).toList();
    } else {
      throw Exception('Failed to load albums');
    }
  }
}