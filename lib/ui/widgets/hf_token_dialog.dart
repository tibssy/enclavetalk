import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HfTokenDialog extends StatefulWidget {
  final Function(String) onSave;

  const HfTokenDialog({super.key, required this.onSave});

  @override
  State<HfTokenDialog> createState() => _HfTokenDialogState();
}

class _HfTokenDialogState extends State<HfTokenDialog> {
  final TextEditingController _controller = TextEditingController();

  bool _isValidating = false;
  String? _errorMessage;
  String? _successMessage;

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://huggingface.co/settings/tokens');
    if (!await launchUrl(url)) {
      debugPrint('Could not launch $url');
    }
  }

  Future<void> _validateAndSave() async {
    final token = _controller.text.trim();
    if (token.isEmpty) return;

    setState(() {
      _isValidating = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://huggingface.co/api/whoami-v2'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final username = data['name'];

        if (mounted) {
          setState(() {
            _isValidating = false;
            _successMessage = 'Verified as $username';
          });
        }

        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          widget.onSave(token);
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          setState(() {
            _isValidating = false;
            _errorMessage = 'Invalid token. Please check and try again.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isValidating = false;
          _errorMessage = 'Connection error. Please check internet.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Hugging Face Token Required'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This model is gated and requires a Hugging Face User Access Token to download.',
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _launchUrl,
            child: Text(
              'Get your token here',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            enabled: !_isValidating && _successMessage == null,
            decoration: InputDecoration(
              labelText: 'Paste Token (hf_...)',
              border: const OutlineInputBorder(),
              errorText: _errorMessage,
              suffixIcon: _successMessage != null
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
            ),
          ),
          if (_successMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.check, size: 16, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(
                    _successMessage!,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      actions: [
        if (_isValidating)
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else ...[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: _successMessage != null ? null : _validateAndSave,
            child: const Text('Verify & Save'),
          ),
        ],
      ],
    );
  }
}
