import QtQuick 2.0

Item{
    id: rootContainer
    property int    show_state_posY     : 350
    property int    hide_state_posY     : 710
    property double hide_scale          : 0.5

    implicitHeight: 300
    implicitWidth: 300
    states:[
        State {
            name: "show"
            PropertyChanges {target: rootContainer; opacity: 1; y: show_state_posY ; z: 10    }

        }
        ,State {
            name: "hide"
            PropertyChanges {target: rootContainer;  opacity: 0; y: hide_state_posY; z: -1}
        }
    ]
    transitions: [ Transition {
            from: "show"
            to:   "hide"
            ParallelAnimation{
                NumberAnimation { target: rootContainer; property: "opacity"; duration: 300;  }
                NumberAnimation { target: rootContainer; property: "y"; duration: 400; easing.type: Easing.Bezier }
//                SequentialAnimation{
//                    NumberAnimation{ target: rootContainer; properties: "scale"; from: 1.0; to: 1.5; duration: 200;}
//                    NumberAnimation{ target: rootContainer; properties: "scale"; from: 1.5; to: 0.5; duration: 200;}

//                }

            }
        },
        Transition{
            from: "hide"
            to: "show"
            ParallelAnimation{
                NumberAnimation { target: rootContainer; property: "opacity"; duration: 400;  }
                NumberAnimation { target: rootContainer; property: "y"; duration: 600; easing.type: Easing.Bezier }
//                SequentialAnimation{
//                    NumberAnimation{ target: rootContainer; properties: "scale"; from: 0.5; to: 1.0; duration: 200;}
//                    NumberAnimation{ target: rootContainer; properties: "scale"; from: 1.0; to: 1.5; duration: 200;}
//                    NumberAnimation{ target: rootContainer; properties: "scale"; from: 1.5; to: 1; duration: 200;}

//                }
            }
        }
    ]
}
