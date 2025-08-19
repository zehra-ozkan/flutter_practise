import 'package:flutter/material.dart';

class CategoryModel {
  //this class if for modelling the plates
  String name;
  String iconPath;
  Color boxColor;

  CategoryModel({
    required this.name,
    required this.iconPath,
    required this.boxColor,
  });

  static List<CategoryModel> getCategories() {
    List<CategoryModel> models = [];

    models.add(
      CategoryModel(
        name: "pancake",
        iconPath: "assets/images/pancake.jpg",
        boxColor: Color.fromARGB(255, 227, 162, 77),
      ),
    );

    models.add(
      CategoryModel(
        name: "pie",
        iconPath: "assets/images/pie.jpg",
        boxColor: Color.fromARGB(255, 146, 82, 73),
      ),
    );

    models.add(
      CategoryModel(
        name: "salad",
        iconPath: "assets/images/salad.jpg",
        boxColor: Color.fromARGB(255, 133, 200, 140),
      ),
    );

    models.add(
      CategoryModel(
        name: "smoothies",
        iconPath: "assets/images/smoothies.jpg",
        boxColor: Color.fromARGB(255, 200, 133, 171),
      ),
    );
    models.add(
      CategoryModel(
        name: "pancake",
        iconPath: "assets/images/pancake.jpg",
        boxColor: Color.fromARGB(255, 227, 162, 77),
      ),
    );

    models.add(
      CategoryModel(
        name: "pie",
        iconPath: "assets/images/pie.jpg",
        boxColor: Color.fromARGB(255, 146, 82, 73),
      ),
    );

    models.add(
      CategoryModel(
        name: "salad",
        iconPath: "assets/images/salad.jpg",
        boxColor: Color.fromARGB(255, 133, 200, 140),
      ),
    );

    models.add(
      CategoryModel(
        name: "smoothies",
        iconPath: "assets/images/smoothies.jpg",
        boxColor: Color.fromARGB(255, 200, 133, 171),
      ),
    );

    models.add(
      CategoryModel(
        name: "pancake",
        iconPath: "assets/images/pancake.jpg",
        boxColor: Color.fromARGB(255, 227, 162, 77),
      ),
    );

    models.add(
      CategoryModel(
        name: "pie",
        iconPath: "assets/images/pie.jpg",
        boxColor: Color.fromARGB(255, 146, 82, 73),
      ),
    );

    models.add(
      CategoryModel(
        name: "salad",
        iconPath: "assets/images/salad.jpg",
        boxColor: Color.fromARGB(255, 133, 200, 140),
      ),
    );

    models.add(
      CategoryModel(
        name: "smoothies",
        iconPath: "assets/images/smoothies.jpg",
        boxColor: Color.fromARGB(255, 200, 133, 171),
      ),
    );
    return models;
  }
}
