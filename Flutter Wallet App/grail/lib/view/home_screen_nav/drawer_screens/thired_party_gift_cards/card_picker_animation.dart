import 'dart:ui';

import 'package:flutter/material.dart';

class NewChatItemLongPressDialog extends StatefulWidget {
  final VoidCallback _onItemPressed;
  final Widget _firstChild;
  final Widget _secondChild;

  const NewChatItemLongPressDialog({
    Key? key,
    required VoidCallback onItemPressed,
    required Widget firstChild,
    required Widget secondChild,
  })  : _onItemPressed = onItemPressed,
        _firstChild = firstChild,
        _secondChild = secondChild,
        super(key: key);

  @override
  State<NewChatItemLongPressDialog> createState() =>
      _NewChatItemLongPressDialogState();
}

class _NewChatItemLongPressDialogState extends State<NewChatItemLongPressDialog>
    with TickerProviderStateMixin {
  late AnimationController _moreOptionsAnimationController;

  late Animation<double> _moreOptionScaleAnimation;

  late AnimationController _chatAnimationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chatAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 375),
      reverseDuration: const Duration(milliseconds: 300),
    );
    _moreOptionsAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 375),
      reverseDuration: const Duration(milliseconds: 300),
    );
    _moreOptionScaleAnimation = Tween(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
            parent: _moreOptionsAnimationController,
            curve: Curves.ease,
            reverseCurve: Curves.easeOut));
    _moreOptionsAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          _moreOptionsAnimationController.reverse();
          _chatAnimationController.reverse();
          Future.delayed(const Duration(milliseconds: 150), () {
            Navigator.of(context).pop();
            Future.delayed(const Duration(milliseconds: 150), () {
              _moreOptionsAnimationController.reset();
              _chatAnimationController.reset();
            });
          });
        },
        child: SafeArea(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 4.5,
              sigmaY: 4.5,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                // controller: dialogScrollController,
                child: Column(
                  children: [
                    NewFencyFirstSheet(
                      screenContext: context,
                      firstChild: widget._firstChild,
                      chatAnimationController: _chatAnimationController,
                      onPressed: widget._onItemPressed,
                    ),
                    AnimatedBuilder(
                        animation: _moreOptionScaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _moreOptionScaleAnimation.value,
                            alignment: Alignment.topLeft,
                            child: FadeTransition(
                              opacity: _moreOptionScaleAnimation,
                              child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: widget._secondChild
                                  // Container(
                                  //   width: 230,
                                  //   height: 162,
                                  //   margin: const EdgeInsets.symmetric(
                                  //       horizontal: 15),
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.white.withOpacity(0.8),
                                  //     borderRadius: const BorderRadius.all(
                                  //         Radius.circular(15)),
                                  //   ),
                                  //   child: const Column(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [],
                                  //   ),
                                  // ),
                                  ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NewFencyFirstSheet extends StatefulWidget {
  final BuildContext screenContext;
  final VoidCallback onPressed;

  final AnimationController chatAnimationController;
  final Widget firstChild;

  const NewFencyFirstSheet(
      {required this.screenContext,
      required this.onPressed,
      required this.firstChild,
      Key? key,
      required this.chatAnimationController})
      : super(key: key);

  @override
  State<NewFencyFirstSheet> createState() => _NewFencyFirstSheetState();
}

class _NewFencyFirstSheetState extends State<NewFencyFirstSheet> {
  late Animation<double> chatScaleAnimation;
  late Animation<double> chatWidthScaleAnimation;

  @override
  void initState() {
    chatScaleAnimation = Tween(begin: 0.2, end: 1.0).animate(CurvedAnimation(
        parent: widget.chatAnimationController,
        curve: Curves.ease,
        reverseCurve: Curves.easeOut));

    chatWidthScaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.chatAnimationController,
            curve: Curves.ease,
            reverseCurve: Curves.easeOut));

    super.initState();
    widget.chatAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: chatScaleAnimation,
      builder: (context, child) {
        return SizedBox(
          height: (MediaQuery.of(context).size.height * 0.60),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: FadeTransition(
              opacity: chatScaleAnimation,
              child: Container(
                height: (MediaQuery.of(context).size.height * 0.61) *
                    chatScaleAnimation.value,
                margin: EdgeInsets.all(15 * chatWidthScaleAnimation.value),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 2.5),
                child: Stack(
                  clipBehavior: Clip.antiAlias,
                  children: [widget.firstChild],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
