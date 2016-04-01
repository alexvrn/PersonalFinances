import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d4.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 58; border.top: 46
    border.right: 56; border.bottom: 108
  }
}
