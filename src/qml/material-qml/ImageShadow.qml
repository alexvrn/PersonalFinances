import QtQuick 2.0
import "density.js" as Density


Item {
  id: root

  property int depth : 1;

  property string __densitySuffix: Density.dp == 0.75 ? "ldpi"  :
                                   Density.dp == 1.5  ? "hdpi"  :
                                   Density.dp == 2.0  ? "xhdpi" :
                                   Density.dp == 3.0  ? "xxhdpi" :
                                   Density.dp == 4.0  ? "xxxhdpi" :
                                                        "mdpi"

  Loader {
    id: shadowLoader
    anchors.fill: parent
  }
  states: [
    State {
      name: "D1"
      when : depth === 1
      PropertyChanges { target: shadowLoader; source: "drawable-" + root.__densitySuffix + "/shadow-d1.qml" }
    },
    State {
      name: "D2"
      when : depth === 2
      PropertyChanges { target: shadowLoader; source: "drawable-" + root.__densitySuffix + "/shadow-d2.qml" }
    },
    State {
      name: "D3"
      when : depth === 3
      PropertyChanges { target: shadowLoader; source: "drawable-" + root.__densitySuffix + "/shadow-d3.qml" }
    },
    State {
      name: "D4"
      when : depth === 4
      PropertyChanges { target: shadowLoader; source: "drawable-" + root.__densitySuffix + "/shadow-d4.qml" }
    },
    State {
      name: "D5"
      when : depth === 5
      PropertyChanges { target: shadowLoader; source: "drawable-" + root.__densitySuffix + "/shadow-d5.qml" }
    }
  ]
}
