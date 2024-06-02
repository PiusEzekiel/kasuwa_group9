part of 'get_kasuwa_bloc.dart';

sealed class GetKasuwaState extends Equatable {
  const GetKasuwaState();

  @override
  List<Object> get props => [];
}

final class GetKasuwaInitial extends GetKasuwaState {}

final class GetKasuwaFailure extends GetKasuwaState {}

final class GetKasuwaLoading extends GetKasuwaState {}

final class GetKasuwaSuccess extends GetKasuwaState {
  final List<Kasuwa> kasuwas;

  const GetKasuwaSuccess(this.kasuwas);

  @override
  List<Object> get props => [kasuwas];
}
