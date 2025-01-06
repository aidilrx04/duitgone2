import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelectBar extends StatelessWidget {
  const DateSelectBar({
    super.key,
    required this.currentDate,
    required this.availables,
    required this.onDateSelected,
  });

  final DateTime currentDate;
  final List<String> availables;
  final void Function(String selectedDate) onDateSelected;

  @override
  Widget build(BuildContext context) {
    // print(DateTime.now());
    String? prev;
    String? next;
    prev = _getPrev();
    next = _getNext();

    final prevBtn = prev != null
        ? TextButton(
            onPressed: () {
              onDateSelected(prev!);
            },
            child: Text(
              DateFormat("dd-MM").format(
                DateTime.parse(prev),
              ),
            ),
          )
        : _createEmptyDate();

    final nextBtn = next != null
        ? TextButton(
            onPressed: () {
              onDateSelected(next!);
            },
            child: Text(
              DateFormat("dd-MM").format(
                DateTime.parse(next),
              ),
            ),
          )
        : _createEmptyDate();

    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          prevBtn,
          TextButton(
            onPressed: () {},
            child: Text(
              DateFormat("dd-MM").format(currentDate),
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          nextBtn
        ],
      ),
    );
  }

  String? _getPrev() {
    var prevDate = currentDate.subtract(Duration(days: 1));
    final prevDateString = DateFormat("yyyy-MM-dd").format(prevDate);

    if (!availables.contains(prevDateString)) return null;

    return prevDateString;
  }

  String? _getNext() {
    var nextDate = currentDate.add(Duration(days: 1));
    final nextDateString = DateFormat("yyyy-MM-dd").format(nextDate);

    if (!availables.contains(nextDateString)) return null;

    return nextDateString;
  }

  _createEmptyDate() {
    return TextButton(
      onPressed: null,
      child: Text(
        "00-00",
        style: TextStyle(
          color: Colors.transparent,
        ),
      ),
    );
  }
}
