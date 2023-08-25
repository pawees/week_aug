part of 'promo_bloc.dart';

@immutable
abstract class PromoEvent extends Equatable{
  const PromoEvent();
  @override
  List<Object?> get props => [];
}


class GetListPromoEvent extends PromoEvent {
  final int count;
  final bool sendRequest;

  const GetListPromoEvent(this.count, this.sendRequest);

  @override
  List<Object?> get props => [count, sendRequest];
}