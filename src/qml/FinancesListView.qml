import QtQuick 2.3
import QtQuick.Controls 1.2

import "material-qml/density.js" as Density

Item {
  id: root

  property var financesModel: []
  property var financesDelegate

  ListView {
    id: financesView
    anchors.fill: root

    model: financesModel
    delegate: financesDelegate
    boundsBehavior: Flickable.StopAtBounds
    clip: true
    spacing: 4*Density.dp
    MouseArea {
      id: ma
      anchors.fill: financesView
      hoverEnabled: true
    }
  }
  ScrollBar {
    id: scroll
    flickable: financesView;
    anchors.left: financesView.right
    anchors.leftMargin: -8
    anchors.top: financesView.top
    anchors.bottom: financesView.bottom

    inactiveColor: "white"

    anchors.topMargin: 0

    orientation: Qt.Vertical
    size: 8
    opacity: ma.containsMouse ? 0.9 : 0
    Behavior on opacity {
      NumberAnimation { duration: 200 }
    }
  }
}
