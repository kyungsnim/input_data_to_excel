import 'package:flutter/material.dart';

class AnimatedToggleButton extends StatefulWidget {
  @override
  _AnimatedToggleButtonState createState() => _AnimatedToggleButtonState();
}

class _AnimatedToggleButtonState extends State<AnimatedToggleButton> {
  bool toggleValue = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(microseconds: 1000),
        height: 40,
        width: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: toggleValue ? Colors.greenAccent[100] : Colors.blue[100].withOpacity(0.5)
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
                duration: Duration(microseconds: 1000),
                curve: Curves.easeIn,
                top: 3.0,
                left: toggleValue ? 40 : 0,
                right: toggleValue ? 0 : 40,
                child: InkWell(
                  onTap: toggleButton,
                  child: AnimatedSwitcher(
                    duration: Duration(microseconds: 1000),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return RotationTransition(child: child, turns: animation);
                    },
                    child: toggleValue ? Icon(Icons.check_circle, color: Colors.green, size: 35, key: UniqueKey())
                        : Icon(Icons.check_circle, color: Colors.blue, size: 35, key: UniqueKey()),

                  ),
                )
            ),
          ],
        )
    );
  }

  toggleButton() {
    setState(() => toggleValue = !toggleValue);
  }
}