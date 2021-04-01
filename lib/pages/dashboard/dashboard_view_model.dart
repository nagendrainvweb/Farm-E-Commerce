import 'package:stacked/stacked.dart';

class DashboardViewModel extends BaseViewModel {
  List<String> _bannerList = [
    "https://b.zmtcdn.com/data/pictures/chains/8/48188/09b465b6d54418e8d8d43ff64f04dfc3.jpg",
    "https://b.zmtcdn.com/data/pictures/chains/8/48188/5a2efc061852861b316275c4428e5007.jpg",
    "https://b.zmtcdn.com/data/pictures/chains/8/48188/731e244b54f8e8b4df18379ee6e142d2.jpg"
  ];

  List<String> get bannerList => _bannerList;
  int _currentPostion = 0;
  int get currentPosition => _currentPostion;

  void pageChanged(int index) {
    _currentPostion = index;
    notifyListeners();
  }
}
