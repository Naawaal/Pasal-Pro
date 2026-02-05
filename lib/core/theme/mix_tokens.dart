import 'package:mix/mix.dart';

/// Mix token definitions for Pasal Pro.
/// These enums provide type-safe access to design tokens.

// Color tokens
enum PasalColorToken {
  primary('color.primary'),
  onPrimary('color.onPrimary'),
  surface('color.surface'),
  surfaceAlt('color.surfaceAlt'),
  surfaceHover('color.surfaceHover'),
  border('color.border'),
  textPrimary('color.textPrimary'),
  textSecondary('color.textSecondary'),
  textTertiary('color.textTertiary'),
  success('color.success'),
  warning('color.warning'),
  error('color.error'),
  background('color.background');

  final String name;
  const PasalColorToken(this.name);

  ColorToken get token => ColorToken(name);
}

// Typography tokens
enum PasalTextStyleToken {
  headline('text.headline'),
  title('text.title'),
  body('text.body'),
  caption('text.caption'),
  button('text.button');

  final String name;
  const PasalTextStyleToken(this.name);

  TextStyleToken get token => TextStyleToken(name);
}

// Spacing tokens
enum PasalSpaceToken {
  xxSmall('space.xxSmall'),
  xSmall('space.xSmall'),
  small('space.small'),
  medium('space.medium'),
  large('space.large'),
  xLarge('space.xLarge'),
  xxLarge('space.xxLarge'),
  xxxLarge('space.xxxLarge');

  final String name;
  const PasalSpaceToken(this.name);

  SpaceToken get token => SpaceToken(name);
}

// Radius tokens
enum PasalRadiusToken {
  small('radius.small'),
  medium('radius.medium'),
  large('radius.large'),
  xLarge('radius.xLarge');

  final String name;
  const PasalRadiusToken(this.name);

  RadiusToken get token => RadiusToken(name);
}

// Duration tokens
enum PasalDurationToken {
  fast('duration.fast'),
  normal('duration.normal'),
  slow('duration.slow');

  final String name;
  const PasalDurationToken(this.name);

  DurationToken get token => DurationToken(name);
}
