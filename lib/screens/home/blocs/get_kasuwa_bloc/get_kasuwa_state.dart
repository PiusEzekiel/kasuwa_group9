part of 'get_kasuwa_bloc.dart';

abstract class GetKasuwaState extends Equatable {
  const GetKasuwaState();

  @override
  List<Object> get props => [];
}

class GetKasuwaInitial extends GetKasuwaState {}

class GetKasuwaLoading extends GetKasuwaState {}

class GetKasuwaSuccess extends GetKasuwaState {
  final List<Kasuwa> kasuwas;

  const GetKasuwaSuccess({required this.kasuwas});

  @override
  List<Object> get props => [kasuwas];
  // Add the getter
  List<Kasuwa> get kasuwa => kasuwas;
}

class GetKasuwaFailure extends GetKasuwaState {
  final String errorMessage;

  const GetKasuwaFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
