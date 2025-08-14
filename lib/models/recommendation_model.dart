import 'package:flutter/material.dart';

class Recommandation {
  String name;
  String iconPath;
  String level;
  String duration;
  String cal;
  Color boxColor;
  bool view;

  Recommandation({
    required this.name,
    required this.iconPath,
    required this.level,
    required this.boxColor,
    required this.cal,
    required this.duration,
    required this.view,
  });

  static List<Recommandation> getRecommendations() {
    List<Recommandation> rec = [];

    rec.add(
      Recommandation(
        name: "Honey Pancake",
        iconPath: "assets/images/pancake.jpg",
        level: "easy",
        cal: "180cal",
        duration: "30minx",
        boxColor: Color.fromARGB(255, 52, 100, 189),
        view: true,
      ),
    );

    rec.add(
      Recommandation(
        name: "Canadian Bread",
        iconPath: "assets/images/bread.jpg",
        level: "easy",
        cal: "190cal",
        duration: "20min",
        boxColor: Color.fromARGB(255, 170, 59, 204),
        view: false,
      ),
    );

    rec.add(
      Recommandation(
        name: "Canadian Bread",
        iconPath: "assets/images/bread.jpg",
        level: "easy",
        cal: "190cal",
        duration: "20min",
        boxColor: Color.fromARGB(255, 38, 7, 47),
        view: false,
      ),
    );

    rec.add(
      Recommandation(
        name: "Canadian Bread",
        iconPath: "assets/images/bread.jpg",
        level: "easy",
        cal: "190cal",
        duration: "20min",
        boxColor: Color.fromARGB(255, 5, 154, 95),
        view: false,
      ),
    );

    return rec;
  }
}
