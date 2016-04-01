// Based on https://github.com/papyros/qml-material/
// Creates the Material Design guidelines conformant shadow for rectangular items.
//
// It works substantially faster than MaterialShadow but produces too blurry results
// on rounded items (like floating action button)

import QtQuick 2.0
import QtGraphicalEffects 1.0

import "density.js" as Density


Item {
  id: root
  property int radius: 0
  property int depth: 1

  property Component animation

  property var topShadow: [
    {
      "opacity": 0,
      "offset": 0,
      "blur": 0
    },

    {
      "opacity": 0.12,
      "offset": 1 * Density.dp,
      "blur": 1.5 * Density.dp
    },

    {
      "opacity": 0.16,
      "offset": 3 * Density.dp,
      "blur": 3 * Density.dp
    },

    {
      "opacity": 0.19,
      "offset": 10 * Density.dp,
      "blur": 10 * Density.dp
    },

    {
      "opacity": 0.25,
      "offset": 14 * Density.dp,
      "blur": 14 * Density.dp
    },

    {
      "opacity": 0.30,
      "offset": 19 * Density.dp,
      "blur": 19 * Density.dp
    }
  ]

  property var bottomShadow: [
    {
      "opacity": 0,
      "offset": 0,
      "blur": 0
    },

    {
      "opacity": 0.24,
      "offset": 1 * Density.dp,
      "blur": 1 * Density.dp
    },

    {
      "opacity": 0.23,
      "offset": 3 * Density.dp,
      "blur": 3 * Density.dp
    },

    {
      "opacity": 0.23,
      "offset": 6 * Density.dp,
      "blur": 3 * Density.dp
    },

    {
      "opacity": 0.22,
      "offset": 10 * Density.dp,
      "blur": 5 * Density.dp
    },

    {
      "opacity": 0.22,
      "offset": 15 * Density.dp,
      "blur": 6 * Density.dp
    }
  ]

  RectangularGlow {
    property var elevationInfo: bottomShadow[Math.min(depth, 5)]
    property real horizontalShadowOffset: elevationInfo.offset * Math.sin((2 * Math.PI) * (parent.rotation / 360.0))
    property real verticalShadowOffset: elevationInfo.offset * Math.cos((2 * Math.PI) * (parent.rotation / 360.0))

    anchors.centerIn: parent
    width: parent.width
    height: parent.height
    anchors.horizontalCenterOffset: horizontalShadowOffset
    anchors.verticalCenterOffset: verticalShadowOffset
    glowRadius: elevationInfo.blur
    opacity: elevationInfo.opacity
    spread: 0.05
    color: "black"
    cornerRadius: root.radius + glowRadius * 2.2

    Behavior on glowRadius { NumberAnimation { duration: 150; easing.type: Easing.Bezier; easing.bezierCurve: [ 0.4, 0, 0.2, 1 ] } }
    Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.Bezier; easing.bezierCurve: [ 0.4, 0, 0.2, 1 ] } }
    Behavior on anchors.verticalCenterOffset { NumberAnimation { duration: 150; easing.type: Easing.Bezier; easing.bezierCurve: [ 0.4, 0, 0.2, 1 ] } }
  }

  RectangularGlow {
    property var elevationInfo: topShadow[Math.min(depth, 5)]
    property real horizontalShadowOffset: elevationInfo.offset * Math.sin((2 * Math.PI) * (parent.rotation / 360.0))
    property real verticalShadowOffset: elevationInfo.offset * Math.cos((2 * Math.PI) * (parent.rotation / 360.0))

    anchors.centerIn: parent
    width: parent.width
    height: parent.height
    anchors.horizontalCenterOffset: horizontalShadowOffset
    anchors.verticalCenterOffset: verticalShadowOffset
    glowRadius: elevationInfo.blur
    opacity: elevationInfo.opacity
    spread: 0.05
    color: "black"
    cornerRadius: root.radius + glowRadius * 2.2

    Behavior on glowRadius { NumberAnimation { duration: 150; easing.type: Easing.Bezier; easing.bezierCurve: [ 0.4, 0, 0.2, 1 ] } }
    Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.Bezier; easing.bezierCurve: [ 0.4, 0, 0.2, 1 ] } }
    Behavior on anchors.verticalCenterOffset { NumberAnimation { duration: 150; easing.type: Easing.Bezier; easing.bezierCurve: [ 0.4, 0, 0.2, 1 ] } }
  }
}
