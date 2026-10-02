/*
  Q Light Controller Plus
  MainView.qml

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
import QtQuick.Controls

import org.qlcplus.classes 1.0
import "."

Rectangle
{
    id: mainView
    visible: true
    width: 800
    height: 600
    anchors.fill: parent
    color: UISettings.bgMedium

    property string currentContext: ""

    Component.onCompleted: UISettings.sidePanelWidth = Math.min(width / 3, UISettings.bigItemHeight * 5)
    onWidthChanged: UISettings.sidePanelWidth = Math.min(width / 3, UISettings.bigItemHeight * 5)

    property bool showWizardVisible: false
    function openShowWizard() { mainView.showWizardVisible = true }

    function enableContext(ctx, setChecked)
    {
        var item = null

        if (ctx === "FIXANDFUNC")
            item = fnfEntry
        else if (ctx === "VC")
            item = vcEntry
        else if (ctx === "SDESK")
            item = sdEntry
        else if (ctx === "SHOWMGR")
            item = smEntry
        else if (ctx === "IOMGR")
            item = ioEntry

        if (item)
        {
            item.visible = true
            if (setChecked)
                item.checked = true
            return true
        }
        return false
    }

    function switchToContext(ctx, qmlRes)
    {
        if (currentContext === ctx)
            return

        if (enableContext(ctx, true) === true)
        {
            currentContext = ctx
            // show toolbar only if not in kiosk mode
            if (qlcplus.accessMask !== App.AC_VCControl)
                mainToolbar.visible = true
        }
        else
        {
            mainToolbar.visible = false
            currentContext = ""
        }

        if (qmlRes)
            mainViewLoader.source = qmlRes
    }

    function setDimScreen(enable)
    {
        dimScreen.visible = enable
    }

    function openAccessRequest(sessionId, clientName, peerAddress, peerPort)
    {
        clientAccessPopup.deciding = false
        clientAccessPopup.sessionId = sessionId
        clientAccessPopup.clientName = clientName
        clientAccessPopup.peerAddress = peerAddress
        clientAccessPopup.peerPort = peerPort
        clientAccessPopup.open()
    }

    function closeAccessRequest(sessionId)
    {
        if (clientAccessPopup.sessionId === sessionId)
            clientAccessPopup.close()
    }

    function saveProject()
    {
        actionsMenu.handleSaveAction()
    }

    function saveBeforeExit()
    {
        //actionsMenu.open()
        actionsMenu.saveBeforeExit()
    }

    function loadResource(qmlRes)
    {
        mainViewLoader.source = qmlRes
    }

    FontLoader
    {
        source: "qrc:/RobotoCondensed-Regular.ttf"
    }

    // Load the "FontAwesome" font for the monochrome icons
    FontLoader
    {
        id: faFontLoader
        source: "qrc:/FontAwesome7-Free-Solid-900.otf"
        onStatusChanged:
        {
            if (status === FontLoader.Ready)
                UISettings.fontAwesomeFontName = faFontLoader.name
        }
    }

    /* Unified, macOS-style top toolbar:
     * [ Actions ]   ( workspace segmented control )   [ dump | BPM | STOP ] */
    Rectangle
    {
        id: mainToolbar
        visible: qlcplus.accessMask & App.AC_VCControl ? false : true // this is kiosk mode
        width: parent.width
        height: UISettings.iconSizeDefault
        z: 50
        color: UISettings.toolbarStartMain

        // bottom hairline
        Rectangle
        {
            width: parent.width
            height: 1
            y: parent.height - 1
            color: UISettings.borderColorDark
        }

        RowLayout
        {
            spacing: 6
            anchors.fill: parent
            anchors.leftMargin: 6
            anchors.rightMargin: 8

            ButtonGroup { id: menuBarGroup }

            MenuBarEntry
            {
                id: actEntry
                Layout.alignment: Qt.AlignVCenter
                implicitHeight: mainToolbar.height
                imgSource: "qrc:/qlcplus.svg"
                entryText: qsTr("Actions")
                onPressed: actionsMenu.open()
                autoExclusive: false
                checkable: false

                // "unsaved changes" dot, like the macOS document indicator
                Rectangle
                {
                    visible: qlcplus.docModified
                    x: actEntry.pillMargin + 3
                    y: actEntry.pillMargin + 3
                    width: Math.max(7, actEntry.height * 0.2)
                    height: width
                    radius: width / 2
                    color: UISettings.warning
                    border.width: 1
                    border.color: UISettings.toolbarStartMain
                }
            }

            // flexible spacer
            Item { Layout.fillWidth: true; implicitHeight: 1 }

            // ################## WORKSPACE SEGMENTED CONTROL ##################
            Rectangle
            {
                id: workspaceSwitcher
                Layout.alignment: Qt.AlignVCenter
                implicitWidth: workspaceRow.implicitWidth + 6
                implicitHeight: mainToolbar.height * 0.78
                radius: UISettings.cornerRadius
                color: UISettings.bgStronger
                border.width: 1
                border.color: UISettings.separator

                RowLayout
                {
                    id: workspaceRow
                    anchors.centerIn: parent
                    height: parent.height - 2
                    spacing: 0

                    MenuBarEntry
                    {
                        id: fnfEntry
                        property string ctxName: "FIXANDFUNC"
                        property string ctxRes: "qrc:/FixturesAndFunctions.qml"
                        implicitHeight: workspaceRow.height
                        pillMargin: 2

                        //visible: qlcplus.accessMask & App.AC_FunctionEditing
                        imgSource: "qrc:/editor.svg"
                        entryText: qsTr("Fixtures & Functions")
                        checked: false
                        ButtonGroup.group: menuBarGroup
                        onCheckedChanged:
                        {
                            if (checked === true)
                                switchToContext(fnfEntry.ctxName, fnfEntry.ctxRes)
                        }
                    }
                    MenuBarEntry
                    {
                        id: vcEntry
                        property string ctxName: "VC"
                        property string ctxRes: "qrc:/VirtualConsole.qml"
                        implicitHeight: workspaceRow.height
                        pillMargin: 2

                        visible: qlcplus.accessMask & App.AC_VCControl
                        imgSource: "qrc:/virtualconsole.svg"
                        entryText: qsTr("Virtual Console")
                        ButtonGroup.group: menuBarGroup
                        onCheckedChanged:
                        {
                            if (checked === true)
                                switchToContext(vcEntry.ctxName, vcEntry.ctxRes)
                        }
                        onRightClicked:
                        {
                            vcEntry.visible = false
                            contextManager.detachContext("VC")
                        }
                    }
                    MenuBarEntry
                    {
                        id: sdEntry
                        property string ctxName: "SDESK"
                        property string ctxRes: "qrc:/SimpleDesk.qml"
                        implicitHeight: workspaceRow.height
                        pillMargin: 2

                        visible: qlcplus.accessMask & App.AC_SimpleDesk
                        imgSource: "qrc:/simpledesk.svg"
                        entryText: qsTr("Simple Desk")
                        ButtonGroup.group: menuBarGroup
                        onCheckedChanged:
                        {
                            if (checked === true)
                                switchToContext(sdEntry.ctxName, sdEntry.ctxRes)
                        }
                        onRightClicked:
                        {
                            sdEntry.visible = false
                            contextManager.detachContext("SDESK")
                        }
                    }
                    MenuBarEntry
                    {
                        id: smEntry
                        property string ctxName: "SHOWMGR"
                        property string ctxRes: "qrc:/ShowManager.qml"
                        implicitHeight: workspaceRow.height
                        pillMargin: 2

                        visible: qlcplus.accessMask & App.AC_ShowManager
                        imgSource: "qrc:/showmanager.svg"
                        entryText: qsTr("Show Manager")
                        ButtonGroup.group: menuBarGroup
                        onCheckedChanged:
                        {
                            if (checked === true)
                                switchToContext(smEntry.ctxName, smEntry.ctxRes)
                        }
                        onRightClicked:
                        {
                            smEntry.visible = false
                            contextManager.detachContext("SHOWMGR")
                        }
                    }
                    MenuBarEntry
                    {
                        id: ioEntry
                        property string ctxName: "IOMGR"
                        property string ctxRes: "qrc:/InputOutputManager.qml"
                        implicitHeight: workspaceRow.height
                        pillMargin: 2

                        visible: qlcplus.accessMask & App.AC_InputOutput
                        imgSource: "qrc:/inputoutput.svg"
                        entryText: qsTr("Input/Output")
                        ButtonGroup.group: menuBarGroup
                        onCheckedChanged:
                        {
                            if (checked === true)
                                switchToContext(ioEntry.ctxName, ioEntry.ctxRes)
                        }
                        onRightClicked:
                        {
                            ioEntry.visible = false
                            contextManager.detachContext("IOMGR")
                        }
                    }
                }
            }

            // flexible spacer
            Item { Layout.fillWidth: true; implicitHeight: 1 }

            // ################## DMX DUMP ##################
            IconButton
            {
                id: sceneDump
                z: 2
                implicitWidth: mainToolbar.height * 0.78
                implicitHeight: mainToolbar.height * 0.78
                Layout.alignment: Qt.AlignVCenter
                bgColor: "transparent"
                border.width: 0
                imgSource: "qrc:/dmxdump.svg"
                imgMargins: 10
                tooltip: qsTr("Dump DMX values on a Scene")
                counter: (qlcplus.accessMask & App.AC_FunctionEditing)

                property string bubbleLabel: {
                    if (currentContext === sdEntry.ctxName)
                        return simpleDesk ? simpleDesk.dumpValuesCount : ""
                    else
                        return contextManager ? contextManager.dumpValuesCount : ""
                }

                function updateDumpVariables()
                {
                    if (currentContext === sdEntry.ctxName)
                    {
                        dmxDumpDialog.capabilityMask = simpleDesk ? simpleDesk.dumpChannelMask : 0
                        dmxDumpDialog.channelSetMask = simpleDesk ? simpleDesk.dumpChannelMask : 0
                    }
                    else
                    {
                        dmxDumpDialog.capabilityMask = fixtureManager ? fixtureManager.capabilityMask : 0
                        dmxDumpDialog.channelSetMask = contextManager ? contextManager.dumpChannelMask : 0
                    }
                }

                // channel count badge
                Rectangle
                {
                    x: sceneDump.width - width * 0.75
                    y: -height * 0.2
                    width: Math.max(height, dumpBadgeText.implicitWidth + height * 0.5)
                    height: sceneDump.height * 0.42
                    color: UISettings.danger
                    radius: height / 2
                    visible: sceneDump.bubbleLabel !== "0" ? true : false

                    Text
                    {
                        id: dumpBadgeText
                        anchors.centerIn: parent
                        text: sceneDump.bubbleLabel
                        color: "white"
                        font.family: UISettings.robotoFontName
                        font.pixelSize: parent.height * 0.7
                        font.weight: Font.DemiBold
                    }
                }

                MouseArea
                {
                    id: dumpDragArea
                    anchors.fill: parent
                    drag.target: dumpDragItem
                    drag.threshold: 10

                    onClicked: (mouse) =>
                    {
                        sceneDump.updateDumpVariables()
                        dmxDumpDialog.open()
                        dmxDumpDialog.focusEditItem()
                    }

                    property bool dragActive: drag.active

                    onDragActiveChanged:
                    {
                        console.log("Drag active changed: " + dragActive)
                        if (dragActive == false)
                        {
                            dumpDragItem.Drag.drop()
                            dumpDragItem.parent = sceneDump
                            dumpDragItem.x = 0
                            dumpDragItem.y = 0
                        }
                        else
                        {
                            dumpDragItem.parent = mainView
                        }

                        dumpDragItem.Drag.active = dragActive
                    }
                }

                Item
                {
                    id: dumpDragItem
                    z: 99
                    visible: dumpDragArea.drag.active

                    Drag.source: dumpDragItem
                    Drag.keys: [ "dumpValues" ]

                    function itemDropped(id, name)
                    {
                        console.log("Dump values dropped on " + id)
                        functionManager.selectFunctionID(id, false)
                        sceneDump.updateDumpVariables()
                        dmxDumpDialog.sceneName = name
                        dmxDumpDialog.existingScene = true
                        dmxDumpDialog.open()
                        dmxDumpDialog.focusEditItem()
                    }

                    Rectangle
                    {
                        width: UISettings.iconSizeMedium
                        height: width
                        radius: width / 2
                        color: UISettings.danger
                        border.width: 2
                        border.color: "white"

                        RobotoText
                        {
                            anchors.centerIn: parent
                            label: sceneDump.bubbleLabel
                        }
                    }
                }

                PopupDMXDump
                {
                    id: dmxDumpDialog
                    implicitWidth: Math.min(UISettings.bigItemHeight * 4, mainView.width / 3)

                    onAccepted:
                    {
                        if (currentContext === sdEntry.ctxName)
                        {
                            simpleDesk.dumpDmxChannels(sceneName, getChannelsMask(), existingScene && func ? func.id : -1, nonZeroOnly)
                        }
                        else
                        {
                            contextManager.dumpDmxChannels(getChannelsMask(), sceneName, existingScene && func ? func.id : -1,
                                                           allChannels, nonZeroOnly);
                        }
                    }
                }
            }

            // ################## BEATS ##################
            Rectangle
            {
                id: bpmPill
                Layout.alignment: Qt.AlignVCenter
                implicitWidth: bpmRow.implicitWidth + UISettings.textSizeDefault * 1.4
                implicitHeight: mainToolbar.height * 0.62
                radius: height / 2
                color: gsMouseArea.containsMouse || beatSelectionPanel.visible ? UISettings.bgLight : UISettings.bgControl
                border.width: 1
                border.color: UISettings.separator

                Behavior on color { ColorAnimation { duration: 100 } }

                Row
                {
                    id: bpmRow
                    anchors.centerIn: parent
                    spacing: UISettings.textSizeDefault * 0.5

                    Rectangle
                    {
                        id: beatIndicator
                        anchors.verticalCenter: parent.verticalCenter
                        width: bpmPill.height * 0.36
                        height: width
                        radius: width / 2
                        color: UISettings.fgMedium

                        ColorAnimation on color
                        {
                            id: cAnim
                            from: UISettings.success
                            to: UISettings.fgMedium
                            // half the duration of the current BPM
                            duration: ioManager.bpmNumber ? 30000 / ioManager.bpmNumber : 200
                            running: false
                        }

                        Connections
                        {
                            id: beatSignal
                            target: ioManager
                            function onBeat()
                            {
                                cAnim.restart()
                            }
                        }
                    }

                    Text
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "BPM"
                        color: UISettings.fgMedium
                        font.family: UISettings.robotoFontName
                        font.pixelSize: UISettings.textSizeDefault * 0.75
                        font.weight: Font.DemiBold
                        font.letterSpacing: 0.5
                    }

                    Text
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        text: ioManager.bpmNumber > 0 ? ioManager.bpmNumber : qsTr("Off")
                        color: UISettings.fgMain
                        font.family: UISettings.robotoFontName
                        font.pixelSize: UISettings.textSizeDefault * 0.95
                        font.weight: Font.DemiBold
                    }
                }

                MouseArea
                {
                    id: gsMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: beatSelectionPanel.visible = !beatSelectionPanel.visible
                }
                BeatGeneratorsPanel
                {
                    id: beatSelectionPanel
                    parent: mainView
                    y: mainToolbar.height
                    x: mainView.width - width - stopAllButton.width - 16
                    z: 51
                    visible: false
                }
            }

            // ################## STOP ALL FUNCTIONS ##################
            IconButton
            {
                id: stopAllButton
                implicitWidth: stopRow.implicitWidth + UISettings.textSizeDefault * 1.6
                implicitHeight: mainToolbar.height * 0.62
                Layout.alignment: Qt.AlignVCenter
                enabled: runningCount ? true : false
                radius: height / 2
                bgColor: enabled ? UISettings.danger : UISettings.bgControl
                hoverColor: Qt.lighter(UISettings.danger, 1.15)
                pressColor: Qt.darker(UISettings.danger, 1.3)
                tooltip: qsTr("Stop all the running functions")

                onClicked: qlcplus.stopAllFunctions()

                property int runningCount: qlcplus.runningFunctionsCount

                onRunningCountChanged: console.log("Functions running: " + runningCount)

                Row
                {
                    id: stopRow
                    anchors.centerIn: parent
                    spacing: UISettings.textSizeDefault * 0.4
                    opacity: stopAllButton.enabled ? 1.0 : 0.45

                    Text
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        color: "white"
                        font.family: UISettings.fontAwesomeFontName
                        font.pixelSize: stopAllButton.height * 0.42
                        text: FontAwesome.fa_stop
                    }

                    Text
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "STOP"
                        color: "white"
                        font.family: UISettings.robotoFontName
                        font.pixelSize: UISettings.textSizeDefault * 0.8
                        font.weight: Font.Bold
                        font.letterSpacing: 0.8
                    }

                    // running functions counter
                    Rectangle
                    {
                        visible: stopAllButton.runningCount
                        anchors.verticalCenter: parent.verticalCenter
                        width: Math.max(height, runCountText.implicitWidth + height * 0.5)
                        height: stopAllButton.height * 0.62
                        radius: height / 2
                        color: Qt.rgba(0, 0, 0, 0.28)

                        Text
                        {
                            id: runCountText
                            anchors.centerIn: parent
                            text: stopAllButton.runningCount
                            color: "white"
                            font.family: UISettings.robotoFontName
                            font.pixelSize: parent.height * 0.65
                            font.weight: Font.DemiBold
                        }
                    }
                }
            }

        } // end of RowLayout
    } // end of mainToolbar

    Loader
    {
        id: showWizardOverlay
        width: parent.width
        height: parent.height
        source: parent.showWizardVisible ? "qrc:/ShowWizard.qml" : ""
        z: 100
        onLoaded: if (item) { item.closeRequested.connect(function() { mainView.showWizardVisible = false }); item.open() }
    }

    Loader
    {
        id: mainViewLoader
        width: parent.width
        height: parent.height - (mainToolbar.visible ? mainToolbar.height : 0)
        y: mainToolbar.visible ? mainToolbar.height : 0

        Component.onCompleted:
        {
            var ctx = "FIXANDFUNC"
            // handle Kiosk mode on startup
            if (qlcplus.accessMask === App.AC_VCControl)
                ctx = "VC"
            enableContext(ctx, true)
        }
    }

    PopupNetworkConnect { id: clientAccessPopup }

    /** Menu to open/load/save a project */
    ActionsMenu
    {
        id: actionsMenu
        x: 1
        y: actEntry.height + 1
        visible: false
        z: visible ? 99 : 0
    }

    /** Allow a project (.qxw/.qxw.gz) or fixture (.qxf/.d4) file to be opened
      * by dragging it from the OS file manager and dropping it on the window.
      * Qt Quick delivers drag hover/position events to only the topmost
      * DropArea under the pointer - "keys" only gates acceptance
      * (containsDrag/onDropped), not hit testing. Being a full-window
      * overlay, this would otherwise always win that hit test and starve any
      * nested DropArea underneath it (e.g. the fixture editor's channel
      * reordering) of position updates. So it drops below the main view's
      * content (z < 0) for as long as UISettings.internalDragActive says an
      * in-app drag is going on anywhere, and only then. */
    DropArea
    {
        id: fileDropArea
        anchors.fill: parent
        z: UISettings.internalDragActive ? -1 : 100
        keys: [ "text/uri-list" ]

        onDropped: function(drop)
        {
            if (drop.urls.length)
                actionsMenu.openFile(drop.urls[0])
        }
    }

    Rectangle
    {
        anchors.fill: parent
        z: 100
        visible: fileDropArea.containsDrag
        color: Qt.rgba(0, 0, 0, 0.6)
        border.width: 3
        border.color: UISettings.activeDropArea

        Text
        {
            anchors.centerIn: parent
            text: qsTr("Drop a project or fixture file to open it")
            font.pixelSize: UISettings.textSizeDefault * 1.4
            color: "white"
        }
    }

    /* Rectangle covering the whole window to
     * have a dimmered background for popups */
    Rectangle
    {
        id: dimScreen
        anchors.fill: parent
        visible: false
        z: 99
        color: Qt.rgba(0, 0, 0, 0.5)
    }

    //PopupDisclaimer { }
}
