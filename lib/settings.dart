import 'dart:io';

import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _openFileExplorer(BuildContext context) async {
    try {
      FilePickerResult? result;
      if (kIsWeb) {
        result = await FilePickerWeb.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['json'],
            dialogTitle: "Selecione seu backup");
        if (result != null && result.files.isNotEmpty) {
          final fileBytes = result.files.first.bytes;
          final fileName = result.files.first.name;

          print("FileName: $fileName");
        }
      } else {
        result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['json'],
            dialogTitle: "Selecione seu backup");
        if (result != null && result.files.isNotEmpty) {
          File file = File(result.files.single.path!);
          print("File: $file");
        } else {
          print("Canceled the picker");
        }
      }
    } catch (e) {
      print("Error while picking the file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Exportar backup'),
            subtitle: const Text('Exporte seus dados através do arquivo JSON'),
            leading: const Icon(Icons.backup_rounded),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Importar backup'),
            subtitle: const Text('Importe seus dados através do arquivo JSON'),
            leading: const Icon(Icons.restore_rounded),
            onTap: () => _openFileExplorer(context),
          ),
        ],
      ),
    );
  }
}
