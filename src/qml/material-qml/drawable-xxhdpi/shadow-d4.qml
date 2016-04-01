import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d4.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 87; border.top: 69
    border.right: 85; border.bottom: 163
  }
}
