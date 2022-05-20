import 'package:bobby_shopping/command.dart';
import 'package:flutter/material.dart';

import 'common.dart';
import 'custom_colors.dart';

class PreviousCommands extends StatefulWidget {
  const PreviousCommands({Key? key}) : super(key: key);

  @override
  State<PreviousCommands> createState() => _PreviousCommandsState();
}

class _PreviousCommandsState extends State<PreviousCommands> {

  @override
  void initState() {
    CustomColors.currentColor = CustomColors.blueColor.shade900;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ExpansionPanel> result = [];
    for (int i = 0; i < Common.allCommands.length; i++) {
      result.add(commandExpansionPanel(Common.allCommands[i]));
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.currentColor,
          centerTitle: true,
          title: const Text('Previous commands'),
          leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(child: Center(child:
      Container(width: 1000, height: 1000, alignment: Alignment.center, child: ListView(children: [ExpansionPanelList(
        children: result,
        expansionCallback: (i, isOpen) => setState(() {
          Common.allCommands[i].isExpanded = !Common.allCommands[i].isExpanded;
        })
    )])))));
  }
}
