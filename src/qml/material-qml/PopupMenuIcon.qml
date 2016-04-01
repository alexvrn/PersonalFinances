import QtQuick 2.0
import "density.js" as Density

Item {
  id: popupMenuIcon
  width: 24 * Density.dp
  height: 24 * Density.dp

  Rectangle {
    id: circle1
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: parent.height / 4
    width: height
    height: 3 * Density.dp
    color: "#fff"
    radius: width / 2
    antialiasing: true
  }

  Rectangle {
    id: circle2
    anchors.centerIn: parent
    width: height
    height: 3 * Density.dp
    color: "#fff"
    radius: height / 2
    antialiasing: true
  }

  Rectangle {
    id: circle3
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: parent.height / 4
    width: height
    height: 3 * Density.dp
    color: "#fff"
    radius: height / 2
    antialiasing: true
  }
}
