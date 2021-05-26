import 'package:flutter/material.dart';
void addIfNonNull(
    List<LayoutId> children,
    Widget child,
    Object childId,
    BuildContext context,
    {
      required bool removeLeftPadding,
      required bool removeTopPadding,
      required bool removeRightPadding,
      required bool removeBottomPadding,
      bool removeBottomInset = false,
      bool maintainBottomViewPadding = false,
    }) {
  MediaQueryData data = MediaQuery.of(context).removePadding(
    removeLeft: removeLeftPadding,
    removeTop: removeTopPadding,
    removeRight: removeRightPadding,
    removeBottom: removeBottomPadding,
  );
  if (removeBottomInset) data = data.removeViewInsets(removeBottom: true);

  if (maintainBottomViewPadding && data.viewInsets.bottom != 0.0) {
    data = data.copyWith(
        padding: data.padding.copyWith(bottom: data.viewPadding.bottom));
  }

  if (child != null) {
    children.add(
      LayoutId(
        id: childId,
        child: MediaQuery(data: data, child: child),
      ),
    );
  }
}