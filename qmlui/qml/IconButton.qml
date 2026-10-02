/*
  Q Light Controller Plus
  IconButton.qml

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
import QtQuick.Controls.Basic

import "."

Button
{
    id: control
    visible: counter ? true : false
    height: UISettings.iconSizeDefault
    width: UISettings.iconSizeDefault
    hoverEnabled: true
    padding: 0
    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0

    property int counter: 1
    property color bgColor: UISettings.bgControl
    property color hoverColor: UISettings.hover
    property color pressColor: UISettings.highlightPressed
    property color checkedColor: UISettings.highlight

    property alias border: contentBody.border
    property alias radius: contentBody.radius
    property string imgSource: ""
    property int imgMargins: 8
    property string faSource: ""
    property color faColor: UISettings.fgMain

    property string tooltip: ""

    onCounterChanged:
    {
        if (counter == 0 && checkable && checked)
        {
            control.toggle()
            control.toggled()
        }
    }

    ToolTip
    {
        visible: tooltip && hovered
        text: tooltip
        delay: 800
        timeout: 5000
        padding: 6
        background:
            Rectangle
            {
                color: UISettings.bgControl
                radius: UISettings.controlRadius
                border.width: 1
                border.color: UISettings.bgLight
            }
        contentItem:
            Text
            {
                text: tooltip
                color: UISettings.fgMain
                font.family: UISettings.robotoFontName
                font.pixelSize: UISettings.textSizeDefault * 0.85
            }
    }

    contentItem:
        Item
        {
            opacity: control.enabled ? 1.0 : 0.35

            Image
            {
                id: btnIcon
                visible: imgSource ? true : false
                anchors.centerIn: parent
                width: Math.min(control.width - imgMargins, control.height - imgMargins)
                height: width
                source: imgSource
                sourceSize: Qt.size(width, height)
            }

            Text
            {
                id: faIcon
                visible: faSource ? true : false
                anchors.centerIn: parent
                color: control.checked ? UISettings.fgMain : faColor
                font.family: UISettings.fontAwesomeFontName
                font.pixelSize: control.height * 0.5
                text: faSource
            }
        }

    background:
        Rectangle
        {
            id: contentBody
            color: bgColor
            radius: UISettings.controlRadius
            border.color: Qt.rgba(1, 1, 1, 0.06)
            border.width: 1
            opacity: control.enabled ? 1.0 : 0.5

            Behavior on color { ColorAnimation { duration: 100 } }

            states: [
                State
                {
                    when: checked
                    PropertyChanges
                    {
                        target: contentBody
                        color: checkedColor
                        border.color: Qt.lighter(checkedColor, 1.3)
                    }
                },
                State
                {
                    when: control.pressed
                    PropertyChanges
                    {
                        target: contentBody
                        color: pressColor
                    }
                },
                State
                {
                    when: hovered
                    PropertyChanges
                    {
                        target: contentBody
                        color: hoverColor
                    }
                }
            ]
        }
}
