import 'package:customerapp/actions/check_login.dart';
import 'package:customerapp/screens/commonComponents/single_message_dialog.dart';
import 'package:customerapp/screens/loggedPage/profile_settings.dart';
import 'package:customerapp/styles/Komet.dart';
import 'package:customerapp/styles/overview_mobile_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabBarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabBarScreen();
}

class _TabBarScreen extends State<TabBarScreen> {
  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: userIsLogged(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              if (MediaQuery.of(context).size.width > 650) {
                Navigator.pop(
                    context); //when resizing screen slowly, error occurs
              }

              return DefaultTabController(
                length: 2,
                child: new Scaffold(
                  appBar: new PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight * 0.8 + 28),
                    child: new Container(
                      color: Colors.white,
                      child: new SafeArea(
                          child: Padding(
                        padding: EdgeInsets.only(right: 50, left: 50, top: 20),
                        child: Column(
                          children: <Widget>[
                            new TabBar(
                              labelStyle: notSelectedStyleBar,
                              labelColor: kommetDistinctiveYellow,
                              unselectedLabelColor: Colors.black,
                              indicatorPadding: EdgeInsets.only(top: 50),
                              indicatorWeight: 4,
                              onTap: (value) {},
                              unselectedLabelStyle: selectedStyleBar,
                              indicatorColor: kommetDistinctiveYellow,
                              tabs: [
                                Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text("Orders")),
                                Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text("Account"))
                              ],
                            ),
                          ],
                        ),
                      )),
                    ),
                  ),
                  body: Stack(children: [
                    TabBarView(
                      children: <Widget>[
                        SubPageOrders(),
                        SubPageUserProfile(),
                      ],
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          iconSize: 36,
                          icon: Image.asset(
                            'resources/images/arrow_diag.png',
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ))
                  ]),
                ),
              );
            } else {
              Future.delayed(Duration.zero, () {
                Navigator.pushNamed(context, '/');
              });
              return CircularLoaderKomet();
              //
            }
          } else {
            return CircularLoaderKomet();
          }
        },
      );
}

class SubPageOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 20, left: 50, right: 50),
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        "¡Ups! Parece que todavía no has hecho ningún pedido",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )),
                  Text(
                    "Conoce nuestras tiendas y encuentra todo lo que necesites",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class SubPageUserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height - 100),
              padding: EdgeInsets.only(left: 25, right: 25),
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    UserInformation(),
                  ])))
        ]);
  }
}
