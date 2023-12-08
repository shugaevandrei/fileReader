import QtQuick
import QtQuick.Controls
import FileManager 1.0

ListView {
    id: fsysmod
    property var fmControl: null
    property var sourcePathForCopy: null
    property var sourceFileForCopy: null

    highlight: Rectangle {
        color: "lightsteelblue";
    }
    currentIndex: -1
    delegate: Rectangle
    {
        color: "transparent"
        height: 30
        width: parent.width
        Text {
            text: fileName
            font.bold: fileIsDir ? true : false
        }
        MouseArea {
            z: 1
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            //propagateComposedEvents: true
            //  preventStealing: true
            onClicked: {
                                fsysmod.currentIndex = index
                if (mouse.button === Qt.RightButton) {
                    contextMenu.popup()
                }

                if (!fileIsDir) {

                    // console.log("fileName", folderModel.get(index, "fileName"))
                    // console.log("filePath", folderModel.get(index, "filePath"))
                    // console.log("fileURL", folderModel.get(index, "fileURL"))
                    // console.log("fileUrl", folderModel.get(index, "fileUrl"))
                    // console.log("fileBaseName", folderModel.get(index, "fileBaseName"))
                    // console.log("fileSuffix", folderModel.get(index, "fileSuffix"))
                    // console.log("fileSize", folderModel.get(index, "fileSize"))
                    //  console.log("fileModified", folderModel.get(index, "fileModified"))
                    //  console.log("fileAccessed", folderModel.get(index, "fileAccessed"))
                    // console.log("fileIsDir", folderModel.get(index, "fileIsDir"))
                    console.log("parentFolder", folderModel.parentFolder)

                    console.log("fsysmod.model.folder", fsysmod.model.name)

                   // pathLbl.text = filePath
                    te.text = fm.setPath(filePath)
                }
            }
            onDoubleClicked: {
                fsysmod.currentIndex = index
                if (fileIsDir) {
                    folderModel.folder =  "file:/" + filePath + "/"
                    // folderModel.folder = folderModel.get(folderModel.index, "fileUrl");
                    //te.text = fm.setPath(filePath)
                    console.log(folderModel.get(folderModel.index, "filePath"),  "file:/" + filePath + "/")
                }
                //console.log(folderModel.get(folderModel.index, "fileURL"))
                // folderModel.folder =  "file:/" + filePath + "/"
            }

            Menu {
                id: contextMenu
                MenuItem { text: "удалить"
                    onTriggered: fm.remove(filePath)
                }
                MenuItem { text: "Копировать"
                    onTriggered: {sourcePathForCopy = filePath
                        sourceFileForCopy = fileName
                     console.log("имя файла", fileName)
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        z: -1
        onClicked: {
            //if (mouse.button === Qt.RightButton) {
            cm.popup()
            // }
        }
        Menu {
            id: cm
            MenuItem {
                //  property var newPathForCopy: null
                text: "Вставить"
                onTriggered: {

                    if (!fm.copy(sourcePathForCopy, urlToPath(fsysmod.model.folder) +sourceFileForCopy/*folderModel.get(folderModel.index, "filePath")*/))
                        errorCopy.open()

                }
            }
        }

    }


    //    FileManager {
    //        id: fm
    //    }
}
