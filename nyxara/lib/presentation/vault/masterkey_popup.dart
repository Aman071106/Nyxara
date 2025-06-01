import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MasterKeyVerificationPopup extends StatefulWidget {
  final Function(String) onVerified;

  const MasterKeyVerificationPopup({super.key, required this.onVerified});

  @override
  State<MasterKeyVerificationPopup> createState() =>
      _MasterKeyVerificationPopupState();
}

class _MasterKeyVerificationPopupState
    extends State<MasterKeyVerificationPopup> {
  final _formKey = GlobalKey<FormState>();
  final _masterKeyController = TextEditingController();
  bool _isVerifying = false;

  @override
  void dispose() {
    _masterKeyController.dispose();
    super.dispose();
  }

  String? _validateMasterKey(String? value) {
    if (value == null || value.isEmpty) {
      return 'Master key is required';
    }
    if (value.length < 6) {
      return 'Key must be at least 6characters';
    }
    return null;
  }

  Future<void> _verifyMasterKey() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isVerifying = true);
    try {
      await widget.onVerified(_masterKeyController.text);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      log("Exception here....");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.lock_outline, color: Colors.blue[700], size: 32),
                  const SizedBox(width: 12),
                  Text(
                    'VERIFY MASTER KEY',
                    style: TextStyle(
                      color: Colors.blue[300],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Master Key Field
              TextFormField(
                controller: _masterKeyController,
                obscureText: true,
                obscuringCharacter: '•',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 1.5,
                ),
                decoration: InputDecoration(
                  labelText: 'Enter Master Key',
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.vpn_key, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blueGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.lightBlue),
                  ),
                  filled: true,
                  fillColor: Colors.grey[850],
                ),
                validator: _validateMasterKey,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                    RegExp(r'\s'),
                  ), // No spaces allowed
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Minimum 6 characters required',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _isVerifying ? null : _verifyMasterKey,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child:
                    _isVerifying
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text(
                          'VERIFY & CONTINUE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
