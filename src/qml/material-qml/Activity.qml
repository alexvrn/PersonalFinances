import QtQuick 2.3
import "density.js" as Density

FocusScope {
  id: root

  property alias color: rect.color
  property alias gradient: rect.gradient

  ImageShadow {
    anchors.fill: parent
    depth: 2
  }

  Rectangle {
    id: rect
    anchors.fill: parent
  }

  property bool canGoBack: true
  property bool ignoreBackButton: false

  signal backRequested

  Keys.onBackPressed: {
    if (ignoreBackButton) {
      event.accepted = true;
      return;
    }

    if (canGoBack) {
      root.backRequested()
      event.accepted = true;
    } else {
      event.accepted = false;
    }
  }
}
