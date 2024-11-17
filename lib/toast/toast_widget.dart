import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_toast/extentions/gap.dart';
import 'package:my_toast/toast/type.dart';

import 'styles.dart';

class ToastWidget extends StatefulWidget {
  final NotificationType type;
  final ToastStyle style;
  final String message;
  final VoidCallback? onCloce;
  final VoidCallback? onTap;
  const ToastWidget({
    super.key,
    required this.message,
    this.onCloce,
    this.onTap,
    required this.type,
    required this.style,
  });

  @override
  ToastWidgetState createState() => ToastWidgetState();
}

class ToastWidgetState extends State<ToastWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  double _positionX = 0.0;
  bool _isDragging = false;
  late Size _screenSize;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    print(details.delta.dx);
    setState(() {
      _positionX += details.delta.dx;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_positionX.abs() > 100) {
      _delete(_positionX);
      //widget.onCloce?.call();
    } else {
      setState(() {
        _isDragging = false;
        _positionX = 0.0;
      });
    }
  }

  void _onHorizontalDragStart() {
    setState(() {
      _isDragging = true;
    });
  }

  void _delete(double dx) async {
    if (dx > 0) {
      setState(() {
        _positionX -= _screenSize.width * 2;
      });
    } else {
      setState(() {
        _positionX += _screenSize.width * 2;
      });
    }
    await Future.delayed(const Duration(milliseconds: 200));
    widget.onCloce?.call();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _screenSize = MediaQuery.of(context).size;
      },
    );
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 1), // Commence sous l'écran
      end: const Offset(0, 0), // Fin de l'animation à sa position finale
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // Animation fluide
    ));

    _controller.forward(); // Lancer l'animation lorsque le widget apparaît
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Transform.translate(
        offset: Offset(_positionX, 0),
        child: GestureDetector(
          onPanUpdate: (details) {
            print(details.globalPosition.dx);
          },
          onHorizontalDragStart: (details) {
            _onHorizontalDragStart();
          },
          onHorizontalDragUpdate: (details) => _onHorizontalDragUpdate(details),
          onHorizontalDragEnd: (details) => _onHorizontalDragEnd(details),
          onTap: widget.onTap,
          child: Material(
            color: Colors.transparent,
            child: AnimatedContainer(
              curve: Curves.easeInOut,
              transform: Matrix4.identity()..translate(_positionX, 0),
              duration: _isDragging
                  ? Duration.zero
                  : const Duration(milliseconds: 400),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: widget.style.decoration(widget.type.color),
              child: Row(
                children: [
                  SvgPicture.asset(
                    widget.type == NotificationType.success
                        ? "assets/icons/svg/sucess_.svg"
                        : "assets/icons/svg/info.svg",
                    color: widget.style == ToastStyle.style1 ||
                            widget.style == ToastStyle.style3
                        ? widget.type.color.primary
                        : Colors.white,
                  ),
                  5.horisontalSpace,
                  Text(
                    overflow: TextOverflow.ellipsis,
                    widget.type.message,
                    style: TextStyle(
                        color: widget.style == ToastStyle.style1 ||
                                widget.style == ToastStyle.style3
                            ? black
                            : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: widget.onCloce,
                    child: Icon(
                      weight: 0.2,
                      size: 24,
                      Icons.close,
                      color: widget.style == ToastStyle.style1 ||
                              widget.style == ToastStyle.style3
                          ? widget.type.color.primary
                          : Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
