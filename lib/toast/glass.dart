import 'dart:ui';
import 'package:flutter/material.dart';

class GlassmorphismContainer extends StatefulWidget {
  final VoidCallback ontap;
  const GlassmorphismContainer({super.key, required this.ontap});

  @override
  GlassmorphismContainerState createState() => GlassmorphismContainerState();
}

class GlassmorphismContainerState extends State<GlassmorphismContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
