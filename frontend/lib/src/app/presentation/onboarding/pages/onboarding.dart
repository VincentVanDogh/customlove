import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/src/app/service/expert_sys_service.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../../../config/theme.dart';
import '../../../service/user_service.dart';
import '../../swipe/util/content.dart';
import '../../utils/interests.dart';
import '../../utils/secure_storage_service.dart';


class OnboardingPage extends StatefulWidget {
  final UserService userService;
  final List<Content> usersContent;
  const OnboardingPage({Key? key, required this.userService, required this.usersContent}) : super(key: key);
  
  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final SecureStorageService secureStorageService = SecureStorageService();
  late ExpertSysService expertSysService;
  late List<SwipeItem> swipeItems;
  late MatchEngine _matchEngine;
  late List<int> swipeDecisions;
  bool _allTrainingCardsSwiped = false;

  void _onIntroEnd(context) {
    Navigator.of(context).pushNamed('/home/swipe');
  }

  @override
  void initState() {
    expertSysService = Provider.of<ExpertSysService>(context, listen: false);

    swipeDecisions = List.filled(widget.usersContent.length, 0);

    swipeItems = widget.usersContent.map((item) {
    return SwipeItem(
      content: item,
      likeAction: () {},
      nopeAction: () {},
      onSlideUpdate: (SlideRegion? region) async {}
      );
    }).toList();

    _matchEngine = MatchEngine(swipeItems: swipeItems);

    super.initState();
  }

  Widget _buildImage(String assetName, [double width = 300, double height = 200]) {
    return Image.asset(assetName, width: width, height: height);
  }

  Widget rowWidget(String text, IconData icon) {
    return Row(
      children: [
        textWidget(text),
        Icon(icon),
      ],
    );
  }

