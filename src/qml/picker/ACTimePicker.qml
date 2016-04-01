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

import QtQuick 2.1
import QtQuick.Controls 1.1

import "Global"
import "../material-qml/density.js" as Density

Item {

    property int hours: 12
    property int minutes: 00

    function showDialog() {
        dialogView.showDialog()
    }

    function hideDialog() {
        dialogView.hideDialog()
    }

    anchors.fill: parent

    ACDialog  {
        id: dialogView
        z:10
        dialogName: "Выбор времени"
        buttonsContainer: buttonsBlock
        contentContainer: centralBlock
    }

    Component {
        id: centralBlock

        Rectangle {
            ACPicker {
                id: hoursPicker

                model:
                    ListModel {
                    id: hoursModel

                    Component.onCompleted: {
                        append({ value: -1, text: " " })
                        for(var i = 0; i <= 23; i++){
                            var norm = i.toString();
                            if( i < 10 ) norm = "0" + i
                            append({ value: i, text: norm })
                        }
                        append({ value: -1, text: " " })
                    }
                }
                anchors {
                    right: center.left
                    rightMargin: 1*Density.mm
                    verticalCenter: parent.verticalCenter
                }
                Component.onCompleted: {
                    setValue(hours + 1)
                }
            }

            Text {
                id: center
                text:":"
                font.pixelSize: 3*Density.mm
                anchors.centerIn: parent
            }

            ACPicker {
                id: minutesPicker

                model:
                    ListModel {
                    id: minutesModel

                    Component.onCompleted: {
                        append({ value: -1, text: " " })
                        for(var i = 0; i <= 59; i++){
                            var norm = i.toString();
                            if( i < 10 ) norm = "0" + i
                            append({ value: i, text: norm })
                        }
                        append({ value: -1, text: " " })
                    }
                }
                anchors {
                    left: center.right
                    leftMargin: 1*Density.mm
                    verticalCenter: parent.verticalCenter
                }

                Component.onCompleted: {
                    setValue(minutes + 1)
                }
            }

            anchors.fill: parent
        }
    }

    Component {
        id: buttonsBlock

        ACDialogButton {
            id: pbReady

            width: parent.width
            text: qsTr("Готово");
            onBtClicked: {
                dialogView.hideDialog()
            }
        }
    }

    //TODO: setters for hours and minutes
}
