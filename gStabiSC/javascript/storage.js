var table_name;
var table_name_list;

function getDatabaseSync() {
    return LocalStorage.openDatabaseSync("gStabi", "1.0", "gStabi Parameters", 100000);

}
// At the start of the application, we can initialize the tables we need if they haven't been created yet
function initialize() {
    var db = getDatabaseSync()
    db.transaction(
        function(tx) {
            // Create the settings table if it doesn't already exist
            // If the table exists, this is skipped
            tx.executeSql("CREATE TABLE IF NOT EXISTS "+ table_name +" (class TEXT, name TEXT, value NUMERIC)");
      });
}
function getTableName() {
    var db = getDatabaseSync();
    var res="";
    db.transaction(function(tx) {
        var rs = tx.executeSql("SELECT name FROM sqlite_master WHERE type='table'");
        table_name_list = rs;
        if(rs.rows.length > 0){
        for(var i = 0; i < rs.rows.length; i++) {
                                res += rs.rows.item(i).name + "\n"
        }
      } else {
          res = "Unknown";
      }
   })
   return table_name_list;
}

// This function is used to retrieve a param from the database
function getParam(param_class, param_name) {
   var db = getDatabaseSync();
   var res="";
   db.transaction(function(tx) {
       var rs = tx.executeSql("SELECT value FROM " + table_name+ " WHERE class=? AND name=?;", [param_class, param_name]);
     if (rs.rows.length > 0) {
          res = rs.rows.item(0).value;
     } else {
         res = 0;
     }
  })
  // The function returns “Unknown” if the setting was not found in the database
  // For more advanced projects, this should probably be handled through error codes
  return res
}

function saveParam(param_class, param_name, param_value){
    var db = getDatabaseSync();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql("INSERT OR REPLACE INTO " + table_name + " VALUES (?,?,?) ;", [param_class,param_name,param_value]);
               if (rs.rowsAffected > 0) {
                 res = "OK";
               } else {
                 res = "Error";
               }
         }
   );
   // The function returns “OK” if it was successful, or “Error” if it wasn't
   return res;
}
function updateParam(param_class, param_name, param_value){
    var db = getDatabaseSync();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql("UPDATE " + table_name + " SET value=(?) WHERE class=(?) AND name=(?) ;", [param_value, param_class,param_name]);
               if (rs.rowsAffected > 0) {
                 res = "OK";
               } else {
                 res = "Error";
               }
         }
   );
   // The function returns “OK” if it was successful, or “Error” if it wasn't
   return res;
}

function getSettingDatabaseSync(){
    return LocalStorage.openDatabaseSync("App_Settings", "1.0", "Application Settings", 100000);
}
// At the start of the application, we can initialize the tables we need if they haven't been created yet
function initializeSettings() {
    var db = getSettingDatabaseSync()
    db.transaction(
        function(tx) {
            // Create the settings table if it doesn't already exist
            // If the table exists, this is skipped
            tx.executeSql("CREATE TABLE IF NOT EXISTS setting (object TEXT, value TEXT)");
      });
}
// This function is used to retrieve a param from the database
function getSetting(object_name){
   var db = getSettingDatabaseSync();
   var res="";
   db.transaction(function(tx) {
       var rs = tx.executeSql("SELECT value FROM setting WHERE object=?;", [object_name]);
     if (rs.rows.length > 0) {
          res = rs.rows.item(0).value;
     } else {
         res = "NA";
     }
  })
  // The function returns “Unknown” if the setting was not found in the database
  // For more advanced projects, this should probably be handled through error codes
  return res
}
function saveSetting(object_name, setting_value){
    var db = getSettingDatabaseSync();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql("INSERT OR REPLACE INTO setting VALUES (?,?) ;", [object_name, setting_value]);
               if (rs.rowsAffected > 0) {
                 res = "OK";
               } else {
                 res = "Error";
               }
         }
   );
   // The function returns “OK” if it was successful, or “Error” if it wasn't
   return res;
}
function updateSetting(object_name, setting_value){
    var db = getSettingDatabaseSync();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql("UPDATE setting SET value=? WHERE object=? ;", [setting_value, object_name]);
               if (rs.rowsAffected > 0) {
                 res = "OK";
               } else {
                 res = "Error";
               }
         }
   );
   // The function returns “OK” if it was successful, or “Error” if it wasn't
   return res;
}
