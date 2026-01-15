/// ROLE
/// - 앱 공통 카드 위젯을 제공한다
///
/// RESPONSIBILITY
/// - 카드 스타일/상호작용을 표준화한다
/// - 테마 기반 기본값을 제공한다
///
/// DEPENDS ON
/// - flutter
library;

import 'package:flutter/material.dart';

enum CustomCardVariant {
  surface,
  elevated,
  outlined,
  subtle,
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    required this.child,
    this.variant = CustomCardVariant.surface,
    this.padding = const EdgeInsets.all(24),
    this.margin,
    this.elevation = 2,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1,
    this.radius = 16,
    this.clipBehavior = Clip.antiAlias,
    this.onTap,
    this.onLongPress,
    this.width,
    this.height,
    this.constraints,
    super.key,
  });

  /// 일반 정보/섹션 카드 용도.
  const CustomCard.surface({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(24),
    EdgeInsetsGeometry? margin,
    double? elevation,
    Color? backgroundColor,
    Color? borderColor,
    double borderWidth = 1,
    double radius = 16,
    Clip clipBehavior = Clip.antiAlias,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    double? width,
    double? height,
    BoxConstraints? constraints,
    Key? key,
  }) : this(
          key: key,
          child: child,
          variant: CustomCardVariant.surface,
          padding: padding,
          margin: margin,
          elevation: elevation,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderWidth: borderWidth,
          radius: radius,
          clipBehavior: clipBehavior,
          onTap: onTap,
          onLongPress: onLongPress,
          width: width,
          height: height,
          constraints: constraints,
        );

  /// 강조가 필요한 카드 용도.
  const CustomCard.elevated({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(24),
    EdgeInsetsGeometry? margin,
    double? elevation,
    Color? backgroundColor,
    Color? borderColor,
    double borderWidth = 1,
    double radius = 16,
    Clip clipBehavior = Clip.antiAlias,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    double? width,
    double? height,
    BoxConstraints? constraints,
    Key? key,
  }) : this(
          key: key,
          child: child,
          variant: CustomCardVariant.elevated,
          padding: padding,
          margin: margin,
          elevation: elevation,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderWidth: borderWidth,
          radius: radius,
          clipBehavior: clipBehavior,
          onTap: onTap,
          onLongPress: onLongPress,
          width: width,
          height: height,
          constraints: constraints,
        );

  /// 리스트/중립 카드 용도.
  const CustomCard.outlined({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(24),
    EdgeInsetsGeometry? margin,
    double? elevation,
    Color? backgroundColor,
    Color? borderColor,
    double borderWidth = 1,
    double radius = 16,
    Clip clipBehavior = Clip.antiAlias,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    double? width,
    double? height,
    BoxConstraints? constraints,
    Key? key,
  }) : this(
          key: key,
          child: child,
          variant: CustomCardVariant.outlined,
          padding: padding,
          margin: margin,
          elevation: elevation,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderWidth: borderWidth,
          radius: radius,
          clipBehavior: clipBehavior,
          onTap: onTap,
          onLongPress: onLongPress,
          width: width,
          height: height,
          constraints: constraints,
        );

  /// 배경 구분이 필요한 서브 카드 용도.
  const CustomCard.subtle({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(24),
    EdgeInsetsGeometry? margin,
    double? elevation,
    Color? backgroundColor,
    Color? borderColor,
    double borderWidth = 1,
    double radius = 16,
    Clip clipBehavior = Clip.antiAlias,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    double? width,
    double? height,
    BoxConstraints? constraints,
    Key? key,
  }) : this(
          key: key,
          child: child,
          variant: CustomCardVariant.subtle,
          padding: padding,
          margin: margin,
          elevation: elevation,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderWidth: borderWidth,
          radius: radius,
          clipBehavior: clipBehavior,
          onTap: onTap,
          onLongPress: onLongPress,
          width: width,
          height: height,
          constraints: constraints,
        );

  /// 클릭 가능한 카드 용도.
  const CustomCard.action({
    required Widget child,
    required VoidCallback onTap,
    EdgeInsetsGeometry padding = const EdgeInsets.all(24),
    EdgeInsetsGeometry? margin,
    double? elevation,
    Color? backgroundColor,
    Color? borderColor,
    double borderWidth = 1,
    double radius = 16,
    Clip clipBehavior = Clip.antiAlias,
    VoidCallback? onLongPress,
    double? width,
    double? height,
    BoxConstraints? constraints,
    Key? key,
  }) : this(
          key: key,
          child: child,
          variant: CustomCardVariant.surface,
          padding: padding,
          margin: margin,
          elevation: elevation,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderWidth: borderWidth,
          radius: radius,
          clipBehavior: clipBehavior,
          onTap: onTap,
          onLongPress: onLongPress,
          width: width,
          height: height,
          constraints: constraints,
        );

  /// 패딩이 작은 컴팩트 카드 용도.
  const CustomCard.compact({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(12),
    EdgeInsetsGeometry? margin,
    double? elevation,
    Color? backgroundColor,
    Color? borderColor,
    double borderWidth = 1,
    double radius = 16,
    Clip clipBehavior = Clip.antiAlias,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    double? width,
    double? height,
    BoxConstraints? constraints,
    Key? key,
  }) : this(
          key: key,
          child: child,
          variant: CustomCardVariant.surface,
          padding: padding,
          margin: margin,
          elevation: elevation,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderWidth: borderWidth,
          radius: radius,
          clipBehavior: clipBehavior,
          onTap: onTap,
          onLongPress: onLongPress,
          width: width,
          height: height,
          constraints: constraints,
        );

  final Widget child;
  final CustomCardVariant variant;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double radius;
  final Clip clipBehavior;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final CardThemeData cardTheme = theme.cardTheme;
    final ColorScheme scheme = theme.colorScheme;
    final double resolvedElevation =
        elevation ?? cardTheme.elevation ?? _resolveElevation(variant);
    final Color resolvedBackground = backgroundColor ??
        cardTheme.color ??
        _resolveBackgroundColor(scheme, variant);
    final Color resolvedBorderColor =
        borderColor ?? _resolveBorderColor(scheme, variant);
    final double resolvedBorderWidth =
        _resolveBorderWidth(resolvedBorderColor);
    final ShapeBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(color: resolvedBorderColor, width: resolvedBorderWidth),
    );
    final Widget content = _buildContent();
    final Card card = Card(
      elevation: resolvedElevation,
      margin: margin,
      color: resolvedBackground,
      shadowColor: cardTheme.shadowColor,
      shape: shape,
      clipBehavior: clipBehavior,
      child: content,
    );
    return _wrapConstraints(card);
  }

  Widget _buildContent() {
    final Widget padded = Padding(padding: padding, child: child);
    if (onTap == null && onLongPress == null) {
      return padded;
    }
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(radius),
      child: padded,
    );
  }

  Widget _wrapConstraints(Widget child) {
    Widget current = child;
    if (constraints != null) {
      current = ConstrainedBox(constraints: constraints!, child: current);
    }
    if (width != null || height != null) {
      current = SizedBox(width: width, height: height, child: current);
    }
    return current;
  }

  double _resolveElevation(CustomCardVariant variant) {
    switch (variant) {
      case CustomCardVariant.surface:
        return 4;
      case CustomCardVariant.elevated:
        return 6;
      case CustomCardVariant.outlined:
      case CustomCardVariant.subtle:
        return 0;
    }
  }

  Color _resolveBackgroundColor(
    ColorScheme scheme,
    CustomCardVariant variant,
  ) {
    switch (variant) {
      case CustomCardVariant.subtle:
        return scheme.surfaceContainerHighest;
      case CustomCardVariant.surface:
      case CustomCardVariant.elevated:
      case CustomCardVariant.outlined:
        return scheme.surface;
    }
  }

  Color _resolveBorderColor(
    ColorScheme scheme,
    CustomCardVariant variant,
  ) {
    if (variant == CustomCardVariant.outlined) {
      return scheme.outline;
    }
    return Colors.transparent;
  }

  double _resolveBorderWidth(Color resolvedBorderColor) {
    if (resolvedBorderColor == Colors.transparent) {
      return 0;
    }
    return borderWidth;
  }
}
