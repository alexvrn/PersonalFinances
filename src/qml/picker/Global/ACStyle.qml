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

import "../../material-qml/density.js" as Density

//DarkBackground      48
//Drawer              50
//Toast               100

Rectangle {
    id: acStyle

    property color holoLightBlue:   "#33b5e5"
    property color holoDarkBlue:    "#0099cc"
    property color holoLightViolet: "#aa66cc"
    property color holoDarkViolet:  "#9933cc"
    property color holoLightGreen:  "#99cc00"
    property color holoDarkGreen:   "#669900"
    property color holoLightYelloy: "#ffbb33"
    property color holoDarkYellow:  "#ff8800"
    property color holoLightRed:    "#ff4444"
    property color holoDarkRed:     "#cc0000"

    property color darkGray:       "#7d7d7d"
    property color lightGray:      "#dcdcdc"

    // Colors for tasks
    property ListModel colorModel: ListModel {

        ListElement {
            color: "#33b5e5"
        }

        ListElement {
            color: "#aa66cc"
        }

        ListElement {
            color: "#99cc00"
        }

        ListElement {
            color: "#ffbb33"
        }

        ListElement {
            color: "#ff4444"
        }

        ListElement {
            color: "#0099cc"
        }

        ListElement {
            color: "#9933cc"
        }

        ListElement {
            color: "#669900"
        }

        ListElement {
            color: "#ff8800"
        }

        ListElement {
            color: "#cc0000"
        }
    }

    property Component tvTwoTabStyle: TabViewStyle {
        // BUG with styleData.previousSelected https://bugreports.qt-project.org/browse/QTBUG-38819
        tab: Rectangle {
            id: tab

            implicitWidth: styleData.availableWidth / 2 // Count of tabs
            implicitHeight: 8*Density.mm

            // Bottom border on active tab
            Rectangle {
                width: tab.width
                height: 0.2*Density.mm

                color: lightGray
                anchors.bottom: tab.bottom
            }

            // Bottom border on active tab
            Rectangle {
                width: tab.width
                height: 1*Density.mm

                color: darkGray
                anchors.bottom: tab.bottom
                visible: styleData.selected ? true : false

                Rectangle {
                    width: tab.width
                    height: 0.2*Density.mm

                    color: "#555"
                    anchors.bottom: parent.bottom
                }
            }

            // Vertical separator for first (left) tab
            Rectangle {
                width: 0.3*Density.mm
                height: tab.height - (tab.height / 2)

                color: lightGray
                visible: styleData.nextSelected ? true : false
                anchors.right: tab.right
                anchors.verticalCenter: tab.verticalCenter
            }

            // Vertical separator for second (right) tab
            Rectangle {
                width: 0.3*Density.mm
                height: tab.height - (tab.height / 2)

                color: lightGray
                visible: styleData.previousSelected ? true : false

                anchors.left: tab.left
                anchors.verticalCenter: tab.verticalCenter
            }

            Text {
                id: text
                font.bold: true
                font.pixelSize: 2.2*Density.mm
                text: styleData.title
                anchors.centerIn: parent
            }
        }
    }
}
