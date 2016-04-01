import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d5.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 125; border.top: 90
    border.right: 121; border.bottom: 220
  }
}
