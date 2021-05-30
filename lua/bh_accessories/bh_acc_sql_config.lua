-- Place your MySQLOO details in this BH_ACC.MySQLOO table --
BH_ACC.MySQLOO = {
    --
    -- MySQL Database --
    --
    Database = "db_name",
    
    --
    -- MySQL Username --
    --
    Username = "db_user",
    
    --
    -- MySQL Password --
    --
    Password = "db_pass",
    
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