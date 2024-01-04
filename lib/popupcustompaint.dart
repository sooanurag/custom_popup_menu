import 'package:flutter/material.dart';

class MenuPaint extends CustomPainter {
  final Offset center;

  /// [center] coordinate of the icon-button on the canvas,
  /// used in order to position bazier-curve to the center
  /// of the icon-button.

  final Size screenSize;

  /// [screenSize] required to calculate where the iconbutton's
  /// position is on the canvas (is it center, left-to-center, bottom, etc)

  final Size menuSize;

  /// [menuSize] is calulated according to the list of items passed

  final double iconButtonWidth;

  /// [iconButtonWidth] require for offset calculation below

  MenuPaint({
    required this.menuSize,
    required this.center,
    required this.screenSize,
    required this.iconButtonWidth,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = const Color.fromRGBO(42, 39, 58, 1)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white30
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const double rRectRadius = 12.0;
    bool isBelow =
        (screenSize.height - center.dy > menuSize.height + 50) ? true : false;

    /// [isBelow]: finds acc to [screenSize] that there is space available to put the menu
    /// below the icon or not.

    Offset innerRRectOffset = Offset(
        _offsetDx(
          center.dx,
          screenSize.width,
          menuContainerWidth: menuSize.width,
          iconButtonWidth: iconButtonWidth,
        ),
        _offsetDy(
          center.dy,
          screenSize.height,
          menuContainerHeight: menuSize.height,
        ));
    Offset outerRRectOffset =
        Offset(innerRRectOffset.dx - 1, innerRRectOffset.dy - 1);

    // inner RRect
    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromPoints(
        innerRRectOffset,
        Offset(
          innerRRectOffset.dx + menuSize.width,
          innerRRectOffset.dy + menuSize.height,
        ),
      ),
      const Radius.circular(rRectRadius),
    );

    // RRect border, bazier curve
    final Path rRectBorder;
    final Path bazierCurve;
    final Path bazierCurveBorder;

    if (isBelow == false) {
      /// for [isBelow == false]: then we have to put
      /// menu above the menuButton icon.

      // RRect border
      rRectBorder = Path()
        ..moveTo(outerRRectOffset.dx, outerRRectOffset.dy + rRectRadius)
        ..arcToPoint(
            Offset(outerRRectOffset.dx + rRectRadius, outerRRectOffset.dy),
            radius: const Radius.circular(rRectRadius))
        // top-left arc
        ..lineTo(outerRRectOffset.dx + menuSize.width - 11, outerRRectOffset.dy)
        // top border-line
        ..arcToPoint(
            Offset(outerRRectOffset.dx + menuSize.width + 1,
                outerRRectOffset.dy + rRectRadius),
            radius: const Radius.circular(rRectRadius))
        // top-right arc
        ..lineTo(outerRRectOffset.dx + menuSize.width + 1,
            outerRRectOffset.dy + menuSize.height - 11)
        // right-border
        ..arcToPoint(
            Offset(outerRRectOffset.dx + menuSize.width - 11,
                outerRRectOffset.dy + menuSize.height + 1),
            radius: const Radius.circular(rRectRadius))
        // bottom-right arc
        ..lineTo(center.dx + 5, outerRRectOffset.dy + menuSize.height + 1)
        // bottom-border(right to bazier-curve)
        ..moveTo(center.dx - 5, outerRRectOffset.dy + menuSize.height + 1)
        // space for bazier-curve 10-px
        ..lineTo(outerRRectOffset.dx + rRectRadius,
            outerRRectOffset.dy + menuSize.height + 1)
        // bottom-border(left to bazier-curve)
        ..arcToPoint(
            Offset(outerRRectOffset.dx,
                outerRRectOffset.dy + menuSize.height - 11),
            radius: const Radius.circular(rRectRadius))
        // bottom-left arc
        ..lineTo(outerRRectOffset.dx, outerRRectOffset.dy + rRectRadius);
      // left border

      // Bazier-curve fill
      bazierCurve = Path()
        ..moveTo(center.dx + 5, innerRRectOffset.dy + menuSize.height)
        // move to right-side initial point
        ..quadraticBezierTo(
          center.dx, // center point of bazier-curve
          innerRRectOffset.dy + menuSize.height + 11, // bezier height = 11px
          center.dx - 5, // bazier-curve end-point: dx
          innerRRectOffset.dy + menuSize.height, // bazier-curve end-point: dy
        );

      // Bazier-curve border
      bazierCurveBorder = Path()
        ..moveTo(center.dx + 5, outerRRectOffset.dy + menuSize.height + 1)
        ..quadraticBezierTo(
          center.dx, // center point of bazier-curve
          outerRRectOffset.dy + menuSize.height + 12, // bezier height = 11px
          center.dx - 5, // bazier-curve end-point: dx
          outerRRectOffset.dy +
              menuSize.height +
              1, // bazier-curve end-point: dy
        );
    } else {
      /// for [isBelow == true]: then we have to put
      /// menu below the menuButton icon.

      // RRect border
      rRectBorder = Path()
        ..moveTo(outerRRectOffset.dx, outerRRectOffset.dy + rRectRadius)
        // move top inital point
        ..arcToPoint(
            Offset(outerRRectOffset.dx + rRectRadius, outerRRectOffset.dy),
            radius: const Radius.circular(rRectRadius))
        // top-left arc
        ..lineTo(center.dx - 5, outerRRectOffset.dy)
        // top-border(left to bazier-curve)
        ..moveTo(center.dx + 5, outerRRectOffset.dy)
        // space for bazier-curve: 10px
        ..lineTo(outerRRectOffset.dx + menuSize.width - 11, outerRRectOffset.dy)
        // top-border(right to bazier-curve)
        ..arcToPoint(
            Offset(outerRRectOffset.dx + menuSize.width + 1,
                outerRRectOffset.dy + rRectRadius),
            radius: const Radius.circular(rRectRadius))
        // top-left arc
        ..lineTo(outerRRectOffset.dx + menuSize.width + 1,
            outerRRectOffset.dy + menuSize.height - 11)
        // right-border
        ..arcToPoint(
            Offset(outerRRectOffset.dx + menuSize.width - 11,
                outerRRectOffset.dy + menuSize.height + 1),
            radius: const Radius.circular(rRectRadius))
        // bottom-right arc
        ..lineTo(outerRRectOffset.dx + rRectRadius,
            outerRRectOffset.dy + menuSize.height + 1)
        // bottom-border
        ..arcToPoint(
            Offset(outerRRectOffset.dx,
                outerRRectOffset.dy + menuSize.height - 11),
            radius: const Radius.circular(rRectRadius))
        // bottom-left arc
        ..lineTo(outerRRectOffset.dx, outerRRectOffset.dy + rRectRadius);
      // left-border

      // RRect offset curve
      bazierCurve = Path()
        ..moveTo(center.dx - 5, innerRRectOffset.dy)
        ..quadraticBezierTo(
          center.dx,
          innerRRectOffset.dy - 11, // bezier height
          center.dx + 5,
          innerRRectOffset.dy,
        );

      // offset-curve border: 1px offset
      bazierCurveBorder = Path()
        ..moveTo(center.dx + 5, outerRRectOffset.dy + 1)
        ..quadraticBezierTo(
          center.dx,
          outerRRectOffset.dy - 12, // bezier-boder height
          center.dx - 5,
          outerRRectOffset.dy + 1,
        );
    }

    canvas.drawRRect(rrect, fillPaint);
    canvas.drawPath(bazierCurve, fillPaint);
    canvas.drawPath(rRectBorder, borderPaint);
    canvas.drawPath(bazierCurveBorder, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

_offsetDy(double buttonDy, double screenHeight,
    {required double menuContainerHeight}) {
  double availableBelowDy = screenHeight - buttonDy;
  // [availableBelowDy]: check for available space below the iconButton
  double padding = 40;
  // padding/space between the iconButton and the menu-container
  if (availableBelowDy > menuContainerHeight + padding) {
    return buttonDy + padding;
    // below the icon-button
  } else {
    return buttonDy - menuContainerHeight - padding;
    // above the icon-button
  }
}

_offsetDx(double buttonDx, double screenWidth,
    {required double menuContainerWidth, required double iconButtonWidth}) {
  double menuContainerHalfWidth = menuContainerWidth / 2;

  /// [menuContainerHalfWidth]: as displace of the bazier-curve from
  /// the center of the icon-button will be in the range of half-width
  /// of the menu-container only.

  double iconButtonHalfWidth = iconButtonWidth / 2;

  /// [iconButtonHalfWidth]: required to cal tightDxDisplacement,
  /// that bazier-curve pos dont get to extreme corner.

  double tightDxDisplacement = menuContainerHalfWidth - iconButtonHalfWidth;
  // [tightDxDisplacement] check for bazier curve displacement

  if (buttonDx > screenWidth / 2) {
    /// [buttonDx > screenWidth / 2] : that icon-button
    /// is positioned rigth to the center of the canvas.

    double displacement = buttonDx - (screenWidth / 2);

    /// [displacement]: is the distance from center to icon-button
    /// on x-axis, this used to place menuContainer according to the
    /// distance the where the pos is (left/rigth to the center).

    if (displacement >= tightDxDisplacement) {
      /// displacement cant exceed tight-distance,
      /// as to prevent the extreme-corner pos.
      displacement = tightDxDisplacement;
    }

    /// this calculation is acc to icon-position is relation
    /// with center pos, we displace menu-container comparing
    /// the displcement from the center pos.
    /// * Eg. if the displacement = 10px, then the start pos of the drawing
    /// will be dx = (iconButtonDx - menuContainerWidth) - displcement
    /// where, (iconButtonDx - menuContainerWidth) places the conatiner in-center with
    /// the icon button and the displcement is the displaces it in respect to actual distance
    /// from the center of the canvas.
    return buttonDx - menuContainerHalfWidth - displacement;
  } else if (buttonDx < screenWidth / 2) {
    /// same as above, but calculate for postions
    /// left the center of the canvas
    double displacement = (screenWidth / 2) - buttonDx;
    if (displacement >= tightDxDisplacement) {
      displacement = tightDxDisplacement;
    }
    return buttonDx - menuContainerHalfWidth + displacement;
  } else {
    /// for icon-button place on the center of the canvas
    /// means there no displacement
    return buttonDx - menuContainerHalfWidth;
  }
}
