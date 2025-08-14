import 'package:fitness/models/category_models.dart';
import 'package:fitness/models/recommendation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<CategoryModel> models = [];
  List<Recommandation> recModels = [];

  void _getCategories() {
    models = CategoryModel.getCategories();
  }

  void _getRecommendations() {
    recModels = Recommandation.getRecommendations();
  }

  void _setModels() {
    _getCategories();
    _getRecommendations();
  }

  @override
  void initState() {
    _setModels();
  }

  @override
  Widget build(BuildContext context) {
    _setModels();

    return Scaffold(
      appBar: appBar(context),
      backgroundColor: const Color.fromARGB(255, 217, 222, 231),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchField(), //this part does the search field I extracted it as a method
          SizedBox(
            height: 40,
          ), //this is to seperate the search bar form the category text
          _categoriesSection(),
          SizedBox(height: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  "Recommendation for diet",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600, //I am
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 240,
                padding: EdgeInsets.only(left: 20, right: 20),

                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recModels.length,
                  separatorBuilder: (context, index) => SizedBox(width: 25),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: recModels[index].boxColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              right: 8.0,
                            ),
                            child: Image(
                              image: AssetImage(recModels[index].iconPath),
                              height: 80,
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                recModels[index].name,
                                style: TextStyle(
                                  fontSize: 14, //
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              Text(
                                "${recModels[index].level}|${recModels[index].duration}|${recModels[index].cal}",
                                style: TextStyle(
                                  fontSize: 12, //
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromARGB(
                                    255,
                                    101,
                                    101,
                                    101,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            /*            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.amber,
                              backgroundColor: recModels[index].boxColor,
                            ), */
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                recModels[index].boxColor,
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white,
                              ), // White text
                            ),
                            onPressed: onPressed({}),
                            child: Text("View"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      //backgroundColor: Colors.white,
    );
  }

  Column _categoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
          ), //the left blank space for the category
          child: Text(
            "Category",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600, //I am
            ),
          ),
        ),
        SizedBox(height: 15), // for the space between category and the listview
        Container(
          // for the list view
          height: 120,

          // color: const Color.fromARGB(255, 0, 0, 0),
          padding: EdgeInsets.only(left: 20, right: 20),
          child: ListView.separated(
            //
            scrollDirection: Axis.horizontal,
            itemCount: models.length,
            separatorBuilder: (context, index) =>
                SizedBox(width: 25), //this seperates the boxes from each other
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: models[index].boxColor.withOpacity(0.5), //
                  //below code makes the shadow
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(8, 8),
                    ),
                  ],
                ),

                width: 100,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(15),
                          child: Image(
                            image: AssetImage(models[index].iconPath),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      models[index].name,
                      style: TextStyle(
                        fontSize: 14, //
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Container _searchField() {
    return Container(
      //this is the search bar
      margin: EdgeInsets.only(top: 40, left: 20, right: 20),
      child: TextField(
        //we cannot add margin to the text field so we will wrap it inside a container and add margin to the container
        decoration: InputDecoration(
          // this is here
          filled: true,
          fillColor: Colors.white,
          hintText: "Search pancakes",
          hintStyle: TextStyle(
            color: const Color.fromARGB(255, 195, 195, 195),
            fontSize: 14,
          ),
          contentPadding: EdgeInsets.all(
            15,
          ), //the height of the searchbar the padding of the text inside the searchbar
          prefixIcon: Icon(
            Icons.search_outlined,
            size: 32,
          ), //this is the icon in the beginning

          suffixIcon: Container(
            width:
                100, //without the with it takes up all the search bar to fix that a fixed size of the container is assigned
            color: Colors.purple,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  VerticalDivider(
                    color: Colors.black,
                    thickness: 0.5,
                    indent:
                        10, //indent leaves space in the beginning and in the end of the vertical var
                    endIndent: 10,
                  ), //the bar by the left of the filter icon
                  Padding(
                    //wrap it inside padding to make the icon smaller
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      'assets/icons/filter_icon.svg',
                      height: 32,
                      width: 32,
                      color: const Color.fromARGB(255, 88, 88, 88),
                    ),
                  ),
                ],
              ),
            ),
          ),

          border: OutlineInputBorder(
            borderSide: BorderSide.none, //removes the border in the search bar
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Breakfast",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ), //please do not mess up this part
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0.0, //this is the shadow

      leading: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/intropage");
        },
        child: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 207, 221, 246), //I like this color
            borderRadius: BorderRadius.circular(10),
          ),
          //child: SvgPicture.asset("assets/icons/back-svgrepo-com.svg"),
          child: Icon(
            Icons.arrow_back,
            size: 24,
          ), // I can also use flutter's icons
        ),
      ),

      actions: [
        GestureDetector(
          onTap: () {},
          child: Container(
            //this is the bar on top
            width: 37,
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 207, 221, 246), //I like this color
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              "assets/icons/dots-vertical-svgrepo-com.svg",
            ),
            /*   child: Icon(
              Icons.arrow_back,
              size: 24,
            ), // I can also use flutter's icons */
          ),
        ),
      ],
    );
  }

  onPressed(Map map) {}
}
