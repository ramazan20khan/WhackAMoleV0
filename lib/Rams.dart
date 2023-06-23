import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import 'package:helloworld/PlayerGrid.dart';
import 'package:helloworld/globals.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import 'package:helloworld/PlayerGrid.dart';

class Rams extends StatefulWidget {
  @override
  _RamsState createState() => _RamsState();
}

class _RamsState extends State<Rams> {
  bool isMobileLandscape = false;
  int scoreData = 0; // Local variable for score
  int levelData = 1; // Local variable for level

  @override
  void initState() {
    super.initState();
    checkScreenOrientation();
  }

  void onTapCard(int index) {
    AssetsAudioPlayer.newPlayer().open(
      Audio('assets/audio/fc_apple.m4a'),
    );
  }

  Future<void> checkScreenOrientation() async {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isLandscape = screenWidth > screenHeight;

    setState(() {
      isMobileLandscape = isLandscape && screenWidth < 600;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final screenHeight = constraints.maxHeight;
          final screenWidth = constraints.maxWidth;
          final topSectionHeight = screenHeight * 0.2;
          final bottomSectionHeight = screenHeight - topSectionHeight;

          return PlayerGrid();
        },
      ),
    );
  }
}
