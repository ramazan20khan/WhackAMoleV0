import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:helloworld/CustomCard.Dart';
import 'package:helloworld/globals.dart';

class PlayerGrid extends StatefulWidget {
  const PlayerGrid({Key? key}) : super(key: key);

  @override
  _PlayerGridState createState() => _PlayerGridState();
}

class _PlayerGridState extends State<PlayerGrid> {
  late List<CustomCard> gameCards;
  late List<CustomCard> tickCards;
  int milliSeconds = 0;
  int sMilli = 0;
  int prevLevel = levelData;
  late DateTime startTime;
  late Timer visibilityTimer;
  late Timer intervalTimer;
  int visibilityDuration = 2000; // Initial visibility duration in milliseconds

  int haveAGo = 0;

  @override
  void dispose() {
    visibilityTimer.cancel();
    intervalTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    runLogic();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> moleHoles = genMoleHoles(80, 140);

    final Orientation orientation = MediaQuery.of(context).orientation;
    int columns = 2;
    int rows = 3;

    if (orientation == Orientation.landscape) {
      columns = 3;
      rows = 2;
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            height: MediaQuery.of(context).size.height *
                0.2, // 20% of screen height

            child: Stack(children: [
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Score: $scoreData',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Level: $levelData',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ]),
          ),
          Container(
            color: Colors.orangeAccent,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Stack(
              children: [
                GridView.count(
                  crossAxisCount: columns,
                  childAspectRatio:
                      orientation == Orientation.portrait ? 2 : 2.2,
                  controller: ScrollController(keepScrollOffset: false),
                  shrinkWrap: true,
                  mainAxisSpacing:
                      orientation == Orientation.portrait ? 120.0 : 90,
                  children: moleHoles,
                ),
                tickGrid(columns, orientation),
                buildGridView(columns, orientation),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tickGrid(int columns, Orientation orientation) {
    return GridView.count(
      crossAxisCount: columns,
      childAspectRatio: orientation == Orientation.portrait ? 1 : 1.6,
      controller: ScrollController(keepScrollOffset: false),
      mainAxisSpacing: orientation == Orientation.portrait ? 0 : 0.0,
      shrinkWrap: true,
      children: tickCards
          .map(
            (card) => Padding(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  //
                  CustomCard(
                    imagePath: card.imagePath,
                    soundPath: card.soundPath,
                    text: "",
                    isVisible: card.isGameCard, //card.isVisible,
                    isGameCard: card.isGameCard,
                    onVisible: () {
                      //playSound(card.soundPath);
                    },
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget buildGridView(int columns, Orientation orientation) {
    //CustomCard tick = getCustomCards().last;
    return GridView.count(
      crossAxisCount: columns,
      childAspectRatio: orientation == Orientation.portrait ? 1 : 1.6,
      controller: ScrollController(keepScrollOffset: false),
      mainAxisSpacing: orientation == Orientation.portrait ? 0 : 0.0,
      shrinkWrap: true,
      children: gameCards
          .map(
            (card) => Padding(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (card.isGameCard) {
                        setState(() {
                          scoreData += 10;
                          haveAGo = 0;

                          milliSeconds = 0;
                          card.isVisible = false;
                        });

                        playSound('assets/audio/correct.m4a');

                        Timer(Duration(seconds: 1), () {
                          setState(() {
                            gMoreCards();
                          });
                        });
                      }
                    },
                    child: Stack(
                      children: [
                        CustomCard(
                          imagePath: card.imagePath,
                          soundPath: card.soundPath,
                          text: card.text,
                          isVisible: card.isVisible,
                          onVisible: () {
                            //playSound(card.soundPath);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  void runLogic() {
    gMoreCards();
    int timerTick = 0;

    //bool visib = false;
    int milliDuration = milliSeconds + (visibilityDuration * 2) - sMilli;
    visibilityTimer =
        Timer.periodic(Duration(milliseconds: milliDuration), (timer) {
      timerTick++;
      startTime = DateTime.now();
      setState(() {
        // Toggle the visibility of game cards
        Duration elapsed = DateTime.now().difference(startTime);
        //print("$startTime.inMilliseconds    $elapsed.inMilliseconds");
        haveAGo++;

        if (elapsed.inMilliseconds < visibilityDuration) {
          // Make the cards visible for the specified duration
          gameCards.forEach((card) {
            if (card.isGameCard) {
              card.isVisible = true;
              playSound(card.soundPath);
            }
          });
        } else {
          // Make the cards invisible after the specified duration
          gameCards.forEach((card) {
            if (card.isGameCard) {
              card.isVisible = false;
            }
          });
        }
      });

      if (haveAGo > 3) {
        haveAGo = 0;
        milliSeconds += 500;
      }
      print(
          "$timerTick  ${milliSeconds} ${haveAGo} $visibilityDuration ${milliSeconds + (visibilityDuration * 2)}");

      // Shuffle the game cards
      gameCards.shuffle();
      for (int i = 0; i < gameCards.length; i++) {
        tickCards[i].isGameCard = gameCards[i].isGameCard;
      }
    });
  }

  void gMoreCards() {
    tickCards = [];
    CustomCard tick = getCustomCards().last;
    gameCards = gCards();
    gameCards.forEach((element) {
      CustomCard cardx = CustomCard(
        imagePath: tick.imagePath,
        isGameCard: element.isGameCard,
        isVisible: false,
        onVisible: () {},
        soundPath: tick.soundPath,
        text: tick.text,
      );
      tickCards.add(cardx);
    });
  }

  int levelCardNumbers() {
    int level = (scoreData / 30).ceil();
    levelData = level;

    if (prevLevel < levelData) {
      prevLevel = levelData;
      sMilli -= 200;
    }
    if (level > 3) {
      level = level % 3;
    }
    if (level == 0) {
      level = 1;
    }
    print("Level   $level");
    return level;
  }

  List<CustomCard> gCards() {
    List<CustomCard> rCards = oRandomArray();
    int rams = levelCardNumbers();
    print("This is $rams");
    List<int> visCards = getRandomIntArray(rams, 0, rCards.length);
    List<int> isGCards = getRandomIntArray(rams, 0, 1);
    for (int x = 0; x < rCards.length; x++) {
      for (int j = 0; j < visCards.length; j++) {
        if (x == visCards[j]) {
          rCards[x].isVisible = true;
          //if (x == isGCards[j]) {
          rCards[x].isGameCard = true;
          //}
        }
      }
    }
    // Specify the index of the card you want to be visible
    return rCards;
  }

  List<CustomCard> oRandomArray() {
    List<CustomCard> oArr = [];
    List<int> iArr = getRandomIntArray(6, 0, 8);
    List<CustomCard> cCards = getCustomCards();
    for (int i = 0; i < iArr.length; i++) {
      oArr.add(cCards[iArr[i]]);
    }
    return oArr;
  }

  List<Widget> genMoleHoles(double ellipseHeight, double ellipseWidth) {
    return List.generate(
      6,
      (index) => Container(
        child: Center(
          child: Container(
            width: ellipseWidth,
            height: ellipseHeight,
            decoration: BoxDecoration(
              color: Colors.brown,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(ellipseHeight / 2),
            ),
          ),
        ),
      ),
    );
  }

  List<int> getRandomIntArray(int _size, int _min, int _max) {
    final random = Random();
    final List<int> numbers = [];

    while (numbers.length < _size) {
      final randomNumber = random.nextInt(_max - _min) + _min;
      if (!numbers.contains(randomNumber)) {
        numbers.add(randomNumber);
      }
    }
    return numbers;
  }

  List<CustomCard> getCustomCards() {
    List<String> imagePaths = [
      'assets/images/fc_tomato.svg',
      'assets/images/fc_potato.svg',
      'assets/images/fc_orange.svg',
      'assets/images/fc_egg.svg',
      'assets/images/fc_carrot.svg',
      'assets/images/fc_cake.svg',
      'assets/images/fc_bread.svg',
      'assets/images/fc_banana.svg',
      'assets/images/fc_apple.svg',
      'assets/images/tick.svg',
    ];

    List<String> soundPaths = [
      'assets/audio/fc_tomato.m4a',
      'assets/audio/fc_potato.m4a',
      'assets/audio/fc_orange.m4a',
      'assets/audio/fc_egg.m4a',
      'assets/audio/fc_carrot.m4a',
      'assets/audio/fc_cake.m4a',
      'assets/audio/fc_bread.m4a',
      'assets/audio/fc_banana.m4a',
      'assets/audio/fc_apple.m4a',
      'assets/audio/correct.m4a',
    ];

    List<CustomCard> customCards = [];

    for (int num = 0; num < soundPaths.length; num++) {
      CustomCard customCard = CustomCard(
        imagePath: imagePaths[num],
        soundPath: soundPaths[num],
        text: imagePaths[num],
        isVisible: false, // Set the initial visibility of all cards to false
        isGameCard: false,
        //onTap: () {},
        onVisible: () {
          playSound(soundPaths[num]);
        },
      );
      customCards.add(customCard);
    }

    return customCards;
  }

  void playSound(String soundPath) {
    final assetsAudioPlayer = AssetsAudioPlayer();

    assetsAudioPlayer.open(
      Audio(soundPath),
    );
  }
}
