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
import QtQuick.LocalStorage 2.7

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'mch2022.myname'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    property var db: null
    property string entryTable: "ItemEntryTable"

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

            onAccepted: {
                console.log("Entered text " + entryField.text)
                var entry = entryField.text 
                db.transaction(function(tx){
                    tx.executeSql("INSERT INTO " + entryTable + "(entry) VALUES( ? )", [entry])
                })
                model.append({ 'entry' : entry} )
            }
        }

        Button {
            id: submitButton
            text: i18n.tr('Submit')
            color: entryField.text

            anchors {
                top: header.bottom
                left: entryField.right
                
                topMargin: units.gu(2)
                leftMargin: units.gu(1)
            }

            onClicked: {
                console.log("Entered text " + entryField.text)
                var entry = entryField.text 
                db.transaction(function(tx){
                    tx.executeSql("INSERT INTO " + entryTable + "(entry) VALUES( ? )", [entry])
                })
                model.append({ 'entry' : entry} )
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
            }

            delegate: ListItem {
                width: parent.width
                height: units.gu(3)
                Text {
                    text: entry
                }
            }

            Component.onCompleted: {
                initializeDB();
            }

            function initializeDB() {
                var dbName = "MCH2022DB"
                var dbVersion = "1.0te"
                var dbDescription = "Database for todo list"
                var dbEstimatedSize = 1000;

                db = LocalStorage.openDatabaseSync(dbName, dbVersion, dbDescription, dbEstimatedSize)

                db.transaction(function(tx){
                    tx.executeSql("CREATE TABLE IF NOT EXISTS " + entryTable + "( entry TEXT)")
                    var results = tx.executeSql( 'SELECT rowid, entry FROM ' + entryTable)

                    // update the list model
                    for (var i = 0; i < results.rows.length; i++) {
                        model.append({"rowid": results.rows.item(i).rowid, 
                                      "entry": results.rows.item(i).entry})
                    }
                })
            }

        }

        Label {
            anchors {
                top: header.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            text: entryField.text

            verticalAlignment: Label.AlignVCenter
            horizontalAlignment: Label.AlignHCenter
        }
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
