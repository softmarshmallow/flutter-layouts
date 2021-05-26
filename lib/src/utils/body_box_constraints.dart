
// Used to communicate the height of the Footer's footer
//
// Footer expects a _BodyBoxConstraints to be passed to the _BodyBuilder
// widget's LayoutBuilder, see _FooterLayout.performLayout(). The BoxConstraints
// methods that construct new BoxConstraints objects, like copyWith() have not
// been overridden here because we expect the _BodyBoxConstraintsObject to be
// passed along unmodified to the LayoutBuilder. If that changes in the future
// then _BodyBuilder will assert.
import 'package:flutter/widgets.dart';

class BodyBoxConstraints extends BoxConstraints {
  const BodyBoxConstraints({
    double minWidth = 0.0,
    double maxWidth = double.infinity,
    double minHeight = 0.0,
    double maxHeight = double.infinity,
    required this.footerHeight,
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
    return other is BodyBoxConstraints
        && other.footerHeight == footerHeight;
  }

  @override
  int get hashCode {
    return hashValues(super.hashCode, footerHeight);
  }
}