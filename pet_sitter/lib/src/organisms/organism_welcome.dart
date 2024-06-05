import 'package:flutter/material.dart';

import '../atoms/button.dart';
import '../constants/constant_colors.dart';

class OrganismWelcome extends StatefulWidget {
  const OrganismWelcome({super.key});

  static const routeName = "/log";
  @override
  State<OrganismWelcome> createState() => _OrganismWelcomeState();
}

class _OrganismWelcomeState extends State<OrganismWelcome> {
  String logo = "logo";
  //final service = IsarService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _logo,
            const SizedBox(
              height: 50,
            ),
            _buttons(context),
          ],
        ),
      ),
    );
  }

  Widget get _logo {
    return Hero(
      tag: 'logo',
      child: Container(
        width: 350,
        height: 350,
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/logo.png"),
            ),
            borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
    );
  }

  Widget _buttons(BuildContext context) {
    return Center(
      child: Wrap(
        runSpacing: 20,
        children: [
          Button(label: 'Log In', onTap: () => Navigator.pop(context)
              //Navigator.pushNamed(context, TemplatePlatform.routeName),
              ),
          Button(
            label: 'Sign Up',
            onTap: () =>
                {}, //Navigator.pushNamed(context, ConstantRoutes.signUp),
            color: ConstantColors.gray,
          ),
        ],
      ),
    );
  }
}
