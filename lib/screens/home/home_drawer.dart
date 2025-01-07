import 'package:duitgone2/helpers/data_export/data_export.dart'
    if (dart.library.html) 'package:duitgone2/helpers/data_export/html_data_export.dart'
    if (dart.library.io) 'package:duitgone2/helpers/data_export/io_data_export.dart';
import 'package:duitgone2/screens/about/about.dart';
import 'package:duitgone2/screens/home/home.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView(
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
                DataExporter.exportData().then((val) {
                  Scaffold.of(context).closeDrawer();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(val),
                    ),
                  );
                }).catchError((err) {
                  Scaffold.of(context).closeDrawer();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(err.toString()),
                  ));
                });
              },
              title: Text("Export Data"),
              leading: Icon(Icons.file_download_outlined),
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
        ),
      );
}
