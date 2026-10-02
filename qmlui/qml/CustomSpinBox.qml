/*
  Q Light Controller Plus
  CustomSpinBox.qml

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

SpinBox
{
    id: control
    font.family: UISettings.robotoFontName
    font.pixelSize: UISettings.textSizeDefault
    width: UISettings.bigItemHeight
    height: UISettings.listItemHeight
    implicitWidth: UISettings.bigItemHeight
    implicitHeight: UISettings.listItemHeight
    editable: true
    from: 0
    to: 255
    clip: true
    wheelEnabled: true

    property bool showControls: true
    property string suffix: ""
    property alias horizontalAlignment: textControl.horizontalAlignment
    property int controlWidth: showControls ? Math.min(UISettings.iconSizeMedium, control.width / 3) : 0

    onFromChanged: if (value < from) control.value = from
    onToChanged: if (value > to) control.value = to

    onFocusChanged:
    {
        if (focus) contentItem.selectAll()
    }

    textFromValue: function(value) {
        return value + suffix
    }

    valueFromText: function(text) {
        return parseInt(text.replace(suffix, ""))
    }

    opacity: enabled ? 1.0 : 0.4

    background: Rectangle {
        implicitWidth: parent.width
        color: UISettings.bgControl
        radius: UISettings.controlRadius
        border.width: 1
        border.color: textControl.activeFocus ? UISettings.highlight : Qt.rgba(1, 1, 1, 0.07)
    }

    contentItem: TextInput {
        id: textControl
        z: 2
        height: control.height
        font: control.font
        text: control.textFromValue(control.value, control.locale)
        color: UISettings.fgMain
        selectByMouse: true
        selectionColor: UISettings.highlightPressed
        selectedTextColor: "white"
        horizontalAlignment: Qt.AlignRight
        verticalAlignment: Qt.AlignVCenter
        leftPadding: 6
        rightPadding: 6

        readOnly: !control.editable
        validator: control.validator
        inputMethodHints: Qt.ImhFormattedNumbersOnly
    }

    up.indicator: Rectangle {
        visible: showControls
        x: parent.width - width
        implicitHeight: parent.height / 2
        implicitWidth: controlWidth
        color: up.pressed ? UISettings.highlight : (up.hovered ? UISettings.bgLight : "transparent")
        radius: UISettings.controlRadius

        Rectangle
        {
            x: 0
            width: 1
            height: parent.height * 2
            color: UISettings.separator
        }

        Text
        {
            anchors.centerIn: parent
            font.family: UISettings.fontAwesomeFontName
            font.pixelSize: Math.max(8, parent.height * 0.45)
            color: UISettings.fgLight
            text: FontAwesome.fa_chevron_up
        }
    }

    down.indicator: Rectangle {
        visible: showControls
        x: parent.width - width
        y: parent.height / 2
        implicitWidth: controlWidth
        implicitHeight: parent.height / 2
        color: down.pressed ? UISettings.highlight : (down.hovered ? UISettings.bgLight : "transparent")
        radius: UISettings.controlRadius

        Text
        {
            anchors.centerIn: parent
            font.family: UISettings.fontAwesomeFontName
            font.pixelSize: Math.max(8, parent.height * 0.45)
            color: UISettings.fgLight
            text: FontAwesome.fa_chevron_down
        }
    }
}
