import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d3.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 27; border.top: 22
    border.right: 25; border.bottom: 56
  }
}
