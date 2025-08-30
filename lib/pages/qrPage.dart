import 'dart:io';

import 'package:fitness/pages/home.dart';
import 'package:fitness/service/ApiService.dart';
import 'package:fitness/models/UserRepository.dart';
import 'package:fitness/service/token_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Qrpage extends StatefulWidget {
  //final DepartmentRepository depRepo; // Store as a field

  const Qrpage({super.key});
  //bool hidden = true;
  @override
  State<Qrpage> createState() => _QrpageState();
}

class _QrpageState extends State<Qrpage> with TickerProviderStateMixin {
  Widget containerChild = Icon(Icons.person_3_sharp);
  UserRepository? userRepo;
  int? userId;
  int? reqId;
  bool? scan;
  String? friendName = "someone";
  Widget? profileChild = Icon(Icons.person_3_outlined, size: 250);

  late final TabController _tabController;
  TextEditingController textController = TextEditingController();

  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,

    detectionTimeoutMs: 250,
    torchEnabled: true,
    invertImage: true,
    autoZoom: true,
  );

  @override
  void initState() {
    super.initState();
    scan = true;
    reqId = -1;
    _tabController = TabController(length: 2, vsync: this);
    userRepo = Provider.of<UserRepository>(context, listen: false);
    _getUserProfile();
  }

  Future<void> _getUserProfile() async {
    if (userRepo == null) return;
    print("user repo is not null");
    String? token = await TokenService.getToken();
    if (token != null) {
      print("token is not null");
      var data = await userRepo!.fetchHomeInfo(token!);
      setState(() {
        userId = data["userId"];
      });
    } else {
      print("The token is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Center(child: oldColumn()),
          Center(child: scan! ? scanColumn() : friendProfileColumn()),
        ],
      ),

      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 0, 0), //I like this color
        ),
        height: 60,
      ),
    );
  }

  Column oldColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _profilePic(), //bir şeyler
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Your QR is private. If you share it with someone, they can scan it with their App camera to add you as a contact.",
            style: TextStyle(
              fontSize: 12,
              color: const Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.w500, //I am
            ),
          ),
        ),
      ],
    );
  }

  Column scanColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 207, 221, 246), //I like this color
            borderRadius: BorderRadius.circular(20),
          ),
          width: 250,
          height: 250,
          alignment: Alignment.center,

          child: MobileScanner(
            onDetect: (result) async {
              print(result.barcodes.first.rawValue);

              await _handleScan(
                result.barcodes.first.rawValue,
              ); //todo I want to add a loading screen here

              print("you are now friends with someone");
              setState(() {
                scan = false;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Scan to add Friend",
            style: TextStyle(
              fontSize: 12,
              color: const Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.w500, //I am
            ),
          ),
        ),
      ],
    );
  }

  Column friendProfileColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 207, 221, 246), //I like this color
            borderRadius: BorderRadius.circular(20),
          ),
          width: 300,
          height: 300,
          alignment: Alignment.center,
          child: profileChild,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Text(
            "Add $friendName to Friends?",
            style: TextStyle(
              fontSize: 12,
              color: const Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.w500, //I am
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  scan = true;
                });
              },
              child: Icon(Icons.close),
            ),
            SizedBox(width: 15),
            ElevatedButton(
              onPressed: () {
                _addFriend();
                setState(() {
                  scan = true; //I want to display a feedback here
                });
              },
              child: Icon(Icons.check),
            ),
          ],
        ),
        SizedBox(height: 40),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        "QR code",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500, //I am
        ),
      ),
      backgroundColor: Colors.black,
      leading: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/profilepage");
        },
        child: Container(
          margin: EdgeInsets.all(15),
          alignment: Alignment.center,

          child: Icon(Icons.arrow_back, size: 28, color: Colors.white),
        ),
      ),

      bottom: TabBar(
        controller: _tabController,
        tabs: <Widget>[
          Tab(text: "My Code"),
          Tab(text: "Scan Code"),
        ],
      ),
    );
  }

  Container _profilePic() {
    //TODO fix the circle
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 207, 221, 246), //I like this color
        borderRadius: BorderRadius.circular(20),
      ),
      width: 250,
      height: 250,
      alignment: Alignment.center,

      margin: EdgeInsets.only(top: 40),
      // alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: QrImageView(data: userId.toString(), version: QrVersions.auto),
      ), //profile picture size
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _handleScan(String? rawValue) async {
    if (rawValue == null) return;

    controller.dispose();
    int k = int.parse(rawValue);
    reqId = k;
    String? token = await TokenService.getToken();

    if (token == null || userRepo == null || k == userId) return;

    print("calling the database");
    var data = await userRepo!.addFriendReq(token, k);
    //var data = await userRepo!.addFriend(token, k);

    Uint8List? str = data["profile"];
    String name = data["name"];
    setState(() {
      if (str != null) {
        profileChild = Image.memory(str);
        friendName = name;
      }
    });

    print("you are now friends with someone");
  }

  Future<void> _addFriend() async {
    if (reqId == null) return;

    controller.dispose();
    String? token = await TokenService.getToken();

    if (token == null || userRepo == null || reqId == userId) return;
    var data = await userRepo!.addFriend(token, reqId!);
    reqId = -1;
  }
}
