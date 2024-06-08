import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projek/data/user.dart';
import 'package:projek/register_page.dart';
import 'package:projek/search.dart';

class ListUser extends StatefulWidget {
  @override
  _ListUserState createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  late Future<List<User>> futureUsers;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers(currentPage);
  }

  Future<List<User>> fetchUsers(int page) async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=$page'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> data = json['data'];

      return data.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  void _changePage(int page) {
    setState(() {
      currentPage = page;
      futureUsers = fetchUsers(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Daftar Pengguna', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<User>>(
              future: futureUsers,
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : snapshot.hasError
                        ? Center(child: Text('Error: ${snapshot.error}'))
                        : !snapshot.hasData
                            ? Center(child: Text('No data found'))
                            : ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  User user = snapshot.data![index];
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 5,
                                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(10),
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          user.avatar,
                                          width: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: Text(
                                          '${user.firstName} ${user.lastName}',
                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailPage(user: user),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.blue),
                onPressed:
                    currentPage > 1 ? () => _changePage(currentPage - 1) : null,
              ),
              IconButton(
                icon: Icon(Icons.app_registration, color: Colors.green),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.search, color: Colors.orange),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FindUser(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward, color: Colors.blue),
                onPressed:
                    currentPage < 2 ? () => _changePage(currentPage + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class DetailPage extends StatelessWidget {
  final User user;

  const DetailPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${user.firstName} ${user.lastName}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(user.avatar, width: 100, fit: BoxFit.cover),
            SizedBox(height: 16),
            Text('ID: ${user.id}'),
            Text('First Name: ${user.firstName}'),
            Text('Last Name: ${user.lastName}'),
            Text('Email: ${user.email}'),
          ],
        ),
      ),
    );
  }
}
