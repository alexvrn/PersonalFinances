import QtQuick 2.0
import "density.js" as Density

Item {
  property alias color: card.color
  property alias backgroundOpacity: card.opacity
  property alias depth: shadow.depth

  GlowShadow {
    id: shadow
    anchors.fill: parent
    radius: 2
  }

  Rectangle {
    id: card
    anchors.fill: parent
    radius: 2 * Density.dp
  }
}
