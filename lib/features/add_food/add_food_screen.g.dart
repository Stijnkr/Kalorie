// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_food_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FoodSearch)
const foodSearchProvider = FoodSearchProvider._();

final class FoodSearchProvider
    extends $NotifierProvider<FoodSearch, FoodSearchState> {
  const FoodSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodSearchHash();

  @$internal
  @override
  FoodSearch create() => FoodSearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FoodSearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FoodSearchState>(value),
    );
  }
}

String _$foodSearchHash() => r'1e26b116bd2db1bbe0deff232437810496cef7dd';

abstract class _$FoodSearch extends $Notifier<FoodSearchState> {
  FoodSearchState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FoodSearchState, FoodSearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FoodSearchState, FoodSearchState>,
              FoodSearchState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
