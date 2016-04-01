import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d1.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 7; border.top: 4
    border.right: 6; border.bottom: 9
  }
}
