import 'package:amazonclone/constants/global_variables.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselImage extends StatelessWidget {
  const CarouselImage({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
        itemCount: GlobalVariables.carouselImages.length,
        itemBuilder: (c, index, realIndex) {
          return Image.network(
            GlobalVariables.carouselImages[index],
            height: 200,
            fit: BoxFit.cover,
          );
        },
        options: CarouselOptions(
          viewportFraction: 1,
          height: 200,
        ));
  }
}
