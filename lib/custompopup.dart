import 'package:custom_popup_menu/popupcustompaint.dart';
import 'package:flutter/material.dart';

class CustomPopupMenu extends StatefulWidget {
  final List<CustomPopupItem> items;

  /// [items] list of [CustomPopupItems] objects:

  final bool expandView;

  /// [expandView] default value false, means [menuWidth] = 200px
  /// else, [expandView] = true, expand acc to screen size
  final bool scrollable;

  /// [scrollable] enables scroll physics for the items list
  final BuildContext context;

  /// [context] required for expanded view
  final double paddingHzLeft;
  final double paddingHzRight;

  /// [paddingHzLeft] & [paddingHzRight] explicit padding required as menu conatiner
  /// is drawn over an overlay, default value = 20px
  const CustomPopupMenu({
    super.key,
    required this.items,
    this.expandView = false,
    this.scrollable = false,
    required this.context,
    this.paddingHzLeft = 20,
    this.paddingHzRight = 20,
  });

  @override
  State<CustomPopupMenu> createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
  late bool isOpen;

  /// [isOpen] check for menu already open or not.
  GlobalKey buttonKey = GlobalKey();

  /// [buttonKey] required to get the coordinate of the button on canvas.
  OverlayEntry? _tempEntry;

  /// [_tempEntry] to duplicate the overlayEntry and further handling.
  late double menuHeight;
  late double menuWidth;
  late int index;

  /// [index] required when mapping list
  Size iconSize = const Size(40, 40);

  @override
  void initState() {
    double totalPadding = widget.paddingHzLeft + widget.paddingHzRight;
    isOpen = false;
    index = -1;
    menuHeight =
        (16.0 + 40.0) * ((widget.items.length < 4) ? widget.items.length : 4);
    menuWidth = (widget.expandView)
        ? MediaQuery.of(widget.context).size.width - totalPadding
        : 200;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        /// used to get the offset of the icon-button
        /// on the canvas
        Offset buttonOffset = _getOffsetOnCanvas(
          buttonKey,
          context,
          Size(iconSize.width, iconSize.height),
        );
        final overlay = Overlay.of(context);

        /// [showPopup] returns a custom entry, which
        /// is used further to insert and remove on
        /// inkwell calls
        OverlayEntry entry = _showPopup(
          context,
          buttonOffset,
          onTap: () {
            /// this onTap is for off-scope or
            /// outside the menu tap, which disposes the menu
            if (isOpen) {
              isOpen = !isOpen;
              _tempEntry!.remove();
              index = -1;
            }
          },
        );

        /// now we get entry and overlay,
        /// if menu isnt open already then
        /// we insert the entry else remove it.
        if (!isOpen) {
          isOpen = !isOpen;
          overlay.insert(entry);
          _tempEntry = entry;
        } else {
          isOpen = !isOpen;
          _tempEntry!.remove();
          index = -1;
        }
      },
      child:

          /// icon-button defined here
          Ink(
        key: buttonKey,
        height: iconSize.height,
        width: iconSize.width,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  OverlayEntry _showPopup(
    BuildContext context,
    Offset buttonOffset, {
    required VoidCallback onTap,
  }) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          /// this used to remove enrty when clicked
          /// out of the scope or filed of the menu container.
          Positioned.fill(
              child: GestureDetector(
            onTap: onTap,
            child: Container(
              color: Colors.transparent,
            ),
          )),

          /// menu container placement, using custom
          /// paint, postion is not defined as its handled using
          /// custom paint coordinated/offset
          Positioned(
            child: Material(
              color: Colors.transparent,
              child: CustomPaint(
          
                painter: MenuPaint(
                    center: _getOffsetOnCanvas(
                      buttonKey,
                      context,
                      Size(iconSize.width, iconSize.height),
                    ),
                    screenSize: Size(width, height),
                    menuSize: Size(menuWidth, menuHeight),
                    iconButtonWidth: iconSize.width),
              ),
            ),
          ),

          /// custom paint is already in a stack,
          /// therefore placing content in chlid place it
          /// acc to stacks alignment and changing the alignment
          /// interupts the custom paint offset therefore we have
          /// explicitly place the contenst using the same calculation
          /// as used for menu-container with some minor adjustments
          Positioned(
            top:
                _offsetDy(buttonOffset.dy, height, containerHeight: menuHeight),
            left: _offsetDx(buttonOffset.dx, width, containerWidth: menuWidth),
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                height: menuHeight,
                child: SingleChildScrollView(
                  physics: (widget.scrollable)
                      ? null
                      : const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...widget.items.map((item) {
                        index++;
                        return InkWell(
                          borderRadius:
                              _getBorderRadius(index, widget.items.length),
                          onTap: () {
                            item.onTap(); // item-onTap operation
                            onTap(); // removes the entry
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: _getBorderRadius(
                                        index, widget.items.length)),
                                width: menuWidth - 1,
                                height: 16 + 40,
                                // * defined accordingly, dont change
                                padding:
                                    const EdgeInsets.only(top: 20, left: 20),
                                // Text config
                                child: Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              // divider
                              if (widget.items.length > 1 &&
                                  index != widget.items.length - 1)
                                Container(
                                  width: menuWidth - 40,
                                  height: 1,
                                  color: Colors.white30,
                                )
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _getBorderRadius(int index, int length) {
    if (index == 0) {
      return const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      );
    } else if (index == length - 1) {
      return const BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      );
    } else {
      return BorderRadius.circular(0);
    }
  }

  _offsetDy(double buttonDy, double height, {required double containerHeight}) {
    double availableBelowDy = height - buttonDy;
    double padding = 40;
    if (availableBelowDy > containerHeight + padding) {
      return buttonDy + padding;
    } else {
      return buttonDy - containerHeight - padding;
    }
  }

  _offsetDx(double buttonDx, double width, {required double containerWidth}) {
    double containerHalfWidth = containerWidth / 2;
    double iconHalfWidth = 20;
    double tightDxDisplacement = containerHalfWidth - iconHalfWidth;
    if (buttonDx > width / 2) {
      double displacement = buttonDx - (width / 2);
      if (displacement >= tightDxDisplacement) {
        displacement = tightDxDisplacement;
      }
      return buttonDx - containerHalfWidth - displacement;
    } else if (buttonDx < width / 2) {
      double displacement = (width / 2) - buttonDx;
      if (displacement >= tightDxDisplacement) {
        displacement = tightDxDisplacement;
      }
      return buttonDx - containerHalfWidth + displacement;
    } else {
      return buttonDx - containerHalfWidth;
    }
  }

  Offset _getOffsetOnCanvas(
    GlobalKey key,
    BuildContext context,
    Size objectSize,
  ) {
    RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
    Offset iconButtonPosition = renderBox.localToGlobal(Offset.zero);
    return Offset(iconButtonPosition.dx + objectSize.width / 2,
        iconButtonPosition.dy + objectSize.height / 2);
  }
}

class CustomPopupItem {
  final String title;
  final VoidCallback onTap;

  CustomPopupItem({
    required this.title,
    required this.onTap,
  });
}
