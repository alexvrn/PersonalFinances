import QtQuick 2.3

Item {
  property alias backgroundColor: shaderEffect.backgroundColor
  property alias inkColor: shaderEffect.spreadColor

  property variant mouseArea

  Connections {
    target: mouseArea
    onPressed: {
      var coords = mapFromItem(mouseArea, mouse.x, mouse.y)
      touchStart(coords.x, coords.y)
    }
    onReleased: touchEnd()
    onCanceled: touchEnd()
  }


  /**
   * @brief Defines the corner radius of the effect area
   *
   * Has no effect when the maskSource is set
   */
  property alias radius: maskRect.radius
  onRadiusChanged: {
    shaderEffect.hasMask = (maskSource != undefined) || radius != 0;
    if (maskSource != undefined)
      shaderEffectSource.sourceItem = maskSource
    else if (radius != 0)
      shaderEffectSource.sourceItem = maskRect
    else
      shaderEffectSource.sourceItem = undefined
  }


  property variant maskSource
  onMaskSourceChanged: {
    shaderEffect.hasMask = (maskSource != undefined) || radius != 0;
    if (maskSource != undefined)
      shaderEffectSource.sourceItem = maskSource
    else if (radius != 0)
      shaderEffectSource.sourceItem = maskRect
    else
      shaderEffectSource.sourceItem = undefined
  }


  function touchStart(x, y) {
    shaderEffect.normTouchPos = Qt.point(x / width, y / height)
    touchEndAnimation.stop()
    touchStartAnimation.start()
  }

  function touchEnd() {
    touchStartAnimation.stop()
    touchEndAnimation.start()
  }


  Rectangle {
    id: maskRect
    anchors.fill: parent
    visible: false
  }

  ShaderEffectSource {
    id: shaderEffectSource
  }

  ShaderEffect {
    id: shaderEffect

    anchors.fill: parent

    property variant maskSource: shaderEffectSource
    property bool hasMask: false

    property color backgroundColor: "#28999999"
    property color spreadColor: "#1A000000"
    property point normTouchPos
    property real widthToHeightRatio: height / width
    property real maxRadius: Math.sqrt(widthToHeightRatio * widthToHeightRatio + 1) / 2
    property real spread: 0
    opacity: 0

    ParallelAnimation {
      id: touchStartAnimation
      UniformAnimator {
        target: shaderEffect; uniform: "spread"
        from: 0; to: 1
        duration: 1000; easing.type: Easing.InQuad
      }
      OpacityAnimator {
        target: shaderEffect
        from: 0; to: 1
        duration: 75; easing.type: Easing.InQuad
      }
    }

    ParallelAnimation {
      id: touchEndAnimation
      UniformAnimator {
        target: shaderEffect; uniform: "spread"
        from: shaderEffect.spread; to: 1
        duration: 500; easing.type: Easing.OutQuad
      }
      OpacityAnimator {
        target: shaderEffect
        from: 1; to: 0
        duration: 500; easing.type: Easing.OutQuad
      }
    }

    fragmentShader: "
        varying mediump vec2 qt_TexCoord0;
        uniform lowp float qt_Opacity;
        uniform lowp vec4 backgroundColor;
        uniform lowp vec4 spreadColor;
        uniform mediump vec2 normTouchPos;
        uniform mediump float widthToHeightRatio;
        uniform mediump float maxRadius;
        uniform mediump float spread;

        uniform lowp sampler2D maskSource;
        uniform lowp bool hasMask;

        void main() {
            // Pin the touched position of the circle by moving the center as the radius grows.
            // Center of the circle must reach the center of the item at the finish of
            // touchStartAnimation
            mediump float radius = maxRadius * spread;
            mediump vec2 circleCenter = normTouchPos + (vec2(0.5) - normTouchPos) * spread;

            // Calculate everything according to the x-axis. Keep the aspect
            // for the y-axis since we're dealing with 0..1 coordinates.
            mediump float circleX = (qt_TexCoord0.x - circleCenter.x);
            mediump float circleY = (qt_TexCoord0.y - circleCenter.y) * widthToHeightRatio;

            // Use step to apply the color only if x2*y2 < r2.
            lowp vec4 color;
            if (spreadColor.a < 1.0) {
              lowp vec4 tapOverlay = spreadColor * step(circleX*circleX + circleY*circleY, radius*radius);
              color = backgroundColor + tapOverlay;
            } else {
              color = (circleX*circleX + circleY*circleY < radius*radius) ? spreadColor : backgroundColor;
            }

            lowp float maskAlpha = hasMask ? (texture2D(maskSource, qt_TexCoord0.st).a) : 1.0;
            gl_FragColor = color * maskAlpha * qt_Opacity;
        }
    "
  }
}

