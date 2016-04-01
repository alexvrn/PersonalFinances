import QtQuick 2.0
import "density.js" as Density


Rectangle {
  id: snackbar

  property string buttonText
  property color buttonColor: "#2196F3"
  property string text
  property bool opened
  property int duration: 3500
  property bool fullWidth: true

  signal clicked

  function open(text) {
    snackbar.text = text
    opened = true;
    timer.restart();
  }

  function close(text) {
    opened = false;
    timer.stop();
  }

  anchors {
    left: fullWidth ? parent.left : undefined
    right: fullWidth ? parent.right : undefined
    horizontalCenter: fullWidth ? undefined : parent.horizontalCenter

    bottom: parent.bottom
    bottomMargin: opened ? fullWidth ? 0 : 16 * Density.dp : -snackbar.height

    Behavior on bottomMargin {
      NumberAnimation { duration: 300 }
    }
  }
  radius: fullWidth ? 0 : 2 * Density.dp
  color: "#323232"

  height: snackText.lineCount == 2 ? 80 * Density.dp : 48 * Density.dp
  width: fullWidth ? undefined
                   : Math.min(Math.max(implicitWidth, 288 * Density.dp), 568 * Density.dp)
  opacity: opened ? 1 : 0
  implicitWidth: buttonText == "" ? snackText.paintedWidth + 48 * Density.dp
                                  : snackText.paintedWidth + 72 * Density.dp + snackButton.width

  Timer {
    id: timer

    interval: snackbar.duration

    onTriggered: {
      if (!running) {
        snackbar.opened = false;
      }
    }
  }

  Text {
    id: snackText
    anchors {
      right: snackbar.buttonText == "" ? parent.right : snackButton.left
      left: parent.left
      top: parent.top
      leftMargin: 24 * Density.dp
      topMargin: lineCount == 2 ? 24 * Density.dp : 14 * Density.dp
      rightMargin: (!fullWidth && snackbar.buttonText != "") ? 48 * Density.dp : 24 * Density.dp
    }
    text: snackbar.text
    color: "white"

    maximumLineCount: fullWidth ? 2 : 1
    wrapMode: fullWidth ? Text.Wrap : Text.NoWrap
    elide: Text.ElideRight

    font.family: "Roboto"
    font.pixelSize: 14 * Density.dp
  }

  Text {
    id: snackButton
    opacity: snackbar.buttonText == "" ? 0 : 1
    color: snackbar.buttonColor
    text: snackbar.buttonText

    font.family: "Roboto"
    font.pixelSize: 14 * Density.dp
    font.capitalization: Font.AllUppercase
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    height: 48 * Density.dp
    anchors {
      right: parent.right
      rightMargin: snackbar.buttonText == "" ? 0 : 24 * Density.dp
      verticalCenter: parent.verticalCenter
    }

    MouseArea {
      anchors.fill: parent
      onClicked: snackbar.clicked()
    }
  }

  Behavior on opacity {
    NumberAnimation { duration: 300 }
  }
}
