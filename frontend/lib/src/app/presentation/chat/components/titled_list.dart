import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/theme.dart';

class TitledList<T> extends StatelessWidget {
   final String title;
   final String emptyMessage;
   final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
   final ScrollController controller;
   final Axis scrollDirection;
   final int Function (T value) itemCount;
   final Widget? Function (T value, BuildContext context, int index) builder;

   const TitledList({
       required this.title,
       required this.emptyMessage,
       required this.controller,
       required this.scrollDirection,
       required this.itemCount,
       required this.builder,
       super.key
       });

  @override
  Widget build(BuildContext context) {
    SizedBox separator = SizedBox(width: _customLoveTheme.universalPadding,);
    if (scrollDirection == Axis.vertical) {
      separator = SizedBox(height: _customLoveTheme.universalPadding,);
    }

    return Column(children: [
      Row(children: [
        SizedBox(width: 2 * _customLoveTheme.universalPadding,),
        Text(
          title,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ]),
      Expanded(
        child: Scrollbar(
          controller: controller,
          child:  Consumer<T>(
            builder: (BuildContext context, T value, Widget? child) {
              if (itemCount(value) == 0) {
                return Text(emptyMessage);
              }

              return ListView.separated(
                  controller: controller,
                  padding: EdgeInsets.symmetric(
                      vertical: _customLoveTheme.universalPadding,
                      horizontal: _customLoveTheme.universalPadding),
                  separatorBuilder: (BuildContext context, int index) =>
                  separator,
                  scrollDirection: scrollDirection,
                  itemCount: itemCount(value),
                  itemBuilder: (BuildContext context, int index)
                  => builder(value, context, index));
            },
          ),
        ),
      ),
    ]);
  }

}