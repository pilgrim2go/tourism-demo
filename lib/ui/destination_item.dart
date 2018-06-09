import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iraqiairways_demo/app_colors.dart';
import 'package:iraqiairways_demo/models/models.dart';
import 'dart:math' as math;

import 'package:iraqiairways_demo/utils.dart';
import 'package:iraqiairways_demo/wavy_clipper.dart';

class DestinationItem extends AnimatedWidget {
  DestinationItem({
    Key key,
    Animation<double> animation,
    @required this.destination,
    @required this.onTapped,
  }) : super(key: key, listenable: animation);

  final Destination destination;
  final VoidCallback onTapped;

  final double itemHeight = 175.0;

  static BoxDecoration _buildDecorations() {
    return const BoxDecoration(
      color: Colors.black38,
    );
  }

  Widget rotateBy(double degrees) {
    return new Transform(
        child: _buildCarItem(),
        alignment: FractionalOffset.topCenter,
        transform: perspective.scaled(1.0, 1.0, 1.0)
          ..rotateX(math.pi - degrees * math.pi / 180)
        // ..rotateY(math.pi - degrees * math.pi / 180)
        // ..rotateZ(math.pi - degrees * math.pi / 180)
        );
  }

  Widget _buildImage() {
    return new ClipPath(
        clipper: NotchedClipper(topLeft: false, topRight: false),
        child: new Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0),
          child: new Container(
            height: itemHeight,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new ExactAssetImage(destination.photo),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ));
  }

  Widget _buildTextualInfo() {
    return new ClipPath(
      clipper: NotchedClipper(bottomLeft: false, bottomRight: false),
      child: Container(
        color: Colors.grey[300],
        margin: const EdgeInsets.all(0.0),
        // shape: BeveledRectangleBorder(
        //     borderRadius: const BorderRadius.only(
        //         bottomLeft: const Radius.circular(20.0),
        //         bottomRight: const Radius.circular(20.0))),
        // shape: CircleBorder(side: const BorderSide(width: 10.0)),
        child: new Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(destination.title,
                    style: new TextStyle(
                      color: AppColors.primaryTextColor,
                      fontSize: 26.0,
                    )),
                new Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(destination.shortDescription,
                      style: new TextStyle(
                        color: AppColors.secondaryTextColor,
                        fontFamily: 'GE SS Light',
                        fontSize: 14.0,
                      )),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildCarItem() {
    return InkWell(
      onTap: onTapped,
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: new Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildImage(),
                _buildTextualInfo(),
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return rotateBy(animation.value);
  }
}

class DestinationCard extends StatefulWidget {
  final int initialDelay;
  final Destination destination;
  final VoidCallback onTapped;

  const DestinationCard(
      {Key key, this.initialDelay, this.destination, this.onTapped})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _CardState();
  }
}

class _CardState extends State<DestinationCard>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  Timer _timer;

  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    var curvedAnimation =
        new CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    animation =
        new Tween<double>(begin: 90.0, end: 180.0).animate(curvedAnimation);

    _timer = new Timer(Duration(milliseconds: widget.initialDelay), () {
      controller.forward();
    });
  }

  Widget build(BuildContext context) {
    return new DestinationItem(
      animation: animation,
      destination: widget.destination,
      onTapped: widget.onTapped,
    );
  }

  dispose() {
    controller.dispose();
    _timer.cancel();
    super.dispose();
  }
}
