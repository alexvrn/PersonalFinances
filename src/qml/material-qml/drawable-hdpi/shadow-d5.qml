import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d5.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 62; border.top: 45
    border.right: 60; border.bottom: 109
  }
}
