import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final String text;

  const Heading({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).textTheme.caption?.color;

    return Padding(
      padding: const EdgeInsets.only(top: 48, bottom: 24),
      child: LayoutBuilder(
        builder: (context, constraints) => Row(
          children: [
            Expanded(child: Divider(color: color)),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth - 20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  text.toUpperCase(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: color,
                        letterSpacing: 2,
                      ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(child: Divider(color: color)),
          ],
        ),
      ),
    );
  }
}
