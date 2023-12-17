import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.0

ScrollView {
    clip: true
    property var index: tv.currentIndex
    ListView {
        id: tv
        property var sourcePathForCopy: ""
        property var sourceFileForCopy: ""
        model: folderModel
        highlight: Rectangle {
            color: "lightsteelblue";
        }
        currentIndex: -1
        header: RowLayout {
            width: tv.width

            Rectangle {
                color: "transparent"
                Layout.fillWidth: true
                height: 30
                Label {
                    text: "название"
                    font.bold: true
                }
            }

            Rectangle {
                color: "transparent"
                Layout.fillWidth: true
                height: 30
                Label {
                    text: "тип"
                    font.bold: true
                }
            }

            Rectangle {
                color: "transparent"
                Layout.fillWidth: true
                height: 30
                Label {
                    text: "размер"
                    font.bold: true
                }
            }

            Rectangle {
                color: "transparent"
                Layout.fillWidth: true
                height: 30
                Label {
                    text: "дата последнего изменения"
                    font.bold: true
                }
            }
        }
        delegate: MouseArea
        {
            width: childrenRect.width
            height: childrenRect.height
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            RowLayout {
                width: tv.width

                Rectangle {
                    color: "transparent"
                    Layout.fillWidth: true
                    height: 30
                    Label {
                        width: parent.width
                        elide: Text.ElideRight
                        text: fileName
                        font.bold: fileIsDir ? true : false
                    }
                }

                Rectangle {
                    color: "transparent"
                    Layout.fillWidth: true
                    height: 30
                    Label {
                        width: parent.width
                        elide: Text.ElideRight
                        text: fileSuffix
                    }
                }

                Rectangle {
                    color: "transparent"
                    Layout.fillWidth: true
                    height: 30
                    Label {
                        width: parent.width
                        elide: Text.ElideRight
                        text: fileSize
                    }
                }

                Rectangle {
                    color: "transparent"
                    Layout.fillWidth: true
                    height: 30
                    Label {
                        width: parent.width
                        elide: Text.ElideRight
                        text: fileModified
                    }
                }
            }

            onClicked: {
                tv.currentIndex = index
                if (mouse.button === Qt.RightButton)
                    contextMenu.popup()
                else
                    if (!fileIsDir)
                        fm.setFile(filePath)

            }

            onDoubleClicked: {
                tv.currentIndex = index
                if (fileIsDir) {

                    if (folderModel.parentFolder == folderModel.rootFolder)
                        folderModel.folder = folderModel.folder + fileName
                    else
                        folderModel.folder = folderModel.folder + "/" + fileName
                }
            }

            Menu {
                id: contextMenu
                MenuItem {
                    text: "удалить"
                    onTriggered: fm.removeFile(filePath, fileIsDir)
                }
                MenuItem {
                    text: "Копировать"
                    onTriggered: {
                        tv.sourcePathForCopy = filePath
                        tv.sourceFileForCopy = fileName
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            z: -1
            onClicked: {
                if ((tv.sourcePathForCopy != "") && (tv.sourceFileForCopy!= "") )
                    cm.popup()
            }
        }

        Menu {
            id: cm
            MenuItem {
                text: "Вставить"
                onTriggered: {
                    if (!fm.copyFile(tv.sourcePathForCopy,   urlToPath(tv.model.folder) + tv.sourceFileForCopy))
                        errorCopy.open()
                }
            }
        }
    }
}
