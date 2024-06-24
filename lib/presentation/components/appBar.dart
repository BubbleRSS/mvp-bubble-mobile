import 'package:bubble_mobile/data/database_provider.dart';
import 'package:bubble_mobile/data/models/tea.dart';
import 'package:bubble_mobile/data/repositories/tea_repository.dart';
import 'package:bubble_mobile/presentation/pages/flavors.dart';
import 'package:bubble_mobile/presentation/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:bubble_mobile/data/repositories/flavor_repository.dart';
import 'package:bubble_mobile/data/models/flavor.dart';


class AppBarPage extends StatefulWidget implements PreferredSizeWidget{
  final Key? key;

  AppBarPage({this.key}) : super(key: key);
  
  @override
  State<AppBarPage> createState() => _AppBarState();

   @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppBarState extends State<AppBarPage> {
  bool _isLoading = true;
  final List<Flavor> _flavors = [];
  var dropdownValue = null;
  Flavor? selectedFlavor;
  final TeaRepository _teaRepository = TeaRepository();

  final FlavorRepository _flavorRepository = FlavorRepository();
  late Future<List<Flavor>> listFlavor;

  Future<void> loadFlavors() async {
    try {
      listFlavor = _flavorRepository.getFlavors();
      List<Flavor> flavors = await listFlavor;
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

  @override
  void initState() {
    super.initState();
    loadFlavors();
    setTextControllers();
  }

    Future<void> _insertFlavor() async {
      if(_titleFlavorController.text != null && _titleFlavorController.text != ""){
        setTextControllers();

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
    if(_titleTeaController.text != null && _titleTeaController.text != "" && _rssTeaController.text != null && _rssTeaController.text != ""){
      setTextControllers();
        Tea newTea = Tea(
          title: _titleTeaController.text, 
          flavorId: selectedFlavor!.id!,
          rssLink: _rssTeaController.text,
        );
        await _teaRepository.insertTea(newTea);
        await loadFlavors();
        setState(() {
          _titleTeaController.clear();
          _rssTeaController.clear();
        });

        const snackBar = SnackBar(content: Text('Tea adicionada com sucesso!', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.green);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else{
      const snackBar = SnackBar(content: Text('Preencha corretamente os campos',  style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
      
  }

  final TextEditingController _titleFlavorController = TextEditingController();
  final TextEditingController _titleTeaController = TextEditingController();
  final TextEditingController _rssTeaController = TextEditingController();
  final TextEditingController _colorFlavorController = TextEditingController();
  final TextEditingController _iconFlavorController = TextEditingController();

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
              child: DropdownButton<Flavor>(
                value: dropdownValue,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
                style: const TextStyle(color: Colors.white, fontSize: 18),
                underline: Container(
                  height: 2,
                  color: Colors.white,
                ),
                items: _flavors.map((Flavor flavor) {
                  return DropdownMenuItem<Flavor>(
                    value: flavor,
                    child: Text(
                      flavor.title,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                }).toList(),
                onChanged: (Flavor? newValue) {
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
                showTeaForm(null);
              },
            ),
            ListTile(
              leading: Icon(Icons.liquor_sharp),
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
  void showTeaForm(int? id) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
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
                  DropdownButton<Flavor>(
                    hint: Text('Select Flavor'),
                    value: selectedFlavor,
                    items: _flavors.map((Flavor flavor) {
                      return DropdownMenuItem<Flavor>(
                        value: flavor,
                        child: Text(flavor.title),
                      );
                    }).toList(),
                    onChanged: (Flavor? newValue) {
                      setState(() {
                        selectedFlavor = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  if (selectedFlavor != null) ...[
                    TextField(
                      controller: _titleTeaController,
                      decoration: const InputDecoration(hintText: 'Tea Title'),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _rssTeaController,
                      decoration: InputDecoration(hintText: 'Link RSS'),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        await _insertTea();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Create Tea',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}
