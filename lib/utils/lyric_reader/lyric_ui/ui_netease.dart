import 'package:flutter/material.dart';
import 'lyric_ui.dart';

///Sample Netease style
///should be extends LyricUI implementation your own UI.
///this property only for change UI,if not demand just only overwrite methods.
class UINetease extends LyricUI {
  double defaultSize;
  double defaultExtSize;
  double otherMainSize;
  double bias;
  double lineGap;
  double inlineGap;
  LyricAlign lyricAlign;
  LyricBaseLine lyricBaseLine;
  bool highlight;
  HighlightDirection highlightDirection;
  Color highlightColor;

  UINetease(
      {this.defaultSize = 18,
      this.defaultExtSize = 14,
      this.otherMainSize = 16,
      this.bias = 0.5,
      this.lineGap = 25,
      this.inlineGap = 25,
      this.lyricAlign = LyricAlign.CENTER,
      this.lyricBaseLine = LyricBaseLine.CENTER,
      this.highlightColor = Colors.blue,
      this.highlight = true,
      this.highlightDirection = HighlightDirection.LTR});

  UINetease.clone(UINetease uiNetease)
      : this(
          defaultSize: uiNetease.defaultSize,
          defaultExtSize: uiNetease.defaultExtSize,
          otherMainSize: uiNetease.otherMainSize,
          bias: uiNetease.bias,
          lineGap: uiNetease.lineGap,
          inlineGap: uiNetease.inlineGap,
          lyricAlign: uiNetease.lyricAlign,
          lyricBaseLine: uiNetease.lyricBaseLine,
          highlightColor: uiNetease.highlightColor,
          highlight: uiNetease.highlight,
          highlightDirection: uiNetease.highlightDirection,
        );

  @override
  TextStyle getPlayingExtTextStyle() =>
      TextStyle(color: Colors.grey[300], fontSize: defaultExtSize);

  @override
  TextStyle getOtherExtTextStyle() => TextStyle(
        color: Colors.grey[300],
        fontSize: defaultExtSize,
        fontFamily: 'Bahnschrift',
      );

  @override
  TextStyle getOtherMainTextStyle() =>
      TextStyle(color: Colors.grey[200], fontSize: otherMainSize, fontFamily: 'Bahnschrift');

  @override
  TextStyle getPlayingMainTextStyle() => TextStyle(
        color: highlightColor,
        fontSize: defaultSize,
        fontFamily: 'Bahnschrift',
      );

  @override
  double getInlineSpace() => inlineGap;

  @override
  double getLineSpace() => lineGap;

  @override
  double getPlayingLineBias() => bias;

  @override
  LyricAlign getLyricHorizontalAlign() => lyricAlign;

  @override
  LyricBaseLine getBiasBaseLine() => lyricBaseLine;

  @override
  bool enableHighlight() => highlight;

  @override
  HighlightDirection getHighlightDirection() => highlightDirection;
}
