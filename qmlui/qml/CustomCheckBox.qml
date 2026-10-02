/*
  Q Light Controller Plus
  CustomCheckBox.qml

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

RadioButton
{
    id: controlRoot
    implicitWidth: UISettings.iconSizeDefault
    implicitHeight: UISettings.iconSizeDefault
    hoverEnabled: true
    autoExclusive: false
    focusPolicy: Qt.StrongFocus

    property color bgColor: UISettings.bgControl
    property color hoverColor: UISettings.bgLight
    property color pressColor: UISettings.highlightPressed
    property string tooltip: ""

    opacity: enabled ? 1.0 : 0.4

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

    /* macOS-like checkbox: a rounded box that fills with the accent color */
    background:
        Rectangle
        {
            id: cbBody
            x: (controlRoot.width - width) / 2
            y: (controlRoot.height - height) / 2
            width: Math.min(controlRoot.width, controlRoot.height) * 0.62
            height: width
            radius: width * 0.24
            color: controlRoot.checked ? (controlRoot.pressed ? pressColor : UISettings.highlight)
                                       : (controlRoot.hovered ? hoverColor : bgColor)
            border.width: controlRoot.focus ? 2 : 1
            border.color: controlRoot.focus ? Qt.lighter(UISettings.highlight, 1.3)
                                            : (controlRoot.checked ? UISettings.highlight : UISettings.bgLighter)

            Behavior on color { ColorAnimation { duration: 100 } }
        }

    indicator:
        Text
        {
            visible: checked
            anchors.centerIn: parent
            color: "white"
            font.family: UISettings.fontAwesomeFontName
            font.pixelSize: Math.min(controlRoot.width, controlRoot.height) * 0.38
            text: FontAwesome.fa_check
        }
}
