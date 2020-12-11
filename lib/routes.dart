import 'package:Prevent/views/incident.dart';
import 'package:Prevent/views/reward.dart';
import 'package:flutter/material.dart';
import 'views/appointment.dart';
import 'views/home.dart';
import 'views/needOutput.dart';
import 'views/productDetails.dart';
import 'views/need.dart';
import 'views/results.dart';
import 'views/signin.dart';
import 'views/signup.dart';
import 'views/chatRoom.dart';
import 'views/search.dart';
import 'views/conversation.dart';
import 'views/splashScreen.dart';
import 'views/account.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case '/splashScreen':
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case '/signIn':
        return MaterialPageRoute(builder: (context) => SignIn());
      case '/signUp':
        return MaterialPageRoute(builder: (context) => SignUp());
      case '/home':
        return MaterialPageRoute(builder: (context) => Home());
      case '/chatRoom':
        return MaterialPageRoute(builder: (context) => ChatRoom());
      case '/search':
        return MaterialPageRoute(builder: (context) => Search());
      case '/conversation':
        return MaterialPageRoute(
            builder: (context) => Conversation(chatRoom: arguments));
      case '/account':
        return MaterialPageRoute(builder: (context) => Account());
      case '/results':
        return MaterialPageRoute(builder: (context) => Results());
      case '/productDetails':
        return MaterialPageRoute(builder: (context) => ProductDetails());
      case '/appointment':
        return MaterialPageRoute(builder: (context) => Appointment());
      case '/need':
        return MaterialPageRoute(builder: (context) => Need());
      case '/needOutput':
        return MaterialPageRoute(builder: (context) => NeedOutput());
      case '/reward':
        return MaterialPageRoute(builder: (context) => RewardDetailsPage());
      case '/incident':
        return MaterialPageRoute(builder: (context) => IncidentDetailsPage());

      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                body: Center(child: Text('Erreur 404 : Page Introuvable'))));
    }
  }
}
