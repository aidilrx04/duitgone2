import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  static const aboutDesc =
      "duitGone2 is a simple finance manager where you record all your money expenses and can review where all your money 'gone' later";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/images/logo.png"),
            SizedBox(
              height: 10,
            ),
            Text(
              aboutDesc,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text("Created By"),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "@aidilrx04",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.orange),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
