import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'box_label.dart';

class CarouselBox<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext, int) itemBuilder;
  final double height;
  final double viewportFraction;
  final bool enableInfiniteScroll;
  final bool reverse;
  final bool enlargeCenterPage;
  final Axis scrollDirection;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final Duration autoPlayAnimationDuration;
  final Curve autoPlayCurve;
  final String labelText;
  final Color borderColor;
  final Color labelBackgroundColor;
  final EdgeInsets padding;

  const CarouselBox({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.height = 125.0,
    this.viewportFraction = 0.9,
    this.enableInfiniteScroll = true,
    this.reverse = false,
    this.enlargeCenterPage = true,
    this.scrollDirection = Axis.horizontal,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 10),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
    this.autoPlayCurve = Curves.fastOutSlowIn,
    required this.labelText,
    this.borderColor = const Color.fromARGB(255, 100, 102, 168),
    this.labelBackgroundColor = const Color.fromARGB(255, 7, 8, 29),
    this.padding = const EdgeInsets.only(top: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    return BoxLabel(
      padding: padding,
      labelText: labelText,
      borderColor: borderColor,
      labelBackgroundColor: labelBackgroundColor,
      child: CarouselSlider.builder(
        itemCount: items.length,
        options: CarouselOptions(
          height: height,
          viewportFraction: viewportFraction,
          initialPage: 0,
          enableInfiniteScroll: enableInfiniteScroll,
          reverse: reverse,
          enlargeCenterPage: enlargeCenterPage,
          scrollDirection: scrollDirection,
          autoPlay: autoPlay,
          autoPlayInterval: autoPlayInterval,
          autoPlayAnimationDuration: autoPlayAnimationDuration,
          autoPlayCurve: autoPlayCurve,
        ),
        itemBuilder: (BuildContext context, int index, int realIndex) {
          return itemBuilder(context, index);
        },
      ),
    );
  }
}
