import QtQuick 2.2
import "density.js" as Density

Item {
  id: root
  z: 1

  anchors.left: parent.left
  anchors.right: parent.right
  anchors.top: parent.top

  property alias color: background.color
  property alias depth: shadow.depth

  height: 56 * Density.dp

  ImageShadow {
    id: shadow
    anchors.fill: parent
  }

  Rectangle {
    id: background
    anchors.fill: parent
    color: "#9c27b0"
  }
}
