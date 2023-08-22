import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:animated_tree_view/listenable_node/base/i_listenable_node.dart';
import 'package:flutter/foundation.dart';

/// Base class that allows a data of type [T] to be wrapped in a [ListenableNode]
mixin ITreeNode<T> on IListenableNode implements ValueListenable<INode> {
  /// ValueNotifier for node expansion/collapse
  late final ValueNotifier<bool> expansionNotifier = ValueNotifier(false);
  late final ValueNotifier<bool> mayCollapseNotifier = ValueNotifier(true);

  /// [ValueNotifier] for data [T] that can be listened for data changes;
  ValueNotifier<T?> get listenableData;

  /// Shows whether the node is expanded or not
  bool get isExpanded => expansionNotifier.value;

  bool get mayCollapse => mayCollapseNotifier.value;

  set mayCollapse(bool value) {
    mayCollapseNotifier.value = value;
  }

  /// The data value of [T] wrapped in the [ITreeNode]
  T? get data => listenableData.value;

  /// The setter for data value [T] of wrapped in the Node.
  /// It will notify [listenableData] whenever the value is set.
  set data(T? value) {
    listenableData.value = value;
  }

  bool isLastChild = false;

  bool areChildIndicesCached = false;

  void cacheChildIndices() {
    if (childrenAsList.isEmpty || areChildIndicesCached) return;
    (childrenAsList[length - 1] as ITreeNode).isLastChild = true;
    areChildIndicesCached = true;
  }

  void resetIndentationCache() {
    if (childrenAsList.isEmpty) return;
    (childrenAsList[length - 1] as ITreeNode).isLastChild = false;
    areChildIndicesCached = false;
  }
}

/// A [TreeNode] that can be used with the [TreeView].
///
/// To use your own custom data with [TreeView], wrap your model [T] in [TreeNode]
/// like this:
/// ```dart
///   class YourCustomNode extends TreeNode<CustomClass> {
///   ...
///   }
/// ```
class TreeNode<T> extends ListenableNode with ITreeNode<T> {
  bool mayCollapse;

  /// A [TreeNode] constructor that can be used with the [TreeView].
  /// Any data of type [T] can be wrapped with [TreeNode]
  TreeNode({T? data, super.key, super.parent, this.mayCollapse = true})
      : this.listenableData = ValueNotifier(data);

  /// Factory constructor to be used only for root [TreeNode]
  factory TreeNode.root({T? data, bool mayCollapse = true}) =>
      TreeNode(key: INode.ROOT_KEY, data: data, )
        ..isLastChild = true
        ..cacheChildIndices();

  /// [ValueNotifier] for data [T] that can be listened for data changes;
  @override
  final ValueNotifier<T?> listenableData;
}

/// A [IndexedTreeNode] that can be used with the [IndexedTreeView].
///
/// To use your own custom data with [IndexedTreeView], wrap your model [T] in [IndexedTreeNode]
/// like this:
/// ```dart
///   class YourCustomNode extends IndexedTreeView<CustomClass> {
///   ...
///   }
/// ```
class IndexedTreeNode<T> extends IndexedListenableNode with ITreeNode<T> {
  /// A [IndexedTreeNode] constructor that can be used with the [IndexedTreeView].
  /// Any data of type [T] can be wrapped with [IndexedTreeView]
  IndexedTreeNode({T? data, bool mayCollapse = true, super.key, super.parent})
      : this.listenableData = ValueNotifier(data);

  /// Factory constructor to be used only for root [IndexedTreeNode]
  factory IndexedTreeNode.root({T? data, bool mayCollapse = true}) =>
      IndexedTreeNode(key: INode.ROOT_KEY, data: data, mayCollapse: mayCollapse)
        ..isLastChild = true
        ..cacheChildIndices();

  /// [ValueNotifier] for data [T] that can be listened for data changes;
  @override
  final ValueNotifier<T?> listenableData;
}
