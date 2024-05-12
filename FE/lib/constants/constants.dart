import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IntroDataDef {
  String title = '';
  String body = '';
  String imageUrl = '';

  IntroDataDef(
      {required this.title, required this.body, required this.imageUrl});
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

const String ipv4 = '192.168.1.103';

class ListItem {
  final String title;
  final IconData icon;
  final String tag;

  ListItem({required this.title, required this.icon, required this.tag});
}

final List<ListItem> topicTagItems = [
  ListItem(title: "Other", icon: FontAwesomeIcons.question, tag: 'tag_20'),
  ListItem(title: "Travel", icon: FontAwesomeIcons.bus, tag: 'tag_1'),
  ListItem(title: "Vegetables", icon: FontAwesomeIcons.carrot, tag: 'tag_2'),
  ListItem(title: "Fruits", icon: FontAwesomeIcons.apple, tag: 'tag_3'),
  ListItem(title: "Technology", icon: FontAwesomeIcons.laptop, tag: 'tag_4'),
  ListItem(title: "Sports", icon: FontAwesomeIcons.football, tag: 'tag_5'),
  ListItem(title: "Music", icon: FontAwesomeIcons.music, tag: 'tag_6'),
  ListItem(
      title: "Art and Culture",
      icon: FontAwesomeIcons.paintbrush,
      tag: 'tag_7'),
  ListItem(
      title: "Education", icon: FontAwesomeIcons.graduationCap, tag: 'tag_8'),
  ListItem(
      title: "Health and Wellness",
      icon: FontAwesomeIcons.heartPulse,
      tag: 'tag_9'),
  ListItem(title: "Environment", icon: FontAwesomeIcons.leaf, tag: 'tag_10'),
  ListItem(
      title: "Cooking and Cuisine",
      icon: FontAwesomeIcons.utensils,
      tag: 'tag_11'),
  ListItem(title: "History", icon: FontAwesomeIcons.landmark, tag: 'tag_12'),
  ListItem(title: "Science", icon: FontAwesomeIcons.microscope, tag: 'tag_13'),
  ListItem(
      title: "Movies and Entertainment",
      icon: FontAwesomeIcons.film,
      tag: 'tag_14'),
  ListItem(title: "Fashion", icon: FontAwesomeIcons.shirt, tag: 'tag_15'),
  ListItem(
      title: "Economics and Business",
      icon: FontAwesomeIcons.chartBar,
      tag: 'tag_16'),
  ListItem(title: "Politics", icon: FontAwesomeIcons.flag, tag: 'tag_17'),
  ListItem(title: "Literature", icon: FontAwesomeIcons.book, tag: 'tag_18'),
  ListItem(
      title: "Animals and Wildlife", icon: FontAwesomeIcons.paw, tag: 'tag_19'),
];

const double volume = 0.5;
const double pitch = 1.0;
const double rate = 0.5;

List<String> answerLabel = ['A', 'B', 'C', 'D'];
List<Color> answerLabelColor = [const Color(0xffEB5353), const Color(0xffFFC55A), const Color(0xff36AE7C), const Color(0xff187498)];