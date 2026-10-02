/*
  Q Light Controller Plus
  MenuBarEntry.qml

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
import QtQuick.Layouts
import QtQuick.Controls.Basic

import "."

/* A toolbar entry rendered as a macOS-like segmented control item:
 * a rounded "pill" that lights up when hovered or checked */
Button
{
    id: control
    implicitHeight: parent.height

    hoverEnabled: true
    checkable: true
    padding: 0
    topPadding: 0
    bottomPadding: 0
    leftPadding: pillMargin + UISettings.textSizeDefault * 0.6
    rightPadding: pillMargin + UISettings.textSizeDefault * 0.6

    property string imgSource: ""
    property string faSource: ""
    property color faColor: UISettings.fgLight
    property string entryText: ""
    property real mFontSize: UISettings.textSizeDefault * 0.85
    property int iconSize: imgSource ? Math.round((height - topPadding - bottomPadding) * 0.52) : 0
    property int iconRotation: 0

    /* margin between the pill and the entry bounds */
    property real pillMargin: Math.max(2, height * 0.12)

    /* Kept for API compatibility. The modern look is flat, so gradients
     * provided by callers are not painted anymore */
    property Gradient bgGradient: defBgGradient
    property Gradient selGradient: defSelectionGradient
    property Gradient pressedGradient: defPressedGradient
    property color checkedColor: UISettings.toolbarSelectionMain

    signal rightClicked

    Gradient
    {
        id: defBgGradient
        GradientStop { position: 0; color: "transparent" }
    }
    Gradient
    {
        id: defSelectionGradient
        GradientStop { position: 0; color: UISettings.toolbarHoverStart }
        GradientStop { position: 1; color: UISettings.toolbarHoverEnd }
    }
    Gradient
    {
        id: defPressedGradient
        GradientStop { position: 0; color: UISettings.bgLight }
        GradientStop { position: 1; color: UISettings.bgMedium }
    }

    contentItem:
        Item
        {
            implicitWidth: entryContents.implicitWidth
            implicitHeight: control.height
            opacity: control.enabled ? 1 : 0.35

            Row
            {
                id: entryContents
                anchors.centerIn: parent
                spacing: UISettings.textSizeDefault * 0.45

                Image
                {
                    id: btnIcon
                    visible: control.imgSource
                    anchors.verticalCenter: parent.verticalCenter
                    height: control.iconSize
                    width: control.iconSize
                    rotation: iconRotation
                    source: control.imgSource
                    sourceSize: Qt.size(control.iconSize, control.iconSize)
                }

                Text
                {
                    id: faIcon
                    visible: faSource ? true : false
                    anchors.verticalCenter: parent.verticalCenter
                    color: control.checked ? control.checkedColor : faColor
                    font.family: UISettings.fontAwesomeFontName
                    font.pixelSize: control.height * 0.45
                    text: faSource
                }

                Text
                {
                    id: btnLabel
                    visible: text !== ""
                    anchors.verticalCenter: parent.verticalCenter
                    text: control.entryText
                    font.family: UISettings.robotoFontName
                    font.pixelSize: control.mFontSize
                    font.weight: Font.DemiBold
                    color: control.checked || control.hovered ? UISettings.fgMain : UISettings.fgLight
                }
            }
        }

    background:
        Rectangle
        {
            x: control.pillMargin
            y: control.pillMargin
            width: control.width - control.pillMargin * 2
            height: control.height - control.pillMargin * 2
            radius: UISettings.controlRadius
            color:
            {
                if (control.pressed)
                    return UISettings.bgLighter
                if (control.checked)
                    return Qt.rgba(control.checkedColor.r, control.checkedColor.g, control.checkedColor.b, 0.20)
                if (control.hovered)
                    return UISettings.toolbarHoverStart
                return "transparent"
            }
            border.width: control.checked ? 1 : 0
            border.color: Qt.rgba(control.checkedColor.r, control.checkedColor.g, control.checkedColor.b, 0.55)

            Behavior on color { ColorAnimation { duration: 120 } }
        }

    MouseArea
    {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton

        onClicked: (mouse) =>
        {
            if (mouse.button === Qt.RightButton)
                control.rightClicked()
        }
    }
}
