import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:filesystem_picker_example/screens/widgets/demo_scaffold.dart';
import 'package:filesystem_picker_example/screens/widgets/heading.dart';
import 'package:flutter/material.dart';

class BreadcrumbsDemoScreen extends StatelessWidget {
  const BreadcrumbsDemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Breadcrumbs Demo',
      sidePadding: 0,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Heading(text: 'Default Breadcrumbs'),
        ),

        //
        Breadcrumbs<String>(
          items: ['One', 'Two', 'Thee', 'Four', 'Five', 'Six', 'Seven']
              .map((path) => BreadcrumbItem<String>(text: path, data: path))
              .toList(growable: false),
          onSelect: (String? value) {
            debugPrint('* Selected: $value');
          },
        ),

        //
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Heading(text: 'Customized Breadcrumbs'),
        ),

        //
        Breadcrumbs<String>(
          theme: BreadcrumbsThemeData(
            itemColor: Colors.white,
            inactiveItemColor: Colors.blueGrey.shade100,
            itemPadding: const EdgeInsets.symmetric(horizontal: 6),
            itemMinimumSize: Size.zero,
            itemTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            separatorColor: Colors.blueGrey.shade300,
            backgroundColor: Colors.blueGrey,
            separatorIcon: Icons.arrow_right,
            separatorIconSize: 32,
          ),
          items: ['One', 'Two', 'Thee', 'Four', 'Five', 'Six', 'Seven']
              .map((path) => BreadcrumbItem<String>(text: path, data: path))
              .toList(growable: false),
          onSelect: (String? value) {
            debugPrint('* Selected: $value');
          },
        ),

        //
        const SizedBox(height: 32),
      ],
    );
  }
}
