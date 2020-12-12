import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'dart:math' show pi;

import '../models/reward.dart';
import 'components/details_screen.dart';

class RewardDetailsPage extends StatelessWidget {
  RewardDetailsPage({Key key})
      : super(key: key);

  final List<Reward> visits = <Reward>[
    Reward(DateTime(2020, 11, 6), 85, 100, 'free meal'),
    Reward(DateTime(2020, 11, 6), 90, 100, 'free t shirt'),
  ];

  Widget _buildVisit(Reward visit) {
    final EdgeInsets padding = identical(visit, visits.last)
        ? EdgeInsets.only(left: 8, right: 8, bottom: 10)
        : EdgeInsets.symmetric(horizontal: 8, vertical: 10);

    final String dateString = DateFormat("d/MM/yy").format(visit.date);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.2,
            color: Color(0x0D000000),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Visited on $dateString",
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: "Avenir Next LT Pro",
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "${visit.target - visit.points} points till ${visit.claim}",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Avenir Next LT Pro",
                ),
              ),
            ],
          ),
          Builder(
            builder: (BuildContext context) {
              return Text(
                "${visit.points}",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: "Avenir Next LT Pro",
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.73,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DetailsScreen(
      title: 'Reward',
      statusMessage: "You're eligeable for reward",
      numLikes: 369,
      liked: false,
      name: 'Samuel Etoo',
      location: 'UB junction, Buea, Cameroon',
      phone: '+237 685 425 965',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [...visits.reversed.map(_buildVisit)],
      ),
    );
  }
}

