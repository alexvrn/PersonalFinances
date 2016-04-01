import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d1.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 3; border.top: 2
    border.right: 3; border.bottom: 4
  }
}
