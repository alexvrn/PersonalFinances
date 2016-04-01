import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d2.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 15; border.top: 11
    border.right: 15; border.bottom: 23
  }
}
