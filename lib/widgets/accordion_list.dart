import 'package:flutter/material.dart';

class AccordionList extends StatefulWidget {
  const AccordionList({Key? key, required this.items, required this.child})
      : super(key: key);

  final List<Widget> items;
  final Widget child;

  @override
  State<AccordionList> createState() => _AccordionListState();
}

class _AccordionListState extends State<AccordionList> {
  bool status = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: this.widget.child,
          onTap: () {
            setState(() {
              this.status = !this.status;
            });
          },
        ),
        this.status ?
        AnimatedOpacity(
          opacity: this.status ? 1.0 : 0.0,
          duration: Duration(milliseconds: 250),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: widget.items),
          ),
        ): Container()
      ],
    );
  }
}
