import QtQuick
import QtQuick.Controls

ListView {
    id: fsysmod
    width: 110
    height: 400
    highlight: highlight
    currentIndex: -1
    header: Row {
        Rectangle {
            height: 30
            width: 100

            color: "transparent"

            Label {
                anchors.fill: parent
                text: "название"
                 font.bold: true
            }
        }
        Rectangle {
            height: 30
            width: 100

            color: "transparent"

            Label {
                anchors.fill: parent
                text: "тип"
                font.bold: true
            }
        }
        Rectangle {
            height: 30
            width: 100

            color: "transparent"

            Label {
                anchors.fill: parent
                text: "размер"
                font.bold: true
            }
        }
        Rectangle {
            height: 30
            width: 100

            color: "transparent"

            Label {
                anchors.fill: parent
                text: "дата последнего изменения"
                font.bold: true

            }
        }
    }
    delegate: Rectangle
    {
        color: "transparent"
        height: 30
        width: 100

        Row {
               Rectangle {
                   height: 30
                   width: 100

                   color: "transparent"
                   Label {

                       anchors.fill: parent
                       text: fileName
                   }
               }
               Rectangle {
                   height: 30
                   width: 100

                   color: "transparent"

                   Label {
                       anchors.fill: parent
                       text: fileSuffix
                   }
               }
               Rectangle {
                   height: 30
                   width: 100

                   color: "transparent"

                   Label {
                       anchors.fill: parent
                       text: fileSize
                   }
               }
               Rectangle {
                   height: 30
                   width: 100

                   color: "transparent"

                   Label {
                       anchors.fill: parent
                       text: fileModified
                   }
               }
           }
//        Text {
//            text: fileName
//            font.bold: fileIsDir ? true : false
//        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                fsysmod.currentIndex = index
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

                    pathLbl.text = filePath
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
        }
    }

    Component {
        id: highlight
        Rectangle {
            width: 180; height: 40
            color: "lightsteelblue";
            y: fsysmod.currentItem.y
            Behavior on y {
                SpringAnimation {
                    spring: 3
                    damping: 0.2
                }
            }
        }
    }
}
