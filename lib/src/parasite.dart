import 'package:flutter/material.dart';

/// A builder for [Parasite].
typedef ParasiteBuilder<T> = Widget Function(BuildContext, T);

/// An Object that manages the state of a value of type [T].
abstract class ParasiteHost<T> extends ValueNotifier<T> {
  /// Initializes a new [ParasiteHost].
  ParasiteHost(T state) : super(state);

  /// The current state of this [ParasiteHost].
  T get state => value;

  /// Spreads a new state accross all the [Parasite] objects that are listening
  /// to this [ParasiteHost].
  void spread(T newState) {
    value = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

/// A [Widget] that listens to changes from a [ParasiteHost].
class Parasite<T> extends ValueListenableBuilder<T> {
  /// Initializes a new [Parasite].
  Parasite({
    required ParasiteHost<T> host,
    required ParasiteBuilder builder,
    Key? key,
  }) : super(
          builder: (context, state, _) => builder(context, state),
          valueListenable: host,
          key: key,
        );
}

/// A class that provides a [ParasiteHost] to the widget tree.
class HostProvider<T extends ParasiteHost<Object>> extends InheritedWidget {
  /// Initializes a new [HostProvider]
  const HostProvider({required this.host, required Widget child, Key? key})
      : super(key: key, child: child);

  /// [ParasiteHost] to be provided to the tree.
  final T host;

  @override
  bool updateShouldNotify(covariant HostProvider oldWidget) => true;

  /// Gets a [HostProvider] of the specified host in [context].
  static HostProvider<T> of<T extends ParasiteHost<Object>>(
    BuildContext context,
  ) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<HostProvider<T>>();
    assert(provider != null, 'No HostProvider found in the context');
    return provider!;
  }
}
