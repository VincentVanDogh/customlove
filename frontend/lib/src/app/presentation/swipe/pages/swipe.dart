import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';
import 'package:frontend/src/app/model/user_model.dart';
import 'package:frontend/src/app/presentation/swipe/components/swiping_card.dart';
import 'package:frontend/src/app/presentation/swipe/util/swipe_state_notifier.dart';
import 'package:frontend/src/app/presentation/swipe/util/swipe_state.dart';
import 'package:frontend/src/app/presentation/swipe/util/matching_algorithm.dart';
import 'package:frontend/src/app/presentation/swipe/util/content.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/swipe/util/shared_swipeable_event.dart';
import 'package:frontend/src/app/service/swipe_status_service.dart';
import 'package:provider/provider.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:frontend/src/config/theme.dart';

import '../../../service/location_service.dart';
import '../../../service/user_service.dart';
import '../../utils/secure_storage_service.dart';
import '../util/algo_id_notifier.dart';
import '../util/swipes_left.dart';

class Swipe extends StatefulWidget {
  final UserService userService;
  final SwipeStatusService swipeStatusService;

  const Swipe({Key? key, required this.userService, required this.swipeStatusService}) : super(key: key);

  @override
  _SwipeState createState() => _SwipeState();

}

class _SwipeState extends State<Swipe>{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final SecureStorageService _secureStorageService = SecureStorageService();
  final LocationService _locationService = LocationService();

  SwipeStateNotifier? swipeStateNotifier;
  StreamSubscription<bool>? _swipeableSubscription;
  AlgoIdNotifier? algoIdNotifier;
  MatchEngine? _matchEngine;

  late double height;
  late double width;
  late SwipeItem _swipeItem;
  late bool swiped;
  late int userId;

  bool isLoading = false;
  bool swipeable = true;
  bool swipeableTimer = true;
  bool _didChangeDependenciesCalled = false;
  bool _swipeItemLoaded = false;
  bool _listenerAdded = false;
  int swipingAlgoId = 0;

  @override
  void initState() {
    super.initState();

    _fetchInitData();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    _swipeableSubscription ??= SharedSwipeableEvent.swipeable.swipeableChanged
        .listen((bool swipeableChanged) async {
      if (mounted) {
        setState(() {
          swipeable = swipeableChanged;
        });
      }
    });

    if(!_didChangeDependenciesCalled) {
      _didChangeDependenciesCalled = true;

      swipeStateNotifier ??= Provider.of<SwipeStateNotifier>(context);

      algoIdNotifier ??= Provider.of<AlgoIdNotifier>(context);

      if (!_listenerAdded) {
        swipeStateNotifier?.addListener(_swipeStateListener);
        algoIdNotifier?.addListener(_algoIdListener);
        _listenerAdded = true;
      }
    }

  }

  Future<void> _algoIdListener() async {
    if(swipingAlgoId != algoIdNotifier!.algoId) {
      swipingAlgoId = algoIdNotifier!.algoId;
      String accessToken = await _secureStorageService.retrieveAccessToken() as String;
      if (!context.mounted) return;
      await MatchingAlgorithm.updateMatchingAlgorithm(accessToken, context.read<UserService>(), swipingAlgoId);
    }

    if (mounted) {
      setState(() {
        if(swipeStateNotifier!.swipeState == SwipeState.OKAY) {
          _loadNextUser();
        } else if (swipeStateNotifier!.swipeState != SwipeState.NO_SURROUNDING_USERS) {
          _swipeItemLoaded = true;
        }
      });
    }
  }

  void _swipeStateListener() {
    if (mounted) {
      setState(() {

        if(swipeStateNotifier!.swipeState == SwipeState.OKAY) {
          _loadNextUser();
        } else {
          _swipeItemLoaded = true;
        }

      });
    }
  }

  Widget getSwipeCard() {
    SwipeState state = swipeStateNotifier!.swipeState;
    return SafeArea(
      child: Container(
          alignment: Alignment.center,
          height: height - kToolbarHeight > 0 ? height - kToolbarHeight : height,
          width: !kIsWeb ? width * 0.90 : width * 0.65,
          child: Stack(
              children: [getSwipeCardSwitch(state)])),
    );
  }

