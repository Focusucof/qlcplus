/*
  Q Light Controller Plus
  CustomPopupDialog.qml

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

Dialog
{
    id: control
    anchors.centerIn: parent
    width: mainView.width / 3
    parent: mainView

    modal: true
    closePolicy: Popup.CloseOnEscape
    title: ""
    standardButtons: Dialog.Ok | Dialog.Cancel
    onVisibleChanged: mainView.setDimScreen(visible)

    property string message: ""

    signal clicked(int role)

    function setButtonStatus(index, status)
    {
        buttonBoxControl.itemAt(index).enabled = status
    }

    header:
        Label
        {
            text: control.title
            color: "white"
            visible: control.title
            elide: Label.ElideRight
            font.family: UISettings.robotoFontName
            font.pixelSize: UISettings.textSizeDefault * 1.05
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignHCenter
            topPadding: 16
            bottomPadding: 8
            leftPadding: 16
            rightPadding: 16
            background: Item { }
        }

    background:
        Rectangle
        {
            color: UISettings.bgStrong
            radius: UISettings.cornerRadius * 1.5
            border.color: UISettings.bgLight
            border.width: 1

            focus: true
            Keys.onPressed: (event) =>
            {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter)
                {
                    control.accept()
                    event.accepted = true
                }
            }
        }

    contentItem:
        Text
        {
            visible: message
            anchors.centerIn: parent
            font.family: UISettings.robotoFontName
            font.pixelSize: UISettings.textSizeDefault
            color: UISettings.fgMain
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
            text: message
        }

    footer:
        DialogButtonBox
        {
            id: buttonBoxControl
            visible: count > 0

            contentItem.implicitHeight: UISettings.iconSizeDefault

            onClicked: function(button)
            {
                var role = button.DialogButtonBox.buttonRole
                if (role === DialogButtonBox.YesRole)
                    control.clicked(Dialog.Yes)
                else if (role === DialogButtonBox.NoRole)
                    control.clicked(Dialog.No)
                else if (role === DialogButtonBox.AcceptRole)
                    control.clicked(Dialog.Ok)
                else if (role === DialogButtonBox.ApplyRole)
                    control.clicked(Dialog.Apply)
                else if (role === DialogButtonBox.RejectRole)
                    control.clicked(Dialog.Cancel)
            }

            background:
                Item
                {
                    implicitHeight: UISettings.iconSizeDefault
                }

            delegate:
                Button
                {
                    id: buttonControl
                    implicitWidth: UISettings.bigItemHeight * 2
                    implicitHeight: UISettings.iconSizeDefault * 0.75
                    //implicitWidth: width

                    property bool isDefault: DialogButtonBox.buttonRole === DialogButtonBox.AcceptRole ||
                                             DialogButtonBox.buttonRole === DialogButtonBox.YesRole

                    hoverEnabled: true

                    contentItem:
                        Text
                        {
                            text: buttonControl.text
                            font.family: UISettings.robotoFontName
                            font.pixelSize: UISettings.textSizeDefault
                            font.weight: Font.Medium
                            opacity: enabled ? 1.0 : 0.3
                            color: UISettings.fgMain
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }

                    background:
                        Rectangle
                        {
                            color:
                            {
                                if (buttonControl.down)
                                    return UISettings.highlightPressed
                                if (buttonControl.isDefault)
                                    return buttonControl.hovered ? Qt.lighter(UISettings.highlight, 1.15) : UISettings.highlight
                                return buttonControl.hovered ? UISettings.bgLight : UISettings.bgControl
                            }
                            opacity: enabled ? 1 : 0.3
                            radius: UISettings.controlRadius
                            border.color: Qt.rgba(1, 1, 1, 0.08)
                            border.width: 1
                        }
                }
        }
}
