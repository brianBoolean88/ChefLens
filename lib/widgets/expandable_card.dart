import "package:flutter/material.dart";

class ExpandableCard extends StatelessWidget {
  final Widget title;
  final List<Widget>? children;
  final Widget? subtitle;
  const ExpandableCard({
    super.key,
    required this.title,
    this.subtitle,
    this.children = const <Widget>[],
  });

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).colorScheme;

    return Card(
      color: appColorScheme.background,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        child: ExpansionTile(
          childrenPadding: const EdgeInsets.all(8.0),
          title: title,
          subtitle: subtitle,
          children: children ?? [],
        ),
      ),
    );
  }
}
