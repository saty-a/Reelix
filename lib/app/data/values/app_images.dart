class AppImages {
  AppImages._privateConstructor();

  static const onBoardingBackground =
      "assets/images/on_boarding_background.jpg";

  static const List<String> profilePics = [
    'assets/images/Ellipse 1.png',
    'assets/images/Ellipse 2.png',
    'assets/images/Ellipse 3.png',
    'assets/images/Ellipse 4.png',
    'assets/images/Ellipse 5.png',
    'assets/images/Ellipse 6.png',
    'assets/images/Ellipse 7.png',
    'assets/images/Ellipse 8.png',
    'assets/images/Ellipse 9.png',
    'assets/images/Ellipse 10.png',
    'assets/images/Ellipse 11.png',
    'assets/images/Ellipse 12.png',
    'assets/images/Ellipse 13.png',
    'assets/images/Ellipse 14.png',
    'assets/images/Ellipse 15.png',
    'assets/images/Ellipse 16.png',
    'assets/images/Ellipse 17.png',
    'assets/images/Ellipse 18.png',
    'assets/images/Ellipse 19.png',
    'assets/images/Ellipse 20.png',
    'assets/images/Ellipse 21.png',
    'assets/images/Ellipse 22.png',
    'assets/images/Ellipse 23.png',
    'assets/images/Ellipse 24.png',
    'assets/images/Ellipse 25.png',
    'assets/images/Ellipse 26.png',
    'assets/images/Ellipse 27.png',
    'assets/images/Ellipse 28.png',
    'assets/images/Ellipse 29.png',
    'assets/images/Ellipse 30.png',
    'assets/images/Ellipse 31.png',
    'assets/images/Ellipse 32.png',
  ];

  static String getProfilePic(int index) {
    return profilePics[index % profilePics.length];
  }
}
