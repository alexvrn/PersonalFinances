import QtQuick 2.0
import "density.js" as Density

Rectangle {
  id: root

  signal clicked

  property alias text: itemText.text
  property alias secondaryText: secondaryItemText.text
  property Component icon
  property Component control

  onIconChanged: {
    if (icon !== null)
      icon.createObject(iconContainer);
  }

  onControlChanged: {
    if (control !== null)
      control.createObject(controlContainer);
  }

  implicitWidth: 320 * Density.dp
  height: secondaryText != '' ? 72 * Density.dp : ((icon !== null || control !== null)? 56 * Density.dp : 48 * Density.dp)

  MouseArea {
    id: ma
    anchors.fill: parent
    onClicked: root.clicked()
  }

  InkEffect {
    anchors.fill: parent
    mouseArea: ma
  }

  Item {
    id: iconContainer
    width: 40 * Density.dp
    height: 40 * Density.dp

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.leftMargin: 16 * Density.dp
    anchors.topMargin: secondaryText != '' ? 16 * Density.dp : 8 * Density.dp
  }

  Item {
    id: controlContainer
    width: 40 * Density.dp
    height: 40 * Density.dp

    anchors.top: parent.top
    anchors.right: parent.right
    anchors.rightMargin: 16 * Density.dp
    anchors.topMargin: secondaryText != '' ? 12 * Density.dp : 4 * Density.dp
  }

  Text {
    id: itemText

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.leftMargin: icon !== null ? 72 * Density.dp : 16 * Density.dp
    anchors.topMargin: 16 * Density.dp
    anchors.rightMargin: control !== null ? 72 * Density.dp : 16 * Density.dp

    font.family: 'Roboto, sans-serif'
    font.pixelSize: 16 * Density.dp

    opacity: 0.79
  }

  Text {
    id: secondaryItemText

    anchors.top: itemText.bottom
    anchors.left: itemText.left
    anchors.topMargin: 4 * Density.dp

    font.family: 'Roboto, sans-serif'
    font.pixelSize: 14 * Density.dp

    opacity: 0.45
  }
}
