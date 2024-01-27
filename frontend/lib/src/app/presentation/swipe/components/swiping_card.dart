import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:frontend/src/config/theme.dart';

import '../../../service/swipe_status_service.dart';
import '../../utils/interests.dart';

import '../../../service/user_service.dart';
import '../../utils/secure_storage_service.dart';
import '../util/swipes_left.dart';

class SwipingCard extends StatefulWidget {
  final UserService userService;
  final SwipeStatusService swipeStatusService;

  SwipingCard(
      {super.key,
      required MatchEngine? matchEngine,
      required CustomLoveTheme customLoveTheme,
      required SwipeItem swipeItem,
      userId,
      required this.userService,
      required this.swipeStatusService})
      : _matchEngine = matchEngine,
        _customLoveTheme = customLoveTheme,
        _swipeItem = swipeItem,
        _userId = userId;

  final MatchEngine? _matchEngine;
  final CustomLoveTheme _customLoveTheme;
  final SwipeItem _swipeItem;
  final int _userId;
  final SecureStorageService _secureStorageService = SecureStorageService();

  @override
  State<SwipingCard> createState() => _SwipingCardState();
}

class _SwipingCardState extends State<SwipingCard> {
  Color _cardBackgroundColor =
      const CustomLoveTheme().neutralColor.withOpacity(0.80);
  final Duration _timerduration = const Duration(seconds: 10);
  final Curve _animationCurve = Curves.linear;
  bool swipeableTimer = true;
  Timer? timer;
  late bool swiped;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          setState(() {
            _cardBackgroundColor = widget._customLoveTheme.neutralBackgroundColor;
          });
        }
      });
    });
    resetTimer();
  }

  void _setTimer() {
    if (mounted) {
      setState(() {
        swipeableTimer = false;
      });
    }

    swiped = false;

    timer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          swipeableTimer = true;
        });
      }
    });
  }

  void resetTimer() {
    if (timer != null && timer!.isActive) {
      timer?.cancel();
    }
    _setTimer();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = min(MediaQuery.of(context).size.width, 750);

    return SafeArea(
      child: Container(
          alignment: Alignment.center,
          height:
          height - kToolbarHeight > 0 ? height - kToolbarHeight : height,
          width: !kIsWeb ? width * 0.90 : width * 0.65,
          child: Stack(children: [
          Card(
            elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.hardEdge,
      color: widget._customLoveTheme.neutralBackgroundColor,
      surfaceTintColor:  widget._customLoveTheme.neutralBackgroundColor,
      child: SwipeCards(
        matchEngine: widget._matchEngine!,
        itemBuilder: (BuildContext context, int index) {
          return AnimatedContainer(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _cardBackgroundColor,
                      _cardBackgroundColor,
                      _cardBackgroundColor,
                      _cardBackgroundColor,
                      _cardBackgroundColor,
                      _cardBackgroundColor,
                      widget._customLoveTheme.neutralBackgroundColor,
                    ])),
            duration: _timerduration,
            curve: _animationCurve,
            child: Container(
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: ClipRect(
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.04),
                          FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 50 : 40),
                              child: Row(
                                children: [
                                  Text(
                                    widget._swipeItem.content.name,
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                  widget._swipeItem.content.gender == "Divers" ? SizedBox(width: width * 0.01) : const SizedBox(),
                                  widget._swipeItem.content.gender == "Female" ? SvgPicture.asset("lib/src/icons/svg/female.svg") : widget._swipeItem.content.gender == "Male" ? SvgPicture.asset("lib/src/icons/svg/male.svg") : SvgPicture.asset("lib/src/icons/svg/diverse.svg"),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 50 : 40),
                                  child: Text(
                                    "Age: ${widget._swipeItem.content.age}",
                                    style: const TextStyle(fontSize: kIsWeb ? 16 : 14, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(width: kIsWeb ? width * 0.20 : width * 0.15),
                                locationWidget(widget._swipeItem.content.city, widget._swipeItem.content.distance),
                              ],
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 50 : 40),
                            child: FittedBox(
                              child: Wrap(
                                spacing: 25,
                                runSpacing: 4,
                                children: widget._swipeItem.content.interests.length > 0 ? List<Widget>.generate(widget._swipeItem.content.interests.length,
                                      (int i) {
                                    Icon avatar = Interests.getIcon(widget._swipeItem.content.interests[i]["name"]);
                                    return ActionChip(
                                      side: BorderSide(width: 1.5, color: widget._customLoveTheme.primaryColor),
                                      avatar: avatar,
                                      label: Text(widget._swipeItem.content.interests[i]["name"]),
                                      onPressed: () {},
                                    );
                                  },
                                ) : [Container()],
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              //for small bio card
                              height: height - height * 0.6,
                              width: !kIsWeb ? width * 0.70 : width * 0.53,
                              margin: const EdgeInsets.symmetric(vertical: kIsWeb ? 50 : 30, horizontal: 35),
                              decoration: BoxDecoration(
                                color: widget._customLoveTheme.neutralBackgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: widget._customLoveTheme.textColor.withOpacity(0.3),
                                    spreadRadius: 3,
                                    blurRadius: 10,
                                    offset: const Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                      widget._swipeItem.content.bio,
                                      style: const TextStyle(fontSize: kIsWeb ? 16 : 14),
                                      textAlign: TextAlign.left
                                  )
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.bottomCenter,
                              heightFactor: !kIsWeb ? 0.85 : 1,
                              child: FittedBox(
                                child: buttonWidget(context, height, width),
                              )
                          )
                        ]
                    ),
                  ),
                )
            ),
          );
        },
        onStackFinished: () async {},
        itemChanged: (SwipeItem item, int index) {},
        leftSwipeAllowed: swipeableTimer,
        rightSwipeAllowed: swipeableTimer,
        fillSpace: true,
        likeTag: getTag("Like"),
        nopeTag: getTag("Dislike"),
      ),
    ),
          ])),
    );
  }

  Widget locationWidget(city, int distance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.location_on, size: 18),
            Text(
              "Location: $city",
              style: const TextStyle(
                  fontSize: kIsWeb ? 16 : 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.navigation, size: 18),
            Text(
              "Distance: $distance km",
              style: const TextStyle(
                  fontSize: kIsWeb ? 16 : 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget buttonWidget(context, height, width) {
    final buttonHeight = kIsWeb ? height * 0.037 : height * 0.022;
    final buttonWidth = kIsWeb ? width * 0.046 : width * 0.055;
    double buttonSize = kIsWeb ? 40 : 32;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AnimatedOpacity(
          opacity: swipeableTimer ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 500),
          child: ElevatedButton(
              onPressed: () async {
                if (swipeableTimer) {
                  String accessToken = await widget._secureStorageService.retrieveAccessToken() as String;
                  int tmpSwipesLeft = await SwipesLeft.getCurrentSwipesLeft(
                      accessToken, widget._userId, widget.userService);
                  if (tmpSwipesLeft > 0) {
                    widget._matchEngine!.currentItem?.nope();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    vertical: buttonHeight, horizontal: buttonWidth),
                backgroundColor: widget._customLoveTheme.primaryColor,
              ),
              child: Icon(Icons.close,
                  size: buttonSize, color: widget._customLoveTheme.textColor)),
        ),
        SizedBox(width: width * 0.1),
        AnimatedOpacity(
          opacity: swipeableTimer ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 500),
          child: ElevatedButton(
              onPressed: () async {
                if (swipeableTimer) {
                  String accessToken = await widget._secureStorageService.retrieveAccessToken() as String;
                  int tmpSwipesLeft = await SwipesLeft.getCurrentSwipesLeft(
                      accessToken, widget._userId, widget.userService);
                  if (tmpSwipesLeft > 0) {
                    widget._matchEngine!.currentItem?.like();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    vertical: buttonHeight, horizontal: buttonWidth),
                backgroundColor: widget._customLoveTheme.primaryColor,
              ),
              child: Icon(Icons.favorite_outline,
                  size: buttonSize, color: widget._customLoveTheme.textColor)),
        ),
      ],
    );
  }

  Widget getTag(String tagString) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: widget._customLoveTheme.primaryColor)),
      child: Text(tagString),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
