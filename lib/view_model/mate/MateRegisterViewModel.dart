import 'package:fitmate_app/error/CustomException.dart';
import 'package:fitmate_app/model/mate/Mate.dart';
import 'package:fitmate_app/view_model/BaseViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mateRegisterViewModelProvider =
    NotifierProvider<MateRegisterViewModel, Mate>(
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

  void setMateAtDate(DateTime date) {
    final selectDate = date;
    final defaultTime = TimeOfDay(hour: 18, minute: 0);
    final selectDateTime = DateTime(selectDate.year, selectDate.month,
        selectDate.day, defaultTime.hour, defaultTime.minute);
    state = state.copyWith(mateAt: selectDateTime);
  }

  void setMateAtTime(TimeOfDay time) {
    final orgDate = state.mateAt;
    final selectTime = time;
    final selectDateTime = DateTime(orgDate!.year, orgDate.month, orgDate.day,
        selectTime.hour, selectTime.minute);
    state = state.copyWith(mateAt: selectDateTime);
  }

  void addMateFee(MateFee mateFee) {
    _validateMateFeeName(mateFee.name);
    state = state.copyWith(mateFees: [...state.mateFees, mateFee]);
  }

  void _validateMateFeeName(String value) {
    String pattern = r'^[가-힣]{2,15}$';
    RegExp nameRegex = RegExp(pattern);
    if ((!nameRegex.hasMatch(value)))
      throw CustomException(
        domain: ErrorDomain.MATE,
        type: ErrorType.INVALID_INPUT,
        msg: '참가비 종류는 2~15자의 한글로 입력해야 합니다.',
      );
  }
}