import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d4.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 43; border.top: 34
    border.right: 41; border.bottom: 82
  }
}
