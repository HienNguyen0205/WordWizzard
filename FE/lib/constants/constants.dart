import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IntroDataDef {
  String title = '';
  String body = '';
  String imageUrl = '';

  IntroDataDef({required this.title, required this.body, required this.imageUrl});
}

final List<IntroDataDef> introData = [
  IntroDataDef(
    title: 'title_intro_1',
    body: 'body_intro_1',
    imageUrl: 'assets/images/intro/studying.svg',
  ),
  IntroDataDef(
    title: 'title_intro_2',
    body: 'body_intro_2',
    imageUrl: 'assets/images/intro/research_paper.svg',
  ),
  IntroDataDef(
    title: 'title_intro_3',
    body: 'body_intro_3',
    imageUrl: 'assets/images/intro/online_test.svg',
  ),
];

final List<String> iconList = [
  'assets/icon/facebook.svg',
  'assets/icon/apple.svg',
  'assets/icon/google.svg',
];

const String ipv4 = '192.168.1.104';

class ListItem {
  final String title;
  final IconData icon;

  ListItem({required this.title, required this.icon});
}

final List<ListItem> topicTagItems = [
  ListItem(title: "Vegetables", icon: FontAwesomeIcons.carrot),
  ListItem(title: "Fruits", icon: FontAwesomeIcons.apple),
  ListItem(title: "Technology", icon: FontAwesomeIcons.laptop),
  ListItem(title: "Sports", icon: FontAwesomeIcons.football),
  ListItem(title: "Music", icon: FontAwesomeIcons.music),
  ListItem(title: "Art and Culture", icon: FontAwesomeIcons.paintbrush),
  ListItem(title: "Education", icon: FontAwesomeIcons.graduationCap),
  ListItem(title: "Health and Wellness", icon: FontAwesomeIcons.heartPulse),
  ListItem(title: "Environment", icon: FontAwesomeIcons.leaf),
  ListItem(title: "Cooking and Cuisine", icon: FontAwesomeIcons.utensils),
  ListItem(title: "History", icon: FontAwesomeIcons.landmark),
  ListItem(title: "Science", icon: FontAwesomeIcons.microscope),
  ListItem(title: "Movies and Entertainment", icon: FontAwesomeIcons.film),
  ListItem(title: "Fashion", icon: FontAwesomeIcons.shirt),
  ListItem(title: "Economics and Business", icon: FontAwesomeIcons.chartBar),
  ListItem(title: "Politics", icon: FontAwesomeIcons.flag),
  ListItem(title: "Literature", icon: FontAwesomeIcons.book),
  ListItem(title: "Animals and Wildlife", icon: FontAwesomeIcons.paw),
  ListItem(title: "Travel and Transportation", icon: FontAwesomeIcons.bus),
];
