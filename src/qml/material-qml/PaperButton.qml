import QtQuick 2.2
import QtGraphicalEffects 1.0

import "density.js" as Density

FocusScope {
  implicitHeight: 36 * Density.dp
  implicitWidth: Math.max(textField.contentWidth + 16 * Density.dp, (context == "dialog" ? 64 : 88) * Density.dp)

  signal clicked

  property alias text: textField.text

  property alias font: textField.font

  property string  context: "normal"
  property bool flat: context == "dialog" ? true : false
  property bool colored: context == "dialog" ? true : false

  property color color: "#2196f3"
  property color focusColor: "#1e88e5"
  property color pressedColor: "#1976D2"

  property alias radius: button.radius

  id: general
  activeFocusOnTab: true

  property color __disabledColor: flat ? "#00ffffff" : "#1e000000"
  property color __color: flat ? "#00ffffff" : (colored ? color : "white")
  property color __focusColor: flat ? (colored ? "#00ffffff" : "#eaeaea") : (colored ? focusColor : "#eaeaea")
  property color __pressedColor: colored ? (flat ? Qt.rgba(pressedColor.r, pressedColor.g, pressedColor.b, 0.2) : pressedColor) : "#d6d6d6"

  GlowShadow {
    id: shadow
    anchors.fill: button
    radius: button.radius
    depth: general.focus ? (mouseArea.pressed ? 3 : 2) : (mouseArea.pressed ? 2 : 1)
    visible: general.enabled ? (general.flat ? false : true) : false
  }

  Rectangle {
    id: button

    color: enabled ? (general.focus ? __focusColor : __color) : __disabledColor
    Behavior on color { ColorAnimation { duration: 150 } }

    width: general.width
    height: general.heigh
    radius: 2 * Density.dp
    anchors.fill: general
    focus: general.focus
    clip: true

    PaperBreathWave {
      id: focuswave
      color: __pressedColor

      anchors.centerIn: parent
      width: textField.contentWidth + 10 * Density.dp

      running: general.focus && !mouseArea.pressed
      opacity: running ? 1 : 0
      Behavior on opacity { NumberAnimation { duration: 150 } }
    }
  }

  InkEffect {
    anchors.fill: general
    mouseArea: mouseArea
    backgroundColor: __focusColor
    inkColor: __pressedColor
    radius: button.radius
  }

  Text {
    id: textField
    anchors.centerIn: general

    color: colored ? general.enabled ? (flat ? general.color : "white") : (flat ? "#42000000" : "#4bffffff")
                   : general.enabled ? "#de000000"                      : "#42000000"
    Behavior on color { ColorAnimation { duration: 150 } }

    font.family: "Roboto, sans-serif"
    font.pixelSize: 14 * Density.dp
    font.capitalization: Font.AllUppercase
  }

  MouseArea {
    id: mouseArea
    anchors.fill: general
    anchors.margins: -6 * Density.dp
    onClicked: general.clicked()
  }
}
