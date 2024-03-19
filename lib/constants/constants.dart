class IntroDataDef {
  String title = '';
  String body = '';
  String imageUrl = '';

  IntroDataDef({required this.title, required this.body, required this.imageUrl});
}

final List<IntroDataDef> introData = [
  IntroDataDef(
    title: 'Chào mừng bạn đến với ứng dụng WordWizzard',
    body: 'Bắt đầu hành trình nâng cao kỹ năng tiếng Anh của bạn ngay hôm nay',
    imageUrl: 'assets/images/intro/intro.png',
  ),
  IntroDataDef(
    title: 'Khám phá phương pháp học tiếng Anh mới mẻ',
    body: 'Tìm hiểu các phương pháp học tiếng Anh hiệu quả và thú vị',
    imageUrl: 'assets/images/intro/intro.png',
  ),
  IntroDataDef(
    title: 'Kiểm tra trình độ tiếng Anh của bạn',
    body: 'Thử thách trình độ tiếng Anh của bạn với các bài kiểm tra đa dạng',
    imageUrl: 'assets/images/intro/intro.png',
  ),
];