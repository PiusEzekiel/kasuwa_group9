import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasuwa_repository/kasuwa_repository.dart';

part 'get_kasuwa_event.dart';
part 'get_kasuwa_state.dart';

class GetKasuwaBloc extends Bloc<GetKasuwaEvent, GetKasuwaState> {
  final KasuwaRepo _kasuwaRepo;

  GetKasuwaBloc(this._kasuwaRepo) : super(GetKasuwaInitial()) {
    on<GetKasuwa>((event, emit) async {
      emit(GetKasuwaLoading());
      try {
        List<Kasuwa> kasuwas = await _kasuwaRepo.getKasuwas();
        emit(GetKasuwaSuccess(kasuwas: kasuwas));
      } catch (e) {
        emit(GetKasuwaFailure(errorMessage: e.toString()));
      }
    });
  }
}
