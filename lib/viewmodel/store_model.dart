import 'package:flutter/foundation.dart';
import 'package:flutter_mask/model/store.dart';
import 'package:flutter_mask/repository/store_repository.dart';

//얘랑 뷰, 모델이랑 직접적 통신
class StoreModel with ChangeNotifier {
  List<Store> stores = [];

  final _storeRepository = StoreRepository();

  StoreModel() {
    fetch();
  }

  Future fetch() async {
    stores = await _storeRepository.fetch();
    notifyListeners();
  }
}
