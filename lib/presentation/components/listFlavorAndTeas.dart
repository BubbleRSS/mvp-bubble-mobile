import 'package:bubble_mobile/data/models/flavor.dart';
import 'package:bubble_mobile/data/repositories/flavor_repository.dart';
import 'package:bubble_mobile/presentation/components/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListFlavorAndTeasPage extends StatefulWidget {
  @override
  State<ListFlavorAndTeasPage> createState() => _ListFlavorAndTeasState();
}

class _ListFlavorAndTeasState extends State<ListFlavorAndTeasPage> {
  late Future<List<Flavor>> _listFlavors;
  final FlavorRepository _flavorRepository = FlavorRepository();
  final List<Flavor> _options = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFlavors();
  }
  final TextEditingController _titleFlavorController = TextEditingController();
  final TextEditingController _colorFlavorController = TextEditingController();
  final TextEditingController _iconFlavorController = TextEditingController();

  void setTextControllers() {
    _colorFlavorController.text = 'Color'; 
    _iconFlavorController.text = 'Icon';
  }

  Future<void> loadFlavors() async {
    try {
      _listFlavors = _flavorRepository.getFlavors();
      List<Flavor> flavors = await _listFlavors;
      setState(() {
        _options.addAll(flavors);
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> _updateFlavor(int id) async {
    
    setTextControllers();
    Flavor updatedFlavor = Flavor(
      id: id,
      title: _titleFlavorController.text,
      icon: _iconFlavorController.text,
      color: _colorFlavorController.text,
    );

    await _flavorRepository.updateFlavor(updatedFlavor);
    loadFlavors();
  }

  void _deleteFlavor(int? id) async {
    if (id != null) {
      await _flavorRepository.deleteFlavor(id);
      loadFlavors();
      const snackBar = SnackBar(content: Text('Flavor Excluido com sucesso',  style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.yellow);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void showForm(int? id) {
     if (id != null) {
      final existingFlavor = _options.firstWhere((option) => option.id == id);
      _titleFlavorController.text = existingFlavor.title;
      _colorFlavorController.text = existingFlavor.color;
      _iconFlavorController.text = existingFlavor.icon;
    } else {
      _titleFlavorController.clear();
      _colorFlavorController.clear();
      _iconFlavorController.clear();
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleFlavorController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                if (id != null) {
                  await _updateFlavor(id);
                }
                // Implementar atualização de flavor se necessário
                Navigator.of(context).pop();
              },
              child: Text(
                id == null ? 'Create Category' : 'Update Flavor',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
          child: Text(
            "Cadastro de tarefas",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppBarrPage()),
            );
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Flavor>>(
              future: _listFlavors,
              builder: (BuildContext context, AsyncSnapshot<List<Flavor>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar sabores'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Nenhum sabor encontrado'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      Flavor flavor = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.all(15),
                        child: ListTile(
                          title: Text(
                            flavor.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: Colors.white,
                                  onPressed: () => showForm(flavor.id),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.white,
                                  onPressed: () => _deleteFlavor(flavor.id),
                                ),
                                // Outros botões, se necessário
                              ],
                            ),
                          ),
                          onTap: () => showForm(flavor.id),
                        ),
                      );
                    },
                  );
                }
              },
            ),
    );
  }
}

