/*
  Q Light Controller Plus
  ZoomItem.qml

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
    id: itemRoot
    implicitWidth: UISettings.iconSizeDefault * 2
    implicitHeight: UISettings.iconSizeDefault

    color: UISettings.bgControl

    border.color: Qt.rgba(1, 1, 1, 0.07)
    border.width: 1
    radius: UISettings.controlRadius
    clip: true

    property color fontColor: UISettings.fgLight

    signal zoomInClicked
    signal zoomOutClicked

    Rectangle
    {
        width: parent.width / 2
        height: parent.height
        color: zoMouseArea.pressed ? UISettings.highlight :
                                     (zoMouseArea.containsMouse ? UISettings.bgLight : "transparent")
        radius: itemRoot.radius

        Text
        {
            anchors.centerIn: parent
            color: fontColor
            font.family: UISettings.fontAwesomeFontName
            font.pixelSize: parent.height * 0.48
            text: FontAwesome.fa_magnifying_glass_minus
        }
        MouseArea
        {
            id: zoMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: itemRoot.zoomOutClicked()
        }
    }

    // vertical divider
    Rectangle
    {
        x: parent.width / 2
        y: parent.height * 0.2
        z: 2
        width: 1
        height: parent.height * 0.6
        color: UISettings.bgLighter
    }

    Rectangle
    {
        x: parent.width / 2
        width: parent.width / 2
        height: parent.height
        color: ziMouseArea.pressed ? UISettings.highlight :
                                     (ziMouseArea.containsMouse ? UISettings.bgLight : "transparent")
        radius: itemRoot.radius

        Text
        {
            anchors.centerIn: parent
            color: fontColor
            font.family: UISettings.fontAwesomeFontName
            font.pixelSize: parent.height * 0.48
            text: FontAwesome.fa_magnifying_glass_plus
        }
        MouseArea
        {
            id: ziMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: itemRoot.zoomInClicked()
        }
    }
}
