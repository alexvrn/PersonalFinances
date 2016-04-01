import QtQuick 2.0

import "density.js" as Density


Rectangle {
  implicitWidth: 100 * Density.dp
  implicitHeight: 1 * Density.dp
  clip: true
  property color lineColor: "black"
  property int dashWidth: 3 * Density.dp
  property int dashHeight: 1 * Density.dp
  property int spacingWidth: 2 * Density.dp
  property int dashCount: width / (dashWidth + spacingWidth) + 1

  Row {
    spacing: spacingWidth

    Repeater {
      model: dashCount
      Rectangle {
        width: dashWidth
        height: dashHeight
        color: lineColor
      }
    }
  }
}
