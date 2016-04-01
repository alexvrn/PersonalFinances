import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d5.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 41; border.top: 30
    border.right: 39; border.bottom: 72
  }
}
