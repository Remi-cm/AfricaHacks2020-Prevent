import 'package:Prevent/providers/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:ui' as ui;
import 'dart:math' show pi;

import 'package:provider/provider.dart';

final Map<String, BoxDecoration> decoration = {
  'Events': BoxDecoration(color: Colors.white),
  'Rewards': BoxDecoration(color: Colors.white),
  'Incidents': BoxDecoration(color: Color(0x0D212121),
      // backgroundBlendMode: BlendMode.lighten,
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Color(
            0x0D000000,
          ),
          offset: Offset(0, -10),
          blurRadius: 20,
        )
      ]),
};

class MapPage extends StatefulWidget {
  static const String eventsMapRoute = '/events';
  static const String rewardsMapRoute = '/rewards';
  static const String incidentsMapRoute = '/incidents';

  MapPage({
    Key key,
  }) : super(key: key);

  final List<Map<String, Object>> events = [
    {
      'dateTime': DateTime(2019, 6, 15, 19, 30),
      'title': 'Community Conversation',
      'location': 'The Square . Chicago'
    },
    {
      'dateTime': DateTime(2019, 6, 15, 19, 30),
      'title': 'Community Conversation',
      'location': 'The Square . Chicago'
    },
    {
      'dateTime': DateTime(2019, 6, 15, 19, 30),
      'title': 'Community Conversation',
      'location': 'The Square . Chicago'
    },
    {
      'dateTime': DateTime(2019, 6, 15, 19, 30),
      'title': 'Community Conversation',
      'location': 'The Square . Chicago'
    }
  ];

  final List<Map<String, Object>> rewards = [
    {
      'storeName': 'Samuel Etoo',
      'location': 'UB junction, Buea, Cameroon',
      'points': 95,
      'target': 100,
      'claim': 'free meal'
    },
    {
      'storeName': 'Samuel Etoo',
      'location': 'UB junction, Buea, Cameroon',
      'points': 95,
      'target': 100,
      'claim': 'free meal'
    },
    {
      'storeName': 'Samuel Etoo',
      'location': 'UB junction, Buea, Cameroon',
      'points': 95,
      'target': 100,
      'claim': 'free meal'
    },
    {
      'storeName': 'Samuel Etoo',
      'location': 'UB junction, Buea, Cameroon',
      'points': 95,
      'target': 100,
      'claim': 'free meal'
    },
  ];

  final List<Map<String, Object>> incidents = [
    {
      'dateTime': DateTime(2020, 12, 5, 16, 49),
      'type': 'Riot on going',
      'location': 'Ave Dirty South, Molyko, Buea',
      'confirmations': 3
    },
    {
      'dateTime': DateTime(2020, 12, 5, 16, 49),
      'type': 'Loud Music',
      'location': 'Ave UB Junction, Molyko, Buea',
      'confirmations': 5
    },
    {
      'dateTime': DateTime(2020, 12, 5, 16, 49),
      'type': 'Drug Spot',
      'location': 'Ave TKC, Biyem-Assi, Yaoundé',
      'confirmations': 7
    },
    {
      'dateTime': DateTime(2020, 12, 5, 16, 49),
      'type': 'Gun Shots',
      'location': 'Ave Gabon Bar, Logpom, Douala',
      'confirmations': 9
    },
  ];

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool isInitialized = false;

