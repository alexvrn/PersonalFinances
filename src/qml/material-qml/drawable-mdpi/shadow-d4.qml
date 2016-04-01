import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d4.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 29; border.top: 23
    border.right: 27; border.bottom: 53
  }
}
