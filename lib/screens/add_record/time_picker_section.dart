import 'package:flutter/material.dart';

class TimePickerSection extends StatefulWidget {
  const TimePickerSection({super.key, required this.onTimeChanged});

  final void Function(TimeOfDay time) onTimeChanged;

  @override
  State<TimePickerSection> createState() => _TimePickerSectionState();
}

class _TimePickerSectionState extends State<TimePickerSection> {
  TimeOfDay timeOfDay = TimeOfDay.now();
  bool isNow = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Time",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black45,
                  ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Now",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: isNow ? Colors.black54 : Colors.black45,
                      ),
                ),
                Transform.scale(
                  scale: .75,
                  child: Switch(
                    value: isNow,
                    onChanged: _setIsNow,
                  ),
                )
              ],
            )
          ],
        ),
        if (!isNow) ...[
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${timeOfDay.hour}:${timeOfDay.minute} ${timeOfDay.period.name}",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.black87),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _showTimePicker(context);
                },
                child: Text("Select Time"),
              ),
            ],
          )
        ],
      ],
    );
  }

  void _setIsNow(bool value) {
    setState(() {
      isNow = value;
      timeOfDay = TimeOfDay.now();
    });
  }

  _showTimePicker(BuildContext context) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime == null) return;

    setState(() {
      timeOfDay = selectedTime;
    });
    widget.onTimeChanged(selectedTime);
  }
}
