import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls 2.4

ScrollView {
    clip: true
    property var index: lv.currentIndex
    ListView {
        id: lv
        property var sourcePathForCopy: ""
        property var sourceFileForCopy: ""
        model: folderModel
        highlight: Rectangle {
            color: "lightsteelblue";
        }
        currentIndex: -1
        delegate: MouseArea {
            width: childrenRect.width
            height: childrenRect.height
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            Text {
                width: lv.width
                text: fileName
                font.bold: fileIsDir ? true : false
            }

            onClicked: {
                lv.currentIndex = index
                if (mouse.button === Qt.RightButton)
                    contextMenu.popup()
                else
                    if (!fileIsDir)
                        fm.setFile(filePath)

            }

            onDoubleClicked: {
                lv.currentIndex = index
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
                        lv.sourcePathForCopy = filePath
                        lv.sourceFileForCopy = fileName
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            z: -1
            onClicked: {
                if ((lv.sourcePathForCopy != "") && (lv.sourceFileForCopy!= "") )
                    cm.popup()
            }
        }

        Menu {
            id: cm
            MenuItem {
                text: "Вставить"
                onTriggered: {
                    if (!fm.copyFile(lv.sourcePathForCopy,   urlToPath(lv.model.folder) + lv.sourceFileForCopy))
                        errorCopy.open()
                }
            }
        }
    }
}
