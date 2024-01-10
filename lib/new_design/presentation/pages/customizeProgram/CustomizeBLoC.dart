import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/providers/network/apis/selectedProgramApi.dart';
import 'customizeProgramEvnet.dart';
import 'customizeProgramState.dart';
import 'selectedProgramDashboard.dart';

class SelectedProgramBloc extends Bloc<ProgramEvent, SelectedprogramState> {
  final List<String> fetchedPrograms;

  final Map storeData;
  SelectedProgramBloc({this.fetchedPrograms, this.storeData})
      : super(SelectedprogramState(programSelected: fetchedPrograms, storeData: storeData)) {
    on<ProgramEvent>(mapEventToState);
  }
  String selectedProgram = " ";
  Map<String, List> availPrograms = {
    "Manage Health": [],
    "Online Services": [],
    "Health Program": [],
    "Social": []
  };
  List programSelected = [];

  void mapEventToState(ProgramEvent event, Emitter<SelectedprogramState> emit) async {
    programSelected = fetchedPrograms ?? [];
    storeData.forEach((key, value) {
      availPrograms[key] = value;
    });

    if (event is SelectProgramEvent) {
      selectedProgram = event.selecetedProgram;
      if (event.subPrograms != null) {
        programSelected.add(event.subPrograms);
        availPrograms[selectedProgram].add(event.subPrograms);
      }
      /// emiting the state after a program is selected
      emit(getProgram());
    } else if (event is UnSelectProgramEvent) {
      selectedProgram = event.unselecetedProgram;
      programSelected.remove(event.removedSubProgram);
      availPrograms[selectedProgram].remove(event.removedSubProgram);
      if (event.removedSubProgram == null) {
        selectedProgram = "";
      }
      /// emiting the state after a program is unselected
      emit(getProgram());
    }
  }
/// return the map and program lists of selected.
  SelectedprogramState getProgram() {
    return SelectedprogramState(
        selectedProgram: selectedProgram,
        programSelected: programSelected,
        storeData: availPrograms);
  }
}
///bloc for fetching the selected program
class FetchSelectedProgramBloc extends Bloc<DashboardEvent, SelectedDashboardState> {
  final SelectedDashboard _selectedDasboard;
  FetchSelectedProgramBloc(this._selectedDasboard) : super(ProgramLoadingState()) {
    ///initial state
    on<LoadDashboardEvent>((LoadDashboardEvent event, Emitter<SelectedDashboardState> emit) async {
      /// indicating UI that the data is loading
      emit(ProgramLoadingState());
      try {
        ///api call to fetch the selected program
        final GetUserSelectedDashboard dashboardProgram =
            await _selectedDasboard.getSelectedPrograms();
        /// indicating UI that the data is loaded
        emit(ProgramLoadedState(dashboardProgram));
      } catch (e) {
        /// indicating UI that the data is not loaded
        emit(ProgramErrorState(e.toString()));
      }
    });
  }
}
///bloc for the button stages and api call to store data
class ButtonBloc extends Bloc<ButtonEvent, ButtonState> {
  ButtonBloc() : super(ButtonInitialState()) {
    ///initial State
    on<ButtonEvent>((ButtonEvent event, Emitter<ButtonState> emit) async {
      if (event is ButtonPressedEvent) {
        if (event.storeData != null) {
          /// indicating UI that the data is loading
          emit(ButtonLoadingState());
          try {
            /// api call to store the selected program data
            var response = await SelectedDashboard().postSelectedPrograms(event.storeData);
            /// indicating UI that the data is loaded
            emit(ButtonLoadedState(response));
          } catch (e) {
            print(e);
            emit(ButtonErrorState());
          }
        } else {
          emit(ButtonErrorState());
        }
      } else if (event is ButtonWarningEvent) {
        emit(ButtonWarningState());
      }
      // else{
      //   emit(ButtonInitialState(fetchType: "completed"));
      // }
      // emit(ButtonLoadedState("Success"));
    });
  }
}
