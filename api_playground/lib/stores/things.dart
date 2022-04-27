import 'package:mobx/mobx.dart';

import 'package:api_playground/models.dart';

// mobx
part 'things.g.dart';

class ThingsStore = _ThingsStore with _$ThingsStore;

abstract class _ThingsStore with Store {
  _ThingsStore() {
    fetchThings();
  }

  static ObservableFuture<List<Thing>> emptyResponse =
    ObservableFuture.value([]);

  @observable
  ObservableList<Thing> things = ObservableList<Thing>.of([]);

  @observable
  bool initialFetchCompleted = false;

  @observable
  ObservableFuture<List<Thing>> fetchThingsFuture = emptyResponse;

  @action
  Future<void> fetchThings() async {
    await ThingsService().getThings().then((result) {
      initialFetchCompleted = true;
      things = ObservableList<Thing>.of(result);
    });
  }
}