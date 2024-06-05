import 'package:flutter/material.dart';

import '../Molecules/molecule_home_post.dart';

class OrganismHome extends StatefulWidget {
  const OrganismHome({super.key});
  static const routeName = "/feed";
  @override
  State<OrganismHome> createState() => _OrganismHomeState();
}

class _OrganismHomeState extends State<OrganismHome> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [Column(children: _postsList())]);
  }

  _postsList() {
    return const [
      MoleculeHomePost(
        name: "Vin Diesel",
        description: "Rex <3",
        profileImage: "assets/images/homem1.jpg",
        postImage: "assets/images/pastorAlemao.jpg",
        likes: "10",
      ),
      MoleculeHomePost(
        name: "Joshua Turner",
        description: "one love: Tareco",
        profileImage: "assets/images/homem3.jpg",
        postImage: "assets/images/persa.jpg",
        likes: "20",
      ),
      MoleculeHomePost(
        name: "Joanine Cena",
        description: "my big buddy",
        profileImage: "assets/images/mulher1.jpg",
        postImage: "assets/images/saoBernardo.jpg",
        likes: "30",
      ),
    ];
  }
}
