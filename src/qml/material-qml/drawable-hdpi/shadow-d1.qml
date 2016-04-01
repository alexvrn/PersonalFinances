import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d1.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 5; border.top: 4
    border.right: 5; border.bottom: 7
  }
}
