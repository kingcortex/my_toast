import 'package:flutter/material.dart';

import 'styles.dart';
import 'glass.dart';
import 'provider.dart';
import 'toast_widget.dart';
import 'type.dart';

class ToastWrapper extends StatefulWidget {
  final Widget child;
  final ToastStyle style;
  const ToastWrapper(
      {super.key, required this.child, this.style = ToastStyle.style1});

  @override
  ToastWrapperState createState() => ToastWrapperState();
}

class ToastWrapperState extends State<ToastWrapper> {
  bool isExpended = false;
  final List<NotificationType> _toasts = [];
  final List<GlobalKey<ToastWidgetState>> _toastKeys = [];

  late ToastStyle _style;
  @override
  void initState() {
    _style = widget.style;
    super.initState();
  }

  void _showToast(NotificationType type) {
    setState(() {
      _toasts.add(type);
      _toastKeys.add(GlobalKey<ToastWidgetState>());
    });

    // Future.delayed(Duration(seconds: 5), () {
    //   setState(() {
    //     _toasts.removeAt(0); // Supprimer le premier toast après 2 secondes
    //     _toastKeys.removeAt(0); // Supprimer la clé correspondante
    //   });
    // });
  }

  void _deleteToast(int index) {
    setState(() {
      _toasts.removeAt(index);
      _toastKeys.removeAt(index);
    });
    if (_toastKeys.isEmpty) {
      isExpended = false;
    }
  }

  double getGap(int index) {
    int maxLenght = _toastKeys.length;

    if (maxLenght <= 3) {
      return 50 - index * 6;
    }
    if (index == 0) {
      return 50 + 1 * 12;
    }
    if (index == 1) {
      return 50 + 0.5 * 12;
    }

    return 50;
  }

  double getScale(int index) {
    int maxLenght = _toastKeys.length;
    if (maxLenght <= 3) {
      if (index == 0) {
        if (maxLenght == 1) return 1;
        if (maxLenght == 2) {
          return 0.92;
        }
        return 0.84;
      }
      if (index == 1) {
        if (maxLenght <= 2) return 1;
        return 0.92;
      }
    }

    if (index == 0) {
      return 0.84;
    }

    if (index == 1) {
      return 0.92;
    }

    return 1;
  }

  void _setStyle(ToastStyle style) {
    setState(() {
      _style = style;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ToastProvider(
      showToast: _showToast,
      deleteToast: _deleteToast,
      setStyle: _setStyle,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            widget.child,
            if (isExpended)
              GlassmorphismContainer(
                ontap: () {
                  setState(() {
                    isExpended = false;
                  });
                },
              ),
            ..._toasts.asMap().entries.map((entry) {
              int index = entry.key;
              NotificationType type = entry.value;

              return AnimatedPositioned(
                key: _toastKeys[index],
                curve: isExpended ? Curves.easeOutBack : Curves.easeOut,
                bottom: isExpended
                    ? 50 + (_toastKeys.length - index) * 65
                    : getGap(index), // Décalage pour chaque toast
                left: 20,
                right: 20,
                duration: isExpended
                    ? const Duration(milliseconds: 400)
                    : const Duration(milliseconds: 200),
                child: Transform.scale(
                  scaleX: isExpended ? 1 : getScale(index),
                  child: ToastWidget(
                    style: _style,
                    type: type,
                    onTap: () {
                      setState(() {
                        isExpended = true;
                      });
                    },
                    message: "",
                    onCloce: () => _deleteToast(index),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
