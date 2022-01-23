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
  final AudioCache player = AudioCache(prefix: "assets/audio/");
  late List<ItemModel> items;
  late List<ItemModel> items2;
  late int score;
  late int fullScore;
  late bool gameOver;
  late String appBarText;

  initGameState() {
    score = 0;
    appBarText = 'VocaMatch';
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
    fullScore = items.length * 10;
    items.shuffle();
    items2.shuffle();
  }

  @override
  void initState() {
    super.initState();
    initGameState();
  }

  @override
  Widget build(BuildContext context) {
    // Pre-conditions before retun widgets
    gameOver = items.isEmpty;
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
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.swipe),
                    label: const Text(
                      'Drag and Drop | Match Vocabulary',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              children: [
                if (!gameOver) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: items.map((item) {
                          return Container(
                            margin: const EdgeInsets.all(8),
                            child: Draggable<ItemModel>(
                              data: item,
                              childWhenDragging: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                  child: Image.asset(
                                    item.img,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                radius: MediaQuery.of(context).size.width *
                                    0.076 *
                                    1.75,
                              ),
                              feedback: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                  child: Image.asset(
                                    item.img,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                radius:
                                    MediaQuery.of(context).size.width * 0.0775,
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                  child: Image.asset(
                                    item.img,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                radius:
                                    MediaQuery.of(context).size.width * 0.0775,
                              ),
                            ),
                          );
                        }).toList(growable: false),
                      ),
                      Column(
                        children: items2.map((item) {
                          return DragTarget<ItemModel>(
                            onAccept: (receivedItem) {
                              if (item.value == receivedItem.value) {
                                item.accepting = false;
                                player.play('true.wav');
                                items.remove(receivedItem);
                                items2.remove(item);
                                setState(() => score += 10);
                                if (items.isEmpty) {
                                  _showDialog(
                                    title: '📣 Game Over 📣',
                                    subtitle: generateResult(),
                                  );
                                }
                              } else {
                                item.accepting = false;
                                player.play('false.wav');
                                setState(() => score -= 5);
                              }
                              appBarText = 'Score: $score/$fullScore';
                            },
                            onWillAccept: (receivedItem) {
                              setState(() => item.accepting = true);
                              return true;
                            },
                            onLeave: (receivedItem) {
                              setState(() => item.accepting = false);
                            },
                            builder: (context, acceptedItems, rejectedItems) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: item.accepting
                                      ? Colors.grey[400]
                                      : Colors.grey[200],
                                ),
                                alignment: Alignment.center,
                                height: MediaQuery.of(context).size.width / 6.5,
                                width: MediaQuery.of(context).size.width / 3,
                                margin: EdgeInsets.all(8),
                                child: Text(item.name,
                                    style:
                                        Theme.of(context).textTheme.headline6),
                              );
                            },
                          );
                        }).toList(growable: false),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Methods:
  String generateResult() {
    if (score == fullScore) {
      player.play('success.wav');
      return 'Awesome!';
    } else {
      player.play('try_again.wav');
      return 'Try again';
    }
  }

  void _showDialog({required String title, required String subtitle}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.90),
          title: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              CustomDivider(),
            ],
          ),
          content: Text(subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                setState(() => initGameState());
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
          ],
        );
      },
    );
  }
}
