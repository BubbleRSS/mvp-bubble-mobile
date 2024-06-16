import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'package:bubble_mobile/presentation/components/settings_tile.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
    Future<void> _openFileExplorer(BuildContext context) async {
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

          if (fileBytes != null) {
            await _importDatabase(fileBytes, fileName);
          }
        }
      } else {
        result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['json'],
            dialogTitle: "Selecione seu backup");
        if (result != null && result.files.isNotEmpty) {
          File file = File(result.files.single.path!);
          print("File: $file");

          final fileBytes = await file.readAsBytes();
          await _importDatabase(fileBytes, file.path);
        } else {
          print("Canceled the picker");
        }
      }
    } catch (e) {
      print("Error while picking the file: $e");
    }
  }

  Future<void> _importDatabase(Uint8List fileBytes, String fileName) async {
    try {
      // Decode the JSON data
      String jsonString = utf8.decode(fileBytes);
      Map<String, dynamic> jsonData = jsonDecode(jsonString);

      // Get the path to the database file
      final databasesPath = await getDatabasesPath();
      final dbPath = path.join(databasesPath, 'bubble_database.db');

      // Open the database
      Database db = await openDatabase(dbPath);

      // Clear existing data and insert new data
      for (var tableName in jsonData.keys) {
        List<Map<String, dynamic>> tableData = List<Map<String, dynamic>>.from(jsonData[tableName]);
        await db.delete(tableName);
        for (var row in tableData) {
          await db.insert(tableName, row);
        }
      }

      print("Database imported successfully from $fileName");
    } catch (e) {
      print("Error while importing the database: $e");
    }
  }

  Future<void> _exportDatabase() async {
    try {
      // Get the path to the database file
      final databasesPath = await getDatabasesPath();
      final dbPath = path.join(databasesPath, 'bubble_database.db');

      // Open the database
      Database db = await openDatabase(dbPath);

      // Get the data from the database
      List<Map<String, dynamic>> tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table'");
      Map<String, List<Map<String, dynamic>>> dbData = {};

      for (var table in tables) {
        String tableName = table['name'];
        List<Map<String, dynamic>> tableData =
            await db.query(tableName);
        dbData[tableName] = tableData;
      }

      // Convert the data to JSON
      String jsonData = jsonEncode(dbData);

      if (kIsWeb) {
        // Save the file for web
        _saveFileWeb(jsonData, 'backup.json');
      } else {
        // Save the file for non-web
        await _saveFileMobile(jsonData);
      }
    } catch (e) {
      print("Error while exporting the database: $e");
    }
  }

  void _saveFileWeb(String content, String filename) {
    final bytes = utf8.encode(content);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", filename)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  Future<void> _saveFileMobile(String content) async {
    try {
      // Get the path to the documents directory
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      // Create the file
      String filePath = path.join(appDocPath, 'backup.json');
      File file = File(filePath);

      // Write the JSON data to the file
      await file.writeAsString(content);

      // Let the user pick a location to save the file
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save your backup file',
        fileName: 'backup.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (outputFile != null) {
        // Copy the backup file to the chosen location
        await file.copy(outputFile);
        print("Database exported successfully to $outputFile");
      } else {
        print("Canceled the picker");
      }
    } catch (e) {
      print("Error while saving the file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Configurações')),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              SettingsTile(
                title: 'Exportar backup',
                subtitle: 'Exporte seus dados através do arquivo JSON',
                leadingIcon: Icons.backup_rounded,
                onTap: () => _exportDatabase(),
              ),
              SettingsTile(
                title: 'Importar backup',
                subtitle: 'Importe seus dados através do arquivo JSON',
                leadingIcon: Icons.restore_rounded,
                onTap: () => _openFileExplorer(context),
              ),
            ],
          ),
        ));
  }
}