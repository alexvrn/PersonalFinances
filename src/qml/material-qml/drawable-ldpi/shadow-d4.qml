import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d4.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 21; border.top: 16
    border.right: 21; border.bottom: 40
  }
}
