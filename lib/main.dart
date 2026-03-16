import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vrdamvurihydlguadhjy.supabase.co',
    anonKey: 'sb_publishable_7F-_lrJd6dU1OJyiPEbkyg_-GQXyahh',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;

  List users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final data = await supabase.from('elderly_user').select();

    setState(() {
      users = data;
    });
  }

  Future<void> insertUser() async {
    await supabase.from('elderly_user').insert({
      'full_name': 'Test User',
      'age': 70,
      'gender': 'Male',
      'phone_number': '0123456789',
    });

    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Supabase Test')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: insertUser,
            child: const Text("Insert User"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user['full_name'] ?? ''),
                  subtitle: Text("Age: ${user['age']}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
