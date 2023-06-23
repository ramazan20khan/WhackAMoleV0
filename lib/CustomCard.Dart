import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CustomCard extends StatefulWidget {
  String imagePath;
  String text;
  String soundPath;
  final VoidCallback? onVisible;
  bool isVisible;
  bool isGameCard;

  CustomCard({
    required this.imagePath,
    required this.text,
    required this.soundPath,
    this.onVisible,
    this.isVisible = false,
    this.isGameCard = false,
  });

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  void initState() {
    super.initState();
    if (widget.isVisible && widget.onVisible != null) {
      widget.onVisible!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey,
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            child: SvgPicture.asset(
              widget.imagePath,
              //semanticsLabel: 'Custom Card Image',
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.text,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

