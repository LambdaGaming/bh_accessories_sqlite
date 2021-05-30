-- Place your MySQLOO details in this BH_ACC.MySQLOO table --
BH_ACC.MySQLOO = {
    --
    -- MySQL Database --
    --
    Database = "bh_testdb",
    
    --
    -- MySQL Username --
    --
    Username = "root",
    
    --
    -- MySQL Password --
    --
    Password = "",
    
    --
    -- MySQL Host/IP --
    --
    Host = "localhost",
    
    --
    -- MySQL Port --
    --
    Port = 3306

}

if BH_ACC.Loaded then
    hook.Run("BH_ACC_LoadedFile", "bh_acc_sql_config")
end