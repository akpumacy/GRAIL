import 'package:get/get.dart';

class FilterController extends GetxController {
  final RxInt _selectedFilter = 0.obs;

  int get getSelectedFilter {
    return _selectedFilter.value;
  }

  setSelectedFilter(int newSelectedFilter) {
    _selectedFilter.value = newSelectedFilter;
  }
}
