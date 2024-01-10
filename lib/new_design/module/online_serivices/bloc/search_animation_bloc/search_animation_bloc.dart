import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../constants/spKeys.dart';
import '../../data/model/get_spec_class_list.dart';
import '../../data/repositories/online_services_api.dart';
import '../../functionalities/online_services_dashboard_functionalities.dart';
import 'update_search_animation_event.dart';
import 'update_search_animation_state.dart';

// Event
abstract class SearchAnimationEvent {}

class UpdateSearchValue extends SearchAnimationEvent {
  final int value;

  UpdateSearchValue(this.value);
}

// State
class SearchAnimationState {
  final int value;

  SearchAnimationState(this.value);
}

// Bloc
class SearchAnimationBloc extends Bloc<SearchAnimationEvent, SearchAnimationState> {
  SearchAnimationBloc() : super(SearchAnimationState(null));

  @override
  Stream<SearchAnimationState> mapEventToState(SearchAnimationEvent event) async* {
    if (event is UpdateSearchValue) {
      yield (SearchAnimationState(event.value));
    }
  }
}

class SelectSpecialityBloc extends Bloc<SelectSpecEvent, SelectSpecState> {
  SelectSpecialityBloc() : super(SelectSpecState()) {
    on<SelectSpecEvent>(mapEventToState);
  }
  final OnlineServicesApiCall onlineServicesApiCall = OnlineServicesApiCall();
  final OnlineServicesFunctions onlineServicesFunctions = OnlineServicesFunctions();
  GetSpecClassList classList;
  void mapEventToState(SelectSpecEvent event, Emitter<SelectSpecState> emit) async {
    if (event is UpdatedSpecSelectedEvent) {
      classList = await getClassList(spec: event.selectedString);
      String selectedAffi =event.selectedAffi;
      classList.specialityClassList.removeWhere((SpecialityClassList element) {
        var tempAffiLits=[];
        element.affilationExcusiveData.affilationArray.forEach((AffilationArray ele2) {
          tempAffiLits.add(ele2.affilationUniqueName);
      });
        print((!tempAffiLits.contains(selectedAffi))&&element.exclusiveOnly==true);
       return (!tempAffiLits.contains(selectedAffi))&&element.exclusiveOnly==true;
      });
      print(classList);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        var data = prefs.get(SPKeys.userDetailsResponse);
        Map teleConsulResponse = json.decode(data);
        List subscriptionHistoryList = teleConsulResponse["my_subscriptions"];
        List<SpecialityClassList> filtredClassList =
            onlineServicesFunctions.filterExpiredClass(classList);
        filtredClassList.removeWhere((SpecialityClassList element) => subscriptionHistoryList.any(
            (historyElement) =>
                element.courseId == historyElement["course_id"] &&
                (historyElement["approval_status"] == "Accepted" ||
                    historyElement["approval_status"] == "Requested")));
        emit(UpdateSelectSpecState(
            selectedSpeCurrent: event.selectedString, classList: filtredClassList));
      } catch (e) {
        await onlineServicesApiCall.updateUserDetails();
        var data = prefs.get(SPKeys.userDetailsResponse);
        Map teleConsulResponse = json.decode(data);
        List subscriptionHistoryList = teleConsulResponse["my_subscriptions"];
        List<SpecialityClassList> filtredClassList =
            onlineServicesFunctions.filterExpiredClass(classList);
        filtredClassList.removeWhere((SpecialityClassList element) => subscriptionHistoryList.any(
            (historyElement) =>
                element.courseId == historyElement["course_id"] &&
                (historyElement["approval_status"] == "Accepted" ||
                    historyElement["approval_status"] == "Requested")));
        emit(UpdateSelectSpecState(
            selectedSpeCurrent: event.selectedString, classList: filtredClassList));
      }
    }
  }

  getClassList({String spec}) async {
    return await onlineServicesApiCall.getSpecClassList(spec: spec);
  }
}
