import 'package:bubble_mobile/data/models/flavor.dart';
import 'package:bubble_mobile/data/models/tea.dart';
import 'package:bubble_mobile/data/repositories/flavor_repository.dart';
import 'package:bubble_mobile/data/repositories/tea_repository.dart';
import 'package:bubble_mobile/presentation/components/appBar.dart';
import 'package:bubble_mobile/presentation/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

class ListFlavorAndTeasPage extends StatefulWidget {
  @override
  State<ListFlavorAndTeasPage> createState() => _ListFlavorAndTeasState();
}

class _ListFlavorAndTeasState extends State<ListFlavorAndTeasPage> {
  late Future<List<Flavor>> _listFlavors;
  final FlavorRepository _flavorRepository = FlavorRepository();
  final TeaRepository _teaRepository = TeaRepository();
  List<Tea> _teas = [];
  final List<Flavor> _flavors = [];
  bool _isLoading = true;
  late Tea existingTea;
  late Flavor existingFlavor;

  @override
  void initState() {
    super.initState();
    loadFlavors();
  }
  final TextEditingController _titleFlavorController = TextEditingController();
  final TextEditingController  _titleTeaController = TextEditingController();
  final TextEditingController _colorFlavorController = TextEditingController();
  final TextEditingController _iconFlavorController = TextEditingController();
  final TextEditingController _rssTeaController = TextEditingController();


  void setTextControllers() {
    _colorFlavorController.text = 'Color'; 
    _iconFlavorController.text = 'Icon';
  }

  Future<void> loadFlavors() async {
    try {
      _listFlavors = _flavorRepository.getFlavors();
      List<Flavor> flavors = await _listFlavors;
      setState(() {
        _flavors.addAll(flavors);
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
  Future<void> _updateTea(int id, int flavorid) async {
    setTextControllers();
    Tea updateTea = Tea(
      id: id,
      flavorId: flavorid,
      title: _titleTeaController.text,
      rssLink: _rssTeaController.text
    );

    await _teaRepository.updateTea(updateTea);
    loadFlavors();
  }

  void _deleteFlavor(int? id) async {
    _teas = await _teaRepository.getTeasByFlavorId(id!);
    if (id != null) {
      for(Tea tea in _teas){
        if(tea.flavorId== id){
           _deleteTea(tea.id);
        }
      }
      await _flavorRepository.deleteFlavor(id);
      loadFlavors();
      const snackBar = SnackBar(content: Text('Flavor Excluido com sucesso',  style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.yellow);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _deleteTea(int? id) async {
    if (id != null) {
      await _teaRepository.deleteTea(id);
      loadFlavors();
      const snackBar = SnackBar(content: Text('Flavor e teas Excluido com sucesso',  style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.yellow);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void showFormTea(int? id, int flavorid) async {
    _teas = await _teaRepository.getTeasByFlavorId(flavorid);
     if (id != null) {
      for (Tea tea in _teas) {
        if(tea.flavorId == flavorid && tea.id == id){
          existingTea = tea;
        }
      }
      _titleTeaController.text = existingTea.title;
      _rssTeaController.text = existingTea.rssLink;
    } else {
      _titleTeaController.clear();
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
              controller: _titleTeaController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            TextField(
              controller: _rssTeaController,
              decoration: const InputDecoration(hintText: 'Link RSS'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                if (id != null) {
                  await _updateTea(id, flavorid!);
                }
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
  void showForm(int? id) {
     if (id != null) {
      for(Flavor flavor in _flavors){
        if(flavor.id == id){
          existingFlavor = flavor;
        }
      }
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
        title: const Center(
          child: Text(
            "Flavors List",
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: FutureBuilder<List<Flavor>>(
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
                  child: ExpansionTile(
                    title: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.liquor_rounded),
                        Text(
                          flavor.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => showForm(flavor.id),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteFlavor(flavor.id),
                            ),
                          ],
                        ),
                      ],
                    ),

                    children: 
                    <Widget>[
                      FutureBuilder<List<Tea>>(
                        future: _teaRepository.getTeasByFlavorId(flavor.id!),
                        builder: (BuildContext context, AsyncSnapshot<List<Tea>> teaSnapshot) {
                          if (teaSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (teaSnapshot.hasError) {
                            return Center(child: Text('Erro ao carregar chás'));
                          } else if (!teaSnapshot.hasData || teaSnapshot.data!.isEmpty) {
                            return Center(child: Text('Nenhum chá encontrado'));
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: teaSnapshot.data!.length,
                              itemBuilder: (BuildContext context, int teaIndex) {
                                Tea tea = teaSnapshot.data![teaIndex];
                                return ListTile(
                                  leading: Icon(Icons.coffee_sharp),
                                  title: Text(tea.title),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () => showFormTea(tea.id!, flavor.id!),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () => _deleteTea(tea.id),
                                        ),
                                      ],
                                    )
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        }
      )
    );
  }
}