  Widget getSwipeCardSwitch(state) {
    switch (state) {
      case SwipeState.OKAY:
        return SwipingCard(
          matchEngine: _matchEngine,
          customLoveTheme: _customLoveTheme,
          swipeItem: _swipeItem,
          userService: widget.userService,
          swipeStatusService: widget.swipeStatusService,
          userId: userId,
        );
      case SwipeState.NO_SWIPES_LEFT:
        return noSwipesLeftCard();
      case SwipeState.NO_SURROUNDING_USERS:
        return noSurroundingUsersCard();
      default:
        return Center(child: Container());
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = min(MediaQuery.of(context).size.width, 750);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: _customLoveTheme.neutralBackgroundColor,
        body: Center(
            child: _swipeItemLoaded
                ? getSwipeCard()
                : Center(
                    child: CircularProgressIndicator(
                        color: _customLoveTheme.primaryColor))),
      ),
    );
  }

  Future<void> _fetchInitData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getUserId();
      await _getMatchingAlgorithm();
      int currentSwipesLeft = await _checkSwipesLeft();
      if (currentSwipesLeft > 0) {
        swipeStateNotifier!.setSwipeState(SwipeState.OKAY);
      } else {
        swipeStateNotifier!.setSwipeState(SwipeState.NO_SWIPES_LEFT);
      }
    });
  }

  Future<int> _checkSwipesLeft() async {
    String accessToken = await _secureStorageService.retrieveAccessToken() as String;
    int currentSwipesLeft = await SwipesLeft.getCurrentSwipesLeft(
        accessToken, userId, widget.userService);
    if (currentSwipesLeft > 0) {
      SharedSwipeableEvent.swipeable.changeSwipeable(true);
    } else {
      SharedSwipeableEvent.swipeable.changeSwipeable(false);
    }
    return currentSwipesLeft;
  }

  Future<void> _getUserId() async {
    var userIdString = await _secureStorageService.retrieveUserId() as String;
    userId = int.parse(userIdString);
  }

  Future<void> _getMatchingAlgorithm() async {
    String accessToken = await _secureStorageService.retrieveAccessToken() as String;
    await MatchingAlgorithm.getCurrentMatchingAlgorithm(accessToken, userId, widget.userService).then((matchingAlgorithm){
      if (matchingAlgorithm != swipingAlgoId) {
        swipingAlgoId = matchingAlgorithm;
        algoIdNotifier?.setAlgoId(swipingAlgoId);
      }
    });
  }

  void _loadNextUser() async {
    if (isLoading || swipeStateNotifier!.swipeState != SwipeState.OKAY) return;

    if (mounted) {
      setState(() {
        _swipeItemLoaded = false;
        isLoading = true;
      });
    }

    String accessToken = await _secureStorageService.retrieveAccessToken() as String;

    String city = "";
    await widget.userService
        .getAlgoUser(accessToken, swipingAlgoId)
        .then((User? user) async {

          if (user != null) {
            city = await _locationService.getCurrentLocation(
                user.latitude, user.longitude);
          } else {
            city = "noCity";
          }

          _setUserSwipingCard(user, city);

    }).whenComplete(() {
      if (mounted) {
        setState(() {
          isLoading = false;
          _swipeItemLoaded = true;

          if (city == "noCity") {
            swipeStateNotifier!.setSwipeState(SwipeState.NO_SURROUNDING_USERS);
          }
        });
      }
    });
  }

  void _setUserSwipingCard(User? user, String? city) {
    if (user == null) {

    } else {
      if (mounted) {
        setState(() {
          _swipeItem = SwipeItem(
            content: _getSuggestedUserInfo(user, city!),
            likeAction: () async {
              _swipeActionTaken(true);
            },
            nopeAction: () async {
              _swipeActionTaken(false);
            },
            onSlideUpdate: (SlideRegion? region) async {
              _onSlideUpdate(region);
            },
          );
          _matchEngine = MatchEngine(swipeItems: [_swipeItem]);
        }
        );
      }
    }
  }

  _onSlideUpdate(SlideRegion? region) async {
      //ignore the swipe left check if the card is just be tapped
      if (region != null) {
        //ensure that after a swipe attempt the api call happens only once
        if (!swiped) {
          swiped = true;
          await _checkSwipesLeft();
        }
      }

      //when swipe card is in the initial state (null position), it should be possible to make the api call
      if (region == null) {
        swiped = false;
      }
  }

  void _swipeActionTaken(bool hasLiked) async {
    String accessToken = await _secureStorageService.retrieveAccessToken() as String;
    if (hasLiked) {
      await widget.swipeStatusService.postLike(accessToken, int.parse(_swipeItem.content.id));
    } else {
      await widget.swipeStatusService.postView(accessToken, int.parse(_swipeItem.content.id));
    }
    _didChangeDependenciesCalled = false;

    _updateSwipesLeft();
  }

  Content _getSuggestedUserInfo(User user, String city) {
    var id = user.id;
    var firstName = user.firstName;
    var distance = user.distance;
    var genderIdentityId = user.gender_identity_id;

    String gender = "";

    switch (genderIdentityId) {
      case 1:
        gender = "Male";
        break;
      case 2:
        gender = "Female";
        break;
      case 3:
        gender = "Divers";
        break;
      default:
        gender = "Male";
        break;
    }

    List<dynamic>? interests = [];
    if (user.interests != null) {
      interests = user.interests;
    }
    var birthDate = DateTime.parse(user.date_of_birth);
    var birthYear = birthDate.year;
    var todayDate = DateTime.now();

    int age = todayDate.year - birthYear;

    if (birthDate.month > todayDate.month ||
        (birthDate.month == todayDate.month &&
            birthDate.day > todayDate.day)) {
      age--;
    }

    return Content(
        id: id.toString(),
        name: firstName,
        gender: gender,
        age: age,
        city: city,
        bio: user.bio,
        interests: interests,
        distance: distance);
  }

  Widget noSurroundingUsersCard() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.hardEdge,
      color: _customLoveTheme.neutralBackgroundColor,
      surfaceTintColor: _customLoveTheme.neutralBackgroundColor,
      child: SwipeCards(
        matchEngine: _matchEngine = MatchEngine(swipeItems: [
          SwipeItem(
              content: "No users in the area  :(",
          ),
        ]),
        itemBuilder: (BuildContext context, int index) {
          return Container(
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              color: _customLoveTheme.neutralBackgroundColor,
              child: ClipRect(
                child: SingleChildScrollView(
                  child: Stack(
                      children: [
                        SizedBox(height: height * 0.08),
                        const Center(
                          child: FittedBox(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 190, vertical: 190),
                              child: ArcText(
                                radius: 100,
                                text: "No users in the area  :(",
                                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                startAngle: 0,
                                stretchAngle: 3,
                                startAngleAlignment: StartAngleAlignment.center,
                                placement: Placement.middle,
                                direction: Direction.clockwise,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 120 : 105, vertical: kIsWeb ? 120 : 105),
                            child: Column(
                              children: [
                                Icon(Icons.travel_explore_rounded, size: 150, color: _customLoveTheme.textColor),
                                SizedBox(height: height * 0.08),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(top: height * 0.4, left: kIsWeb ? 50 : 25, right: kIsWeb ? 50 : 25),
                            child: Text(
                              "Increase your search radius in your profile settings to find your perfect match!",
                              style: TextStyle(fontSize: kIsWeb ? 16 : 14, fontWeight: FontWeight.bold, color: _customLoveTheme.textColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ]
                  ),
                ),
              )
          );
        },
        onStackFinished: () async {},
        leftSwipeAllowed: false,
        rightSwipeAllowed: false,
        fillSpace: true,
      ),
    );

  }

  Widget noSwipesLeftCard() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.hardEdge,
      color: _customLoveTheme.neutralBackgroundColor,
      surfaceTintColor: _customLoveTheme.neutralBackgroundColor,
      child: SwipeCards(
        matchEngine: _matchEngine = MatchEngine(swipeItems: [
          SwipeItem(
              content: "Sorry - No Swipes Left  :(",
              onSlideUpdate: (SlideRegion? region) async {
                _onSlideUpdate(region);
              }),
        ]),
        itemBuilder: (BuildContext context, int index) {
          return Container(
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              color: _customLoveTheme.neutralBackgroundColor,
              child: ClipRect(
                child: SingleChildScrollView(
                  child: Stack(
                      children: [
                        SizedBox(height: height * 0.08),
                        const FittedBox(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 190, vertical: 190),
                            child: ArcText(
                              radius: 100,
                              text: "Sorry - No Swipes Left  :(",
                              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              startAngle: 0,
                              stretchAngle: 3,
                              startAngleAlignment: StartAngleAlignment.center,
                              placement: Placement.middle,
                              direction: Direction.clockwise,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 120 : 105, vertical: kIsWeb ? 120 : 105),
                          child: Stack(
                            children: [
                              Icon(Icons.amp_stories_rounded, size: 150, color: _customLoveTheme.textColor),
                              Container(padding: const EdgeInsets.only(left: 52, top: 50), child: Icon(Icons.lock_clock_rounded, size: 45, color: _customLoveTheme.primaryColor)),
                            ],
                          ),
                        )
                      ]
                  ),
                ),
              )
          );
        },
        onStackFinished: () async {
          swipeStateNotifier!.setSwipeState(SwipeState.OKAY);
        },
        leftSwipeAllowed: swipeable,
        rightSwipeAllowed: swipeable,
        fillSpace: true,
      ),
    );
  }

  Future<void> _updateSwipesLeft() async {
    String accessToken = await _secureStorageService.retrieveAccessToken() as String;
    int currentSwipesLeft = await SwipesLeft.updateSwipeLeft(accessToken, widget.userService);

    if (currentSwipesLeft > 0) {
      SharedSwipeableEvent.swipeable.changeSwipeable(true);
      _loadNextUser();
    } else {
      SharedSwipeableEvent.swipeable.changeSwipeable(false);
      swipeStateNotifier!.setSwipeState(SwipeState.NO_SWIPES_LEFT);
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    swipeStateNotifier?.removeListener(_swipeStateListener);
    algoIdNotifier?.removeListener(_algoIdListener);

    _swipeableSubscription?.cancel();

    super.dispose();
  }

}
