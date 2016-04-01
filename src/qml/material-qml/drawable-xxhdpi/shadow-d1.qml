import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d1.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 10; border.top: 7
    border.right: 10; border.bottom: 13
  }
}
