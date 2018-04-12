import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation ;

class AnimatedCircle extends StatefulWidget {

  final int counter;
  var alignment;
  final GestureTapCallback onTap;

  AnimatedCircle(this.counter, this.alignment, this.onTap);

  @override
  _AnimatedCircleState createState() => new _AnimatedCircleState(counter, alignment, onTap);
}

class _AnimatedCircleState extends State<AnimatedCircle> with TickerProviderStateMixin{

  AnimationController _controller;
  int counter;
  var alignment;
  final GestureTapCallback onTap;

  _AnimatedCircleState(this.counter, this.alignment, this.onTap);


  @override
  void initState() {
    super.initState();
    counter = 1;
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await _controller.forward().orCancel;
      await _controller.reverse().orCancel;
    } on TickerCanceled{

    }
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return new Container(
      alignment: alignment,
      margin: const EdgeInsets.only(top: 35.5, right: 10.0, bottom: 120.0),
      child: new StaggerAnimation(controller: _controller.view),
    );
  }
}

class StaggerAnimation extends StatelessWidget {

  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> dx;
  final Animation<double> dy;
  final Animation<Alignment> alignment;

  StaggerAnimation({Key key, this.controller}):

        opacity = new Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(new CurvedAnimation(parent: controller, curve: new Interval(0.0, 0.200, curve: Curves.ease))),

        dx = new Tween<double>(
            end: 15.0,
            begin: 70.0
        ).animate(new CurvedAnimation(parent: controller, curve: new Interval(0.0, 0.500, curve: Curves.ease))),

        dy = new Tween<double>(
            end: 15.0,
            begin: 70.0
        ).animate(new CurvedAnimation(parent: controller, curve: new Interval(0.0, 0.500, curve: Curves.ease))),

        alignment = new AlignmentTween(
          begin: Alignment.bottomCenter,
          end: Alignment.topRight,
        ).animate(new CurvedAnimation(parent: controller, curve: new Interval(0.0, 0.500, curve: Curves.ease))),

        super(key: key);

  Widget _buildAnimation(BuildContext context, Widget child){
    return new Container(
        alignment: alignment.value,
        child: new Opacity(
          opacity: opacity.value,
          child: new Container(
            width: dx.value,
            height: dy.value,
            decoration: new BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
            ),
          ),
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return new AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}