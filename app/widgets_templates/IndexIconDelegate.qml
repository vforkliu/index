import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.2 as Kirigami

ItemDelegate
{
    property bool isDetails : false
    property int folderSize : iconSize
    property bool isHovered :  hovered
    property bool showLabel : true
    property bool showSelectionBackground : true
    property bool showTooltip : false

    property bool emblemAdded : false
    property bool keepEmblemOverlay : false
    property bool isCurrentListItem :  ListView.isCurrentItem

    property color labelColor : (isCurrentListItem || GridView.isCurrentItem || (keepEmblemOverlay && emblemAdded)) && !hovered && showSelectionBackground ? highlightedTextColor : textColor
    property color hightlightedColor : GridView.isCurrentItem || hovered || (keepEmblemOverlay && emblemAdded) ? highlightColor : "transparent"

    signal rightClicked();
    signal emblemClicked(int index);

    focus: true
    hoverEnabled: !isMobile

    background: Rectangle
    {
        color: !isDetails? "transparent" : (isCurrentListItem ? highlightColor :
                                                                index % 2 === 0 ? Qt.lighter(backgroundColor,1.2) : backgroundColor)

    }

    MouseArea
    {
        anchors.fill: parent
        acceptedButtons:  Qt.RightButton
        onClicked:
        {
            if(!isMobile && mouse.button === Qt.RightButton)
                rightClicked()
        }
    }

    IndexButton
    {
        id: emblem
        isMask: false

        iconName: (keepEmblemOverlay && emblemAdded) ? "emblem-remove" : "emblem-added"
        visible: isHovered || (keepEmblemOverlay && emblemAdded)
        z: 999
        anchors.top: parent.top
        anchors.left: parent.left
        onClicked:
        {
            emblemAdded = !emblemAdded
            emblemClicked(index)
        }
    }

    GridLayout
    {
        id: delegatelayout
        anchors.fill: parent
        rows: isDetails ? 1 : 2
        columns: isDetails ? 2 : 1
        rowSpacing: space.tiny
        columnSpacing: space.tiny

        Item
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.maximumWidth: folderSize
            Layout.row: 1
            Layout.column: 1
            Layout.alignment: Qt.AlignCenter
            Layout.leftMargin: isDetails ? space.medium : 0
            IndexButton
            {
                anchors.centerIn: parent
                iconName: model.iconName
                isMask: folderSize <= iconSizes.medium
                iconColor: labelColor
                size: folderSize
                enabled: false
            }

            ToolTip.delay: 1000
            ToolTip.timeout: 5000
            ToolTip.visible: hovered && showTooltip
            ToolTip.text: path
        }


        Item
        {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.maximumHeight: parent.height * (isDetails ? 1 : 0.3)

            Layout.row: isDetails ? 1 : 2
            Layout.column: isDetails ? 2 : 1

            Layout.leftMargin: isDetails ? space.medium : 0

            Label
            {
                visible: showLabel
                text: label
                width: parent.width
                height: parent.height
                horizontalAlignment: isDetails? Qt.AlignLeft : Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                elide: Qt.ElideRight
                wrapMode: Text.Wrap
                font.pointSize: fontSizes.default
                color: labelColor

                Rectangle
                {
                    visible: parent.visible && showSelectionBackground && !isDetails
                    anchors.fill: parent
                    z: -1
                    radius: Kirigami.Units.devicePixelRatio * 3
                    color: hightlightedColor
                    opacity: hovered ? 0.25 : 1
                }
            }
        }
    }
}
