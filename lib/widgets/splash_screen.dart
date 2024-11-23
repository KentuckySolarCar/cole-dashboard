// Animated splash screen widget
// Written almost entirely by chatGPT
import 'package:flutter/material.dart';

//TODO PUT IN THE NEW UK EGR LOGO!!!!!!!!!!!

class SplashScreen extends StatefulWidget {
  final Widget dashboard;
  final Duration displayDuration;

  SplashScreen({required this.dashboard, this.displayDuration = const Duration(seconds: 1)});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();
    // Describe the animation sequence
    _controller = AnimationController(
      duration: widget.displayDuration + const Duration(seconds: 5),  // Add the display duration to the animation duration
      vsync: this,
    );

    // Control the image opacity
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.4, curve: Curves.easeInOut)),
    );

    // Control the background fade from white to black
    _backgroundColorAnimation = ColorTween(begin: Colors.white, end: Colors.black).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.6, 1.0, curve: Curves.easeInOut)),
    );

    _startAnimation();
  }

  // Animation sequence call
  _startAnimation() async {
    await _controller.forward(from: 0.0);  // Start the animation
    await Future.delayed(widget.displayDuration);  // Wait for the specified display duration
    // Switch contexts to open up the dashboard
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => widget.dashboard),  // Navigate to the provided dashboard
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Widget to display animation
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _backgroundColorAnimation.value,  // Animate background color
          body: Center(
            child: Opacity(
              opacity: _controller.value <= 0.4 ? _opacityAnimation.value : (_controller.value <= 0.6 ? 1.0 : 1.0 - (_controller.value - 0.6) * 2.5),
              child: _displaySplashSequence(),
            ),
          ),
        );
      },
    );
  }

  // Widget to display the two images on the car
  Widget _displaySplashSequence() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,  // Full width of the screen
          height: 200,  // Adjust the height as needed
          child: Image.asset(
            'images/uk-eng-logo.png',
            fit: BoxFit.contain,  // Adjust the scale (contain, cover, fill, etc.)
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,  // Full width of the screen
          height: 200,  // Adjust the height as needed
          child: Image.asset(
            'images/uk-solar-car-team-logo.png',
            fit: BoxFit.contain,  // Adjust the scale (contain, cover, fill, etc.)
          ),
        ),
      ],
    );
  }
}
