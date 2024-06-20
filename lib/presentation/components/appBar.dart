import 'package:bubble_mobile/data/database_provider.dart';
import 'package:bubble_mobile/data/models/tea.dart';
import 'package:bubble_mobile/data/repositories/tea_repository.dart';
import 'package:bubble_mobile/presentation/components/listFlavorAndTeas.dart';
import 'package:bubble_mobile/presentation/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:bubble_mobile/data/repositories/flavor_repository.dart';
import 'package:bubble_mobile/data/models/flavor.dart';


class AppBarPage extends StatefulWidget {
  @override
  State<AppBarPage> createState() => _AppBarState();
}

class _AppBarState extends State<AppBarPage> {
  bool _isLoading = true;
  final List<String> _options = [];
  var dropdownValue = null;
  final TeaRepository _teaRepository = TeaRepository();

  final FlavorRepository _flavorRepository = FlavorRepository();
  late Future<List<Flavor>> listFlavor;

  Future<void> loadFlavors() async {
    try {
      listFlavor = _flavorRepository.getFlavors();
      List<Flavor> flavors = await listFlavor;
      setState(() {
        _options.addAll(flavors.map((flavor) => flavor.title).toList());
        _isLoading = false; 
      });
    } catch (error) {
      setState(() {
        _isLoading = false; 
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadFlavors();
    setTextControllers();
  }

    Future<void> _insertFlavor() async {
      if(_titleFlavorController.text != null && _titleFlavorController.text != ""){
        setTextControllers();
        print(_colorFlavorController.text);
        print(_iconFlavorController.text);

          Flavor newFlavor = Flavor(
            title: _titleFlavorController.text,
            color:_colorFlavorController.text,
            icon:_iconFlavorController.text,
          );
          await _flavorRepository.insertFlavor(newFlavor);
          await loadFlavors();
          setState(() {
            _titleFlavorController.clear();
            _colorFlavorController.clear();
            _iconFlavorController.clear();
          });

        const snackBar = SnackBar(content: Text('Flavor adicionada com sucesso!', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.green);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }else{
      const snackBar = SnackBar(content: Text('Preencha corretamente os campos',  style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }



  Future<void> _insertTea() async {
    setTextControllers();
      Tea newTea = Tea(
        title: _titleFlavorController.text, 
        flavorId: _options.indexOf(_titleFlavorController.text),
        rssLink: _rssFlavorController.text,
      );
      await _teaRepository.insertTea(newTea);
      await loadFlavors();
      setState(() {
        _titleFlavorController.clear();
        _colorFlavorController.clear();
        _iconFlavorController.clear();
      });
  }

  final TextEditingController _titleFlavorController = TextEditingController();
  final TextEditingController _rssFlavorController = TextEditingController();
  final TextEditingController _colorFlavorController = TextEditingController();
  final TextEditingController _iconFlavorController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  void setTextControllers() {
    _colorFlavorController.text = 'Color'; 
    _iconFlavorController.text = 'Icon';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
                style: const TextStyle(color: Colors.white, fontSize: 18),
                underline: Container(
                  height: 2,
                  color: Colors.white,
                ),
                items: _options.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              icon: Icon(Icons.add_circle_outlined, color: Colors.white),
              onPressed: () {
                _showAddOptions();
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Text('Você selecionou: $dropdownValue'),
      ),
    );
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.emoji_food_beverage),
              title: Text('Create Teas'),
              onTap: () {
                Navigator.of(context).pop();
                showFormTeas(null);
              },
            ),
            ListTile(
              leading: Icon(Icons.liquor_rounded),
              title: Text('Create Flavor'),
              onTap: () {
                Navigator.of(context).pop();
                showFormFlavor(null);
              },
            ),
            ListTile(
              leading: Icon(Icons.list_rounded),
              title: Text('List'),
              onTap: () {
                Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ListFlavorAndTeasPage()),
        );
                // Implementar exibição da lista
              },
            ),
          ],
        );
      },
    );
  }

  void showFormFlavor(int? id) {
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
                if (id == null) {
                  await _insertFlavor();
                }
                // Implementar atualização de flavor se necessário
                Navigator.of(context).pop();
              },
              child: Text(
                'Create Flavor',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
void showFormTeas(int? id) {
  String? selectedCategory;
  String linkRSSValue = '';

  showModalBottomSheet(
    context: context,
    elevation: 5,
    isScrollControlled: true,
    builder: (_) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
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
              DropdownButton<String>(
                hint: Text('Select Flavor'),
                value: selectedCategory,
                items: _options.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
              ),
              const SizedBox(height: 15),
              if (selectedCategory != null) ...[
                const SizedBox(height: 15),
                TextField(
                  controller: _rssFlavorController,
                  onChanged: (value) {
                    setState(() {
                      linkRSSValue = value;
                    });
                  },
                  decoration: InputDecoration(hintText: 'Link RSS'),
                ),
              ],
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await _insertTea();
                  }
                  // Implementar atualização de flavor se necessário
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Create Category',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
  HomePage();
}

}