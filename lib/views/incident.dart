import 'package:flutter/material.dart';

import 'components/details_screen.dart';

class IncidentDetailsPage extends StatelessWidget {
  const IncidentDetailsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DetailsScreen(
      title: 'Incident',
      statusMessage: "You've confirmed anonymously",
      numLikes: 369,
      liked: false,
      name: 'Riot Ongoing',
      location: 'Virtual',
      dateTime: 'Sat, Jun 15  |  7:30 - 9:00 pm',
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          "This is the <drug spot> description. At this spot, I see a group of people at the same spot and saw a drug transaction on two occassions.",
          style: TextStyle(
            fontSize: 13,
            fontFamily: "Avenir Next LT Pro",
          ),
        ),
      ),
    );
  }
}
