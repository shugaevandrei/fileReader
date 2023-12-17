import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.0
import Qt.labs.folderlistmodel 2.11

import FileManager 1.0

ApplicationWindow {
    id: root
    width: 940
    height: 680
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
    header: Row {
        Label {
            id: pathLbl
            leftPadding: 10
        }
    }

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal
        z: -1

        Rectangle {
            //область файловой системы
            height: parent.height
            width: parent.width * 0.3
            color: "white"
            ColumnLayout {
                anchors.fill: parent
                RowLayout {
                    spacing: 0
                    Button {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 20
                        text: "<"
                        Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                            border.color: "black"
                        }
                        onClicked: {
                            if (folderModel.parentFolder != folderModel.rootFolder)
                                folderModel.folder = folderModel.parentFolder
                        }
                    }
                    Button {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 20
                        text: ">"
                        Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                            border.color: "black"
                        }
                        onClicked:  {
                            var ind  = loader.item.index
                            if (folderModel.isFolder(ind)) {
                                if (folderModel.parentFolder == folderModel.rootFolder)
                                    folderModel.folder =  folderModel.folder + folderModel.get(ind, "fileName")
                                else
                                    folderModel.folder =  folderModel.folder + "/" + folderModel.get(ind, "fileName")
                            }
                        }
                    }
                }

                Loader {
                    id: loader
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.leftMargin: 10
                    Layout.topMargin: 10
                    source: "qrc:/ListV.qml"

                }

                FolderListModel {
                    id: folderModel
                    showDirsFirst: true
                    rootFolder: "file:///"
                    Component.onCompleted: pathLbl.text = urlToPath(folderModel.folder)
                    onFolderChanged:  pathLbl.text = urlToPath(folderModel.folder)
                }
            }
        }

        Rectangle {
            height: parent.height
            width: parent.width * 0.7
            color: "white"
            ColumnLayout {
                anchors.fill: parent
                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 10

                    TextEdit {
                        id: te
                        persistentSelection: true
                        selectByMouse: true
                        text: fm.text

                        Menu {
                            id: contextMenu

                            MenuItem {
                                text: "копировать"
                                onTriggered: fm.copyText(te.selectedText)
                            }
                            MenuItem {
                                text: "вырезать"
                                onTriggered: fm.removeText(te.selectionStart, te.selectionEnd)
                            }
                            MenuItem {
                                text: "вставить"
                                onTriggered: fm.pasteText(te.selectionStart)
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            propagateComposedEvents: true
                            acceptedButtons: Qt.RightButton
                            onClicked: {
                                contextMenu.x = mouseX
                                contextMenu.y = mouseY
                                contextMenu.open()
                            }
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: errorCopy
        x: parent.width/2 - width/2
        y: parent.height/2 - height/2
        width: 300
        height: 100
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        Column {
            anchors.fill: parent
            Label {
                text: "такой файл уже существует или \nнедостаточно прав для копирования"
            }
            Button {
                text: "ok"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: errorCopy.close()
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.color: "black"
                }
            }
        }
    }

    FileManager {
        id: fm
    }

    function urlToPath(url) {
        var path = url.toString()
        path = path.replace(/^(file:\/{3})/,"")

        if ((path.substr(path.length - 1) !== "/"))
            path += "/"

        return "/" + decodeURIComponent(path);
    }
}
