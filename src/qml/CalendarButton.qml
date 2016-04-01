/*******************************************************************************
** Copyright © 2014 Eremin Yakov and Putintsev Roman.
** All rights reserved.
** Contact: support@istodo.ru
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
**
** 1. Redistributions of source code must retain the above copyright notice,
** this list of conditions and the following disclaimer.
**
** 2. Redistributions in binary form must reproduce the above copyright notice,
** this list of conditions and the following disclaimer in the documentation
** and/or other materials provided with the distribution.
**
** 3. Neither the name of the copyright holder nor the names of its contributors
** may be used to endorse or promote products derived from this software without
** specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
** AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
** IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
** ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
** LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
** OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
** OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
** INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
** IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
** ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
** POSSIBILITY OF SUCH DAMAGE.
**
****************************************************************************/

import QtQuick 2.0
import QtQuick.Controls.Styles 1.2
import "material-qml/density.js" as Density

Rectangle {
  id: root

  property alias text: name.text
  property int imgSize: root.height - 2*Density.dp
  signal clicked

  color: "transparent"

  Behavior on x { NumberAnimation { duration: 150 } }
  Behavior on y { NumberAnimation { duration: 150 } }
  Behavior on anchors.centerIn { NumberAnimation { duration: 150 } }

  Image {
    id: image
    sourceSize.width: imgSize
    sourceSize.height: imgSize
    // иконка из google-material: https://design.google.com/icons/(раздел Action)
    source: "qrc:/icons/ic_today_black_48px.svg"
    anchors.verticalCenter: parent.verticalCenter
    MouseArea {
      anchors.fill: parent
      onClicked: root.clicked()
    }
  }

  Text {
    id: name
    color: "white"
    font.pixelSize: imgSize/2.5
    anchors {
      top: image.top
      topMargin: imgSize/3
      horizontalCenter: image.horizontalCenter
    }
  }
}
