import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d5.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 166; border.top: 122
    border.right: 162; border.bottom: 292
  }
}
