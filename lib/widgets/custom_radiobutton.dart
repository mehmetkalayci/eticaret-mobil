import 'package:flutter/material.dart';

class CustomRadioListTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final Widget title;
  final Widget? subTitle;
  final ValueChanged<T?> onChanged;

  CustomRadioListTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8.0),
      child: Ink(
        height: 80,
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.0)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  const SizedBox(height: 5),
                  if(subTitle != null) subTitle!,
                ],
              ),
              Icon(Icons.check_circle_rounded, color: isSelected ? Colors.lightGreen : Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
