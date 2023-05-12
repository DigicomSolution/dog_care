import 'package:flutter/material.dart';

class DogImage extends StatelessWidget {
  const DogImage({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: Image.asset('asset/image/dog.png'),
      ),
    );
  }
}
