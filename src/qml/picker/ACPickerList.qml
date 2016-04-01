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
import "../material-qml/density.js" as Density

Rectangle {
    id: rootRect

    property double itemHeight: 8*Density.mm
    property alias model: listView.model

    signal indexChanged(int value)

    function setValue(value) {
        listView.currentIndex = value
        listView.positionViewAtIndex(value, ListView.Center);
    }

    ListView {
        id: listView

        clip: true
        anchors.fill: parent
        contentHeight: itemHeight*3

        delegate: Item {
            property var isCurrent: ListView.isCurrentItem
            id: item

            height: itemHeight
            width:  listView.width

            Rectangle {
                anchors.fill: parent

                Text {
                    text: model.text
                    font.pixelSize: 3*Density.mm
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        rootRect.gotoIndex(model.index)
                    }
                }
            }
        }
        onMovementEnded: {
            var centralIndex = listView.indexAt(listView.contentX+1,listView.contentY+itemHeight+itemHeight/2)
            gotoIndex(centralIndex)
            indexChanged(currentIndex)
        }
    }

    function gotoIndex(inIndex) {
        var begPos = listView.contentY;
        var destPos;

        listView.positionViewAtIndex(inIndex, ListView.Center);
        destPos = listView.contentY;

        anim.from = begPos;
        anim.to = destPos;
        anim.running = true;

        listView.currentIndex = inIndex
    }

    NumberAnimation {
        id: anim;

        target: listView;
        property: "contentY";
        easing {
            type: Easing.OutInExpo;
            overshoot: 50
        }
    }

    function next() {
        gotoIndex(listView.currentIndex+1)
    }

    function prev() {
        gotoIndex(listView.currentIndex-1)
    }
}
