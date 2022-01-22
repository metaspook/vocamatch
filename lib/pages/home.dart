import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:vocamatch/models/item.dart';
import 'package:vocamatch/widgets/custom_divider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var player = AudioCache(prefix: "assets/audio/");
  late List<ItemModel> items;
  late List<ItemModel> items2;
  late int score;
  late bool gameOver;
  late String appBarText;

  initGame() {
    // gameOver = false;
    score = 0;
    appBarText = '';
    items = [
      ItemModel(value: 'lion', name: 'Lion', img: 'assets/images/lion.png'),
      ItemModel(value: 'panda', name: 'Panda', img: 'assets/images/panda.png'),
      ItemModel(value: 'camel', name: 'Camel', img: 'assets/images/camel.png'),
      ItemModel(value: 'dog', name: 'Dog', img: 'assets/images/dog.png'),
      ItemModel(value: 'cat', name: 'Cat', img: 'assets/images/cat.png'),
      ItemModel(value: 'horse', name: 'Horse', img: 'assets/images/horse.png'),
      ItemModel(value: 'sheep', name: 'Sheep', img: 'assets/images/sheep.png'),
      ItemModel(value: 'hen', name: 'Hen', img: 'assets/images/hen.png'),
      ItemModel(value: 'fox', name: 'Fox', img: 'assets/images/fox.png'),
      ItemModel(value: 'cow', name: 'Cow', img: 'assets/images/cow.png'),
    ];
    items2 = List<ItemModel>.from(items);

    items.shuffle();
    items2.shuffle();
  }

  @override
  void initState() {
    super.initState();
    initGame();
  }

  @override
  Widget build(BuildContext context) {
    // Pre-conditions before retun widgets
    gameOver = items.isEmpty;
    appBarText = score != 0
        ? 'Score: $score'
        : gameOver
            ? 'Game Over'
            : 'VocaMatch';

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          centerTitle: true,
          title: Text(appBarText,
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Colors.white70))),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            // mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.swipe),
                    label: Text(
                      'Drag and Drop | Match Vocabulary',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              // padding: EdgeInsets.all(8),
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!gameOver) ...[
                  Row(
                    children: [
                      // Spacer(),
                      Column(
                        children: items.map((item) {
                          return Container(
                            height: MediaQuery.of(context).size.width / 6.5,
                            width: MediaQuery.of(context).size.width / 3,
                            margin: EdgeInsets.all(8),
                            child: Draggable<ItemModel>(
                              data: item,
                              childWhenDragging: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(item.img),

                                // radius: 50,
                              ),
                              feedback: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(item.img),
                                // radius: 30,
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                // backgroundImage: AssetImage(item.img),
                                child: ClipOval(
                                  child: Image.asset(
                                    item.img,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // radius: 100,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      Spacer(flex: 3),
                      Column(
                        children: items2.map((item) {
                          return DragTarget<ItemModel>(
                            onAccept: (receivedItem) {
                              if (item.value == receivedItem.value) {
                                score += 10;
                                setState(() {
                                  items.remove(receivedItem);
                                  items2.remove(item);

                                  if (items.isEmpty && items2.isEmpty) {
                                    initGame();
                                    _showDialog('hello', null, 'gg');
                                  }
                                });
                                item.accepting = false;

                                player.play('true.wav');
                              } else {
                                setState(() {
                                  score -= 5;
                                  item.accepting = false;
                                  player.play('false.wav');
                                });
                              }
                            },
                            onWillAccept: (receivedItem) {
                              setState(() {
                                item.accepting = true;
                              });
                              return true;
                            },
                            onLeave: (receivedItem) {
                              setState(() {
                                item.accepting = false;
                              });
                            },
                            builder: (context, acceptedItems, rejectedItems) =>
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: item.accepting
                                          ? Colors.grey[400]
                                          : Colors.grey[200],
                                    ),
                                    alignment: Alignment.center,
                                    height:
                                        MediaQuery.of(context).size.width / 6.5,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    margin: EdgeInsets.all(8),
                                    child: Text(
                                      item.name,
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    )),
                          );
                        }).toList(),
                      ),
                      Spacer(),
                    ],
                  ),
                ],
                // if (gameOver)
                // Center(
                //   child: Column(
                //     // mainAxisAlignment: MainAxisAlignment.center,
                //     // crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       Text(
                //         result(),
                //         textAlign: TextAlign.center,
                //         style: Theme.of(context).textTheme.headline3,
                //       ),
                //       ElevatedButton.icon(
                //           onPressed: () {
                //             setState(() {
                //               initGame();
                //             });
                //           },
                //           icon: Icon(Icons.refresh),
                //           label: Text(
                //             'New Game',
                //             style: TextStyle(color: Colors.white),
                //           ))
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Functions:

  String result() {
    if (score == 100) {
      player.play('success.wav');
      return 'Awesome!';
    } else {
      player.play('try_again.wav');
      return 'Play again to get better score';
    }
  }

  void _showDialog([String? title, String? image, String? name]) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              // elevation: 15,
              backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.75),
              title: Column(
                children: [
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  CustomDivider(),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (image != null)
                    Image.asset(
                      image,
                      // fit: BoxFit.scaleDown,
                      // height: 150,
                      // width: 150,
                    ),
                  Text(
                    name!,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('OK', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ]
              // ),
              );
        });
  }
}
