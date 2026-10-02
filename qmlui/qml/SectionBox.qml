/*
  Q Light Controller Plus
  SectionBox.qml

  Copyright (c) Massimo Callegari

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0.txt

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/

import QtQuick
import "."

Rectangle
{
    id: boxRoot
    width: parent.width
    height: isExpanded ? (cPropsHeader.height + sectionLoader.height) : cPropsHeader.height
    color: "transparent"
    clip: true

    property bool isExpanded: true
    property string sectionLabel: ""
    property Component sectionContents
    property alias loadedItem: sectionLoader.item

    Column
    {
        id: sectionColumn
        width: parent.width

        Rectangle
        {
            id: cPropsHeader
            width: parent.width
            height: UISettings.listItemHeight
            color: headerMouseArea.containsMouse ? UISettings.bgControl : UISettings.sectionHeader

            Behavior on color { ColorAnimation { duration: 100 } }

            Text
            {
                id: disclosureIcon
                x: UISettings.textSizeDefault * 0.7
                anchors.verticalCenter: parent.verticalCenter
                font.family: UISettings.fontAwesomeFontName
                font.pixelSize: UISettings.textSizeDefault * 0.7
                text: FontAwesome.fa_chevron_right
                color: UISettings.fgMedium
                rotation: boxRoot.isExpanded ? 90 : 0

                Behavior on rotation { NumberAnimation { duration: 120 } }
            }

            Text
            {
                anchors.left: disclosureIcon.right
                anchors.leftMargin: UISettings.textSizeDefault * 0.6
                anchors.right: parent.right
                anchors.rightMargin: UISettings.textSizeDefault * 0.6
                anchors.verticalCenter: parent.verticalCenter
                text: boxRoot.sectionLabel
                elide: Text.ElideRight
                font.family: UISettings.robotoFontName
                font.pixelSize: UISettings.textSizeDefault * 0.9
                font.weight: Font.DemiBold
                color: UISettings.fgLight
            }

            MouseArea
            {
                id: headerMouseArea
                anchors.fill: parent
                hoverEnabled: true

                onClicked: boxRoot.isExpanded = !boxRoot.isExpanded
            }

            Rectangle
            {
                width: parent.width
                height: 1
                y: parent.height - 1
                color: UISettings.sectionHeaderDiv
            }
        }

        Loader
        {
            id: sectionLoader
            width: parent.width
            sourceComponent: isExpanded ? boxRoot.sectionContents : null
        }
    }
}
