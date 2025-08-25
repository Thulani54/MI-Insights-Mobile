import 'package:flutter/material.dart';
import 'package:tween_image_widget/tween_image_widget.dart';

class DeviceCurtainPage extends StatefulWidget {
  DeviceCurtainPage({required Key key}) : super(key: key);

  @override
  _DeviceCurtainPageState createState() => _DeviceCurtainPageState();
}

class _DeviceCurtainPageState extends State<DeviceCurtainPage> {
  ///0 ~ 100
  int curtainPosition = 50;

  bool isOnline = true;
  late TweenImageWidget _curtainAnimationImage;

  @override
  void initState() {
    _curtainAnimationImage = TweenImageWidget(
      ImagesEntry(1, 20, "equipmentcontrol_pic_curtain%s".toAssetImg()),
      durationMilliseconds: 2000,
      repeat: false,
      startsValue: curtainPosition / 100,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //equipmentcontrol_curtain_off
        Expanded(child: _curtainAnimationImage),
        Container(
          padding: EdgeInsets.symmetric(vertical: 0),
          color: MyTheme.color_bg_white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildTurnWidget(
                  "TurnOn",
                  isOnline
                      ? "equipmentcontrol_open_on"
                      : "equipmentcontrol_open_offline", () {
                setState(() {
                  _curtainAnimationImage.stop();
                  _curtainAnimationImage.reverse();
                });
              }),
              buildTurnWidget(
                  "Pause",
                  isOnline
                      ? "equipmentcontrol_pause_on"
                      : "equipmentcontrol_stop_disabled", () {
                setState(() {
                  _curtainAnimationImage.stop();
                });
              }),
              buildTurnWidget(
                  "TurnOff",
                  isOnline
                      ? "equipmentcontrol_close_on"
                      : "equipmentcontrol_close_offline", () {
                setState(() {
                  _curtainAnimationImage.stop();
                  _curtainAnimationImage.forward();
                });
              }),
            ],
          ),
        ),
      ],
    );
  }

  Column buildTurnWidget(
      final String name, final String imageUrl, GestureTapCallback onTap) {
    return Column(
      children: [
        InkWell(
          child: Card(
            shape: CircleBorder(side: BorderSide.none),
            elevation: 2,
            shadowColor: MyTheme.color_bg_black,
            child: CircleAvatar(
              radius: 24,
              backgroundColor:
                  isOnline ? MyTheme.color_bg_orange : MyTheme.color_bg_main,
              child: Image.asset(imageUrl.toAssetImg()),
            ),
          ),
          onTap: onTap,
        ),
        SizedBox(height: 6),
        Text(
          name,
          style: MyTheme.style_subContent,
        ),
      ],
    );
  }
}

class MyTheme {
  MyTheme._();

  static const Color color_bg_white = Color(0xFFFFFFFF);
  static const Color color_bg_black = Color(0xFF000000);
  static const Color color_bg_orange = Colors.red;
  static const Color color_bg_main = Color(0xFFF9F6EF);

  static const Color color_text_main = Color(0xFF000000);

  static const style_subContent =
      TextStyle(color: MyTheme.color_text_main, fontSize: 12);
}

extension StringEx on String {
  String toAssetImg() {
    return "assets/img/${this}.png";
  }
}
