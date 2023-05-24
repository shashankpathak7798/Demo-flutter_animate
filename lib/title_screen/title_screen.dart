import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:next_gen_ui/title_screen/particle_overlay.dart';
import 'package:next_gen_ui/title_screen/title_screen_ui.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen({Key? key}) : super(key: key);

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  final _finalReceiveLightAmt = 0.7;

  final _finalEmitLightAmt = 0.5;

  Color get _emitColor =>
      AppColors.emitColors[_difficultyOverride ?? _difficulty];

  Color get _orbColor =>
      AppColors.orbColors[_difficultyOverride ?? _difficulty];

  /// Currently selected difficulty
  int _difficulty = 0;

  /// Currently focused difficulty (if any)
  int? _difficultyOverride;

  final double _orbEnergy = 0;

  void _handleDifficultyPressed(int value) {
    setState(() => _difficulty = value);
  }

  void _handleDifficultyFocused(int? value) {
    setState(() => _difficultyOverride = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: MouseRegion(
          child: _AnimatedColors(
            orbColor: _orbColor,
            emitColor: _emitColor,
            builder: (_, orbColor, emitColor) {
              return Stack(
                children: [
                  /// Bg-Base
                  Image.asset("assets/images/bg-base.jpg"),

                  /// Bg-Receive
                  _LitImage(
                      color: _orbColor,
                      imgSrc: "assets/images/bg-light-receive.png",
                      lightAmt: _finalReceiveLightAmt),

                  /// Mg-Base
                  _LitImage(
                      color: _orbColor,
                      imgSrc: "assets/images/mg-base.png",
                      lightAmt: _finalReceiveLightAmt),

                  /// Mg-Receive
                  _LitImage(
                      color: _orbColor,
                      imgSrc: "assets/images/mg-light-receive.png",
                      lightAmt: _finalReceiveLightAmt),

                  /// Mg-Emit
                  _LitImage(
                      color: _emitColor,
                      imgSrc: "assets/images/mg-light-emit.png",
                      lightAmt: _finalEmitLightAmt),

                  /// Particle Field
                  Positioned.fill(
                    child: IgnorePointer(
                      child: ParticleOverlay(
                        color: orbColor,
                        energy: _orbEnergy,
                      ),
                    ),
                  ),

                  /// Fg-Rocks
                  Image.asset("assets/images/fg-base.png"),

                  /// Fg-Receive
                  _LitImage(
                      color: _orbColor,
                      imgSrc: "assets/images/fg-light-receive.png",
                      lightAmt: _finalReceiveLightAmt),

                  /// Fg-Emit
                  _LitImage(
                      color: _emitColor,
                      imgSrc: "assets/images/fg-light-emit.png",
                      lightAmt: _finalEmitLightAmt),

                  /// UI
                  Positioned.fill(
                    child: TitleScreenUI(
                      difficulty: _difficulty,
                      onDifficultyPressed: _handleDifficultyPressed,
                      onDifficultyFocused: _handleDifficultyFocused,
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 1.seconds, delay: .3.seconds,);
            },
          ),
        ),
      ),
    );
  }
}

abstract class AppColors {
  static const orbColors = [
    Color(0xFF71FDBF),
    Color(0xFFCE33FF),
    Color(0xFFFF5033),
  ];

  static const emitColors = [
    Color(0xFF96FF33),
    Color(0xFF00FFFF),
    Color(0xFFFF993E),
  ];
}

class _LitImage extends StatelessWidget {
  const _LitImage({
    required this.color,
    required this.imgSrc,
    required this.lightAmt,
  });

  final Color color;
  final String imgSrc;
  final double lightAmt;

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(color);

    return Image.asset(
      imgSrc,
      color: hsl.withLightness(hsl.lightness * lightAmt).toColor(),
      colorBlendMode: BlendMode.modulate,
    );
  }
}


class _AnimatedColors extends StatelessWidget {
  const _AnimatedColors({
    required this.emitColor,
    required this.orbColor,
    required this.builder,
  });

  final Color emitColor;
  final Color orbColor;

  final Widget Function(BuildContext context, Color orbColor, Color emitColor)
  builder;

  @override
  Widget build(BuildContext context) {
    final duration = .5.seconds;
    return TweenAnimationBuilder(
      tween: ColorTween(begin: emitColor, end: emitColor),
      duration: duration,
      builder: (_, emitColor, __) {
        return TweenAnimationBuilder(
          tween: ColorTween(begin: orbColor, end: orbColor),
          duration: duration,
          builder: (context, orbColor, __) {
            return builder(context, orbColor!, emitColor!);
          },
        );
      },
    );
  }
}
