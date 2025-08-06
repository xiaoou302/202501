import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const SplashScreen({Key? key, required this.nextScreen}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // 控制图标动画
  late AnimationController _iconAnimController;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconRotateAnimation;

  // 控制光晕效果
  late AnimationController _glowAnimController;
  late Animation<double> _glowAnimation;

  // 控制文字动画
  late AnimationController _textAnimController;
  late Animation<double> _textAnimation;

  // 控制背景粒子
  late AnimationController _particleAnimController;

  // 控制加载进度
  late AnimationController _progressAnimController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // 图标动画控制器
    _iconAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _iconScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2).chain(
          CurveTween(curve: Curves.easeOutQuad),
        ),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0).chain(
          CurveTween(curve: Curves.easeInOutQuad),
        ),
        weight: 60,
      ),
    ]).animate(_iconAnimController);

    _iconRotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(
      CurvedAnimation(
        parent: _iconAnimController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutQuad),
      ),
    );

    // 光晕动画控制器
    _glowAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _glowAnimController,
        curve: Curves.easeInOutQuad,
      ),
    );

    // 文字动画控制器
    _textAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutQuad),
      ),
    );

    // 粒子动画控制器
    _particleAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10000),
    )..repeat();

    // 进度动画控制器
    _progressAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressAnimController,
        curve: Curves.easeInOut,
      ),
    );

    // 启动动画序列
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    // 启动图标动画
    _iconAnimController.forward();

    // 延迟启动文字动画
    await Future.delayed(const Duration(milliseconds: 600));
    _textAnimController.forward();

    // 启动进度动画
    _progressAnimController.forward();

    // 动画完成后导航到主界面
    _progressAnimController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                widget.nextScreen,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = 0.0;
              const end = 1.0;
              var curve = Curves.easeInOutQuart;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var fadeAnimation = animation.drive(tween);

              return FadeTransition(
                opacity: fadeAnimation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _iconAnimController.dispose();
    _glowAnimController.dispose();
    _textAnimController.dispose();
    _particleAnimController.dispose();
    _progressAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.midnightBlue,
      body: Stack(
        children: [
          // 背景粒子效果
          AnimatedBuilder(
            animation: _particleAnimController,
            builder: (context, child) {
              return CustomPaint(
                size: Size(size.width, size.height),
                painter: ParticlesPainter(
                  animation: _particleAnimController.value,
                ),
              );
            },
          ),

          // 中央内容
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 图标和光晕
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // 光晕效果
                    AnimatedBuilder(
                      animation: _glowAnimController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _glowAnimation.value,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.fieryRed.withOpacity(0.3),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                                BoxShadow(
                                  color: AppColors.coolBlue.withOpacity(0.2),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    // 图标
                    AnimatedBuilder(
                      animation: _iconAnimController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _iconScaleAnimation.value,
                          child: Transform.rotate(
                            angle: _iconRotateAnimation.value,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.fieryRed,
                                    AppColors.coolBlue,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.auto_graph,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // 应用名称
                AnimatedBuilder(
                  animation: _textAnimController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textAnimation.value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - _textAnimation.value)),
                        child: const Text(
                          'CoinAtlas',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 8,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),

                // 副标题
                AnimatedBuilder(
                  animation: _textAnimController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _textAnimation.value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - _textAnimation.value)),
                        child: Text(
                          '金融市场分析工具',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 2,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 60),

                // 自定义加载指示器
                AnimatedBuilder(
                  animation: _progressAnimController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(200, 4),
                      painter: LoadingIndicatorPainter(
                        progress: _progressAnimation.value,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 粒子效果绘制器
class ParticlesPainter extends CustomPainter {
  final double animation;
  final List<Particle> particles = List.generate(
    30,
    (index) => Particle(
      position: Offset(
        math.Random().nextDouble() * 400,
        math.Random().nextDouble() * 800,
      ),
      speed: math.Random().nextDouble() * 0.5 + 0.1,
      radius: math.Random().nextDouble() * 3 + 1,
      color: [
        AppColors.fieryRed.withOpacity(0.3),
        AppColors.coolBlue.withOpacity(0.3),
        AppColors.goldenHighlight.withOpacity(0.3),
      ][math.Random().nextInt(3)],
    ),
  );

  ParticlesPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // 更新粒子位置
      final offset = Offset(
        (particle.position.dx + animation * particle.speed * 100) % size.width,
        (particle.position.dy - animation * particle.speed * 50) % size.height,
      );

      // 绘制粒子
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(offset, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) => true;
}

// 粒子类
class Particle {
  Offset position;
  double speed;
  double radius;
  Color color;

  Particle({
    required this.position,
    required this.speed,
    required this.radius,
    required this.color,
  });
}

// 自定义加载指示器绘制器
class LoadingIndicatorPainter extends CustomPainter {
  final double progress;

  LoadingIndicatorPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // 背景轨道
    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      trackPaint,
    );

    // 进度指示器
    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColors.fieryRed,
          AppColors.coolBlue,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width * progress, size.height / 2),
      progressPaint,
    );

    // 进度指示器末端的光晕效果
    if (progress > 0) {
      final glowPaint = Paint()
        ..color = AppColors.coolBlue.withOpacity(0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(
        Offset(size.width * progress, size.height / 2),
        6,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(LoadingIndicatorPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
