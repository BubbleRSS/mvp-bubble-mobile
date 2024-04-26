import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Exportar dados'),
            subtitle: const Text(
                'Exporte suas configurações através do arquivo JSON'),
            leading: const Icon(Icons.backup_rounded),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Importar dados'),
            subtitle: const Text(
                'Importe suas configurações através do arquivo JSON'),
            leading: const Icon(Icons.restore_rounded),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
