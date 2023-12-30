import QtQuick 2.0
import QtQuick.Controls 2.4

ScrollView {
    clip: true
    property var index: gv.currentIndex
    GridView {
        id: gv
        property var sourcePathForCopy: ""
        property var sourceFileForCopy: ""
        cellWidth: 90
        cellHeight: 90
        model: folderModel
        currentIndex: -1
        snapMode: GridView.SnapOneRow
        highlight: Rectangle {
            color: "lightsteelblue";
        }
        delegate: MouseArea {
            width: childrenRect.width
            height: childrenRect.height
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            Column {
                Image {
                    id: name
                    width: 30
                    height: 30
                    source: fileIsDir ? "qrc:/folder.png":"qrc:/file.png"
                }
                Text {
                    width: 90
                    text: fileName
                    elide: Text.ElideRight
                    font.bold: fileIsDir ? true : false
                    font.pixelSize: 10
                }
            }

            onClicked: {
                gv.currentIndex = index
                if (mouse.button === Qt.RightButton)
                    contextMenu.popup()
                else
                    if (!fileIsDir)
                        fm.setFile(filePath)
            }

            onDoubleClicked: {
                gv.currentIndex = index
                if (fileIsDir) {

                    if (folderModel.parentFolder == folderModel.rootFolder)
                        folderModel.folder =  folderModel.folder + fileName
                    else
                        folderModel.folder =  folderModel.folder + "/" + fileName
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
                        gv.sourcePathForCopy = filePath
                        gv.sourceFileForCopy = fileName
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            z: -1
            onClicked: {
                if ((gv.sourcePathForCopy != "") && (gv.sourceFileForCopy!= "") )
                    cm.popup()
            }
        }

        Menu {
            id: cm
            MenuItem {
                text: "Вставить"
                onTriggered: {
                    if (!fm.copyFile(gv.sourcePathForCopy,   urlToPath(gv.model.folder) + gv.sourceFileForCopy))
                        errorCopy.open()
                }
            }
        }
    }
}

