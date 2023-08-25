part of 'promo_bloc.dart';


class PromoState extends Equatable {
  final List<PromoModel>  listPromo;
  final RequestStatus status;
  final bool updateProgress;


  const PromoState({
    this.listPromo = const [],
    this.status = RequestStatus.loading,
    this.updateProgress = false,
  });

  PromoState copyWith({
    List<PromoModel>? listPromo,
    RequestStatus? status,
    bool updateProgress = false,
  }) {
    return PromoState(
      listPromo: listPromo ?? this.listPromo,
      status: status ?? this.status,
      updateProgress: updateProgress,
    );
  }

  @override
  List<Object?> get props => [
    listPromo,
    status,
    updateProgress
  ];
}

