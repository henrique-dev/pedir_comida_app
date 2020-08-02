import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pedir_comida/connection/connection.dart';
import 'package:pedir_comida/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {

  int _currentBottomNavigationBarIndex = 0;

  MainScreen({int currentBottomNavigationBarIndex = 0}) {
    this._currentBottomNavigationBarIndex = currentBottomNavigationBarIndex;
  }

  @override
  _MainScreenState createState() => _MainScreenState(currentBottomNavigationBarIndex: this._currentBottomNavigationBarIndex);
}

class _MainScreenState extends State<MainScreen> {

  int _currentBottomNavigationBarIndex = 0;

  _MainScreenState({int currentBottomNavigationBarIndex = 0}) {
    this._currentBottomNavigationBarIndex = currentBottomNavigationBarIndex;
  }

  void reloadedCallback(Response response) {
    setState(() {

    });
  }

  void reloadCallback(Response response) {
    //Connection.login(reloadedCallback, User("01741053200", "123456"));
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> screens = [
      Container(
          child: ListView(
            children: [
              Card(
                child: ListTile(
                  title: Text("Meus dados", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Visualize seus dados cadastrados"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()
                        )
                    );
                  },
                ),
              ),
              Card(
                  child: ListTile(
                    title: Text("Meus documentos", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Visualize ou envie seus documentos ou exames já realizados"),
                    onTap: () {},
                  )
              )
            ],
          )
      ),
      Container(),
      Container(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Tela Principal"),
        backgroundColor: Colors.black45,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: null,
          )
        ],
      ),
      body: screens[_currentBottomNavigationBarIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            _currentBottomNavigationBarIndex = index;
          });
        },
        currentIndex: _currentBottomNavigationBarIndex,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(
          color: Colors.redAccent,
        ),
        selectedItemColor: Colors.redAccent,
        items: [
          BottomNavigationBarItem(
            title: Text("Perfil"),
            icon: Icon(Icons.account_circle)
          ),
          BottomNavigationBarItem(
            title: Text("Agendamentos"),
            icon: Icon(Icons.add_alarm),
          ),
          BottomNavigationBarItem(
            title: Text("Buscar"),
            icon: Icon(Icons.search),
          )
        ],
      ),
    );
  }

}
