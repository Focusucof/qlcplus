/*
  Q Light Controller Plus
  QLCPlusFader.qml

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

Slider
{
    id: slider
    width: 32
    height: 100
    orientation: Qt.Vertical
    from: 0
    to: 255
    stepSize: 1.0
    wheelEnabled: true

    property Gradient handleGradient: defaultGradient
    property Gradient handleGradientHover: defaultGradientHover
    property color trackColor: defaultTrackColor

    property color defaultTrackColor: UISettings.highlight
    property Gradient defaultGradient:
        Gradient
        {
            GradientStop { position: 0; color: "#EDEDF0" }
            GradientStop { position: 0.44; color: "#CFCFD4" }
            GradientStop { position: 0.45; color: "#2A2A2E" }
            GradientStop { position: 0.55; color: "#2A2A2E" }
            GradientStop { position: 0.56; color: "#C4C4C9" }
            GradientStop { position: 1.0; color: "#A9A9AF" }
        }

    property Gradient defaultGradientHover:
        Gradient
        {
            GradientStop { position: 0; color: "#FFFFFF" }
            GradientStop { position: 0.44; color: "#E0E0E4" }
            GradientStop { position: 0.45; color: UISettings.highlight }
            GradientStop { position: 0.55; color: UISettings.highlight }
            GradientStop { position: 0.56; color: "#D6D6DA" }
            GradientStop { position: 1.0; color: "#BEBEC3" }
        }

    opacity: enabled ? 1.0 : 0.4

    /* Lightkey-like fader: a recessed dark well, filled from the bottom
     * with the track color up to the current level */
    background:
        Rectangle
        {
            y: slider.topPadding
            x: slider.leftPadding + slider.availableWidth / 2 - width / 2
            implicitHeight: slider.height
            width: Math.max(6, Math.min(slider.availableWidth * 0.22, 10))
            height: slider.availableHeight
            radius: width / 2
            color: UISettings.bgStronger
            border.width: 1
            border.color: Qt.rgba(1, 1, 1, 0.05)

            Rectangle
            {
                y: slider.visualPosition * parent.height
                width: parent.width
                height: parent.height - y
                radius: parent.radius
                color: trackColor
            }
        }

    handle:
        Rectangle
        {
            y: slider.topPadding + slider.visualPosition * (slider.availableHeight - height)
            x: slider.leftPadding + slider.availableWidth / 2 - width / 2
            implicitHeight: Math.min(slider.width * 0.6, UISettings.iconSizeDefault * 0.5)
            implicitWidth: Math.min(UISettings.iconSizeDefault, slider.width)
            gradient: pressed ? handleGradientHover : handleGradient
            border.color: Qt.rgba(0, 0, 0, 0.55)
            border.width: 1
            radius: UISettings.controlRadius
        }
}
