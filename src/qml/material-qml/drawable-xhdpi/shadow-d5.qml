import QtQuick 2.0

Item {
  BorderImage {
    source: "shadow-d5.png"

    anchors {
      fill: parent
      leftMargin: -border.left; topMargin: -border.top
      rightMargin: -border.right; bottomMargin: -border.bottom
    }

    border.left: 83; border.top: 61
    border.right: 81; border.bottom: 145
  }
}
