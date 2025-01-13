import 'package:duitgone2/models/category.dart';
import 'package:duitgone2/models/transaction.dart';
import 'package:duitgone2/screens/add_record/time_picker_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddRecord extends StatefulWidget {
  const AddRecord({super.key, this.onRecordAdded});

  final void Function(Transaction)? onRecordAdded;

  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  String? selectedCat;

  late List<String> categories;
  final amount = TextEditingController(text: "0");
  bool hasLoaded = false;
  bool isAmountValid = true;
  bool hasCatSelected = true;
  TimeOfDay? timeOfDay;

  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    categories = Category.generateMockData();

    focusNode = FocusNode();

    if (hasLoaded == false) {
      hasLoaded = true;
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isAmountValid == false) {
      focusNode.requestFocus();
    }

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
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d{0,2}'))
              ],
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              onChanged: (value) {
                try {
                  double.parse(value);
                  setState(() {
                    isAmountValid = true;
                  });
                } catch (e) {
                  setState(() {
                    isAmountValid = false;
                  });
                  return;
                }
              },
              focusNode: focusNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Amount"),
                icon: Icon(Icons.paid_outlined),
                helper: isAmountValid == false
                    ? Text(
                        "Amount is not valid. Please try again.",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.red,
                            ),
                      )
                    : null,
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
                    label: Text(category),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(9999),
                      ),
                    ),
                    selected: category == selectedCat,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedCat = category;
                          hasCatSelected = true;
                        });
                      }
                    },
                  ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            TimePickerSection(
              onTimeChanged: (TimeOfDay time) {
                setState(() {
                  timeOfDay = time;
                });
              },
            ),
            if (hasCatSelected == false) ...[
              SizedBox(
                height: 5,
              ),
              Text(
                "Please select a category",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.red,
                    ),
              ),
            ],
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

  Transaction _createTransaction(double amount, String cat) {
    final now = DateTime.now();
    setState(() {
      timeOfDay ??= TimeOfDay.now();
    });
    return Transaction(
      amount: amount,
      category: cat,
      date: DateTime(
        now.year,
        now.month,
        now.day,
        timeOfDay!.hour,
        timeOfDay!.minute,
      ),
    );
  }

  _onAddBtnTap(BuildContext context) {
    return () {
      if (widget.onRecordAdded != null) {
        // validate amount value

        if (isAmountValid == false) {
          return;
        }

        if (selectedCat == null) {
          setState(() {
            hasCatSelected = false;
          });
          return;
        }

        Navigator.pop(context);
        widget.onRecordAdded!(
          _createTransaction(
            double.parse(amount.text),
            selectedCat!,
          ),
        );
      }
    };
  }
}
