import 'package:flutter/widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// 앱 전역에서 사용하는 디바이스 폼 팩터 정의.
enum DeviceFormFactor { mobile, tablet, desktop, fourK }

/// 반응형 레이아웃을 빌드할 때 사용할 빌더 타입.
typedef ResponsiveWidgetBuilder = Widget Function(
  BuildContext context,
  DeviceFormFactor formFactor,
);

/// 공통 Breakpoint 기반으로 formFactor를 전달하는 헬퍼 위젯.
class ResponsiveLayoutBuilder extends StatelessWidget {
  const ResponsiveLayoutBuilder({
    required this.builder,
    this.child,
    super.key,
  });

  final ResponsiveWidgetBuilder builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final DeviceFormFactor factor = context.deviceFormFactor;
    return builder(context, factor);
  }
}

/// BuildContext에 빈번하게 쓰이는 폼 팩터 유틸리티 확장.
extension ResponsiveBuildContext on BuildContext {
  DeviceFormFactor get deviceFormFactor =>
      _ResponsiveHelper.resolveFormFactor(this);

  bool get isMobileLayout => deviceFormFactor == DeviceFormFactor.mobile;
  bool get isTabletLayout => deviceFormFactor == DeviceFormFactor.tablet;
  bool get isDesktopLayout => deviceFormFactor == DeviceFormFactor.desktop;
  bool get isFourKLayout => deviceFormFactor == DeviceFormFactor.fourK;

  /// 폼 팩터별 열 개수를 간단하게 선택.
  int responsiveColumns({
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
    int fourK = 4,
  }) =>
      _ResponsiveHelper.pickValue<int>(
        formFactor: deviceFormFactor,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
        fourK: fourK,
      );

  /// 페이지 패딩을 화면 크기에 맞게 변환.
  EdgeInsets responsivePagePadding({
    EdgeInsets mobile = const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    EdgeInsets tablet = const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    EdgeInsets desktop = const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
    EdgeInsets fourK = const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
  }) =>
      _ResponsiveHelper.pickValue<EdgeInsets>(
        formFactor: deviceFormFactor,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
        fourK: fourK,
      );
}

/// 실제 Breakpoint 값을 해석하는 내부 헬퍼.
class _ResponsiveHelper {
  static DeviceFormFactor resolveFormFactor(BuildContext context) {
    final ResponsiveBreakpointsData data = ResponsiveBreakpoints.of(context);
    if (data.largerThan(DESKTOP) || data.equals('4K')) {
      return DeviceFormFactor.fourK;
    }
    if (data.largerThan(TABLET) || data.equals(DESKTOP)) {
      return DeviceFormFactor.desktop;
    }
    if (data.largerThan(MOBILE) || data.equals(TABLET)) {
      return DeviceFormFactor.tablet;
    }
    return DeviceFormFactor.mobile;
  }

  static T pickValue<T>({
    required DeviceFormFactor formFactor,
    required T mobile,
    required T tablet,
    required T desktop,
    required T fourK,
  }) {
    switch (formFactor) {
      case DeviceFormFactor.mobile:
        return mobile;
      case DeviceFormFactor.tablet:
        return tablet;
      case DeviceFormFactor.desktop:
        return desktop;
      case DeviceFormFactor.fourK:
        return fourK;
    }
  }
}
