import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApplicationFormScreen extends StatefulWidget {
  const ApplicationFormScreen({super.key});

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _moduleName = TextEditingController();
  final TextEditingController _additionalNotes = TextEditingController();
  String _academicLevel = 'First Year';
  bool _meetsRequirements = false;
  bool _isSubmitting = false;

  final List<String> _academicLevels = [
    'First Year',
    'Second Year',
    'Third Year'
  ];

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all required fields'),
            backgroundColor: Colors.red),
      );
      return;
    }

    if (!_meetsRequirements) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please confirm you meet the minimum requirements'),
            backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('Not logged in');
      }

      // Check if user has profile
      final existingProfile = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (existingProfile == null) {
        await Supabase.instance.client.from('profiles').insert({
          'id': user.id,
          'full_name': user.email?.split('@').first ?? 'Student',
          'role': 'student',
        });
      }

      // Create application
      final appRes = await Supabase.instance.client
          .from('applications')
          .insert({
            'user_id': user.id,
            'status': 'pending',
            'meets_requirements': _meetsRequirements,
          })
          .select()
          .single();

      // Create module application
      await Supabase.instance.client.from('module_applications').insert({
        'application_id': appRes['id'],
        'academic_level': _academicLevel,
        'module_name': _moduleName.text.trim(),
        'additional_notes': _additionalNotes.text.trim(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Application submitted successfully!'),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Application'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Module Application',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _academicLevel,
                  decoration: const InputDecoration(
                    labelText: 'Academic Level',
                    border: OutlineInputBorder(),
                  ),
                  items: _academicLevels.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _academicLevel = value!);
                  },
                  validator: (value) => value == null ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _moduleName,
                  decoration: const InputDecoration(
                    labelText: 'Module Name',
                    hintText: 'e.g., TPG316C, SOD316C',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.trim().isEmpty ? 'Module name required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _additionalNotes,
                  decoration: const InputDecoration(
                    labelText: 'Additional Notes (Optional)',
                    hintText: 'Tell us why you want to assist',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _meetsRequirements,
                      onChanged: (value) {
                        setState(() => _meetsRequirements = value ?? false);
                      },
                      activeColor: Colors.green,
                    ),
                    const Expanded(
                      child: Text(
                        'I confirm that I meet the minimum requirements (65% average, no failed modules)',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (_isSubmitting)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: _submitApplication,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.deepPurple,
                    ),
                    child: const Text('Submit Application'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
