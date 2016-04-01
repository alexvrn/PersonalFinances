import QtQuick 2.3
import "density.js" as Density

Item {
  id: root

  width: 48 * Density.dp
  height: width

  state: "plus"

  signal clicked

  Rectangle {
    id: element

    radius: root.width / 2
    anchors.fill: root

    color: "red"

    MouseArea {
      id: ma
      anchors.fill: parent
      anchors.margins: -4 * Density.dp

      onClicked: root.clicked()
    }

    Item {
      id: inkClipper

      anchors {
        fill: parent
        topMargin: -4 * Density.dp
        bottomMargin: -4 * Density.dp
        leftMargin: __inkMargins
        rightMargin: __inkMargins
      }

      clip: true

      InkEffect {
        anchors {
          fill: parent
          topMargin: __inkMargins - inkClipper.anchors.topMargin
          bottomMargin: __inkMargins - inkClipper.anchors.bottomMargin
        }
        mouseArea: ma
        radius: width
        backgroundColor: Qt.rgba(1, 1, 1, 0.1)
        inkColor: Qt.rgba(1, 1, 1, 0.2)
      }
    }
  }
}
