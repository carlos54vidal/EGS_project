import 'package:flutter/material.dart';
import 'package:pet_sitter/src/atoms/input.dart';
import 'package:pet_sitter/src/constants/constant_colors.dart';

import '../atoms/button.dart';

class OrganismSignIn extends StatefulWidget {
  const OrganismSignIn({super.key});

  @override
  State<OrganismSignIn> createState() => _OrganismSignInState();
}

class _OrganismSignInState extends State<OrganismSignIn> {
  final _space = const SizedBox(
    height: 30,
  );
  String _userName = '';
  String _password = '';

  String logo = "logo";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: ConstantColors.primary,
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              children: [
                _space,
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/logo.png"),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                ),
                _space,
                _inputs,
                const SizedBox(
                  height: 10,
                ),
                _logInButton,
              ],
            )),
      ),
    );
  }

  Widget get _inputs {
    return Wrap(
      runSpacing: 15,
      children: [
        Input(
          hintText: 'Username',
          keyboardType: TextInputType.name,
          onValueChanged: (value) => setState(() => _userName = value),
        ),
        Input(
          hintText: 'Password',
          obscureText: true,
          onValueChanged: (value) => setState(() => _password = value),
        ),
      ],
    );
  }

  Widget get _logInButton {
    return Container(
      alignment: Alignment.bottomRight,
      child: Button(
        label: 'Log In',
        width: 80,
        height: 40,
        fontSize: 16,
        onTap: () {}, //_logIn,
      ),
    );
  }

/*   _logIn(){
    if(_userName == ConstantUserInfo.username && _password ==ConstantUserInfo.password){
      Navigator.pushNamed(context, ConstantRoutes.logged);
    }
    if(_userName.isEmpty){
      return print('please, insert your user name');
    }
    if(_password.isEmpty){
      return print('please, insert your password');
    }

    return print('Username or password wrong');
  } */
}
