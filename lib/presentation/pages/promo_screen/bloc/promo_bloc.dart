import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../data/repositories/promo_repository/models/promo_model.dart';
import '../../../../data/repositories/promo_repository/promo_repository.dart';
import '../../../../services/service_locator.dart';
import '../../../../utils/enums.dart';
import '../promo_screen_service.dart';

part 'promo_event.dart';
part 'promo_state.dart';


class PromoBloc extends Bloc<PromoEvent, PromoState> {
  PromoBloc({required PromoRepository promoRepository}) : _promoRepository = promoRepository,
        super(const PromoState()) {
    on<GetListPromoEvent>(_getPromo);
  }
  final PromoRepository _promoRepository;

  Future<void> _getPromo(
      GetListPromoEvent event, Emitter<PromoState> emit) async {
    if(_promoRepository.promoList.isNotEmpty){
      try {
        emit(state.copyWith(
          status: RequestStatus.loaded,
          listPromo: _promoRepository.promoList,
        updateProgress: true),);
        await _promoRepository.getListPromoMethod(event.count, event.sendRequest);
      } catch (e) {
        print('Error $e');
      } finally {
        emit(state.copyWith(
          status: RequestStatus.loaded,
          listPromo: _promoRepository.promoList,),);
      }
    } else {
      emit(state.copyWith(
        status: RequestStatus.loading),);
      try {
        await _promoRepository.getListPromoMethod(event.count, event.sendRequest);
        emit(state.copyWith(
          status: RequestStatus.loaded,
          listPromo: _promoRepository.promoList,),);
      }  catch (e) {
        print('Error $e');
        emit(
          state.copyWith(
            status: RequestStatus.error,
          ),
        );
      }
    }
  }
}
