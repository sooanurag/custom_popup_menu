import 'package:custom_popup_menu/custompopup.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: MainView(),
  ));
}

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 150,
                      ),
                      CustomPopupMenu(
                        context: context,
                        expandView: true,
                        scrollable: true,
                        items: [
                          CustomPopupItem(title: "Block User", onTap: () {}),
                          CustomPopupItem(title: "Profile", onTap: () {}),
                          CustomPopupItem(title: "Profile", onTap: () {}),
                          CustomPopupItem(title: "Profile", onTap: () {}),
                          CustomPopupItem(title: "Profile", onTap: () {}),
                          CustomPopupItem(title: "Block User", onTap: () {}),
                          CustomPopupItem(title: "Block User", onTap: () {}),
                          CustomPopupItem(title: "Block User", onTap: () {}),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
