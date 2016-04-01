import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d3.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 73; border.top: 63
    border.right: 71; border.bottom: 153
  }
}
