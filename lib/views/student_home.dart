import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'application_form.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  List<Map<String, dynamic>> _applications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final response = await Supabase.instance.client
          .from('applications')
          .select()
          .eq('user_id', user.id);
      setState(() {
        _applications = response;
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Portal'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _applications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.description,
                          size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('No applications yet.'),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ApplicationFormScreen()),
                          );
                          _loadData();
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Create Application'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _applications.length,
                    itemBuilder: (context, index) {
                      final app = _applications[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          title:
                              Text('Application #${app['id'].substring(0, 6)}'),
                          subtitle: Text('Status: ${app['status']}'),
                          trailing: Chip(
                            label: Text(app['status']),
                            backgroundColor: app['status'] == 'pending'
                                ? Colors.orange
                                : (app['status'] == 'approved'
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: _applications.isEmpty
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ApplicationFormScreen()),
                );
                _loadData();
              },
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
