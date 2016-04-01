import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d2.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 31; border.top: 23
    border.right: 29; border.bottom: 49
  }
}
