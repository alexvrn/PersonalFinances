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
import "../material-qml/density.js" as Density
import "Global"

Item {

    property int day: 15
    property int month: 12
    property int year: 2014

    signal dateSelected()

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
        dialogName: "Выбор даты"
        buttonsContainer: buttonsBlock
        contentContainer: centralBlock
    }

    // TODO: check 30 and 31 day in month
    Component {
        id: centralBlock

        Item {
            ACPicker {
                id: daysPicker

                model:
                    ListModel {
                    Component.onCompleted: {
                        append({ value: -1, text: " " })
                        for(var i = 1; i <= 31; i++){
                            var norm = i.toString();
                            if( i < 10 ) norm = "0" + i
                            append({ value: i, text: norm })
                        }
                        append({ value: -1, text: " " })
                    }
                }

                anchors {
                    right: monthsPicker.left
                    rightMargin: 1.5*Density.mm
                    verticalCenter: parent.verticalCenter
                }

                Component.onCompleted: {
                    setValue(day)
                }

                onIndexSelected: {
                    day = value
                    var lastDate = new Date(year, month + 1, 0).getDate();
                    if(day > lastDate) {
                        day = lastDate;
                    }
                }
            }

            ACPicker {
                id: monthsPicker

                model:
                    ListModel {
                    Component.onCompleted: {
                        var buffDate = new Date();
                        append({ value: -1, text: " " })
                        for(var i = 0; i <= 11; i++){
                            buffDate.setMonth(i)
                            var monthNic = Qt.formatDate(buffDate, "MMM")
                            monthNic = monthNic.slice(0,-1)
                            //append({ value: i, text: monthNic })
                        }
                        append({ value: -1, text: " " })
                    }
                }
                anchors.centerIn: parent

                Component.onCompleted: {
                    setValue(month)
                }

                onIndexSelected: {
                    month = value - 1
                }
            }

            ACPicker {
                id: yearsPicker

                model:
                    ListModel {
                    Component.onCompleted: {
                        append({ value: -1, text: " " })
                        for(var i = 2001; i <= 2038; i++){
                            append({ value: i, text: i.toString() })
                        }
                        append({ value: -1, text: " " })
                    }
                }
                anchors {
                    left: monthsPicker.right
                    leftMargin: 1.5*Density.mm
                    verticalCenter: parent.verticalCenter
                }

                Component.onCompleted: {
                    setValue(year%100)
                }

                onIndexSelected: {
                    year = value + 2000
                }
            }
            Connections {
                target: ACGlobal.dp

                onCurrentDateChanged: {
                    day = Qt.formatDateTime( arg, "d" )
                    month = Qt.formatDateTime( arg, "M" )
                    year = Qt.formatDateTime( arg, "yyyy" )
                    daysPicker.setValue( day )
                    monthsPicker.setValue( month )
                    yearsPicker.setValue( year )
                }
            }
        }
    }

    Component {
        id: buttonsBlock

        ACDialogButton {
            id: pbReady

            width: parent.width
            text: qsTr("Готово");
            onBtClicked: {
                dateSelected()
                dialogView.hideDialog()
            }
        }
    }
}
