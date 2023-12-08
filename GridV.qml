import QtQuick

GridView {
    id: gv
   // width: 110
    //height: parent.width
    cellWidth: 80
    cellHeight: 80
    model: folderModel
    highlight: Rectangle {
        color: "lightsteelblue";
    }
    delegate: MouseArea {
        width: childrenRect.width
        height: childrenRect.height
        Column {
            Image {
                id: name
                width: 30
                height: 30
                source: fileIsDir ? "qrc:/folder.png":"qrc:/file.png"
            }
            Text {
                text: fileName
            }
        }
        onClicked: {
            gv.currentIndex = index
            pathLbl.text = filePath
            te.text = fm.setPath(filePath)
        }
        onDoubleClicked: {
            gv.currentIndex = index
            if (fileIsDir) {
                folderModel.folder =  "file:/" + filePath + "/"
            }
        }
    }
   // flow: GridView.FlowLeftToRight
   // layoutDirection: Qt.LeftToRight
    //snapMode: GridView.SnapOneColumn
}


