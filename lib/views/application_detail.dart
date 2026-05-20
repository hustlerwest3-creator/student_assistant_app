import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/student_viewmodel.dart';

class ApplicationDetailScreen extends StatelessWidget {
  final String applicationId;
  final String status;
  final bool meetsRequirements;
  final List<dynamic> modules;

  const ApplicationDetailScreen({
    super.key,
    required this.applicationId,
    required this.status,
    required this.meetsRequirements,
    required this.modules,
  });

  Future<void> _deleteApplication(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Application'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      final studentVM = Provider.of<StudentViewModel>(context, listen: false);
      await studentVM.deleteApplication(applicationId, context);
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPending = status == 'pending';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Details'),
        backgroundColor: Colors.deepPurple,
        actions: [
          if (isPending)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteApplication(context),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: status == 'pending'
                    ? Colors.orange
                    : (status == 'approved' ? Colors.green : Colors.red),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(status.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: meetsRequirements
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: meetsRequirements ? Colors.green : Colors.red),
              ),
              child: Text(
                meetsRequirements
                    ? '✓ Meets minimum requirements'
                    : '✗ Does NOT meet minimum requirements',
                style: TextStyle(
                    color: meetsRequirements ? Colors.green : Colors.red),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Modules Applied For',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...modules.map((mod) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(mod.moduleName,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple)),
                        const SizedBox(height: 4),
                        Text('Academic Level: ${mod.academicLevel}'),
                        if (mod.additionalNotes != null &&
                            mod.additionalNotes!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text('Notes: ${mod.additionalNotes}',
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic)),
                          ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 24),
            if (!isPending)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: status == 'approved'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                        status == 'approved'
                            ? Icons.check_circle
                            : Icons.cancel,
                        color:
                            status == 'approved' ? Colors.green : Colors.red),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        status == 'approved'
                            ? 'Congratulations! Your application has been approved.'
                            : 'Unfortunately, your application has been rejected.',
                        style: TextStyle(
                            color: status == 'approved'
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
