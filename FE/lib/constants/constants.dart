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
    imageUrl: 'assets/images/intro/intro.png',
  ),
  IntroDataDef(
    title: 'title_intro_2',
    body: 'body_intro_2',
    imageUrl: 'assets/images/intro/intro.png',
  ),
  IntroDataDef(
    title: 'title_intro_3',
    body: 'body_intro_3',
    imageUrl: 'assets/images/intro/intro.png',
  ),
];

final List<String> iconList = [
  'assets/icon/facebook.svg',
  'assets/icon/apple.svg',
  'assets/icon/google.svg',
];