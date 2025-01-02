import 'package:duitgone2/models/category.dart';
import 'package:duitgone2/models/money.dart';
import 'package:flutter/material.dart';

class AddRecord extends StatefulWidget {
  const AddRecord({super.key, this.onRecordAdded});

  final void Function(Money)? onRecordAdded;

  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  Category? selectedCat;

  late List<Category> categories;
  final amount = TextEditingController();

  @override
  void initState() {
    super.initState();

    categories = Category.generateMockData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Record"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 32,
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: amount,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Amount"),
                icon: Icon(Icons.paid_outlined),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Category",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black45,
                  ),
            ),
            SizedBox(
              height: 10,
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.start,
              children: [
                for (final category in categories)
                  ChoiceChip(
                    label: Text(category.label),
                    avatar: Text(""),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(9999),
                      ),
                    ),
                    selected: category.label == selectedCat?.label,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedCat = category;
                        });
                      }
                    },
                  ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
              onPressed: _onAddBtnTap(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: Text(
                  "ADD",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Money _createMoney(double amount, Category cat) {
    return Money(amount: amount, category: cat, date: DateTime.now());
  }

  _onAddBtnTap(BuildContext context) {
    return () {
      Navigator.pop(context);

      if (widget.onRecordAdded != null) {
        widget.onRecordAdded!(
          _createMoney(
            double.parse(amount.text),
            selectedCat!,
          ),
        );
      }
    };
  }

}
