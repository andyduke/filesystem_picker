import 'package:flutter/material.dart';

class DemoScaffold extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? bottom;
  final double sidePadding;

  const DemoScaffold({
    Key? key,
    required this.title,
    required this.children,
    this.bottom,
    this.sidePadding = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              children: [
                const BackButton(),
                Expanded(
                  child:
                      Text(title, style: Theme.of(context).textTheme.headline6),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sidePadding) +
                  const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: (bottom != null)
          ? Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black12)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16) +
                    EdgeInsets.symmetric(horizontal: sidePadding),
                child: bottom,
              ),
            )
          : null,
    );
  }
}
