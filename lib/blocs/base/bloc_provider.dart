import 'package:flutter/material.dart';

abstract class BlocBase {
  void dispose();
}

///**
// * 虽然这种方案运行起来没啥问题，但从性能角度却不是最优解。
// * 这是因为 context.ancestorWidgetOfExactType() 是一个时间复杂度为 O(n) 的方法，
// * 为了获取符合指定类型的 ancestor ，它会沿着视图树从当前 context 开始逐步往上递归查找其 parent 是否符合指定类型。
// * 如果当前 context 和目标 ancestor 相距不远的话这种方式还可以接受，否则应该尽量避免使用。
// */
//class BlocProvider<T extends BlocBase> extends StatefulWidget {
//  BlocProvider({
//    Key key,
//    @required this.child,
//    @required this.bloc,
////    this.userDispose: true,
//  }) : super(key: key);
//
//  final T bloc;
//  final Widget child;
////  final bool userDispose;
//
//  @override
//  _BlocProviderState<T> createState() => _BlocProviderState<T>();
//
//  static T of<T extends BlocBase>(BuildContext context) {
////    final type = _typeOf<BlocProvider<T>>();
////    LogUtil.e("of", tag: type == null ? "type null" : type.toString());
////    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
////    LogUtil.e("of", tag: provider == null ? "provider null" : "provider ok");
//    BlocProvider<T> provider = context.findAncestorWidgetOfExactType<BlocProvider<T>>();
//    return provider?.bloc;
//  }
//
//  static Type _typeOf<M>() => M;
//}
//
//class _BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>> {
//  @override
//  void dispose() {
//    LogUtil.e("BlocProviderState", tag: "dispose");
////    if (widget.userDispose) {
////      widget.bloc.dispose();
////    }
//    widget.bloc?.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return widget.child;
//  }
//}

/**
 * 新方案毫无疑问是具有性能优势的，因为用了 InheritedWidget，在查找符合指定类型的 ancestor 时，
 * 我们就可以调用 InheritedWidget 的实例方法 context.ancestorInheritedElementForWidgetOfExactType()，
 * 而这个方法的时间复杂度是 O(1)，意味着几乎可以立即查找到满足条件的 ancestor。
 */
class BlocProvider<T extends BlocBase> extends StatefulWidget {
  BlocProvider({
    Key? key,
    required this.child,
    required this.bloc,
  }) : super(key: key);

  final T bloc;
  final Widget child;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T? of<T extends BlocBase>(BuildContext context) {
    // final Type type = _typeOf<_BlocProviderInherited<T>>();
    // _BlocProviderInherited<T> provider = context.ancestorInheritedElementForWidgetOfExactType(type)?.widget;

    // v1.12.1版本后，ancestorInheritedElementForWidgetOfExactType已被getElementForInheritedWidgetOfExactType取代
    InheritedWidget? provider = (context.getElementForInheritedWidgetOfExactType<_BlocProviderInherited<T>>())?.widget;
    if (provider == null) {
      return null;
    }
    if (provider is _BlocProviderInherited) {
      return (provider as _BlocProviderInherited<T>).bloc;
    }
    return null;
  }

  static Type _typeOf<T>() => T;
}

class _BlocProviderState<T extends BlocBase> extends State<BlocProvider<T>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BlocProviderInherited(
        bloc: widget.bloc,
        child:  widget.child
    );
  }
}

class _BlocProviderInherited<T extends BlocBase> extends InheritedWidget {
  _BlocProviderInherited({
    Key? key,
    required Widget child,
    required this.bloc,
  }) : super(key: key, child: child);

  final T bloc;

  @override
  bool updateShouldNotify(_BlocProviderInherited oldWidget) => false;
}