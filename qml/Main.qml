/*
 * Copyright (C) 2022  My Name
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * mch2022 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import Ubuntu.Components 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import io.thp.pyotherside 1.4

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'mch2022.myname'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    Page {
        anchors.fill: parent

        header: PageHeader {
            id: header
            title: i18n.tr('MCH 2022')
        }

        TextField {
            id: entryField

            anchors {
                top: header.bottom
                left: parent.left

                topMargin: units.gu(2)
                leftMargin: units.gu(2)
            }
        }

        Button {
            id: submitButton
            text: i18n.tr('Submit')

            anchors {
                top: header.bottom
                left: entryField.right
                
                topMargin: units.gu(2)
                leftMargin: units.gu(1)
            }

            onClicked: {
                console.log("Entered text " + entryField.text)
                model.append({ 'entry' : entryField.text} )
            }
        }

ListView {
    id: listOfTodos

    anchors {
        top: entryField.bottom
        left: parent.left
        right: parent.right
        bottom: parent.bottom

        margins: units.gu(2)
    }

    model: ListModel {
        id: model

        // will be explained later
        property var addItem: null
    }

    delegate: ListItem {
        width: parent.width
        height: units.gu(3)
        Text {
            text: entry
        }
    }

}
        // Label {
        //     anchors {
        //         top: entryField.bottom
        //         left: parent.left
        //         right: parent.right
        //         bottom: parent.bottom
        //     }
        //     text: i18n.tr('Check the logs!')

        //     verticalAlignment: Label.AlignVCenter
        //     horizontalAlignment: Label.AlignHCenter
        // }
    }

    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../src/'));

            importModule('example', function() {
                console.log('module imported');
                python.call('example.speak', ['Hello World!'], function(returnValue) {
                    console.log('example.speak returned ' + returnValue);
                })
            });
        }

        onError: {
            console.log('python error: ' + traceback);
        }
    }
}