  Widget textWidget(String text) {
    return Text(style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal), text);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titlePadding: EdgeInsets.only(top: 0, bottom: 10),
      bodyPadding: EdgeInsets.only(top: 10),
      contentMargin: EdgeInsets.fromLTRB(50, 20, 50, 50),
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: false,
      infiniteAutoScroll: false,
      pages: [
        PageViewModel(
          title: "Welcome to CustomLove!",
          body:
          "\n We love having you. \n Prepare to embark on a journey of love.",
          image: _buildImage('lib/src/icons/handshake.png'),
          decoration: pageDecoration.copyWith(
            titleTextStyle: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
            bodyTextStyle: bodyStyle,
            titlePadding: const EdgeInsets.only(top: 16, bottom: 24),
            contentMargin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            pageColor: Colors.white,
            imagePadding: EdgeInsets.zero,
          ),
        ),
        PageViewModel(
          title: "What is CustomLove?",
          image: _buildImage('lib/src/icons/balloons.png'),
          body: "CustomLove is more than just a dating app. It's designed to help you discover your ideal match.\n\n\nIn the following steps we are going to customize your experience.",
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "It's not About Looks!",
          image: _buildImage('lib/src/icons/no-photos.png'),
          body: "We facilitate an environment where people want to meet others based on their personalities. \n\n That´s why you see a person's picture only if you have both decided to connect.",
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Personalized Matches Await!",
          image: _buildImage('lib/src/icons/deck.png'),
          body: "Let's start by swiping a stack full of cards to help us understand your preferences. \n\n So press the buttons on the next slide!",
          decoration: pageDecoration.copyWith(
            titlePadding: const EdgeInsets.only(top: 0, bottom: 20),
          ),
        ),
        _allTrainingCardsSwiped ? PageViewModel(
          title: "All Set!",
          image: _buildImage("lib/src/icons/yes.png"),
          body: "Our algorithms have been fine-tuned to your liking.",
          decoration: pageDecoration,
        ) :
        PageViewModel(
            title: "",
            decoration: const PageDecoration(
              titlePadding: EdgeInsets.only(top: 25),
              contentMargin: EdgeInsets.only(top: 2),
            ),
            bodyWidget: swipeCardsStack()),
        PageViewModel(
          title: "Discover Your Match, Your Way!",
          image: _buildImage("lib/src/icons/heart.png"),
          bodyWidget: FittedBox(
            child: Column(
              children: [
                rowWidget("Randomized ", Icons.casino),
                textWidget("Embrace unexpected matches"),
                const SizedBox(height: 30),
                rowWidget("Interest-based ", Icons.favorite),
                Column(
                  children: [
                    textWidget("Connect based on shared interests"),
                    const SizedBox(height: 5),
                    textWidget("and hobbies"),
                  ],
                ),
                const SizedBox(height: 30),
                rowWidget("Preference-based ", Icons.settings),
                Column(
                  children: [
                    textWidget("Fine-tune matches according to"),
                    const SizedBox(height: 5),
                    textWidget("your specific preferences")
                  ],
                ),
              ],
            ),
          ),
          decoration: pageDecoration.copyWith(
            titlePadding: const EdgeInsets.only(top: 0, bottom: 5),
            contentMargin: const EdgeInsets.fromLTRB(35, 20, 35, 50),
          ),
        ),
        PageViewModel(
          title: "Take Your Time to Connect!",
          image: _buildImage("lib/src/icons/hourglass.png"),
          body:
          "At CustomLove we believe in making meaningful connections.\n\n Each suggestion comes with a 10s countdown, giving you the opportunity to explore the profile of the user more thoughtfully.",
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Limited Swipes, Unlimited Connections!",
          body: "You have a limited set of swipes available within a 24-hour period. \n\n This is to promote a more enjoyable and intentional swiping experience.",
          image: _buildImage("lib/src/icons/banned.png"),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Congratulations!",
          body: "You are ready to connect!",
          image: _buildImage("lib/src/icons/rocket.png"),
          decoration: pageDecoration.copyWith(
            titlePadding: const EdgeInsets.only(top: 20, bottom: 20),
            imagePadding: const EdgeInsets.only(bottom: 30),
          ),
        ),
      ],
      onDone: () {
        if (_allTrainingCardsSwiped) {
          _onIntroEnd(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Not so fast. You still have some cards to swipe."),
            ),
          );
        }
      },
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: Icon(Icons.arrow_forward, color: _customLoveTheme.primaryColor),
      done: Text('Done', style: TextStyle(fontWeight: FontWeight.w600, color: _customLoveTheme.primaryColor)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(25),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: _customLoveTheme.neutralBackgroundColor.withOpacity(0.9),
        activeSize: const Size(22.0, 10.0),
        activeColor: _customLoveTheme.primaryColor,
        activeShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }

  Widget swipeCardsStack() {
    final height = MediaQuery.of(context).size.height;
    final width = min(MediaQuery.of(context).size.width, 750);

    return SafeArea(
      child: Container(
          alignment: Alignment.center,
          height: height > 0 ? kIsWeb ? height * 0.81 : height * 0.75 : height,
          width: !kIsWeb ? width * 0.90 : width * 0.65,
          child: Stack(children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              clipBehavior: Clip.hardEdge,
              color: _customLoveTheme.neutralBackgroundColor,
              surfaceTintColor: _customLoveTheme.neutralBackgroundColor,
              elevation: 10,
              child: SwipeCards(
                      matchEngine: _matchEngine,
                      itemBuilder: (BuildContext context, int index) {
                        if (_matchEngine.currentItem == swipeItems[index]) {
                          return Container(
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
                                        SizedBox(height: height * 0.05),
                                        FittedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 50 : 40),
                                            child: Row(
                                              children: [
                                                Text(
                                                  swipeItems[index].content.name,
                                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                                ),
                                                swipeItems[index].content.gender == "Divers" ? SizedBox(width: width * 0.01) : const SizedBox(),
                                                swipeItems[index].content.gender == "Female" ? SvgPicture.asset("lib/src/icons/svg/female.svg") : swipeItems[index].content.gender == "Male" ? SvgPicture.asset("lib/src/icons/svg/male.svg") : SvgPicture.asset("lib/src/icons/svg/diverse.svg"),
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
                                                  "Age: ${swipeItems[index].content.age}",
                                                  style: const TextStyle(fontSize: kIsWeb ? 16 : 14, fontWeight: FontWeight.bold),
                                                ),
                                              ),
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
                                            children: swipeItems[index].content.interests.length > 0 ? List<Widget>.generate(swipeItems[index].content.interests.length,
                                                  (int i) {
                                                Icon avatar = Interests.getIcon(swipeItems[index].content.interests[i].toLowerCase());
                                                return ActionChip(
                                                  side: BorderSide(width: 1.5, color: _customLoveTheme.primaryColor),
                                                  avatar: avatar,
                                                  label: Text(swipeItems[index].content.interests[i]),
                                                  onPressed: () {},
                                                );
                                              },
                                            ) : [Container()],
                                          ),
                                        )
                                        ),
                                        Center(
                                          child: Container(
                                            //for small bio card
                                            height: height - height * 0.6,
                                            width: !kIsWeb ? width * 0.70 : width * 0.53,
                                            margin: const EdgeInsets.symmetric(vertical: kIsWeb ? 50 : 30, horizontal: 35),
                                            decoration: BoxDecoration(
                                              color: _customLoveTheme.neutralBackgroundColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: _customLoveTheme.textColor.withOpacity(0.3),
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
                                                    swipeItems[index].content.bio,
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
                                              child: buttonWidget(context, height, width, index),
                                            )
                                        ),
                                      ]
                                  ),
                                ),
                              )
                          );
                        } else {
                          return Container();
                        }
                      },
                      onStackFinished: () async {
                        if (mounted) {
                          setState(() {
                            _allTrainingCardsSwiped = true;
                          });
                        }

                        String accessToken = await secureStorageService.retrieveAccessToken() as String;
                        await expertSysService.postExpertSys(accessToken, swipeDecisions);
                      },
                      itemChanged: (SwipeItem item, int index) {},
                      leftSwipeAllowed: false,
                      rightSwipeAllowed: false,
                      fillSpace: true,
                    ),
              ),
          ])),
    );
  }

  Widget buttonWidget(context, height, width, index) {
    final buttonHeight = kIsWeb ? height * 0.037 : height * 0.022;
    final buttonWidth = kIsWeb ? width * 0.046 : width * 0.055;
    double buttonSize = kIsWeb ? 40 : 32;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            onPressed: () async {
              swipeDecisions[index] = 0;
              _matchEngine.currentItem?.nope();
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                  vertical: buttonHeight, horizontal: buttonWidth),
              backgroundColor: _customLoveTheme.primaryColor,
            ),
            child: Icon(Icons.close,
                size: buttonSize, color: _customLoveTheme.textColor)),
        SizedBox(width: width * 0.1),
        ElevatedButton(
            onPressed: () async {
              swipeDecisions[index] = 1;
              _matchEngine.currentItem?.like();
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                  vertical: buttonHeight, horizontal: buttonWidth),
              backgroundColor: _customLoveTheme.primaryColor,
            ),
            child: Icon(Icons.favorite_outline,
                size: buttonSize, color: _customLoveTheme.textColor)),
      ],
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
}
