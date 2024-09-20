import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/utils/helpers/date_formatter.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class AdaptiveDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  const AdaptiveDatePicker({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
  });

  @override
  _AdaptiveDatePickerState createState() => _AdaptiveDatePickerState();
}

class _AdaptiveDatePickerState extends State<AdaptiveDatePicker> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
            onTap: () => _showDatePicker(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightPrimaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.date_range_rounded, size: 20),
                  const Gap(8),
                  Expanded(
                      child: Text(DateFormatter.formatDate(_selectedDate))),
                ],
              ),
            )),
        const SizedBox(
          height: 10,
        ),
        Visibility(
            visible: _selectedDate.difference(DateTime.now()).inHours > 23,
            child: Align(
                alignment: Alignment.topLeft,
                child: RichText(
                    text: TextSpan(
                        text: "That should be ",
                        style: AppStyles.blackNormal14,
                        children: [
                      TextSpan(
                          text:
                              "${_selectedDate.difference(DateTime.now()).inDays} days ",
                          style: AppStyles.blackBold14),
                      const TextSpan(text: "from now")
                    ]))))
      ],
    );
  }

  void _showDatePicker(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: CupertinoDatePicker(
              initialDateTime: _selectedDate,
              mode: CupertinoDatePickerMode.date,
              minimumDate: DateTime.now().subtract(const Duration(hours: 5)),
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  _selectedDate = newDate;
                  widget.onDateChanged(_selectedDate);
                });
              },
            ),
          ),
        ),
      );
    } else {
      showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      ).then((DateTime? date) {
        if (date != null) {
          setState(() {
            _selectedDate = date;
            widget.onDateChanged(_selectedDate);
          });
        }
      });
    }
  }
}
