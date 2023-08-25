import '../../method_constants.dart';
import '../request_post_function.dart';
import 'models/promo_model.dart';


class PromoRepository {
  //todo принимает Api

  // Список акций
  var _promoList = const <PromoModel>[];
  List<PromoModel> get promoList => List.unmodifiable(_promoList);

  // Парметр sendRequest нужен чтобы различать кто делает запрос
  Future<void> getListPromoMethod(int count, bool sendRequest) async {
    /*
     Проверка перед запросм, если список акций не пустой и
     параметр sendRequest == true то не делаем запрос, а акции
     на экране отображаются из уже существующего списка
     */
    if(_promoList.isNotEmpty && sendRequest == false) return;
    final result = await getPromo(count: count);
    _promoList = result;
  }

  Future<List<PromoModel>> getPromo({
    required int count,
  }) async {
    final Map<String, dynamic> params = {
      "offset": 0,
      "count": count,
      "city_id": ''};


    /*
    Объявление функции parseJson, принимающей на вход
    динамический объект json и возвращающей список объектов типа NewsModel
     */
    List<PromoModel> parseJson(dynamic json) {
      // приведение объекта json к типу Map<String, dynamic> и сохранение его в переменную jsonMap
      final jsonMap = json as Map<String, dynamic>;
      // создание пустого списка объектов типа NewsModel и сохранение его в переменную listObject
      final listObject = <PromoModel>[];
      // проверка, содержит ли объект jsonMap свойство "result"
      if (jsonMap.containsKey('result')) {
        /*
        извлечение значения свойства "result" и преобразование его в
        список объектов типа NewsModel с помощью метода from() класса List
         */
        final resultJson = List<PromoModel>.from((jsonMap["result"] as List)
        /*
            // преобразование каждого элемента списка из типа Map<String, dynamic> в
            объект типа NewsModel с помощью метода map()
             */
            .map((e) => PromoModel.fromJson(e)));
        return resultJson; // возвращение списка объектов типа NewsModel
      } else {
        return listObject; // возвращение пустого списка объектов типа NewsModel
      }
    }


    final result = functionRequest(
        params: params, method: MethodConstants.getPromo, parser: parseJson);
    return result;
  }


}