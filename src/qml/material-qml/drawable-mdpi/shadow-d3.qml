import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d3.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 18; border.top: 15
    border.right: 17; border.bottom: 37
  }
}
