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
import "Global"
import "Other"
import "../material-qml/density.js" as Density

Item {
    id: root

    property alias dialogName: dTitle.text
    property alias buttonsContainer : buttonsContainer.sourceComponent
    property alias contentContainer : content.sourceComponent

    function showDialog() {
        dialog.visible = true
        dialogBackground.visible = true
        dialogBackground.state = "showBack"
    }

    function hideDialog() {
        dialog.visible = false
        dialogBackground.timer.start()
        dialogBackground.state = "hideBack"
    }

    anchors.fill: parent

    ACDarkBackground {
        id: dialogBackground

        onBackClicked: {
            hideDialog()
        }
    }

    Rectangle {
        id: dialog

        width: 45*Density.mm
        height: 50*Density.mm

        radius: 0.5*Density.mm
        visible: false

        anchors {
            centerIn: parent
        }

        Rectangle {
            id: header

            height: 8*Density.mm
            width: parent.width
            anchors {
                top: parent.top
                topMargin: 0.5*Density.mm
            }

            Text {
                id: dTitle

                font.pixelSize: 3.5*Density.mm
                color: ACGlobal.style.holoDarkBlue
                anchors {
                    left: parent.left
                    leftMargin: 2*Density.mm
                    verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                id: headerBorder

                height: 0.4*Density.mm
                width: parent.width
                color: ACGlobal.style.holoLightBlue
                anchors.bottom: parent.bottom
            }
        }

        Loader {
            id: content
            width: parent.width
            anchors{
                top:header.bottom
                bottom: footer.top
            }
        }

        Rectangle {
            id: footerBorder

            height: 0.1*Density.mm
            width: parent.width
            color: ACGlobal.style.lightGray
            anchors.bottom: footer.top
        }

        Rectangle {
            id: footer

            height: 7*Density.mm
            width: parent.width - 2*Density.mm

            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            Loader {
                id: buttonsContainer

                height: parent.height
                width: parent.width
            }
        }
    }
}
