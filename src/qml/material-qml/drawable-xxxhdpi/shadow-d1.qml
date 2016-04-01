import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d1.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 15; border.top: 9
    border.right: 13; border.bottom: 19
  }
}
