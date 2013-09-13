import QtQuick 2.0
import QtQuick.LocalStorage 2.0
//import "../../javascript/storage.js" as Storage
import "qrc:/javascript/storage.js" as Storage
import "../Components"
GContainer{
    id: profileDialog

    property string profile_name    : "Profile_Default"
    property int    bottom_value    : 0
    property int    top_value       : 100
    property bool   read_only       : false
    property bool   save_profile    : true;
    property string tilt_motor_class_name   : "Tilt Motor"
    property string pan_motor_class_name    : "Pan Motor"
    property string roll_motor_class_name   : "Roll Motor"


    hide_scale: 0
    width: 400; height:200
    Rectangle{
        id: root
        anchors.fill: parent
        color: "transparent"
        border.width: 1; border.color: "cyan"
        smooth: true;
        Rectangle{
            id: profileNameContainer
            width: 190;  height: 30
//            width: profileNameInput.contentWidth+10; height: profileNameInput.contentHeight+10;
            border.width: 1; border.color: "cyan"
            color: "transparent";  smooth: true;
            radius: 0.7*height/2
            anchors.left: profileNameList.right
            anchors.leftMargin: 40
            anchors.top: parent.top
            anchors.topMargin: 10

            MouseArea{
                id: mouseArea
                anchors.fill: parent; hoverEnabled: true
                onEntered: {
                    profileNameContainer.state = "focus"
                    dialog_log("Profile name must not contain space")
                }
                onExited:  profileNameContainer.state = "unfocus"
            }

            TextInput {
                id: profileNameInput
                anchors.centerIn: parent
                color: "#04ffdf"
                font{ family: "Segoe UI"; bold: true; pixelSize: 16}
                focus: true
                horizontalAlignment: TextInput.AlignHCenter
                Behavior on color {ColorAnimation {duration: 200 }}
                text: profile_name

            }

            states: [
                State{
                    name: "focus"
                    PropertyChanges {target: profileNameContainer; border.color: "#009dff"; border.width: 2}
                    PropertyChanges { target: profileNameInput; color: "red"   }
                }
                ,State {
                    name: "unfocus"
                    PropertyChanges {target: profileNameContainer; border.color: "cyan"; border.width: 1 }
                    PropertyChanges { target: profileNameInput; color: "#04ffdf"   }

                }
            ]
            Behavior on color {ColorAnimation {duration: 200 }}

        } // end of profileNameContainer
        Row{
            id: buttonsRow
            width: 120
            height: 26
            anchors.left: profileNameList.right
            anchors.leftMargin: 40
            anchors.top: profileNameContainer.bottom
            anchors.topMargin: 20
            spacing: 5
            GButton{
                id: saveProfileButton
                text: "Save"
                onClicked: {
                    profile_name = profileNameInput.text;
                    save_profile = true;
                    if(table_name_exist(profile_name) === 1){
                        Storage.table_name = profile_name;      // select a new table to get data
                        Storage.initialize();
                        dialog_log("Updating params to profile: " + profile_name);
                        update_parameters_to_profile();
                        dialog_log("Updating params to profile successfully");
                    } else {
                        dialog_log("Creating and saving params to profile: " + profile_name);
                        Storage.table_name = profile_name;      // select a new table to get data
                        Storage.initialize();
                        save_parameters_to_profile();
                        dialog_log("Creating and saving params to profile successfully");
                    }
                }
            }
            GButton {
                id: loadProfileButton
                text: "Load"
                onClicked: {
                    dialog_log("Load profile: " + profile_name )
                    Storage.table_name = profile_name;      // select a new table to get data
                    Storage.initialize();
                    load_parameters_to_ui();
                    dialog_log("Loading parameters from "+ profile_name + " done!")
                }
            }
            GButton {
                id: clearTextButton
                text: "Clear"
                onClicked: {
                    profile_name = ""
                    profileNameInput.text = ""
                    profileNameInput.focus = true
                }
            }

        }

        GListView{
            id: profileNameList
            width: 150; height: parent.height - 20; anchors.left: parent.left; anchors.leftMargin: 10;  anchors.top: parent.top ; anchors.topMargin: 10
            list_header_title: "Profile Name"
            hightlght_color: "blue"
            onClicked: {
                profile_name = item_text;
                dialog_log("Selected new profile: " + profile_name);
            }
        }


    }
    onStateChanged: {
        if(profileDialog.state === "show"){update_table_name_list()}
    }
    Component.onCompleted: {
        Storage.getDatabaseSync();
        update_table_name_list();
    }
    function update_table_name_list(){
        var m_list = Storage.getTableName();
        var m_table_name;
        profileNameList.list_model.clear();
        for(var i=0 ; i < m_list.rows.length ; i++){
            m_table_name = m_list.rows.item(i).name;
            profileNameList.list_model.append({"value": m_table_name});
            if(profile_name === m_table_name) profileNameList.current_index = i;

        }
    }
    function table_name_exist(name_str){
        var res = 0;
        var m_list = Storage.getTableName();
        var m_table_name;
        for(var i=0 ; i < m_list.rows.length ; i++){
            m_table_name = m_list.rows.item(i).name;
            if(m_table_name === name_str) {
                res = 1;
            }
        }
        return res;
    }

    /* function dialog_log(_message)
   @brief: put message to log
   @input: _message
   @output: msg_log in HTML format
  */
//    function dialog_log(_message){
////        msg_log = "<font color=\"yellow\">" + _message+ "</font><br>";
//         msg_log = _message+ "\n";
//    }
    /* function save_parameters_to_profile()
   @brief: save all parameters to profile name
   @input: parameters value get from _mavlink_manager
   @output: OK if save done; Error if fail
   @note:   this function only save the value from _mavlink_manager.current_params_on_board,
            it DOES NOT save value from UI.
  */
    function save_parameters_to_profile(){
        var class_name;
        // Save Tilt params:
        class_name = tilt_motor_class_name;
        Storage.saveParam(class_name, "Power", _mavlink_manager.tilt_power);
        Storage.saveParam(class_name, "Pole Num", _mavlink_manager.motor_roll_num_poles);
        Storage.saveParam(class_name, "Up limit", _mavlink_manager.tilt_up_limit_angle);
        Storage.saveParam(class_name, "Down limit", _mavlink_manager.tilt_down_limit_angle);
        Storage.saveParam(class_name, "Direction", _mavlink_manager.motor_tilt_dir);
        Storage.saveParam(class_name, "P", _mavlink_manager.tilt_kp);
        Storage.saveParam(class_name, "I", _mavlink_manager.tilt_ki);
        Storage.saveParam(class_name, "D", _mavlink_manager.tilt_kd);
        Storage.saveParam(class_name, "Follow", _mavlink_manager.tilt_follow);
        Storage.saveParam(class_name, "Filter", _mavlink_manager.tilt_filter);

        // Save Pan params:
        class_name = pan_motor_class_name;
        Storage.saveParam(class_name, "Power", _mavlink_manager.pan_power);
        Storage.saveParam(class_name, "Pole Num", _mavlink_manager.motor_roll_num_poles);
        Storage.saveParam(class_name, "CCW limit", _mavlink_manager.pan_ccw_limit_angle);
        Storage.saveParam(class_name, "CW limit", _mavlink_manager.pan_cw_limit_angle);
        Storage.saveParam(class_name, "Direction", _mavlink_manager.motor_pan_dir);
        Storage.saveParam(class_name, "P", _mavlink_manager.pan_kp);
        Storage.saveParam(class_name, "I", _mavlink_manager.pan_ki);
        Storage.saveParam(class_name, "D", _mavlink_manager.pan_kd);
        Storage.saveParam(class_name, "Follow", _mavlink_manager.pan_follow);
        Storage.saveParam(class_name, "Filter", _mavlink_manager.pan_filter);

        // Save Roll params:
        class_name = roll_motor_class_name;
        Storage.saveParam(class_name, "Power", _mavlink_manager.roll_power);
        Storage.saveParam(class_name, "Pole Num", _mavlink_manager.motor_roll_num_poles);
        Storage.saveParam(class_name, "Up limit", _mavlink_manager.roll_up_limit_angle);
        Storage.saveParam(class_name, "Down limit", _mavlink_manager.roll_down_limit_angle);
        Storage.saveParam(class_name, "Direction", _mavlink_manager.motor_roll_dir);
        Storage.saveParam(class_name, "P", _mavlink_manager.roll_kp);
        Storage.saveParam(class_name, "I", _mavlink_manager.roll_ki);
        Storage.saveParam(class_name, "D", _mavlink_manager.roll_kd);
        Storage.saveParam(class_name, "Follow", _mavlink_manager.roll_follow);
        Storage.saveParam(class_name, "Filter", _mavlink_manager.roll_filter);

    }
    /* function update_parameters_to_profile()
   @brief: update all parameters to profile name
   @input: parameters value get from _mavlink_manager
   @output: OK if update done; Error if fail
   @note:   this function only update the value from _mavlink_manager.current_params_on_board,
            it DOES NOT update value from UI.
  */
    function update_parameters_to_profile(){
        var class_name;
        // update Tilt params:
        class_name = tilt_motor_class_name;
        Storage.updateParam(class_name, "Power", _mavlink_manager.tilt_power);
        Storage.updateParam(class_name, "Pole Num", _mavlink_manager.motor_roll_num_poles);
        Storage.updateParam(class_name, "Up limit", _mavlink_manager.tilt_up_limit_angle);
        Storage.updateParam(class_name, "Down limit", _mavlink_manager.tilt_down_limit_angle);
        Storage.updateParam(class_name, "Direction", _mavlink_manager.motor_tilt_dir);
        Storage.updateParam(class_name, "P", _mavlink_manager.tilt_kp);
        Storage.updateParam(class_name, "I", _mavlink_manager.tilt_ki);
        Storage.updateParam(class_name, "D", _mavlink_manager.tilt_kd);
        Storage.updateParam(class_name, "Follow", _mavlink_manager.tilt_follow);
        Storage.updateParam(class_name, "Filter", _mavlink_manager.tilt_filter);

        // update Pan params:
        class_name = pan_motor_class_name;
        Storage.updateParam(class_name, "Power", _mavlink_manager.pan_power);
        Storage.updateParam(class_name, "Pole Num", _mavlink_manager.motor_roll_num_poles);
        Storage.updateParam(class_name, "CCW limit", _mavlink_manager.pan_ccw_limit_angle);
        Storage.updateParam(class_name, "CW limit", _mavlink_manager.pan_cw_limit_angle);
        Storage.updateParam(class_name, "Direction", _mavlink_manager.motor_pan_dir);
        Storage.updateParam(class_name, "P", _mavlink_manager.pan_kp);
        Storage.updateParam(class_name, "I", _mavlink_manager.pan_ki);
        Storage.updateParam(class_name, "D", _mavlink_manager.pan_kd);
        Storage.updateParam(class_name, "Follow", _mavlink_manager.pan_follow);
        Storage.updateParam(class_name, "Filter", _mavlink_manager.pan_filter);

        // update Roll params:
        class_name = roll_motor_class_name;
        Storage.updateParam(class_name, "Power", _mavlink_manager.roll_power);
        Storage.updateParam(class_name, "Pole Num", _mavlink_manager.motor_roll_num_poles);
        Storage.updateParam(class_name, "Up limit", _mavlink_manager.roll_up_limit_angle);
        Storage.updateParam(class_name, "Down limit", _mavlink_manager.roll_down_limit_angle);
        Storage.updateParam(class_name, "Direction", _mavlink_manager.motor_roll_dir);
        Storage.updateParam(class_name, "P", _mavlink_manager.roll_kp);
        Storage.updateParam(class_name, "I", _mavlink_manager.roll_ki);
        Storage.updateParam(class_name, "D", _mavlink_manager.roll_kd);
        Storage.updateParam(class_name, "Follow", _mavlink_manager.roll_follow);
        Storage.updateParam(class_name, "Filter", _mavlink_manager.roll_filter);

    }

    function load_parameters_to_ui(){
        var class_name;

        class_name = tilt_motor_class_name;
        _mavlink_manager.tilt_power             = Storage.getParam(class_name, "Power");
        _mavlink_manager.motor_roll_num_poles   = Storage.getParam(class_name, "Pole Num");
        _mavlink_manager.tilt_up_limit_angle    = Storage.getParam(class_name, "Up limit");
        _mavlink_manager.tilt_down_limit_angle  = Storage.getParam(class_name, "Down limit");
        _mavlink_manager.motor_tilt_dir         = Storage.getParam(class_name, "Direction");
        _mavlink_manager.tilt_kp                = Storage.getParam(class_name, "P" );
        _mavlink_manager.tilt_ki                = Storage.getParam(class_name, "I");
        _mavlink_manager.tilt_kd                = Storage.getParam(class_name, "D");
        _mavlink_manager.tilt_follow            = Storage.getParam(class_name, "Follow");
        _mavlink_manager.tilt_filter            = Storage.getParam(class_name, "Filter");

        class_name = pan_motor_class_name;
        _mavlink_manager.pan_power             = Storage.getParam(class_name, "Power");
        _mavlink_manager.motor_roll_num_poles  = Storage.getParam(class_name, "Pole Num");
        _mavlink_manager.pan_ccw_limit_angle   = Storage.getParam(class_name, "CCW limit");
        _mavlink_manager.pan_cw_limit_angle    = Storage.getParam(class_name, "CW limit");
        _mavlink_manager.motor_pan_dir         = Storage.getParam(class_name, "Direction");
        _mavlink_manager.pan_kp                = Storage.getParam(class_name, "P" );
        _mavlink_manager.pan_ki                = Storage.getParam(class_name, "I");
        _mavlink_manager.pan_kd                = Storage.getParam(class_name, "D");
        _mavlink_manager.pan_follow            = Storage.getParam(class_name, "Follow");
        _mavlink_manager.pan_filter            = Storage.getParam(class_name, "Filter");

        class_name = roll_motor_class_name;
        _mavlink_manager.roll_power             = Storage.getParam(class_name, "Power");
        _mavlink_manager.motor_roll_num_poles   = Storage.getParam(class_name, "Pole Num");
        _mavlink_manager.roll_up_limit_angle    = Storage.getParam(class_name, "Up limit");
        _mavlink_manager.roll_down_limit_angle  = Storage.getParam(class_name, "Down limit");
        _mavlink_manager.motor_roll_dir         = Storage.getParam(class_name, "Direction");
        _mavlink_manager.roll_kp                = Storage.getParam(class_name, "P" );
        _mavlink_manager.roll_ki                = Storage.getParam(class_name, "I");
        _mavlink_manager.roll_kd                = Storage.getParam(class_name, "D");
        _mavlink_manager.roll_follow            = Storage.getParam(class_name, "Follow");
        _mavlink_manager.roll_filter            = Storage.getParam(class_name, "Filter");
    }

}

