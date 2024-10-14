import 'package:flutter/material.dart';

class MoleculePetSitterBlock extends StatelessWidget {
  const MoleculePetSitterBlock(
      {super.key,
      required this.name,
      required this.age,
      required this.likes,
      required this.image});

  final String name;
  final String age;
  final String likes;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.blueGrey)),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(image: AssetImage(image)),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      age,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      " years old",
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "✮ ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      likes,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
              ]),
        ],
      ),
    );
  }
}
