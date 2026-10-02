/*
  Q Light Controller Plus
  CustomScrollBar.qml

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

ScrollBar
{
    id: control
    active: true
    visible: size == 1.0 ? false : true
    orientation: Qt.Vertical

    padding: 2

    /* macOS-like scroller: transparent track and a slim rounded thumb */
    background:
        Rectangle
        {
            color: control.hovered || control.pressed ? Qt.rgba(1, 1, 1, 0.04) : "transparent"
        }

    contentItem:
        Rectangle
        {
            implicitWidth: UISettings.scrollBarWidth
            implicitHeight: UISettings.scrollBarWidth
            radius: Math.min(width, height) / 2
            color: control.pressed ? UISettings.fgLight
                                   : (control.hovered ? UISettings.fgMedium : UISettings.bgLighter)

            Behavior on color { ColorAnimation { duration: 120 } }
        }
}
