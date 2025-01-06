import 'package:duitgone2/screens/about/about.dart';
import 'package:duitgone2/screens/home/home.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Drawer(
        child: Builder(builder: (context) {
          return ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.orange,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Home.title,
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  Scaffold.of(context).closeDrawer();
                },
                leading: Icon(Icons.home_outlined),
                title: Text("Dashboard"),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => About()));
                },
                leading: Icon(Icons.info_outlined),
                title: Text("About"),
              ),
            ],
          );
        }),
      );
}
