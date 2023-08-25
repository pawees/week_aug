// import '../../../data/repositories/promo_screen_request/models/promo_model.dart';
// import '../../../data/repositories/promo_screen_request/promo_repository.dart';
//
// // Сервис экрана с акциями
// class PromoScreenService{
//   final PromoScreenRequest promoScreenRequest = PromoScreenRequest();
//
//   // Список акций
//   var _promoList = const <PromoModel>[];
//   List<PromoModel> get promoList => List.unmodifiable(_promoList);
//
//   // Парметр sendRequest нужен чтобы различать кто делает запрос
//   Future<void> getListPromoMethod(int count, bool sendRequest) async {
//     /*
//      Проверка перед запросм, если список акций не пустой и
//      параметр sendRequest == true то не делаем запрос, а акции
//      на экране отображаются из уже существующего списка
//      */
//     if(_promoList.isNotEmpty && sendRequest == false) return;
//     final result = await promoScreenRequest.getPromo(count: count);
//     _promoList = result;
//   }
//
// }