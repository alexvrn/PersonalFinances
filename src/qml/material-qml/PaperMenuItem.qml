import QtQuick 2.3
import "density.js" as Density

Item {
  id: root

  signal clicked

  property alias text: itemText.text
  property Component icon

  onIconChanged: {
    if (icon !== null)
      icon.createObject(iconContainer);
  }

  implicitWidth: 320 * Density.dp
  height: icon !== null ? 56 * Density.dp : 48 * Density.dp

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
    anchors.topMargin: 8 * Density.dp
  }

  Text {
    id: itemText

    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    anchors.leftMargin: icon !== null ? 72 * Density.dp : 16 * Density.dp
    anchors.topMargin: 16 * Density.dp
    anchors.rightMargin: 16 * Density.dp

    font.family: 'Roboto, sans-serif'
    font.pixelSize: 16 * Density.dp

    opacity: 0.79
  }
}
