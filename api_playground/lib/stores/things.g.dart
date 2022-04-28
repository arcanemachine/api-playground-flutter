// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'things.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ThingsStore on _ThingsStore, Store {
  final _$thingsAtom = Atom(name: '_ThingsStore.things');

  @override
  ObservableList<Thing> get things {
    _$thingsAtom.reportRead();
    return super.things;
  }

  @override
  set things(ObservableList<Thing> value) {
    _$thingsAtom.reportWrite(value, super.things, () {
      super.things = value;
    });
  }

  final _$initialFetchCompletedAtom =
      Atom(name: '_ThingsStore.initialFetchCompleted');

  @override
  bool get initialFetchCompleted {
    _$initialFetchCompletedAtom.reportRead();
    return super.initialFetchCompleted;
  }

  @override
  set initialFetchCompleted(bool value) {
    _$initialFetchCompletedAtom.reportWrite(value, super.initialFetchCompleted,
        () {
      super.initialFetchCompleted = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_ThingsStore.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$thingsFetchAsyncAction = AsyncAction('_ThingsStore.thingsFetch');

  @override
  Future<void> thingsFetch() {
    return _$thingsFetchAsyncAction.run(() => super.thingsFetch());
  }

  final _$thingCreateAsyncAction = AsyncAction('_ThingsStore.thingCreate');

  @override
  Future<void> thingCreate(String name) {
    return _$thingCreateAsyncAction.run(() => super.thingCreate(name));
  }

  @override
  String toString() {
    return '''
things: ${things},
initialFetchCompleted: ${initialFetchCompleted},
isLoading: ${isLoading}
    ''';
  }
}
