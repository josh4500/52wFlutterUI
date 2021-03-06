import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shoe_shop/model/product.dart';
import 'package:shoe_shop/provider/liked_provider.dart';
import 'package:shoe_shop/ui/shoe_details/shoe_details.dart';
import 'package:shoe_shop/util/constant.dart';

import 'package:flutter/material.dart';

class AnimatedShoeCard extends StatefulWidget {
  const AnimatedShoeCard({
    Key? key,
    required this.color,
    required this.index,
    required this.width,
    required this.height,
    required this.isView,
    required this.child,
    required this.product,
    this.showNext = true,
    this.nextCard,
  }) : super(key: key);
  final int index;
  final Color color;
  final double width;
  final double height;
  final bool isView;
  final bool showNext;
  final VoidCallback? nextCard;
  final Widget child;
  final Product product;

  @override
  _AnimatedShoeCardState createState() => _AnimatedShoeCardState();
}

class _AnimatedShoeCardState extends State<AnimatedShoeCard> {
  double get width => widget.width - (widget.width * 0.2);
  double get height => widget.height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ShoeDetails(
              index: widget.index,
              color: widget.color,
              product: widget.product,
            ),
          ),
        );
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: widget.isView ? 1.0 : 0.9,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: TweenAnimationBuilder(
              duration: const Duration(milliseconds: 350),
              curve: Curves.bounceInOut,
              tween: Tween<double>(begin: 0.05, end: widget.isView ? 0 : -0.1),
              builder: (context, double angle, _) {
                return Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle * math.pi),
                      decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.product.brand,
                                style: SHOESHOP.SHOECARD_TITLE,
                              ),
                              const Spacer(),
                              Consumer<LikedProvider>(
                                builder: (context, liked, _) {
                                  return GestureDetector(
                                    onTap: () {
                                      liked.isLiked(widget.product.id)
                                          ? liked.removeLiked(widget.product.id)
                                          : liked.addLiked(widget.product.id);
                                    },
                                    child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      child: liked.isLiked(widget.product.id)
                                          ? const Icon(
                                              Icons.favorite,
                                              key: Key('liked'),
                                              color: Colors.white,
                                            )
                                          : const Icon(
                                              Icons.favorite_outline,
                                              key: Key('not_liked'),
                                              color: Colors.white,
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Text(
                            widget.product.name,
                            style: SHOESHOP.SHOECARD_SHOENAME,
                          ),
                          Text(
                            "\$${widget.product.price}",
                            style: SHOESHOP.SHOECARD_SHOEPRICE,
                          ),
                          const Spacer(),
                          if (widget.showNext)
                            InkWell(
                              onTap: widget.nextCard,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: const RotatedBox(
                                  quarterTurns: 2,
                                  child: Icon(
                                    Icons.keyboard_backspace,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                    // Positioned(
                    //   bottom: 110,
                    //   right: 5,
                    //   child: Transform.rotate(
                    //     angle: -0.3,
                    //     child: PhysicalModel(
                    //       shape: BoxShape.circle,
                    //       elevation: 8.0,
                    //       color: Colors.transparent,
                    //       shadowColor: Colors.black,
                    //       child: SizedBox(
                    //         width: width * 0.8,
                    //         height: 30,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      right: -20,
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateZ(angle * math.pi)
                          ..translate(0.2),
                        child: Transform.rotate(
                          angle: -0.3,
                          child: SizedBox(
                            width: width * 0.8,
                            child: widget.child,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
