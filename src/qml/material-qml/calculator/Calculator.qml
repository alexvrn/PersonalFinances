import QtQuick 2.3

import ".." as Material
import "../density.js" as Density

Material.Dialog {
  id: calculator
  title: ""

  property string value: "0"
  property bool __isOperation: false

  signal getValue(int value)

  function clear() {
    __isOperation = false
    summa.text = "0"
    summa.placeholderText = ""
    summa.floatingLabel = false
  }

  function calculation(isNumber, operation) {
    // Если число
    if (isNumber) {
      if (__isOperation) {
        __isOperation = false
        summa.text = operation
      }
      else {
        if (summa.text === "0")
          summa.text = operation
        else
          summa.text += operation
      }
    }
    // Если операция
    else {
      if (operation === "C") {
        clear()
      }
      else if (operation === "=") {
        __isOperation = true
        summa.placeholderText += summa.text
        summa.text = eval(summa.placeholderText)
        summa.placeholderText = ""
        summa.floatingLabel = false
      }
      else if (operation === "←") {
        var s = summa.text.slice(0, -1);
        if (s === "" || s === "-")
          s = "0"
        summa.text = s
      }
      else if (operation === "±") {
        summa.text = eval("-1*" + summa.text);
      }
      else {
        // Если операция уже выбрана
        if (__isOperation)
          return

        __isOperation = true
        summa.placeholderText += summa.text + operation
        summa.floatingLabel = true
      }
    }
  }

  Material.PaperTextField {
    id: summa
    floatingLabel: false
    anchors {
      left: parent.left
      leftMargin: 20*Density.dp
      right: parent.right
      rightMargin: 20*Density.dp
    }
    text: value
  }


  Grid {
    id: grid
    columns: 5
    anchors {
      top: summa.bottom
      topMargin: 5*Density.dp
      left: parent.left
      leftMargin: 20*Density.dp
      right: parent.right
      rightMargin: 20*Density.dp
    }
    spacing: 4*Density.dp
    horizontalItemAlignment: Grid.AlignHCenter
    verticalItemAlignment: Grid.AlignVCenter

    CalculatorButton { color: "#03a9f4"; text: "MC"; }
    CalculatorButton { color: "#03a9f4"; text: "MR"; }
    CalculatorButton { color: "#03a9f4"; text: "MS"; }
    CalculatorButton { color: "#03a9f4"; text: "M+"; }
    CalculatorButton { color: "#03a9f4"; text: "M-"; }
    CalculatorButton { color: "#ff5722"; text: "C";  }
    CalculatorButton { color: "#ff5722"; text: "←"; }
    CalculatorButton { color: "#757575"; text: "7"; isNumber: true}
    CalculatorButton { color: "#757575"; text: "8"; isNumber: true}
    CalculatorButton { color: "#757575"; text: "9"; isNumber: true}
    CalculatorButton { color: "#4caf50"; text: "%"; }
    CalculatorButton { color: "#4caf50"; text: "/"; }
    CalculatorButton { color: "#757575"; text: "4"; isNumber: true}
    CalculatorButton { color: "#757575"; text: "5"; isNumber: true}
    CalculatorButton { color: "#757575"; text: "6"; isNumber: true}
    CalculatorButton { color: "#4caf50"; text: "-"; }
    CalculatorButton { color: "#4caf50"; text: "*"; }
    CalculatorButton { color: "#757575"; text: "1"; isNumber: true}
    CalculatorButton { color: "#757575"; text: "2"; isNumber: true}
    CalculatorButton { color: "#757575"; text: "3"; isNumber: true}
    CalculatorButton { color: "#4caf50"; text: "="; }
    CalculatorButton { color: "#4caf50"; text: "+"; }
    CalculatorButton { color: "#4caf50"; text: "±"; }
    CalculatorButton { color: "#757575"; text: "0"; isNumber: true}
    CalculatorButton { color: "#4caf50"; text: "."; isNumber: true;}
  }
  CalculatorButton {
    id: ok
    color: "#009688";
    text: "✓";
    anchors {
      top: grid.bottom
      topMargin: Density.dp*2
      horizontalCenter: parent.horizontalCenter
    }
    onClicked: {
      getValue(summa.text)
      close()
    }
  }

  onOpened: {
    clear()
    for(var i = 0; i < grid.children.length; i++) {
      var item = grid.children[i]
      item.height = 40*Density.dp
      item.width = 40*Density.dp
    }
    ok.height = 40*Density.dp
    ok.width = 40*Density.dp

    if (value === "")
      value = "0"
    summa.text = value
  }

  onClosed: {
    for(var i = 0; i < grid.children.length; i++) {
      var item = grid.children[i]
      item.height = 0
      item.width = 0
    }
    ok.height = 0
    ok.width = 0
  }
}
