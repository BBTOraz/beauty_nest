// Изменённый файл: lib/widgets/personal_data_section.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_view_model.dart';

class PersonalDataSection extends StatefulWidget {
  const PersonalDataSection({super.key});
  @override
  _PersonalDataSectionState createState() => _PersonalDataSectionState();
}

class _PersonalDataSectionState extends State<PersonalDataSection> {
  final _addressController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authVM = Provider.of<AuthViewModel>(context);
    _addressController.text = authVM.userModel?.address ?? '';
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        final text = _addressController.text;
        if (text.isNotEmpty) {
          authVM.updateAddress(text);
        }
      }
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _addressController,
        focusNode: _focusNode,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-zА-Яа-яЁё0-9\s,.\-]'))
        ],
        decoration: const InputDecoration(
          labelText: 'Адрес',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
