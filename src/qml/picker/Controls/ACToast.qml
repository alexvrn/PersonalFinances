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

Rectangle {
    id:root

    property alias toastText: label.text
    signal toastClicked()

    function showToast() {
        root.visible = true
        root.state = "showToast"
        visibleTimer.start()
    }

    height: 5*mm
    width: label.paintedWidth + 10*mm

    anchors{
        bottom: parent.bottom
        bottomMargin: 10*mm
        horizontalCenter: parent.horizontalCenter
    }

    color: "#333"
    radius: 0.5*mm

    opacity: 0;
    state: "hideToast"
    visible: false

    Text {
        id: label
        color: "white"
        font.pixelSize: 2.5*mm
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        renderType: Text.NativeRendering
        anchors.fill: parent
    }

    Timer {
        id: visibleTimer
        interval: 2222; running: false;
        onTriggered: {
            state = "hideToast"
        }
    }

    states: [
        State {
            name: "hideToast"
            PropertyChanges { target: root; opacity: 0; }
        },
        State {
            name: "showToast"
            PropertyChanges { target: root; opacity: 1; }
        }
    ]

    transitions: Transition {
        from: "hideToast"; to: "showToast"; reversible: true
        NumberAnimation {
            properties: "opacity";
            duration: 400
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            toastClicked()
        }
    }
}
