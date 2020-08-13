import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:pedir_comida/config/my_theme.dart';
import 'package:pedir_comida/config/transition.dart';
import 'package:pedir_comida/connection/connection.dart';
import 'package:pedir_comida/screens/address_screen.dart';

class AddressesScreen extends StatefulWidget {
  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus endereços"),
        backgroundColor: MyTheme.THEME_COLOR_1,
      ),
      body: Container(
        child: FutureBuilder(
          future: Connection.get("/user/addresses.json", callback: null),
          builder: (context, snapshot) {

            List jsonDecoded;

            switch(snapshot.connectionState) {

              case ConnectionState.none:
                // TODO: Handle this case.
                break;
              case ConnectionState.waiting:
                return Center(child: Loading(indicator: BallPulseIndicator(), size: 50.0,color: MyTheme.THEME_COLOR_1_LIGHT_2),);
                break;
              case ConnectionState.active:
                // TODO: Handle this case.
                break;
              case ConnectionState.done:

                Response response = snapshot.data;

                jsonDecoded = json.decode(response.body);

                List<Widget> widgets = [];

                if (jsonDecoded.length > 0) {
                  jsonDecoded.forEach((element) {
                    widgets.add(
                      ListTile(
                        title: Text(element["description"]),
                        subtitle: Text(element["street"]),
                        trailing: Text(element["neighborhood"]),
                        onTap: () async {
                          await Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AddressScreen( address: element["id"])));
                          setState(() {});
                        },
                      )
                    );
                  });
                }
                widgets.add(
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: ButtonTheme(
                        height: 45,
                        child: RaisedButton(
                          onPressed: () async {
                            await Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: AddressScreen()));
                            setState(() {});
                          },
                          child: Text("Adicionar novo endereço", style: TextStyle(fontSize: 16),),
                          color: MyTheme.THEME_COLOR_1,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: Colors.black12)
                          ),
                        ),
                      ),
                    )
                );
                return ListView(
                  children: widgets,
                );

                break;
            }

            return Text("");
          },
        ),
      ),
    );
  }

}
