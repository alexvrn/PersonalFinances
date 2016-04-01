import QtQuick 2.3
import QtQuick.Controls 1.2

import "density.js" as Density

FocusScope {
  id: root
  implicitWidth:  48 * Density.dp + (text == "" ? 0 : 32 * Density.dp + label.implicitWidth)
  implicitHeight: 48 * Density.dp

  signal clicked

  property bool checked: false
  property ExclusiveGroup exclusiveGroup: null
  property alias text: label.text
  property color color: "#2196f3"

  activeFocusOnTab: true

  Keys.onPressed: {
    if ((event.key === Qt.Key_Space || event.key === Qt.Key_Return) && !event.isAutoRepeat)
      if (!checked)
        checked = true;
  }

  onExclusiveGroupChanged: {
    if (exclusiveGroup)
      exclusiveGroup.bindCheckable(root)
  }

  // Focus and ripple
  Rectangle {
    id: focusCircle

    anchors.centerIn: circle

    width: 48 * Density.dp
    height: width
    radius: width / 2

    color: root.checked ? root.color : "#89000000"
    opacity: root.focus ? 0.13 : 0

    Behavior on opacity { NumberAnimation { duration: 150 } }
    Behavior on color { ColorAnimation { duration: 150 } }
  }

  InkEffect {
    id: rippleWave
    anchors.fill: focusCircle
    mouseArea: rippleArea
    inkColor: checked ? Qt.rgba(root.color.r, root.color.g, root.color.b, 0.13) : "#11000000"
    backgroundColor: "transparent"
    radius: width / 2
  }

  // Indicator
  Rectangle {
    id: circle

    anchors.left: parent.left
    anchors.leftMargin: 16 * Density.dp
    anchors.verticalCenter: parent.verticalCenter

    width: 20 * Density.dp
    height: width
    radius: width / 2

    focus: root.focus

    color: "transparent"
    border.color: enabled ? (checked ? root.color: "#89000000") : "42000000"
    border.width: 2 * Density.dp

    Behavior on border.color { ColorAnimation { duration: 150 } }
  }

  Rectangle {
    id: raisedCircle
    width: 10 * Density.dp
    height: width
    radius: width / 2
    color: root.color
    anchors.centerIn: circle

    scale: checked ? 1 : 0
    Behavior on scale { NumberAnimation { duration: 150 } }
  }

  // Label
  Text {
    id: label

    anchors.left: circle.right
    anchors.leftMargin: 16 * Density.dp
    anchors.verticalCenter: parent.verticalCenter

    font.family: "Roboto, sans-serif"
    font.pixelSize: 16 * Density.dp
    opacity: 0.87
  }

  // Mouse area
  MouseArea {
    id: mouseArea
    anchors.fill: parent

    onReleased: root.checked = true
  }

  MouseArea {
    id: rippleArea
    anchors.fill: circle
    anchors.margins: -circle.width

    onReleased: root.checked = true
  }
}
