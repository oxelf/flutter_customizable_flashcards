library customizable_flashcard;

import 'dart:math' as math;

import 'package:customizable_flashcard/flashcard_side_enum.dart';
import 'package:flutter/material.dart';

/// UI flash card, commonly found in language teaching to children
class FlashCard extends StatefulWidget {
  /// constructor: Default height 200dp, width 200dp, duration  500 milliseconds
  const FlashCard({
    required this.frontWidget,
    required this.backWidget,
    required this.ontap,
    Key? key,
    this.duration = const Duration(milliseconds: 500),
    this.height = 200,
    this.width = 200,
    this.frontColor,
    this.backColor,
    this.frontGradient,
    this.backGradient,
    this.onFlip,
    this.defaultSide,
    this.frontAnimation,
    this.backAnimation,
    this.borderRadius,
    this.border,
  }) : super(key: key);

  /// this is the front of the card
  final Widget frontWidget;

  /// this is the back of the card
  final Widget backWidget;

  /// flip time
  final Duration duration;

  /// height of card
  final double height;

  /// width of card
  final double width;

  //front color of the card
  //default is Colors.white
  final Color? frontColor;

  //back color of the card
  //default is Colors.white
  final Color? backColor;

  //front gradient of the card
  //default is no gradient
  final Gradient? frontGradient;

  //back gradient of the card
  //default is no gradient
  final Gradient? backGradient;

  /// default side of the card
  /// default is front
  final FlashCardSide? defaultSide;

  /// callback when card is tapped
  final Function() ontap;

  /// callback when card is flipped
  /// gives the current side after the flip back as param
  final Function(FlashCardSide side)? onFlip;

  /// if you really want  you can override the default animation
  final Animation<double>? frontAnimation;

  /// if you really want  you can override the default animation
  final Animation<double>? backAnimation;

  /// border radius of the card
  ///default is 20
  final double? borderRadius;

  /// add a border to the flashcard
  /// default is no border
  final Border? border;

  @override
  FlashCardState createState() => FlashCardState();
}

class FlashCardState extends State<FlashCard>
    with SingleTickerProviderStateMixin {
  /// controller flip animation
  late AnimationController _controller;

  /// animation for flip from front to back
  late Animation<double> _frontAnimation;

  ///animation for flip from back  to front
  late Animation<double> _backAnimation;

  /// state of card is front or back
  bool isFrontVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _frontAnimation = widget.frontAnimation ??
        TweenSequence(
          <TweenSequenceItem<double>>[
            TweenSequenceItem<double>(
              tween: Tween(begin: 0.0, end: math.pi / 2)
                  .chain(CurveTween(curve: Curves.linear)),
              weight: 50.0,
            ),
            TweenSequenceItem<double>(
              tween: ConstantTween<double>(math.pi / 2),
              weight: 50.0,
            ),
          ],
        ).animate(_controller);

    _backAnimation = widget.backAnimation ??
        TweenSequence(
          <TweenSequenceItem<double>>[
            TweenSequenceItem<double>(
              tween: ConstantTween<double>(math.pi / 2),
              weight: 50.0,
            ),
            TweenSequenceItem<double>(
              tween: Tween(begin: -math.pi / 2, end: 0.0)
                  .chain(CurveTween(curve: Curves.linear)),
              weight: 50.0,
            ),
          ],
        ).animate(_controller);
    if (widget.frontColor != null && widget.frontGradient != null) {
      throw ArgumentError('Cannot provide both a color and a gradient.\n'
          'To have a gradient, use "gradient: LinearGradient(colors: [/* ... */])"');
    }
    if (widget.backColor != null && widget.backGradient != null) {
      throw ArgumentError('Cannot provide both a color and a gradient.\n'
          'To have a gradient, use "gradient: LinearGradient(colors: [/* ... */])"');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //back card
        GestureDetector(
          onTap: _toggleSide,
          child: AnimatedCard(
            animation: _frontAnimation,
            height: widget.height,
            width: widget.width,
            color: widget.frontColor ?? Colors.white,
            gradient: widget.frontGradient,
            child: widget.frontWidget,
            borderRadius: widget.borderRadius,
            border: widget.border,
          ),
        ),

        //front card
        GestureDetector(
          onTap: _toggleSide,
          child: AnimatedCard(
            animation: _backAnimation,
            height: widget.height,
            width: widget.width,
            color: widget.backColor ?? Colors.white,
            gradient: widget.backGradient,
            child: widget.backWidget,
            borderRadius: widget.borderRadius,
            border: widget.border,
          ),
        ),
      ],
    );
  }

  /// when user onTap, It will run function
  void _toggleSide() {
    widget.ontap.call();
    widget.onFlip
        ?.call((isFrontVisible) ? FlashCardSide.back : FlashCardSide.front);
    if (isFrontVisible) {
      _controller.forward();
      isFrontVisible = false;
    } else {
      _controller.reverse();
      isFrontVisible = true;
    }
  }
}

class AnimatedCard extends StatelessWidget {
  const AnimatedCard(
      {required this.child,
      required this.animation,
      required this.height,
      required this.width,
      this.color,
      this.gradient,
      this.borderRadius,
      this.border,
      Key? key})
      : super(key: key);

  final Widget child;
  final Animation<double> animation;
  final double height;
  final double width;
  final Color? color;
  final Gradient? gradient;
  final double? borderRadius;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: _builder,
      child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          borderOnForeground: false,
          child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: color,
                gradient: gradient,
                borderRadius: BorderRadius.circular(borderRadius ?? 20),
                border: border,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: child,
              ))),
    );
  }

  Widget _builder(BuildContext context, Widget? child) {
    var transform = Matrix4.identity();
    transform.setEntry(3, 2, 0.001);
    transform.rotateY(animation.value);
    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: child,
    );
  }
}
