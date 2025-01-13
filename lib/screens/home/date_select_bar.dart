import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class DateSelectBar extends StatelessWidget {
  const DateSelectBar({
    super.key,
    required this.currentDate,
    required this.onDateSelected,
  });

  final DateTime currentDate;
  final void Function(DateTime selectedDate) onDateSelected;

  @override
  Widget build(BuildContext context) {
    // range to display at top bar, always have currentDate - 1 day
    final range = [
      currentDate.subtract(Duration(days: 1)),
      currentDate,
    ];

    final isCurrentToday = _isToday(currentDate);

    // check if current selected date is today,
    // if not, add selected date + 1 day
    // means that selected date is in the past
    if (!isCurrentToday) {
      range.add(currentDate.add(Duration(days: 1)));
    }

    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (final date in range)
            TextButton(
              onPressed: () {
                onDateSelected(date);
              },
              child: Text(
                _formatDate(date),
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight:
                      date == currentDate ? FontWeight.bold : FontWeight.normal,
                  fontSize: date == currentDate ? 18 : 16,
                ),
              ),
            ),
          if (isCurrentToday) _createEmptyDate(),
        ],
      ),
    );
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

  String _formatDate(DateTime date) {
    final formatter = DateFormat("dd-MM");
    return formatter.format(date);
  }

  bool _isToday(DateTime date) {
    final formatter = DateFormat("yyyy-MM-dd");

    final dateInDateFormat = DateTime.parse(formatter.format(date));
    final todayInDateFormat = DateTime.parse(formatter.format(DateTime.now()));

    return dateInDateFormat.isAtSameMomentAs(todayInDateFormat);
  }
}
