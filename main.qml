import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtQml
import Qt.labs.folderlistmodel
import FileManager 1.0

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("File Reader")

    menuBar: MenuBar {
        Menu {
            title: qsTr("Вид")
            MenuItem {
                text: qsTr("Список")
                onTriggered: loader.setSource("qrc:/ListV.qml", {"model": folderModel }, {"fmControl": fm})

            }

            MenuItem {
                text: qsTr("Значки")
                onTriggered:  loader.setSource("qrc:/GridV.qml", {"model": folderModel })
            }

            MenuItem {
                text: qsTr("Таблица")
                onTriggered: loader.setSource("qrc:/TableV.qml", {"model": folderModel })
            }
        }

        Menu {
            title: qsTr("Сортировка")
            MenuItem {
                text: qsTr("Название")
                onTriggered: folderModel.sortField = FolderListModel.Name

            }

            MenuItem {
                text: qsTr("Время")
                onTriggered: folderModel.sortField = FolderListModel.Time
            }

            MenuItem {
                text: qsTr("Размер")
                onTriggered: folderModel.sortField = FolderListModel.Size
            }
            MenuItem {
                text: qsTr("Тип")
                onTriggered: folderModel.sortField = FolderListModel.Type
            }
        }
    }
    header: Label {
        id: pathLbl
        // text: folderModel.folder

    }
    Rectangle {
        id: background
        anchors.fill: parent
        color: "gray"
        // opacity: 0.7
        z: -1
        RowLayout {
            anchors.fill: parent
            spacing: 6
            Rectangle {
                //левая часть
                id: modelSpace
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.3
                color: "white"
                ColumnLayout {
                    anchors.fill: parent
                    RowLayout {
                        //Layout.fillWidth: true
                        // anchors.fill: parnt
                        Button {
                            Layout.preferredWidth: 50
                            text: "back"
                            onClicked: {
                                folderModel.folder = folderModel.parentFolder// + "/"
                                // te.text = fm.setPath(filePath)

                            }
                        }
                        Button {
                            Layout.preferredWidth: 50
                            text: "next"
                        }
                    }
                    ScrollView {
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Loader {
                            id: loader
                            anchors.fill: parent
                            // Layout.preferredHeight: 1000
                            //Layout.preferredWidth: 500
                            source: "qrc:/GridV.qml"


                        }
                        FolderListModel {
                            id: folderModel
                            showDirsFirst: true
                            //  rootFolder:"file:/c"
                            //folder:  "file:/git"
                            // nameFilters: ["*.qml"]


                            Component.onCompleted: pathLbl.text = urlToPath(folderModel.folder)


                            onFolderChanged: pathLbl.text = urlToPath(folderModel.folder)

                        }

                    }

                }
            }
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: (parent.width * 0.7) - parent.spacing
                color: "white"
                ColumnLayout {
                    anchors.fill: parent
                    // Layout.fillHeight: true
                    // Layout.preferredWidth: parent.width * 0.8


                    ScrollView {
                        // Layout.leftMargin: 6
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        // Layout.minimumWidth: 100
                        //  Layout.preferredWidth: 300
                        // Layout.minimumHeight: 50
                        //  Layout.preferredHeight: 100

                        TextEdit {
                            id: te
                            //Layout.alignment: Qt.AlignCenter
                            // Layout.preferredWidth: 500
                            //Layout.preferredHeight: 300
                            //implicitWidth: text.impl

                            //                            MouseArea {
                            //                                anchors.fill: parent
                            //                                acceptedButtons: Qt.LeftButton | Qt.RightButton
                            //                                onClicked: {
                            //                                     if (mouse.button === Qt.RightButton) {
                            //                                        contextMenu.popup()
                            //                                     }
                            //                                }

                            //                                Menu {
                            //                                    id: contextMenu

                            //                                    MenuItem { text: "копировать" }
                            //                                    MenuItem { text: "вставить" }
                            //                                }
                            //                            }
                        }
                    }
                }

            }
        }
    }

    Popup {
        id: errorCopy
        Label {
            text: "такой файл уже существует или недостаточно прав для копирования"
        }
        x: 100
        y: 100
        width: 200
        height: 300
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    }

    FileManager {
        id: fm
    }

    function urlToPath(url) {
        var path = url.toString()
        path = path.replace(/^(file:\/{3})/,"")

        if ((path.substr(path.length - 1) !== "/"))
            path += "/"

        return decodeURIComponent(path);
    }

}
