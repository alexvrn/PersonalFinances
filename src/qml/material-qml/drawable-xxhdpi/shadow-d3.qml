import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d3.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 55; border.top: 47
    border.right: 53; border.bottom: 115
  }
}
