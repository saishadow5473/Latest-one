import '../../data/model/get_spec_class_list.dart';

class SearchAnimationState{
  String searchString;
  SearchAnimationState( {this.searchString});
}

class SelectSpecState{}

class UpdateSelectSpecState extends SelectSpecState{
  String selectedSpeCurrent;
  List<SpecialityClassList> classList;
  UpdateSelectSpecState({this.selectedSpeCurrent,this.classList});
}