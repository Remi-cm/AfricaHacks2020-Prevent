import 'package:intl/intl.dart';

class Algorithms {
  String getOtherIdFromList({List list, String val}) {
    if (list[0] == val) {
      return list[1];
    } else {
      return list[0];
    }
  }

  List getKeyWords(String input) {
    List getKeys(String input) {
      var keyWords = new List(input.length);
      for (int i = 0; i < input.length; i++) {
        keyWords[i] = input.substring(0, i + 1).toLowerCase();
      }
      return keyWords;
    }

    List getKeysReversed(String input) {
      var keyWords = new List(input.length);
      for (int i = 0; i < input.length; i++) {
        keyWords[i] =
            input.substring(0, i + 1).toLowerCase().split('').reversed.join('');
      }
      return keyWords;
    }

    var results = [];
    String inputReversed = input.split('').reversed.join('');
    var words = input.toLowerCase().split(new RegExp('\\s+'));
    var wordsReversed = inputReversed.toLowerCase().split(new RegExp('\\s+'));

    for (int i = 0; i < words.length; i++) {
      results = results + getKeys(words[i]);
    }
    for (int i = 0; i < words.length; i++) {
      results = results + getKeysReversed(wordsReversed[i]);
    }

    results = results + getKeys(input);
    results = results.toSet().toList();

    return results;
  }

  String getConversationId({String userId, String targetId}) {
    
    String conversationId;
    if (userId.hashCode <= targetId.hashCode) {
      conversationId = "$userId-$targetId";
    } else {
      conversationId = "$targetId-$userId";
    }
    return conversationId;
  }

  String getDateFromTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm a');
    var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + 'DAY AGO';
      } else {
        time = diff.inDays.toString() + 'DAYS AGO';
      }
    }

    return time;
  }

}
