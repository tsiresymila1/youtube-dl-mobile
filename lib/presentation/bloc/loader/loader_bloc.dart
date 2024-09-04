import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'loader_event.dart';
part 'loader_state.dart';

class LoaderBloc extends Bloc<LoaderEvent, LoaderState> {
  LoaderBloc() : super(LoaderStateStop()) {
    on<LoaderEventLoading>((event, emit) {
      emit(LoaderStateLoading());
    });
    on<LoaderEventStop>((event, emit) {
      emit(LoaderStateStop());
    });
  }
}
