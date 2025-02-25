// Изменения в BranchDetailViewModel (lib/viewmodels/branch_detail_view_model.dart)
import 'package:flutter/cupertino.dart';

import '../model/branch_model.dart';

class BranchDetailViewModel extends ChangeNotifier {
  final Branch branch;
  int currentTabIndex = 0;
  final Set<int> selectedServiceIndices = {};
  final Set<int> selectedPackageIndices = {};
  BranchDetailViewModel(this.branch);
  void changeTab(int index) {
    currentTabIndex = index;
    notifyListeners();
  }
  void toggleServiceSelection(int index) {
    if (selectedServiceIndices.contains(index)) {
      selectedServiceIndices.remove(index);
    } else {
      selectedServiceIndices.add(index);
    }
    notifyListeners();
  }
  void togglePackageSelection(int index) {
    if (selectedPackageIndices.contains(index)) {
      selectedPackageIndices.remove(index);
    } else {
      selectedPackageIndices.add(index);
    }
    notifyListeners();
  }
}
