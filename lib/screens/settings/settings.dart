import 'package:duitgone2/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 5),
              child: Text(
                "CATEGORY",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SettingsCategory(
              onCategoryChanged: (String category, Color color) {
                print(category);
                // print(color.);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsCategory extends StatefulWidget {
  final void Function(String category, Color color) onCategoryChanged;

  const SettingsCategory({super.key, required this.onCategoryChanged});

  @override
  State<SettingsCategory> createState() => _SettingsCategoryState();
}

class _SettingsCategoryState extends State<SettingsCategory> {
  late final Map<String, Color> catColors = Category.colors;

  Map<String, Color> editted = {};

  @override
  Widget build(BuildContext context) {
    // print(editted);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        spacing: 5,
        children: [
          for (final category in catColors.entries)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(category.key),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Change color"),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor:
                                editted[category.key] ?? category.value,
                            onColorChanged: (color) {
                              // print(color);
                              setState(() {
                                editted[category.key] = color;
                                editted = editted;

                                widget.onCategoryChanged(category.key, color);
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 50,
                    height: 25,
                    decoration: BoxDecoration(
                      color: editted[category.key] ?? category.value,
                    ),
                  ),
                )
              ],
            )
        ],
      ),
    );
  }
}
