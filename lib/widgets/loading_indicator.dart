import 'package:flutter/material.dart';
import 'package:bubble_loader/bubble_loader.dart';


class LoadingIndicator extends StatelessWidget {

  const LoadingIndicator({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: BubbleLoader(
        color1: Colors.pinkAccent,
        color2: Colors.white,
        bubbleGap: 10,
        bubbleScalingFactor: 1,
        duration: Duration(milliseconds: 1500),
      ),
    );
  }
}
