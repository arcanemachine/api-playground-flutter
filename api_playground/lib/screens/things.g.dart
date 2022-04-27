// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'things.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ThingsStore on _ThingsStore, Store {
  Computed<bool>? _$hasResultsComputed;

  @override
  bool get hasResults =>
      (_$hasResultsComputed ??= Computed<bool>(() => super.hasResults,
              name: '_ThingsStore.hasResults'))
          .value;

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

  final _$fetchThingsFutureAtom = Atom(name: '_ThingsStore.fetchThingsFuture');

  @override
  ObservableFuture<List<Thing>> get fetchThingsFuture {
    _$fetchThingsFutureAtom.reportRead();
    return super.fetchThingsFuture;
  }

  @override
  set fetchThingsFuture(ObservableFuture<List<Thing>> value) {
    _$fetchThingsFutureAtom.reportWrite(value, super.fetchThingsFuture, () {
      super.fetchThingsFuture = value;
    });
  }

  final _$fetchThingsAsyncAction = AsyncAction('_ThingsStore.fetchThings');

  @override
  Future<void> fetchThings() {
    return _$fetchThingsAsyncAction.run(() => super.fetchThings());
  }

  @override
  String toString() {
    return '''
things: ${things},
initialFetchCompleted: ${initialFetchCompleted},
fetchThingsFuture: ${fetchThingsFuture},
hasResults: ${hasResults}
    ''';
  }
}
