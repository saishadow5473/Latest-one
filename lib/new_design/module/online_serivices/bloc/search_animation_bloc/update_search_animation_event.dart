class SearchAnimationEvent{}

class UpdateSearchAnimationEvent extends SearchAnimationEvent{
  String updatedSearchString;
  UpdateSearchAnimationEvent({this.updatedSearchString});
}

class SelectSpecEvent{

}

class UpdatedSpecSelectedEvent extends SelectSpecEvent{
  String selectedString;
  String selectedAffi;
  UpdatedSpecSelectedEvent({this.selectedString,this.selectedAffi});
}