  GoogleMapController mapController;
  Location _location = Location();
  String darkMap;
  final _kInitialCameraPosition = CameraPosition(
    target: const LatLng(4.1489, 9.2879),
    zoom: 20.0,
  );
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _location.onLocationChanged.listen((l) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15)));
    });
    rootBundle
        .loadString('assets/json/dark_map.json')
        .then((json) => darkMap = json);
    final themeProvider = Provider.of<ThemeModel>(context);
    if (themeProvider.mode == ThemeMode.dark) {
      mapController.setMapStyle(darkMap);
    } else {
      mapController.setMapStyle('[]');
    }
  }

  String title;
  List<String> places = ['Chicago, 11th District'];
  String location;
  Widget listItemBuilder(BuildContext context, int index) {
    List<String> imagePaths = ['christina', 'jeanne', 'mary'];

    final Map<String, dynamic> item = title == 'Events'
        ? widget.events[index]
        : title == 'Rewards'
            ? widget.rewards[index]
            : title == 'Incidents'
                ? widget.incidents[index]
                : null;

    Widget rewardEventFooter = Row(
      children: [
        SizedBox(
          width: 64,
          height: 28,
          child: Stack(
            children: [
              ...imagePaths.reversed.map(
                (path) => Positioned(
                  left: imagePaths.indexOf(path) * 16.0,
                  top: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 1,
                      ),
                      image: DecorationImage(
                        image: AssetImage("assets/images/$path.png"),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xffeaecef),
                          blurRadius: 1,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 4),
        RichText(
          text: TextSpan(
            text: 'Christina & Jean',
            style: TextStyle(
              fontSize: 11,
              fontFamily: "Avenir Next LT Pro",
              fontWeight: FontWeight.w600,
            ),
            children: <TextSpan>[
              TextSpan(
                text: title == 'Events'
                    ? ' are going'
                    : title == 'Rewards'
                        ? ' visited'
                        : null,
                style: TextStyle(),
              ),
            ],
          ),
        )
      ],
    );

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          switch (title) {
            case 'Events':
              Navigator.pushNamed(
                context,
                '/event',
              );
              break;
            case 'Rewards':
              Navigator.pushNamed(
                context,
                '/reward',
              );
              break;
            case 'Incidents':
              Navigator.pushNamed(
                context,
                '/incident',
              );
              break;
            default:
              break;
          }
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title == 'Events'
                              ? DateFormat('EEE, MMM d   h:mm a')
                                  .format(item['dateTime'])
                              : title == 'Rewards'
                                  ? '${item['points']} points, ${item['target'] - item['points']} points till ${item['claim']}'
                                  : title == 'Incidents'
                                      ? DateFormat('MMMM d, yyyy h:mm a')
                                          .format(item['dateTime'])
                                      : null,
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: "Avenir Next LT Pro",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          title == 'Events'
                              ? item['title']
                              : title == 'Rewards'
                                  ? item['storeName']
                                  : title == 'Incidents'
                                      ? item['type']
                                      : null,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Avenir Next LT Pro",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          item['location'],
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Avenir Next LT Pro",
                          ),
                        ),
                        SizedBox(height: 16),
                        title != 'Incidents'
                            ? rewardEventFooter
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${item['confirmations']} Confirmed",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: "Avenir Next LT Pro",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  TextButton(
                                    child: Text(
                                      "Confirm",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: "Avenir Next LT Pro",
                                        foreground: Paint()
                                          ..shader = ui.Gradient.linear(
                                            Offset.fromDirection(-0.25 * pi),
                                            Offset.fromDirection(0.75 * pi),
                                            <Color>[
                                              const Color(0xFF8B34A9),
                                              const Color(0xFFF63669),
                                            ],
                                          ),
                                      ),
                                    ),
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size(48, 20),
                                    ),
                                  )
                                ],
                              )
                      ],
                    ),
                  ),
                  Container(
                    height: 88,
                    width: 88,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/picture.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: title == 'Rewards'
                        ? Text(
                            "${item['points']}",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 32,
                              fontFamily: "Avenir Next LT Pro",
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.73,
                            ),
                          )
                        : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    title = 'Incidents';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeModel>(context);
    if (mapController != null) {
      if (themeProvider.mode == ThemeMode.dark) {
        mapController.setMapStyle(darkMap);
      } else {
        mapController.setMapStyle('[]');
      }
    }
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: _kInitialCameraPosition,
          myLocationEnabled: true,
        ),
        Positioned(
          top: 108,
          left: 28,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.4)),
                    child: Material(
                      type: MaterialType.transparency,
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(24),
                      child: IconButton(
                        icon: Icon(MdiIcons.chatOutline,
                            color: Theme.of(context).primaryColor),
                        onPressed: () {},
                        padding: EdgeInsets.all(10),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        constraints:
                            BoxConstraints(maxHeight: 44, maxWidth: 44),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ClipOval(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.4)),
                    child: Material(
                      type: MaterialType.transparency,
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(24),
                      child: IconButton(
                        icon: Icon(MdiIcons.accountMultipleOutline,
                            color: Theme.of(context).primaryColor),
                        onPressed: () {},
                        padding: EdgeInsets.all(10),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        constraints:
                            BoxConstraints(maxHeight: 44, maxWidth: 44),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              /*ClipOval(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.4)),
                    child: Material(
                      type: MaterialType.transparency,
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(24),
                      child: IconButton(
                        icon: Icon(MdiIcons.accountMultipleOutline, 
                          color: Theme.of(context).primaryColor),
                        onPressed: () {},
                        padding: EdgeInsets.all(10),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        constraints:
                            BoxConstraints(maxHeight: 44, maxWidth: 44),
                      ),
                    ),
                  ),
                ),
              ),*/
            ],
          ),
        ),
        DraggableScrollableSheet(
          minChildSize: 0.15,
          maxChildSize: 0.75,
          builder: (BuildContext context, ScrollController scrollController) {
            return ClipRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.4)),
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: LimitedBox(
                        maxHeight: constraints.maxHeight,
                        child: Column(
                          children: [
                            Container(
                              height: 96,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: Color(0x1A000000),
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 44,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color: themeProvider.mode ==
                                                ThemeMode.light
                                            ? Colors.black38
                                            : Color(0x80d8d8d8),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 18),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              title,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontFamily:
                                                    "Avenir Next LT Pro",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'in  ',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                    value: location,
                                                    items: places
                                                        .map<
                                                                DropdownMenuItem<
                                                                    String>>(
                                                            (String item) =>
                                                                DropdownMenuItem<
                                                                    String>(
                                                                  value: item,
                                                                  child: Text(
                                                                      item),
                                                                ))
                                                        .toSet()
                                                        .toList(),
                                                    onChanged:
                                                        (String newValue) {
                                                      setState(() {
                                                        location = newValue;
                                                      });
                                                    },
                                                    style: TextStyle(
                                                      color: themeProvider
                                                                  .mode ==
                                                              ThemeMode.light
                                                          ? Colors.black54
                                                          : Colors.white70,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    iconSize: 20,
                                                    isDense: true,
                                                    icon: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 6),
                                                      child: Icon(
                                                        Icons.arrow_drop_down,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 4),
                                        child: IconButton(
                                          icon: Icon(Icons.add_rounded),
                                          iconSize: 32,
                                          splashRadius: 20,
                                          padding: EdgeInsets.zero,
                                          onPressed: () {},
                                          constraints: BoxConstraints(
                                            maxHeight: 32,
                                            maxWidth: 32,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.only(bottom: 48),
                                itemCount: title == 'Events'
                                    ? widget.events.length
                                    : title == 'Rewards'
                                        ? widget.rewards.length
                                        : title == 'Incidents'
                                            ? widget.incidents.length
                                            : 0,
                                itemBuilder: listItemBuilder,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.4)),
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/images/christina.png"),
                                fit: BoxFit.cover,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xffeaecef),
                                  blurRadius: 1,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: title,
                              items: <String>[
                                /*'Events', */ 'Rewards',
                                'Incidents'
                              ]
                                  .map<DropdownMenuItem<String>>(
                                      (String item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: TextStyle(
                                                  color: themeProvider.mode ==
                                                          ThemeMode.light
                                                      ? Colors.black54
                                                      : Colors.white70),
                                            ),
                                          ))
                                  .toList(),
                              onChanged: (String newValue) {
                                setState(() {
                                  title = newValue;
                                  if (themeProvider.mode == ThemeMode.dark) {
                                    mapController.setMapStyle(darkMap);
                                  } else {
                                    mapController.setMapStyle('[]');
                                  }
                                });
                              },
                              iconSize: 20,
                              isDense: true,
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Avenir Next LT Pro",
                                fontWeight: FontWeight.w600,
                              ),
                              icon: Container(
                                margin: EdgeInsets.only(left: 6),
                                child: Icon(
                                  Icons.arrow_drop_down,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 24,
          right: 20,
          child: ClipOval(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.4)),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                  iconSize: 28,
                  splashRadius: 22,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
