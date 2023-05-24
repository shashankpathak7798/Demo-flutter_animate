import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:focusable_control_builder/focusable_control_builder.dart';

class TitleScreenUI extends StatelessWidget {
  const TitleScreenUI({Key? key, required this.difficulty, required this.onDifficultyPressed, required this.onDifficultyFocused,}) : super(key: key);

  final int difficulty;
  final void Function(int difficulty) onDifficultyPressed;
  final void Function(int? difficulty) onDifficultyFocused;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 40,
        horizontal: 50,
      ),
      child: Stack(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: _TitleText(),
          ),

          Align(
            alignment: Alignment.bottomLeft,
            child: _DifficultyBtns(
              difficulty: difficulty,
              onDifficultyPressed: onDifficultyPressed,
              onDifficultyFocused: onDifficultyFocused,
            ),
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20, right: 40,),
              child: _StartBtn(onPressed: () {}),
            ),
          )

        ],
      ),
    );
  }
}



class _StartBtn extends StatefulWidget {
  const _StartBtn({required this.onPressed});
  final VoidCallback onPressed;

  @override
  State<_StartBtn> createState() => _StartBtnState();
}

class _StartBtnState extends State<_StartBtn> {
  AnimationController? _btnAnim;
  bool _wasHovered = false;

  @override
  Widget build(BuildContext context) {
    return FocusableControlBuilder(
      cursor: SystemMouseCursors.click,
      onPressed: widget.onPressed,
      builder: (_, state) {
        if ((state.isHovered || state.isFocused) &&
            !_wasHovered &&
            _btnAnim?.status != AnimationStatus.forward) {
          _btnAnim?.forward(from: 0);
        }
        _wasHovered = (state.isHovered || state.isFocused);
        return SizedBox(
          width: 520,
          height: 100,
          child: Stack(
            children: [
              Positioned.fill(child: Image.asset("assets/images/button-start.png"),),
              if (state.isHovered || state.isFocused) ...[
                Positioned.fill(
                    child: Image.asset("assets/images/button-start-hover.png"),),
              ],
              const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('START MISSION',
                        style: TextStyle(fontSize: 24, letterSpacing: 18, fontWeight: FontWeight.bold,),),
                  ],
                ),
              ),
            ],
          ).animate(autoPlay: false, onInit: (c) => _btnAnim = c)
              .shimmer(duration: .7.seconds, color: Colors.black),
        ).animate()
            .fadeIn(delay: 2.3.seconds)
            .slide(begin: const Offset(0, .2),);
      },
    );
  }
}




class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: const Offset(-(35 * 0.5), 0),
              child: const Text("OUTPOST", style: TextStyle(fontSize: 75, letterSpacing: 35, fontWeight: FontWeight.w700),),
            ),
            Image.asset("assets/images/select-left.png", height: 65),
            const Text('57', style: TextStyle(fontSize: 40, letterSpacing: 0, fontWeight: FontWeight.w700),),
            Image.asset("assets/images/select-right.png", height: 65),
          ],
        ).animate().fadeIn(delay: .8.seconds, duration: .7.seconds),
        const Text('INTO THE UNKNOWN', style: TextStyle(fontSize: 24, letterSpacing: 20, fontWeight: FontWeight.w400),).animate().fadeIn(delay: 1.seconds, duration: .7.seconds,),
      ],
    );
  }
}




class _DifficultyBtns extends StatelessWidget {
  const _DifficultyBtns({
    required this.difficulty,
    required this.onDifficultyPressed,
    required this.onDifficultyFocused,
  });

  final int difficulty;
  final void Function(int difficulty) onDifficultyPressed;
  final void Function(int? difficulty) onDifficultyFocused;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DifficultyBtn(
          label: 'Casual',
          selected: difficulty == 0,
          onPressed: () => onDifficultyPressed(0),
          onHover: (over) => onDifficultyFocused(over ? 0 : null),
        ).animate().fadeIn(delay: 1.3.seconds, duration: .35.seconds)
            .slide(begin: const Offset(0, .2),),
        _DifficultyBtn(
          label: 'Normal',
          selected: difficulty == 1,
          onPressed: () => onDifficultyPressed(1),
          onHover: (over) => onDifficultyFocused(over ? 1 : null),
        ).animate().fadeIn(delay: 1.5.seconds, duration: .35.seconds)
            .slide(begin: const Offset(0, .2),),
        _DifficultyBtn(
          label: 'Hardcore',
          selected: difficulty == 2,
          onPressed: () => onDifficultyPressed(2),
          onHover: (over) => onDifficultyFocused(over ? 2 : null),
        ).animate().fadeIn(delay: 1.7.seconds, duration: .35.seconds)
            .slide(begin: const Offset(0, .2),),
        const SizedBox(height: 20,),
      ],
    );
  }
}

class _DifficultyBtn extends StatelessWidget {
  const _DifficultyBtn({
    required this.selected,
    required this.onPressed,
    required this.onHover,
    required this.label,
  });
  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final void Function(bool hasFocus) onHover;

  @override
  Widget build(BuildContext context) {
    return FocusableControlBuilder(
      onPressed: onPressed,
      onHoverChanged: (_, state) => onHover.call(state.isHovered),
      builder: (_, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 250,
            height: 60,
            child: Stack(
              children: [
                /// Bg with fill and outline
                AnimatedOpacity(
                  opacity: (!selected && (state.isHovered || state.isFocused) ) ? 1 : 0,
                  duration: .3.seconds,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D1FF).withOpacity(.1),
                      border: Border.all(color: Colors.white, width: 5),
                    ),
                  ),
                ),

                if (state.isHovered || state.isFocused) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D1FF).withOpacity(.1),
                    ),
                  ),
                ],

                /// cross-hairs (selected state)
                if (selected) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset("assets/images/select-left.png"),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset("assets/images/select-right.png"),
                  ),
                ],

                /// Label
                Center(
                  child: Text(label.toUpperCase(), style: const TextStyle(fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 10,),),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}