pragma ComponentBehavior: Bound
import QtQuick
import org.kde.layershell as LayerShell
import Vicinae

LauncherWindow {
    id: root
    autoPlaceOnShow: false
    shadowPadding: Config.shadowSize
    width: Screen.width
    height: Screen.height
    panelX: Math.round((width - root._w) / 2)
    panelY: root.usesRootLayout ? Math.max(shadowPadding, panelTop) : Math.round((height - expandedHeight) / 2) + shadowPadding
    LayerShell.Window.exclusionZone: -1

    LayerShell.Window.anchors: LayerShell.Window.AnchorTop | LayerShell.Window.AnchorBottom | LayerShell.Window.AnchorLeft | LayerShell.Window.AnchorRight
    LayerShell.Window.scope: "vicinae"
    LayerShell.Window.wantsToBeOnActiveScreen: true
    LayerShell.Window.layer: Launcher.lsLayer
    LayerShell.Window.keyboardInteractivity: Launcher.lsKeyboardInteractivity

    // Niri moves bottom layers with workspaces. Render in its stationary
    // backdrop, and receive input through a separate, transparent bottom layer.
    Window {
        id: inputWindow
        screen: root.screen
        width: root.width
        height: root.height
        color: "transparent"
        flags: Qt.FramelessWindowHint
        visible: root.visible && root.presentationOpen && Launcher.lsLayer === LayerShell.Window.LayerBackground
        LayerShell.Window.scope: "vicinae-input"
        LayerShell.Window.anchors: LayerShell.Window.AnchorTop | LayerShell.Window.AnchorBottom | LayerShell.Window.AnchorLeft | LayerShell.Window.AnchorRight
        LayerShell.Window.exclusionZone: -1
        LayerShell.Window.layer: LayerShell.Window.LayerBottom
        LayerShell.Window.keyboardInteractivity: LayerShell.Window.KeyboardInteractivityExclusive
        Component.onCompleted: Launcher.registerWorkspaceInputWindow(inputWindow)
    }

    MouseArea {
        anchors.fill: parent
        z: -1
        acceptedButtons: Qt.AllButtons
        onClicked: mouse => {
            if (mouse.x < root.panelX || mouse.x >= root.panelX + root._w || mouse.y < root.panelY || mouse.y >= root.panelY + root._contentH)
                Launcher.nav.closeWindow();
        }
    }
}
