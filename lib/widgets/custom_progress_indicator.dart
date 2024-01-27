import "package:flutter/material.dart";

class CustomProgressIndicator extends StatelessWidget {
  final Widget? subwidget;
  const CustomProgressIndicator({super.key, this.subwidget});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SizedBox(
          width: 250.0,
          height: 150.0,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const CircularProgressIndicator.adaptive(
                    strokeCap: StrokeCap.round,
                    strokeWidth: 4.0,
                  ),
                  if (subwidget != null) subwidget!
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
