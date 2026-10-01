import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../services/api_service.dart';

enum GopicaState { idle, loading, success, error }

class GopicaScreen extends ConsumerStatefulWidget {
  const GopicaScreen({super.key});

  @override
  ConsumerState<GopicaScreen> createState() => _GopicaScreenState();
}

class _GopicaScreenState extends ConsumerState<GopicaScreen> {
  final TextEditingController _controller = TextEditingController();
  GopicaState _state = GopicaState.idle;
  String _result = '';
  String _errorMessage = '';

  Future<void> _processInput() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    FocusScope.of(context).unfocus(); // Dismiss keyboard
    setState(() => _state = GopicaState.loading);

    try {
      final api = ref.read(apiServiceProvider);
      final response = await api.processGopicaCommand(input);
      setState(() {
        _result = response;
        _state = GopicaState.success;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _state = GopicaState.error;
      });
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _result));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied successfully'), behavior: SnackBarBehavior.floating),
    );
  }

  void _shareResult() {
    Share.share(_result, subject: 'Gopica Result');
  }

  void _reset() {
    setState(() {
      _controller.clear();
      _result = '';
      _state = GopicaState.idle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gopica Workspace'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('What would you like to do?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              // Workspace Input
              TextField(
                controller: _controller,
                maxLines: 4,
                enabled: _state != GopicaState.loading,
                decoration: InputDecoration(
                  hintText: 'Enter your command or prompt here...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),
              
              // Process Button
              if (_state == GopicaState.idle || _state == GopicaState.error)
                FilledButton.icon(
                  onPressed: _processInput,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Process'),
                  style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
                ),

              if (_state == GopicaState.loading)
                const Column(
                  children: [
                    SizedBox(height: 24),
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Processing your request...', style: TextStyle(color: Colors.grey)),
                  ],
                ),

              if (_state == GopicaState.error)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(height: 8),
                      Text('Something went wrong. We couldn\'t complete your request.', style: TextStyle(color: Colors.red.shade900)),
                    ],
                  ),
                ),

              if (_state == GopicaState.success) ...[
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                const Text('Result', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(_result, style: const TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.copy, size: 16),
                      label: const Text('Copy'),
                      onPressed: _copyToClipboard,
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.share, size: 16),
                      label: const Text('Share'),
                      onPressed: _shareResult,
                    ),
                    ActionChip(
                      avatar: const Icon(Icons.bookmark_border, size: 16),
                      label: const Text('Save'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved to history!')));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('New Gopica'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}