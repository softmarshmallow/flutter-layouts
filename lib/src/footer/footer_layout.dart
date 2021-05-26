import 'package:flutter_layouts/flutter_layouts.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;


enum _FooterSlot { footer, body }

class _FooterLayout extends MultiChildLayoutDelegate {
  final EdgeInsets minInsets;

  _FooterLayout({required this.minInsets});

  @override
  void performLayout(Size size) {
    final BoxConstraints looseConstraints = BoxConstraints.loose(size);

    final BoxConstraints fullWidthConstraints =
        looseConstraints.tighten(width: size.width);
    final double bottom = size.height;
    double contentTop = 0.0;
    double footerHeight = 0.0;
    double footerTop;

    if (hasChild(_FooterSlot.footer)) {
      final double bottomHeight =
          layoutChild(_FooterSlot.footer, fullWidthConstraints).height;
      footerHeight += bottomHeight;
      footerTop = math.max(0.0, bottom - footerHeight);
      positionChild(_FooterSlot.footer, Offset(0.0, footerTop));
    }

    final double contentBottom =
        math.max(0.0, bottom - math.max(minInsets.bottom, footerHeight));

    if (hasChild(_FooterSlot.body)) {
      double bodyMaxHeight = math.max(0.0, contentBottom - contentTop);

      final BoxConstraints bodyConstraints = BodyBoxConstraints(
        maxWidth: fullWidthConstraints.maxWidth,
        maxHeight: bodyMaxHeight,
        footerHeight: footerHeight,
      );
      layoutChild(_FooterSlot.body, bodyConstraints);
      positionChild(_FooterSlot.body, Offset(0.0, contentTop));
    }
  }

  @override
  bool shouldRelayout(_FooterLayout oldDelegate) {
    return oldDelegate.minInsets != minInsets;
  }
}

class Footer extends StatefulWidget {
  final Widget body;
  final Widget footer;

  const Footer({Key? key, required this.body, required this.footer})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    List<LayoutId> children = [];
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    EdgeInsets minInset = mediaQuery.padding.copyWith(bottom: 0.0);

    if (widget.footer != null) {
      _addIfNonNull(
        children,
        widget.footer,
        _FooterSlot.footer,
        removeLeftPadding: false,
        removeTopPadding: true,
        removeRightPadding: false,
        removeBottomPadding: false,
      );
    }

    if (widget.body != null) {
      _addIfNonNull(
        children,
        widget.body,
        _FooterSlot.body,
        removeLeftPadding: false,
        removeTopPadding: false,
        removeRightPadding: false,
        removeBottomPadding: true,
      );
    }

    return CustomMultiChildLayout(
      children: children,
      delegate: _FooterLayout(minInsets: minInset),
    );
  }

  void _addIfNonNull(
    List<LayoutId> children,
    Widget child,
    Object childId, {
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
}


