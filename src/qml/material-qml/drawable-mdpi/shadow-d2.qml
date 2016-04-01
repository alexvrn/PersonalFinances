import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d2.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 8; border.top: 5
    border.right: 8; border.bottom: 12
  }
}
