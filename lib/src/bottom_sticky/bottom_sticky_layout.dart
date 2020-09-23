import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_layouts/flutter_layouts.dart';
/*

class BottomSticky extends StatelessWidget {
  final Widget body;
  final Widget bottom;

  /// explicitly provided size (height) of the bottom -> will be removed after using multichild delegate
  final double bottomSize;

  /// the color of fade damping section
  final Color dampingColor;

  /// gets the default theme's surface color if [dampingColor] is not provided
  Color getOverrideDampingColor(BuildContext context) {
    if (dampingColor == null) {
      return Theme.of(context).colorScheme.surface;
    }
    return dampingColor;
  }

  const BottomSticky({
    Key key,
    @required this.body,
    @required this.bottom,
    @required this.bottomSize,
    this.dampingColor,
  })  : assert(bottomSize != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color dampingColor = getOverrideDampingColor(context);
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
//              body,
//              SizedBox(
//                height: bottomSize,
//              )
            ],
          ),
        ),
        body,
//        Container(
//          child: body,
//          padding: EdgeInsets.only(bottom: 1),
//        ),
//        Positioned(child: body, top: 0, left: 0, right: 0, bottom: bottomSize,),
//        body,
        Positioned(
          child: Container(
            width: double.maxFinite,
            height: bottomSize,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [
                  0,
                  0.8,
                  1
                ],
                    colors: [
                  dampingColor,
                  dampingColor,
                  dampingColor.withAlpha(0),
                ])),
            child: bottom,
          ),
          bottom: 0,
          left: 0,
          right: 0,
        )
      ],
    );
  }
}
*/

enum _Slots { bottom, damp, body }

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



    if (hasChild(_Slots.damp)) {
      final double bottomHeight =
          layoutChild(_Slots.damp, fullWidthConstraints).height;
      footerHeight += bottomHeight;
      footerTop = math.max(0.0, bottom - footerHeight);
      positionChild(_Slots.bottom, Offset(0.0, footerTop));
      // TODO
    }


    if (hasChild(_Slots.bottom)) {
      final double bottomHeight =
          layoutChild(_Slots.bottom, fullWidthConstraints).height;
      footerHeight += bottomHeight;
      footerTop = math.max(0.0, bottom - footerHeight);
      positionChild(_Slots.bottom, Offset(0.0, footerTop));
    }


    final double contentBottom =
        math.max(0.0, bottom - math.max(minInsets.bottom, footerHeight));

    if (hasChild(_Slots.body)) {
      double bodyMaxHeight = math.max(0.0, contentBottom - contentTop);

      final BoxConstraints bodyConstraints = BodyBoxConstraints(
        maxWidth: fullWidthConstraints.maxWidth,
        maxHeight: bodyMaxHeight,
        footerHeight: footerHeight,
      );
      layoutChild(_Slots.body, bodyConstraints);
      positionChild(_Slots.body, Offset(0.0, contentTop));
    }
  }

  @override
  bool shouldRelayout(_FooterLayout oldDelegate) {
    return oldDelegate.minInsets != minInsets;
  }
}

class BottomSticky extends StatefulWidget {
  final Widget body;
  final Widget bottom;
  final Gradient gradient;
  final double dampingHeight;

  /// the color of fade damping section
  final Color dampingColor;

  /// gets the default theme's surface color if [dampingColor] is not provided
  Color getOverrideDampingColor(BuildContext context) {
    if (dampingColor == null) {
      return Theme.of(context).colorScheme.surface;
    }
    return dampingColor;
  }

  const BottomSticky(
      {Key key,
      @required this.body,
      @required this.bottom,
      this.dampingColor,
      this.gradient,
      this.dampingHeight = 24})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomStickyState();
}

class _BottomStickyState extends State<BottomSticky> {
  @override
  Widget build(BuildContext context) {
    List<LayoutId> children = [];
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    EdgeInsets minInset = mediaQuery.padding.copyWith(bottom: 0.0);

    if (widget.bottom != null) {
      addIfNonNull(
        children,
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: widget.bottom,
        ),
        _Slots.bottom,
        context,
        removeLeftPadding: false,
        removeTopPadding: false,
        removeRightPadding: false,
        removeBottomPadding: false,
      );
    }

    // region damping
    Widget damping = Container(
      height: widget.dampingHeight,
      decoration: BoxDecoration(
        gradient: widget.gradient,
      ),
    );
    if (widget.body != null) {
      addIfNonNull(
        children,
        damping,
        _Slots.damp,
        context,
        removeLeftPadding: false,
        removeTopPadding: false,
        removeRightPadding: false,
        removeBottomPadding: true,
      );
    }
    // endregion damping

    if (widget.body != null) {
      addIfNonNull(
        children,
        widget.body,
        _Slots.body,
        context,
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
}
