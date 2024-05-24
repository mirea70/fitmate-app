import 'package:fitmate_app/model/mate/Mate.dart';
import 'package:fitmate_app/view_model/BaseViewModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mateRegisterViewModelProvider = NotifierProvider<MateRegisterViewModel, Mate>(
    () => MateRegisterViewModel());

class MateRegisterViewModel extends Notifier<Mate> implements BaseViewModel {
  @override
  Mate build() {
    return Mate.initial();
  }

  @override
  void reset() {
    state = Mate.initial();
  }

  void setFitCategory(FitCategory value) {
    state = state.copyWith(fitCategory: value);
  }

  void setPlace(String name, String address) {
    state = state.copyWith(fitPlaceName: name, fitPlaceAddress: address);
  }

  void setTitle(String value) {
    state = state.copyWith(title: value);
  }

  void setIntroduction(String value) {
    state = state.copyWith(introduction: value);
  }
}