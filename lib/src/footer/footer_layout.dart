import 'package:flutter/widgets.dart';
import 'dart:math' as math;

enum _FooterSlot { footer, body }

class _FooterLayout extends MultiChildLayoutDelegate {
  final EdgeInsets minInsets;

  _FooterLayout({@required this.minInsets});

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
      final double bottomNavigationBarHeight =
          layoutChild(_FooterSlot.footer, fullWidthConstraints).height;
      footerHeight += bottomNavigationBarHeight;
      footerTop = math.max(0.0, bottom - footerHeight);
      positionChild(_FooterSlot.footer, Offset(0.0, footerTop));
    }

    final double contentBottom =
        math.max(0.0, bottom - math.max(minInsets.bottom, footerHeight));

    if (hasChild(_FooterSlot.body)) {
      double bodyMaxHeight = math.max(0.0, contentBottom - contentTop);

      final BoxConstraints bodyConstraints = _BodyBoxConstraints(
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

  const Footer({Key key, @required this.body, @required this.footer})
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
    @required bool removeLeftPadding,
    @required bool removeTopPadding,
    @required bool removeRightPadding,
    @required bool removeBottomPadding,
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



// Used to communicate the height of the Footer's footer
//
// Footer expects a _BodyBoxConstraints to be passed to the _BodyBuilder
// widget's LayoutBuilder, see _FooterLayout.performLayout(). The BoxConstraints
// methods that construct new BoxConstraints objects, like copyWith() have not
// been overridden here because we expect the _BodyBoxConstraintsObject to be
// passed along unmodified to the LayoutBuilder. If that changes in the future
// then _BodyBuilder will assert.
class _BodyBoxConstraints extends BoxConstraints {
  const _BodyBoxConstraints({
    double minWidth = 0.0,
    double maxWidth = double.infinity,
    double minHeight = 0.0,
    double maxHeight = double.infinity,
    @required this.footerHeight,
  }) : assert(footerHeight != null),
        assert(footerHeight >= 0),
        super(minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight);

  final double footerHeight;

  // RenderObject.layout() will only short-circuit its call to its performLayout
  // method if the new layout constraints are not == to the current constraints.
  // If the height of the bottom widgets has changed, even though the constraints'
  // min and max values have not, we still want performLayout to happen.
  @override
  bool operator ==(Object other) {
    if (super != other)
      return false;
    return other is _BodyBoxConstraints
        && other.footerHeight == footerHeight;
  }

  @override
  int get hashCode {
    return hashValues(super.hashCode, footerHeight);
  }
}