import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:fitness/models/friends_model.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:fitness/models/User.dart';
import 'package:fitness/models/UserRepository.dart';
import 'package:fitness/models/category_models.dart';
import 'package:fitness/models/recommendation_model.dart';
import 'package:fitness/pages/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:fitness/service/token_service.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<CategoryModel> models = [];
  List<Friend> friendModels = [];
  UserRepository? userRepo;
  final ImagePicker _picker = ImagePicker();
  File? _image; //this will be used to change the profile picture

  List<Recommandation> recModels = [];
  User? _user;
  String _name = "Whoever you are";
  String _birthday = "Whenever that is";

  Widget containerChild = Icon(Icons.person_3_sharp);
  Widget friendContainer = Icon(Icons.person_3_sharp);

  void _getRecommendations() {
    recModels = Recommandation.getRecommendations();
  }

  void _getCategories() {
    models = CategoryModel.getCategories();
  }

  Future<void> _getFriends() async {
    if (userRepo == null) return;
    String? token = await TokenService.getToken();
    if (token == null) return;
    var data = await userRepo!.getUserFriends(token);
    List<dynamic> bb = data["friends"];
    friendModels = bb.map((json) => Friend.fromJson(json)).toList();
  }

  Future<void> _getUser() async {
    if (userRepo == null) return;
    print("user repo is not null");

    String? token = await TokenService.getToken();
    if (token != null) {
      print("token is not null");
      var data = await userRepo!.fetchHomeInfo(token!);
      setState(() {
        String name1 = data["userName"];
        String birthday1 = data["birthday"];
        Uint8List? str = data["picture"];
        _name = name1;
        _birthday = birthday1;
        if (str != null) {
          //TODO maybe is empty?

          containerChild = SizedBox(
            height: 90,
            child: Image.memory(
              str,
              fit: BoxFit.contain, // or BoxFit.cover, BoxFit.fitWidth, etc.
            ),
          );
        }
      });
    } else {
      print("The token is null");
    }
  }

  void _setModels() {
    _getFriends();
    _getCategories();
    _getRecommendations();
  }

  @override
  void initState() {
    super.initState();
    userRepo = Provider.of<UserRepository>(context, listen: false);
    _getUser();
    _setModels(); //these are for friends and for user posts
  }

  @override
  Widget build(BuildContext context) {
    _setModels();

    return Scaffold(
      resizeToAvoidBottomInset:
          false, //this fixed the overflow error when the keyboard appears
      appBar: appBar(context),
      backgroundColor: const Color.fromARGB(255, 217, 222, 231),
      body: ListView(
        //listview is for the scrollvar
        scrollDirection: Axis.vertical,
        children: [
          _profilePic(),
          TextButton(
            onPressed: () {
              //_pickImage();
              _openPicker();
            },
            child: Text(
              "Change Profile Picture",
              style: TextStyle(
                color: const Color.fromARGB(255, 18, 54, 153),
                fontSize: 18,
                fontWeight: FontWeight.w300, //I am
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ), //this is to seperate the search bar form the category text

          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Name : ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600, //I am
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/nameUpdate");
                  },
                  child: Text(
                    _name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500, //I am
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Birthday : ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600, //I am
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/postspage");
                  },
                  child: Text(
                    _birthday,
                    style: TextStyle(
                      //TODO borders to text
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500, //I am
                    ),
                  ),
                ),
              ),
            ],
          ),

          _friendsSection(),
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
        ],
      ),
      //backgroundColor: Colors.white,
    );
  }

  Container _profilePic() {
    //TODO fix the circle
    return Container(
      child: ColoredBox(
        color: Colors.blue,
        child: SizedBox(
          width: 80,
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: containerChild, //profile picture size
          ),
        ),
      ),
    );
  }

  Column _recommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            "My posts",
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

  Column _friendsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
          ), //the left blank space for the category
          child: Text(
            "My Friends:",
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

            itemCount: friendModels.length,
            separatorBuilder: (context, index) =>
                SizedBox(width: 5), //this seperates the boxes from each other
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),

                width: 80,

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
                        padding: const EdgeInsets.all(10.0),

                        child: getProfile(friendModels[index].image),
                        //child: profileWidget(),
                      ),
                    ),
                    Text(
                      friendModels[index].name,
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

  Widget getProfile(String str) {
    return StreamBuilder<String>(
      stream: Stream.value(str), // Force rebuild with new value
      builder: (context, snapshot) {
        if (str.isEmpty) return Icon(Icons.person);

        try {
          final bytes = base64Decode(str);
          return Image.memory(bytes);
        } catch (e) {
          return Icon(Icons.error);
        }
      },
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      elevation: 0.0, //this is the shadow

      leading: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/homepage");
        },
        child: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 207, 221, 246), //I like this color
            borderRadius: BorderRadius.circular(10),
          ),
          //child: SvgPicture.asset("assets/icons/back-svgrepo-com.svg"),
          child: Icon(Icons.home, size: 24), // I can also use flutter's icons
        ),
      ),
    );
  }

  /*   _pickImage() async {
    print("inside picking object");
    final _picker = ImagePicker();

    final _pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    ); //TODO we need pupup for that

    if (_pickedImage != null) {
      _image = File(_pickedImage.path);
      String? token = await TokenService.getToken();
      if (token == null) return;
      userRepo?.uploadProfileImage(token, _image!.path);
      setState(() {
        containerChild = SizedBox(child: Image.file(_image!), height: 350);
      });
    }
  } */

  Future<void> _openPicker() async {
    print("inside picking object");
    final _picker = ImagePicker();

    final _pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (_pickedImage != null) {
      String? token = await TokenService.getToken();
      if (token == null) return;
      await cropImage(_pickedImage!.path);

      setState(() {
        // _image = File(_pickedImage.path);
        userRepo?.uploadProfileImage(token, _image!.path);
        containerChild = SizedBox(child: Image.file(_image!));
      });
    }
  }

  Future<void> cropImage(String path) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatio: CropAspectRatio(ratioX: 50, ratioY: 50),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          //toolbarTitle: 'Cropper',
          toolbarColor: const Color.fromARGB(142, 17, 87, 218),
          toolbarWidgetColor: Colors.white,
          hideBottomControls: true,
          aspectRatioPresets: [CropAspectRatioPreset.square],
        ),
      ],
    );
    setState(() {
      // _image = croppedFile as File;
      _image = File(croppedFile!.path);
    });
  }
}

class profileWidget extends StatelessWidget {
  const profileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.person);
  }
}
