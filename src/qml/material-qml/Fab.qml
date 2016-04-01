import QtQuick 2.0
import "density.js" as Density

Item {
  id: root

  signal clicked

  property color color: "#ff4081"
  property bool mini: false
  property bool flat: false
  property alias radius: circle.radius

  property int depth: 2
  property bool animatedShadow: false
  property bool rippleEnabled: false

  Loader {
    id: shadowLoader
    anchors.fill: circle
    active: !root.flat

    sourceComponent: MaterialShadow {
      radius: root.radius
      depth: root.depth
      animated: root.animatedShadow
    }
  }


  Rectangle {
    id: circle
    anchors.fill: parent
    radius: width / 2

    color: root.color

    Loader {
      id: rippleLoader
      anchors.fill: parent
      active: root.rippleEnabled

      sourceComponent: Ripple {
        mouseArea: ma
      }
    }
  }

  MouseArea {
    id: ma
    anchors.fill: parent
    onClicked: root.clicked()
  }

  width: (root.mini ? 40 : 56) * Density.dp
  height: width
}
