import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/Persona/persona_helper.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PersonaMenu extends StatelessWidget {
  const PersonaMenu({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors=ConstantColors();
    return Scaffold(
      backgroundColor: constantColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Provider.of<PersonaHelper>(context,listen: false).information(context, "I'm persona bot, How can I help you ?"),
            Provider.of<PersonaHelper>(context,listen: false).category(context),
          ],
        ),
      ),
    );
  }
}
