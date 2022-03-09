import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0 as Controls
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.private.kicker 0.1 as Kicker

Item {
    id: root

    Plasmoid.switchWidth: units.gridUnit * 11
    Plasmoid.switchHeight: units.gridUnit * 11

    property string clock_fontfamily: plasmoid.configuration.clock_fontfamily || "Noto Sans"

    property var stateVal: 1
    property var maxSeconds: plasmoid.configuration.focus_time * 60
    property var countdownSeconds: maxSeconds
    property var countdownMilliseconds: countdownSeconds * 1000
    property var customIconSource: plasmoid.file(
                                       "", "icons/pomodoro-start-light.svg")
    property var sessionBtnText: "Start"
    property var sessionBtnIconSource: "media-playback-start"
    property var statusText: "focus"
    property var timeText: formatCountdown()
    property var previousTime: new Date()

    Plasmoid.status: PlasmaCore.Types.PassiveStatus
    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground | PlasmaCore.Types.ConfigurableBackground

    NotificationManager {
        id: notificationManager
    }

    Timer {
        id: timer
        interval: 100
        repeat: true
        running: false
        triggeredOnStart: false
        onTriggered: setTime()
    }

    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        property var callbacks: ({})
        onNewData: {
            var stdout = data["stdout"]

            if (callbacks[sourceName] !== undefined) {
                callbacks[sourceName](stdout);
            }

            exited(sourceName, stdout)
            disconnectSource(sourceName) // cmd finished
        }

        function exec(cmd, onNewDataCallback) {
            if (onNewDataCallback !== undefined){
                callbacks[cmd] = onNewDataCallback
            }
            connectSource(cmd)

        }
        signal exited(string sourceName, string stdout)
    }

    Plasmoid.toolTipMainText: formatCountdown()
    Plasmoid.toolTipSubText: getToolTipText()

    Component.onCompleted: {
        if(plasmoid.configuration.autostart) {
            start()
        }
    }

    Plasmoid.compactRepresentation: MouseArea {
        id: compactRoot

        Layout.minimumWidth: units.iconSizes.small
        Layout.minimumHeight: units.iconSizes.small
        Layout.preferredHeight: Layout.minimumHeight
        Layout.maximumHeight: Layout.minimumHeight

        Layout.preferredWidth: plasmoid.configuration.show_time_in_compact_mode ? row.width : root.width

        property int wheelDelta: 0

        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        onClicked: {
            if (mouse.button == Qt.LeftButton) {
                plasmoid.expanded = !plasmoid.expanded
            } else {
                timer.running ? pause() : start()
            }
        }

        onWheel: {
            wheelDelta = scrollByWheel(wheelDelta, wheel.angleDelta.y);
        }

        RowLayout {
            id: row
            spacing: units.smallSpacing
            Layout.margins: units.smallSpacing
            visible: plasmoid.configuration.show_time_in_compact_mode ? true : false

            Item {
                Layout.preferredHeight: compactRoot.height
                Layout.preferredWidth: compactRoot.height

                PlasmaCore.IconItem {
                    id: trayIcon2
                    height: parent.height
                    width: parent.width
                    source: customIconSource
                    smooth: true
                }

                ColorOverlay {
                    anchors.fill: trayIcon2
                    source: trayIcon2
                    color: getTextColor()
                }
            }

            PlasmaComponents.Label {
                font.pointSize: -1
                font.pixelSize: compactRoot.height * 0.6
                fontSizeMode: Text.FixedSize
                font.family: clock_fontfamily
                text: timeText
                minimumPixelSize: 1
                anchors.verticalCenter: row.verticalCenter
                color: getTextColor()
                smooth: true
            }
        }

        Item {
            visible: plasmoid.configuration.show_time_in_compact_mode ? false : true

            PlasmaCore.IconItem {
                id: trayIcon
                width: compactRoot.width
                height: compactRoot.height
                Layout.preferredWidth: height
                source: customIconSource
                smooth: true
            }

            ColorOverlay {
                anchors.fill: trayIcon
                source: trayIcon
                color: getTextColor()
            }
        }

        function scrollByWheel(wheelDelta, eventDelta) {
            // magic number 120 for common "one click"
            // See: http://qt-project.org/doc/qt-5/qml-qtquick-wheelevent.html#angleDelta-prop
            wheelDelta += eventDelta;

            var increment = 0;

            while (wheelDelta >= 120) {
                wheelDelta -= 120;
                increment++;
            }

            while (wheelDelta <= -120) {
                wheelDelta += 120;
                increment--;
            }

            while (increment != 0) {
                if(increment > 0) {
                    shiftCountdown(60)
                } else {
                    shiftCountdown(-60)
                }

                updateTime()
                increment += (increment < 0) ? 1 : -1;
            }

            return wheelDelta;
        }
    }

    Kicker.DashboardWindow {
        id: breakDialog
        flags: Qt.WindowStaysOnTopHint
        backgroundColor: Qt.hsla(
            PlasmaCore.Theme.backgroundColor.hslHue, 
            PlasmaCore.Theme.backgroundColor.hslSaturation, 
            PlasmaCore.Theme.backgroundColor.hslLightness,
            0.85)

        Column {
            anchors.fill: parent

            MouseArea {
                anchors.fill: parent
                property int wheelDelta: 0

                function scrollByWheel(wheelDelta, eventDelta) {
                    // magic number 120 for common "one click"
                    // See: http://qt-project.org/doc/qt-5/qml-qtquick-wheelevent.html#angleDelta-prop
                    wheelDelta += eventDelta;

                    var increment = 0;

                    while (wheelDelta >= 120) {
                        wheelDelta -= 120;
                        increment++;
                    }

                    while (wheelDelta <= -120) {
                        wheelDelta += 120;
                        increment--;
                    }

                    while (increment != 0) {
                        if(increment > 0) {
                            shiftCountdown(60)
                        } else {
                            shiftCountdown(-60)
                        }

                        updateTime()
                        increment += (increment < 0) ? 1 : -1;
                    }

                    return wheelDelta;
                }

                onWheel: {
                    wheelDelta = scrollByWheel(wheelDelta, wheel.angleDelta.y);
                }
            }

            ProgressCircle {
                id: dialogProgressCircle
                anchors.centerIn: parent
                size: Math.min(parent.width / 2.4, parent.height / 2.4)
                colorCircle: getCircleColor()
                arcBegin: 0
                arcEnd: Math.ceil((countdownSeconds / maxSeconds) * 360)
                lineWidth: size / 30
            }

            Column {
                anchors.centerIn: parent
                height: dialogTimeLabel.height

                PlasmaComponents.Label {
                    id: dialogTimeLabel
                    text: timeText
                    font.pointSize: dialogProgressCircle.width / 8
                    font.family: clock_fontfamily
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                }

                Controls.PageIndicator {
                    id: dialogPageIndicator
                    count: 4
                    currentIndex: (stateVal - 1) / 2

                    anchors {
                        bottom: dialogTimeLabel.top
                        horizontalCenter: parent.horizontalCenter
                        bottomMargin: dialogProgressCircle.width / 15
                    }

                    spacing: dialogProgressCircle.width / 25
                    delegate: Rectangle {
                        implicitWidth: dialogProgressCircle.width / 34
                        implicitHeight: width
                        radius: width / 2
                        color: theme.textColor

                        opacity: index === dialogPageIndicator.currentIndex ? 0.95 : 0.45

                        Behavior on opacity {
                            OpacityAnimator {
                                duration: 100
                            }
                        }
                    }
                }

                PlasmaComponents.Label {
                    text: statusText
                    font.pointSize: dialogProgressCircle.width / 24
                    color: getTextColor()

                    anchors {
                        top: dialogTimeLabel.bottom
                        horizontalCenter: parent.horizontalCenter
                        topMargin: dialogProgressCircle.width / 20
                    }

                }
            }

            RowLayout {
                spacing: 10

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: units.largeSpacing * 2
                }

                PlasmaComponents.Button {
                    text: "Postpone"
                    implicitWidth: minimumWidth
                    iconSource: "circular-arrow-shape"
                    onClicked: postpone()
                }

                PlasmaComponents.Button {
                    text: "Skip"
                    implicitWidth: minimumWidth
                    iconSource: "go-next-skip"
                    onClicked: skip()
                }

                PlasmaComponents.Button {
                    text: "Close"
                    implicitWidth: minimumWidth
                    iconSource: "dialog-close"
                    onClicked: {
                        breakDialog.close()
                    }
                }
            }
        }
    }

    Plasmoid.fullRepresentation: Item {
        id: fullRoot

        Layout.minimumWidth: units.gridUnit * 12
        Layout.maximumWidth: units.gridUnit * 18
        Layout.minimumHeight: units.gridUnit * 11
        Layout.maximumHeight: units.gridUnit * 18

        Column {
            anchors {
                top: fullRoot.top
                left: fullRoot.left
                right: fullRoot.right
                bottom: buttonsRow.top
            }

            MouseArea {
                anchors.fill: parent
                property int wheelDelta: 0

                function scrollByWheel(wheelDelta, eventDelta) {
                    // magic number 120 for common "one click"
                    // See: http://qt-project.org/doc/qt-5/qml-qtquick-wheelevent.html#angleDelta-prop
                    wheelDelta += eventDelta;

                    var increment = 0;

                    while (wheelDelta >= 120) {
                        wheelDelta -= 120;
                        increment++;
                    }

                    while (wheelDelta <= -120) {
                        wheelDelta += 120;
                        increment--;
                    }

                    while (increment != 0) {
                        if(increment > 0) {
                            shiftCountdown(60)
                        } else {
                            shiftCountdown(-60)
                        }

                        updateTime()
                        increment += (increment < 0) ? 1 : -1;
                    }

                    return wheelDelta;
                }

                onWheel: {
                    wheelDelta = scrollByWheel(wheelDelta, wheel.angleDelta.y);
                }
            }

            ProgressCircle {
                id: progressCircle
                anchors.centerIn: parent
                size: Math.min(parent.width / 1.4, parent.height / 1.4)
                colorCircle: getCircleColor()
                arcBegin: 0
                arcEnd: Math.ceil((countdownSeconds / maxSeconds) * 360)
                lineWidth: size / 30
            }

            Column {
                anchors.centerIn: parent
                height: time.height

                PlasmaComponents.Label {
                    id: time
                    text: timeText
                    font.pointSize: progressCircle.width / 8
                    font.family: clock_fontfamily
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Controls.PageIndicator {
                    id: pageIndicator
                    count: 4
                    currentIndex: (stateVal - 1) / 2

                    anchors {
                        bottom: time.top
                        horizontalCenter: parent.horizontalCenter
                        bottomMargin: progressCircle.width / 15
                    }

                    spacing: progressCircle.width / 25
                    delegate: Rectangle {
                        implicitWidth: progressCircle.width / 34
                        implicitHeight: width
                        radius: width / 2
                        color: theme.textColor

                        opacity: index === pageIndicator.currentIndex ? 0.95 : 0.45

                        Behavior on opacity {
                            OpacityAnimator {
                                duration: 100
                            }
                        }
                    }
                }

                PlasmaComponents.Label {
                    text: statusText
                    font.pointSize: progressCircle.width / 24
                    color: getTextColor()

                    anchors {
                        top: time.bottom
                        horizontalCenter: parent.horizontalCenter
                        topMargin: progressCircle.width / 20
                    }

                }
            }
        }

        RowLayout {
            id: buttonsRow
            spacing: 10

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
            }

            PlasmaComponents.Button {
                text: "Skip"
                implicitWidth: minimumWidth
                iconSource: "media-skip-forward"
                onClicked: skip()
            }

            PlasmaComponents.Button {
                id: sessionBtn
                text: sessionBtnText
                implicitWidth: minimumWidth
                iconSource: sessionBtnIconSource
                onClicked: {
                    if (sessionBtnText == "Start") {
                        start()
                    } else {
                        pause()
                    }
                }
            }

            PlasmaComponents.Button {
                text: "Stop"
                implicitWidth: minimumWidth
                iconSource: "media-playback-stop"
                onClicked: stop()
            }
        }
    }

    function formatNumberLength(num, length) {
        var r = "" + num
        while (r.length < length) {
            r = "0" + r
        }

        return r
    }

    function shiftCountdown(seconds) {
        if (countdownSeconds + seconds > 0) {
            countdownMilliseconds += seconds * 1000
            countdownSeconds += seconds
            maxSeconds += seconds
        }
    }

    function formatCountdown() {
        var sec = countdownSeconds % 60
        var min = Math.floor(countdownSeconds / 60)

        return formatNumberLength(min, 2) + ":" + formatNumberLength(sec, 2)
    }

    function getToolTipText() {
        var text = ""

        if (timer.running) {
            switch (stateVal) {
                case 1:
                case 3:
                case 5:
                case 7:
                    text = "Focus on your work!"
                    break
                case 2:
                case 4:
                case 6:
                    text = "Go for a walk."
                    break
                case 8:
                    text = "Take a long break!"
                    break
            }
        }

        return text
    }

    function start() {
        //notificationManager.start(stateVal)
        previousTime = new Date()
        executeScript(1)
        timer.start()
        sessionBtnText = "Pause"
        sessionBtnIconSource = "media-playback-pause"
        customIconSource = plasmoid.file(
                    "", "icons/pomodoro-indicator-light-61.svg")
        Plasmoid.status = PlasmaCore.Types.ActiveStatus

        showBreakDialogIfNeeded()
    }

    function pause() {
        timer.stop()
        sessionBtnText = "Start"
        sessionBtnIconSource = "media-playback-start"
        customIconSource = plasmoid.file("",
                                            "icons/pomodoro-start-light.svg")
    }

    function end() {
        notificationManager.end(stateVal)
        executeScript(2)
        timer.stop()
        sessionBtnText = "Start"
        sessionBtnIconSource = "media-playback-start"
        customIconSource = plasmoid.file("",
                                            "icons/pomodoro-start-light.svg")
        nextState()
        resetTime()

        if (plasmoid.configuration.timer_auto_next_enabled) {
            start()
        } else {
            Plasmoid.status = PlasmaCore.Types.PassiveStatus
        }
    }

    function skip() {
        nextState()
        resetTime()

        showBreakDialogIfNeeded()
    }

    function postpone() {
        prevState()
        statusText = "focus"
        maxSeconds = plasmoid.configuration.focus_time * 60
        previousTime = new Date()
        countdownSeconds = 60 * 5
        countdownMilliseconds = countdownSeconds * 1000
        updateTime()
        showBreakDialogIfNeeded()
    }

    function stop() {
        //notificationManager.stop()
        executeScript(0)
        timer.stop()
        stateVal = 1
        resetTime()
        sessionBtnText = "Start"
        sessionBtnIconSource = "media-playback-start"
        customIconSource = plasmoid.file("",
                                            "icons/pomodoro-start-light.svg")
        Plasmoid.status = PlasmaCore.Types.PassiveStatus
    }

    function resetTime() {
        switch (stateVal) {
            case 1:
            case 3:
            case 5:
            case 7:
                maxSeconds = plasmoid.configuration.focus_time * 60
                statusText = "focus"
                break
            case 2:
            case 4:
            case 6:
                maxSeconds = plasmoid.configuration.short_break_time * 60
                statusText = "short break"
                break
            case 8:
                maxSeconds = plasmoid.configuration.long_break_time * 60
                statusText = "long break"
                break
        }

        previousTime = new Date()
        countdownSeconds = maxSeconds
        countdownMilliseconds = countdownSeconds * 1000
        updateTime()
    }

    function setTime() {
        var currentTime = new Date()
        var timeDiff = currentTime.getTime() - previousTime.getTime()
        previousTime = currentTime

        var oldCountdownSeconds = Math.ceil(countdownMilliseconds / 1000)
        countdownMilliseconds -= timeDiff
        var newCountdownSeconds = Math.ceil(countdownMilliseconds / 1000)

        // Avoid too fast countdown when relying solely on QML's Timer
        if (newCountdownSeconds === oldCountdownSeconds) {
            return;
        }
        countdownSeconds--

        if (countdownSeconds <= 0) {
            end()
        }

        updateTime()
    }

    function updateTime() {
        timeText = formatCountdown()

        if (timer.running) {
            customIconSource = plasmoid.file(
                        "",
                        "icons/pomodoro-indicator-light-" + formatNumberLength(
                            Math.ceil(
                                (countdownSeconds / maxSeconds) * 61),
                            2) + ".svg")
        }
    }

    function nextState() {
        if (stateVal < 8) {
            stateVal++
        } else {
            stateVal = 1
        }
    }

    function prevState() {
        if (stateVal != 1) {
            stateVal--
        }
    }

    function getCircleColor() {
        var color

        switch (stateVal) {
            case 1:
            case 3:
            case 5:
            case 7:
                color = theme.buttonFocusColor
                break
            case 2:
            case 4:
            case 6:
            case 8:
                color = theme.disabledTextColor
                break
        }

        return color
    }

    function getTextColor() {
        var color

        switch (stateVal) {
            case 1:
            case 3:
            case 5:
            case 7:
                color = theme.textColor
                break
            case 2:
            case 4:
            case 6:
            case 8:
                color = theme.disabledTextColor
                break
        }

        return color
    }

    function showBreakDialogIfNeeded() {
        if(!plasmoid.configuration.show_fullscreen_break) {
            return
        }

        if(isBreak() && timer.running) {
            breakDialog.showFullScreen()
        } else {
            breakDialog.hide()
        }
    }

    function executeScript(state) {
        switch (state) {
            case 0:
                if (plasmoid.configuration.stop_script_enabled) {
                    executable.exec("sh " + plasmoid.configuration.stop_script_filepath);
                }
                break
            case 1:
                switch (stateVal) {
                    case 1:
                    case 3:
                    case 5:
                    case 7:
                        if (plasmoid.configuration.start_focus_script_enabled) {
                            executable.exec("sh " + plasmoid.configuration.start_focus_script_filepath);
                        }
                        break
                    case 2:
                    case 4:
                    case 6:
                    case 8:
                        if (plasmoid.configuration.start_break_script_enabled) {
                            executable.exec("sh " + plasmoid.configuration.start_break_script_filepath);
                        }
                        break
                }
                break
            case 2:
                switch (stateVal) {
                    case 1:
                    case 3:
                    case 5:
                    case 7:
                        if (plasmoid.configuration.end_focus_script_enabled) {
                            executable.exec("sh " + plasmoid.configuration.end_focus_script_filepath);
                        }
                        break
                    case 2:
                    case 4:
                    case 6:
                    case 8:
                        if (plasmoid.configuration.end_break_script_enabled) {
                            executable.exec("sh " + plasmoid.configuration.end_break_script_filepath);
                        }
                        break
                }
                break
        } 
    }

    function isBreak() {
        switch (stateVal) {
            case 2:
            case 4:
            case 6:
            case 8:
                return true
                break
        }

        return false
    }
}
