import 'dart:typed_data';

import 'package:fitness/models/UserRepository.dart';
import 'package:fitness/models/recommendation_model.dart';
import 'package:fitness/service/token_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserRepository? userRepo;
  List<Recommandation> recModels = [];
  String greetName = "";

  Widget containerChild = Icon(Icons.person_3_sharp);

  void _getRecommendations() {
    recModels = Recommandation.getRecommendations();
  }

  Future<void> _getUserProfile() async {
    if (userRepo == null) return;
    print("user repo is not null");
    String? token = await TokenService.getToken();
    if (token != null) {
      print("token is not null");
      var data = await userRepo!.fetchHomeInfo(token!);
      setState(() {
        greetName = data["userName"];
        Uint8List? str = data["picture"];
        if (str != null) {
          //TODO maybe is empty?
          containerChild = Image.memory(str);
        }
      });
    } else {
      print("The token is null");
    }
  }

  void _setModels() {
    _getRecommendations();
  }

  @override
  void initState() {
    super.initState();
    userRepo = Provider.of<UserRepository>(context, listen: false);
    print("fetched user repo");

    _getUserProfile();

    print("user name is $greetName");
    _setModels();
  }

  @override
  Widget build(BuildContext context) {
    _setModels();

    return Scaffold(
      resizeToAvoidBottomInset:
          false, //this fixed the overflow error when the keyboard appears
      appBar: appBar(context),
      backgroundColor: const Color.fromARGB(255, 217, 222, 231),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _searchField(), //this part does the search field I extracted it as a method
          SizedBox(
            height: 40,
          ), //this is to seperate the search bar form the category text
          // _categoriesSection(),
          SizedBox(height: 30),
          _recommendationsSection(),
          SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.all(14.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/postspage");
              },
              child: Text("See All Posts"),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/newpost");
            },
            child: Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 122, 135, 157), //I like this color
                borderRadius: BorderRadius.circular(10),
              ),
              //child: SvgPicture.asset("assets/icons/back-svgrepo-com.svg"),
              child: Icon(
                Icons.post_add,
                size: 24,
              ), // I can also use flutter's icons
            ),
          ),
        ],
      ),
      //backgroundColor: Colors.white,
    );
  }

  Column _recommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            "Your Friends Posted:",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600, //I am
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 270,
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(8, 8),
                    ),
                  ],
                ),
                width: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Image(
                        image: AssetImage(recModels[index].iconPath),
                        height: 80,
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                              color: Colors.amber,
                            ),
                            child: Icon(Icons.person_3_sharp),
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
                            SizedBox(height: 5),
                            SizedBox(
                              width: 45,
                              child: Text(
                                "${recModels[index].level}|${recModels[index].duration}|${recModels[index].cal}",
                                style: TextStyle(
                                  fontSize: 12, //
                                  fontWeight: FontWeight.w400,
                                  //  color: const Color.fromARGB(255, 101, 101, 101),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
          hintText: "Search Friends",
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
            //color: Colors.purple,
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
      backgroundColor: const Color.fromARGB(0, 244, 67, 54),
      title: Text(
        "Hello $greetName",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ), //please do not mess up this part
      centerTitle: true,
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
          onTap: () {
            Navigator.pushNamed(context, "/profilepage");
          },
          child: Container(
            //this is the bar on top
            width: 37,
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 207, 221, 246), //I like this color
              borderRadius: BorderRadius.circular(10),
            ),
            /* a */
            child: ClipOval(
              child: containerChild,
            ), // I can also use flutter's icons
          ),
        ),
      ],
    );
  }
}
