import 'package:stacked/stacked.dart';

class IntroViewModel extends BaseViewModel{

  final List<String> _images = [
    // AppImage.intro_slider1,
    // AppImage.intro_slider2,
    // AppImage.intro_slider3
  ];

  int _currentPage = 0;
  final List<String> _infoList = [
    "Follow up call and check up *meet reminder*",
    "*Never miss* a follow up call",
    "*Never miss* a check up meet"
  ];

  List<String> get images => _images;
  List<String> get infoList => _infoList;
  int get currentPage => _currentPage;

  onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }
}