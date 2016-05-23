import QtQuick 2.3

import ".." as Material
import "../density.js" as Density

Material.Dialog {
  id: calculator
  title: ""

  property string value: "0"
  property bool __isOperation: false
  property string __memory: ""

  signal getValue(int value)

  function clear() {
    __isOperation = false
    summa.text = "0"
    summa.placeholderText = ""
    summa.floatingLabel = false
  }

  function calculation(isNumber, operation, type) {
    // Если число
    if (isNumber) {
      if (__isOperation) {
        __isOperation = false
        if (operation === ".")
          summa.text = "0.";
        else
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
      if (type === "clear") {
        clear()
      }
      else if (type === "clear-memory") {
        __memory = ""
      }
      else if (type === "plus-memory") {
        __memory = eval(__memory + "+(" + summa.text + ")");
      }
      else if (type === "minus-memory") {
        __memory = eval(__memory + "-(" + summa.text + ")");
      }
      else if (type === "from-memory") {
        if (__memory === "")
          return

        summa.text = __memory;
      }
      else if (type === "to-memory") {
        __memory = summa.text
      }
      else if (type === "eval") {
        __isOperation = true
        summa.placeholderText += summa.text
        summa.text = eval(summa.placeholderText)
        summa.placeholderText = ""
        summa.floatingLabel = false
      }
      else if (type === "back") {
        var s = summa.text.slice(0, -1);
        if (s === "" || s === "-")
          s = "0"
        summa.text = s
      }
      else if (type === "negative") {
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
    textHorizontalAlignment: Text.AlignRight
    text: value
    textReadOnly: true // Запрещаем вводить текст вручную
    tipVisible: true
  }

  Material.AnimatedText {
    id: memoryText
    text: __memory === "" ? "" : ("M = " + __memory)
    anchors {
      top: summa.bottom
      topMargin: 2*Density.dp
      left: parent.left
      leftMargin: 20*Density.dp
      right: parent.right
      rightMargin: 20*Density.dp
    }
    height: 10*Density.dp
    animation: memoryText.flipAnimation
  }

  Grid {
    id: grid
    columns: 5
    anchors {
      top: memoryText.bottom
      topMargin: 10*Density.dp
      left: parent.left
      leftMargin: 20*Density.dp
      right: parent.right
      rightMargin: 20*Density.dp
    }
    spacing: 4*Density.dp
    horizontalItemAlignment: Grid.AlignHCenter
    verticalItemAlignment: Grid.AlignVCenter

    CalculatorButton { color: "#03a9f4"; text: "MC"; type: "clear-memory" }
    CalculatorButton { color: "#03a9f4"; text: "MR"; type: "from-memory" }
    CalculatorButton { color: "#03a9f4"; text: "MS"; type: "to-memory" }
    CalculatorButton { color: "#03a9f4"; text: "M+"; type: "plus-memory" }
    CalculatorButton { color: "#03a9f4"; text: "M-"; type: "minus-memory" }
    CalculatorButton { color: "#ff5722"; text: "C"; type: "clear" }
    CalculatorButton { color: "#ff5722"; text: "←"; type: "back" }
    CalculatorButton { color: "#757575"; text: "7"; isNumber: true }
    CalculatorButton { color: "#757575"; text: "8"; isNumber: true }
    CalculatorButton { color: "#757575"; text: "9"; isNumber: true }
    CalculatorButton { color: "#4caf50"; text: "%"; }
    CalculatorButton { color: "#4caf50"; text: "/"; }
    CalculatorButton { color: "#757575"; text: "4"; isNumber: true }
    CalculatorButton { color: "#757575"; text: "5"; isNumber: true }
    CalculatorButton { color: "#757575"; text: "6"; isNumber: true }
    CalculatorButton { color: "#4caf50"; text: "-"; }
    CalculatorButton { color: "#4caf50"; text: "*"; }
    CalculatorButton { color: "#757575"; text: "1"; isNumber: true }
    CalculatorButton { color: "#757575"; text: "2"; isNumber: true }
    CalculatorButton { color: "#757575"; text: "3"; isNumber: true }
    CalculatorButton { color: "#4caf50"; text: "="; type: "eval" }
    CalculatorButton { color: "#4caf50"; text: "+"; }
    CalculatorButton { color: "#4caf50"; text: "±"; type: "negative" }
    CalculatorButton { color: "#757575"; text: "0"; isNumber: true }
    CalculatorButton { color: "#4caf50"; text: "."; isNumber: true }
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
    MouseArea {
      anchors.fill: parent
      onClicked: {
        getValue(summa.text)
        close()
      }
    }
  }

  onOpened: {
    clear()
    __memory = ""
    for(var i = 0; i < grid.children.length; i++) {
      var item = grid.children[i]
      //item.height = 40*Density.dp
      //item.width = 40*Density.dp
      item.setSize(40*Density.dp)
    }
    //ok.height = 40*Density.dp
    //ok.width = 40*Density.dp
    ok.setSize(40*Density.dp)

    if (value === "")
      value = "0"
    summa.text = value
  }

  onClosed: {
    for(var i = 0; i < grid.children.length; i++) {
      var item = grid.children[i]
      //item.height = 0
      //item.width = 0
      item.setSize(0)
    }
    //ok.height = 0
    //ok.width = 0
    ok.setSize(0)
  }
}
