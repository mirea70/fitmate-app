import 'package:fitmate_app/error/CustomException.dart';
import 'package:fitmate_app/model/mate/MateListItem.dart' as mates;
import 'package:fitmate_app/model/mate/MateListRequestModel.dart';
import 'package:fitmate_app/repository/mate/MateRepository.dart';
import 'package:fitmate_app/view_model/BaseViewModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mateListRequestViewModelProvider =
    NotifierProvider<MateListRequestViewModel, MateListRequestModel>(
        () => MateListRequestViewModel());

class MateListRequestViewModel extends Notifier<MateListRequestModel> implements BaseViewModel {
  @override
  MateListRequestModel build() {
    return MateListRequestModel.initial();
  }

  @override
  void reset() {
    state = MateListRequestModel.initial();
  }

  Future<List<mates.MateListItem>> requestFilter({required int page, String? keyword}) {
    return ref.read(mateRepositoryProvider).findAllWithCondition(state, page, keyword);
  }

  void setPermitMinAge(int value) {
    state = state.copyWith(permitMinAge: value);
  }

  void setPermitMaxAge(int value) {
    state = state.copyWith(permitMaxAge: value);
  }

  void setLimitPeopleCnt(int start, int end) {
    state = state.copyWith(startLimitPeopleCnt: start, endLimitPeopleCnt: end);
  }

  void setFitCategory(FitCategory value) {
    state = state.copyWith(fitCategory: value);
  }

  void setDayOfWeek(int value) {
    state = state.copyWith(dayOfWeek: value);
  }

  void setMateAt(DateTime? startAt, DateTime? endAt) {
    if(startAt != null) {
      state = state.copyWith(startMateAt: startAt, endMateAt: endAt);
    }
  }

  void addFitPlaceRegion(String value) {
    if(state.fitPlaceRegions.length >= 3)
      throw CustomException(
          domain: ErrorDomain.MATE,
          type: ErrorType.LIMIT_OVER,
          msg: '지역은 최대 3곳까지 선택 가능합니다.'
      );
    state = state.copyWith(fitPlaceRegions: [...state.fitPlaceRegions, value]);
  }

  void removeFitPlaceRegion(String value) {
    if(state.fitPlaceRegions.length == 0)
      return;
    state = state.copyWith(
      fitPlaceRegions: [
        for (String region in state.fitPlaceRegions)
          if(region != value) region,
      ]
    );
  }

  void removeAndAddFitPlaceRegion(String parentName, String removeItem, String addItem) {
    if(state.fitPlaceRegions.length == 0)
      return;
    state = state.copyWith(
        fitPlaceRegions: [
          for (String region in state.fitPlaceRegions)
            if(region.split(" ")[0] != parentName) region,
          parentName + " " + addItem
        ]
    );
  }

  void removeAllAndAddFitPlaceRegion(String parentName, List<String> removeItems, String addItem) {
    if(state.fitPlaceRegions.length == 0)
      return;
    state = state.copyWith(
        fitPlaceRegions: [
          for (String region in state.fitPlaceRegions)
            if(!removeItems.contains(region.split(" ")[1])) region,
          parentName + " " + addItem
        ]
    );
  }

  void clearFitPlaceRegion() {
    state = state.copyWith(fitPlaceRegions: []);
  }
}