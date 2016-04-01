import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d3.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 36; border.top: 32
    border.right: 36; border.bottom: 76
  }
}
