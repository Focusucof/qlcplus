/*
  Q Light Controller Plus
  UISettings.qml

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

pragma Singleton

import QtQuick

QtObject
{
    /* Typography. On macOS this resolves to the system UI font (SF Pro),
       which gives the interface a native look. The property keeps its
       historical name since it is referenced all over the UI */
    property string robotoFontName: Qt.application.font.family
    property string fontAwesomeFontName: "Font Awesome 7 Free"

    property real scalingFactor: 1.0

    /* Colors - dark graphite theme, inspired by modern macOS lighting apps */
    property color bgStronger:      "#111113"   // window chrome, deepest wells
    property color bgStrong:        "#1A1A1D"   // panels, sidebars
    property color bgMedium:        "#212124"   // main canvas
    property color bgControl:       "#2E2E32"   // controls at rest
    property color bgLight:         "#3C3C41"   // raised / hovered controls
    property color bgLighter:       "#56565C"   // strong borders, pressed
    property color bgFixtureOdd:    "#26302A"
    property color bgFixtureEven:   "#272A33"

    property color fgMain:          "#F2F2F7"
    property color fgMedium:        "#8E8E93"
    property color fgLight:         "#AEAEB2"

    property color sectionHeader:     "#26262A"
    property color sectionHeaderDiv:  "#323237"
    property color highlight:         "#0A84FF"
    property color highlightPressed:  "#0064D1"
    property color hover:             "#46464C"
    property color selection:         "#FFD60A"
    property color activeDropArea:    "#30D158"
    property color borderColorDark:   "#0B0B0D"

    /* Toolbars are flat: start and end colors are almost identical */
    property color toolbarStartMain:  "#1C1C1F"
    property color toolbarStartSub:   "#1E1E21"
    property color toolbarEnd:        "#1A1A1D"
    property color toolbarHoverStart: "#2E2E32"
    property color toolbarHoverEnd:   "#2A2A2E"

    property color toolbarSelectionMain: "#0A84FF"
    property color toolbarSelectionSub:  "#FF9F0A"

    /* Extra theme tokens used by the modern look */
    property color separator:       "#2C2C30"
    property color accentSoft:      Qt.rgba(highlight.r, highlight.g, highlight.b, 0.22)
    property color danger:          "#FF453A"
    property color success:         "#30D158"
    property color warning:         "#FF9F0A"
    property real  cornerRadius:    screenPixelDensity * scalingFactor * 1.6
    property real  controlRadius:   screenPixelDensity * scalingFactor * 1.1

    /* Sizes */
    property int  textSizeDefault:  screenPixelDensity * scalingFactor * 4.2
    property real iconSizeDefault:  screenPixelDensity * scalingFactor * 10 // more or less the size of a finger
    property real iconSizeMedium:   screenPixelDensity * scalingFactor * 8
    property real listItemHeight:   screenPixelDensity * scalingFactor * 7
    property real mediumItemHeight: screenPixelDensity * scalingFactor * 15
    property real bigItemHeight:    screenPixelDensity * scalingFactor * 25
    property real scrollBarWidth:   screenPixelDensity * scalingFactor * 4
    property real sidePanelWidth:   screenPixelDensity * scalingFactor * 50

    /* Persisted Simple Desk channel view scroll position, as the index of the
       first visible channel (survives context changes) */
    property int simpleDeskScrollIndex: 0

    /* True while an in-app QML drag (channels, functions, fixtures, VC
       widgets...) is in progress anywhere in the UI. MainView's full-window
       fileDropArea (used for OS file drag & drop) watches this to get out of
       the way: being a high z, full-window overlay, it would otherwise
       always win Qt's drag hit test over any nested DropArea underneath it
       and starve it of position updates, regardless of "keys" filtering. */
    property bool internalDragActive: false

    /* Channel properties column widths */
    property real chPropsModesWidth: bigItemHeight * 1.2
    property real chPropsFlagsWidth: bigItemHeight * 1.3
    property real chPropsCanFadeWidth: bigItemHeight * 0.7
    property real chPropsPrecedenceWidth: bigItemHeight * 1.2
    property real chPropsModifierWidth: bigItemHeight
}
