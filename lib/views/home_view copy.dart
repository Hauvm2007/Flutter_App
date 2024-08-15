import 'package:flutter/material.dart';
import '../viewmodels/login_viewmodel.dart';
import 'login_view.dart';

class HomePage extends StatefulWidget {

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _mockData = List.generate(30, (index) => 'Item $index');
  int _itemsToShow = 10;

  final LoginViewModel _viewModel = LoginViewModel();

  void _logout(BuildContext context) async {
    await _viewModel.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
  void _showMoreItems() {
    setState(() {
      if (_itemsToShow + 10 <= _mockData.length) {
        _itemsToShow += 10;
      } else {
        _itemsToShow = _mockData.length;
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: <Widget> [
          ListView.builder(
          itemCount: _itemsToShow + 1, // +1 for the "Show more list" item
          itemBuilder: (context, index) {
            if (index < _itemsToShow) {
              return ListTile(
                title: Text(_mockData[index]),
                leading: Icon(Icons.list),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: GestureDetector(
                    onTap: _showMoreItems,
                    child: const Text(
                      'Show more list',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              );
            }
           },
          ),
          ElevatedButton(onPressed: () => _logout(context), 
            child: Text('Log out'))
        ],
      )
    );
  }
}