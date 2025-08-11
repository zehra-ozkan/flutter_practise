import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  bool hidden = true;

  @override
  Widget build(BuildContext context) {
    var hiddenIcon = Icon(Icons.visibility);
    var hiddenOff = Icon(Icons.visibility_off);
    var icon = hidden ? hiddenOff : hiddenIcon;

    return Scaffold(
      appBar: AppBar(title: Text("this is hte app var")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("This is the first text"),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  obscureText: false,

                  decoration: InputDecoration(
                    labelText: "this is the label text 1",
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_3),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  obscureText: hidden,

                  decoration: InputDecoration(
                    labelText: "this is the label text 2",
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),

                    suffixIcon: IconButton(
                      icon: icon,
                      onPressed: () {
                        setState(() {
                          hidden = !hidden;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/homepage");
            },
            child: Text("this is the button"),
          ),
        ],
      ),
    );
  }

  void buttonPressed() {}
}
