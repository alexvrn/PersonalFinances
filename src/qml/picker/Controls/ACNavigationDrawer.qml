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
import "../Other"

Rectangle {
    id: root

    property alias model: viewList.model
    signal drawerShowed()
    signal drawerClosed()
    signal viewSelected(int inNumber)

    function showDrawer() {
        drawerList.state = "showDrawer"
        drawerBackground.visible = true
        drawerBackground.state = "showBack"
        drawerShowed()
    }

    function hideDrawer() {
        drawerList.state = "hideDrawer"
        drawerBackground.timer.start()
        drawerBackground.state = "hideBack"
        drawerClosed()
    }

    color: "transparent"

    // dark background with variable opacity
    ACDarkBackground {
        id: drawerBackground

        onBackClicked: {
            hideDrawer()
        }
    }

    // List with available views
    Rectangle {
        id: drawerList

        width: 4*parent.width/5 < 50*mm ? 4*parent.width/5 : 50*mm
        height: parent.height
        anchors.left: parent.left
        anchors.leftMargin: -width;

        ListView {
            id: viewList
            anchors.fill: parent
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            delegate: Item {
                property var view: ListView.view
                property var isCurrent: ListView.isCurrentItem

                width: drawerList.width
                height: 10*mm

                Rectangle {
                    anchors.fill: parent
                    color: isCurrent ? "#d6d6d6" : "white"

                    Rectangle {
                        width: drawerList.width
                        height: parseInt(0.2*mm)
                        color: "#eee"
                        anchors.bottom: parent.bottom
                    }

                    Text {

                        text: name
                        font.bold: false
                        renderType: mm > 7 ? Text.NativeRendering : Text.QtRendering
                        color: "#4e4e4e"
                        font.pixelSize: 3.5*mm
                        anchors {
                            left:parent.left
                            leftMargin: 5*mm
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            view.currentIndex = model.index
                            root.viewSelected(view.currentIndex)
                            hideDrawer()
                        }
                    }
                }
            }
        }

        state: "hideDrawer"

        states: [
            State {
                name: "hideDrawer"
                PropertyChanges { target: drawerList; anchors.leftMargin: -width; }
            },
            State {
                name: "showDrawer"
                PropertyChanges { target: drawerList; anchors.leftMargin: 0; }
            }
        ]

        transitions: Transition {
            from: "hideDrawer"; to: "showDrawer"; reversible: true
            NumberAnimation {
                properties: "anchors.leftMargin";
                easing {
                    type: Easing.OutInExpo;
                    overshoot: 400
                }
            }
        }
    }
}
