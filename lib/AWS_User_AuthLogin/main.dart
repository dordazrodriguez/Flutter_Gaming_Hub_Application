import 'dart:async';
import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:epic_games_ui/AWS_User_AuthLogin/screens/home_screen.dart';
import 'package:epic_games_ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Counter {
  int count;
  Counter(this.count);

  factory Counter.fromJson(json) {
    return Counter(json['count']);
  }
}

class CounterService {
  AwsSigV4Client awsSigV4Client;
  CounterService(this.awsSigV4Client);

  /// Retrieve user's previous count from Lambda + DynamoDB
  Future<Counter> getCounter() async {
    final signedRequest =
        SigV4Request(awsSigV4Client, method: 'GET', path: '/counter');
    final response =
        await http.get(signedRequest.url, headers: signedRequest.headers);
    return Counter.fromJson(json.decode(response.body));
  }

  /// Increment user's count in DynamoDB
  Future<Counter> incrementCounter() async {
    final signedRequest =
        SigV4Request(awsSigV4Client, method: 'PUT', path: '/counter');
    final response =
        await http.put(signedRequest.url, headers: signedRequest.headers);
    return Counter.fromJson(json.decode(response.body));
  }
}

//void main() => runApp(SecureCounterApp());
/*
class SecureCounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cognito on Flutter',
      home: AuthPage(title: 'Cognito on Flutter'),
    );
  }
}
*/