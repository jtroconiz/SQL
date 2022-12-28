use network_inventory;

-- Device
create or replace view V_DEVICES_TYPE_LIST AS   
    Select 
        D.DEV_MOD AS Modelo,
        D.DEV_TYPE AS Tipo,
        D.DEV_OS_VERSION AS Software,
        D.DEV_PART_NO AS Numero_de_Parte
    from network_inventory.device_type AS D;

create or replace view V_DEVICES_INVENTORY_COUNT AS   
    Select 
        D.DEV_MOD AS Modelos, count(*) AS Numero_de_Modelos,
		DT.DEV_TYPE AS Familia,
		DT.DEV_PART_NO AS Numero_de_parte,
        DT.DEV_OS_VERSION AS Software
		FROM network_inventory.device AS D
    INNER JOIN DEVICE_TYPE AS DT ON D.DEV_MOD = DT.DEV_MOD
    GROUP by D.DEV_MOD
    ORDER BY Numero_de_Modelos desc;

create or replace view V_DEVICES_INVENTORY_LIST AS
    Select 
        D.DEV_HOST_NAME AS Host_Name,
        D.DEV_LOCATION AS Ubicacion,
        D.DEV_IP AS IP,
        D.DEV_SERIAL_NO AS "Serial",
        D.DEV_MOD AS Modelo, 
		DT.DEV_TYPE AS Familia,
		DT.DEV_PART_NO AS Numero_de_parte,
        DT.DEV_OS_VERSION AS Software
		FROM network_inventory.device AS D
    INNER JOIN DEVICE_TYPE AS DT ON D.DEV_MOD = DT.DEV_MOD;

-- Modules

create or replace view V_MODULE_TYPE_LIST AS   
    Select 
        M.MODULE_MOD AS Modelo,
        M.MODULE_TYPE AS Tipo,
        M.MODULE_OS_VERSION AS Software,
        M.MODULE_PART_NO AS Numero_de_Parte
    from network_inventory.module_type AS M;

create or replace view V_MODULE_INVENTORY_COUNT AS   
    Select 
        M.MODULE_MOD AS Modelos, count(*) AS Numero_de_Modelos,
		MT.MODULE_TYPE AS Tipo,
        MT.MODULE_OS_VERSION AS Software,
        MT.MODULE_PART_NO AS Numero_de_Parte
    from network_inventory.module_device AS M 
    INNER JOIN MODULE_TYPE AS MT ON M.MODULE_MOD = MT.MODULE_MOD
    GROUP by M.MODULE_MOD
    ORDER BY Numero_de_Modelos desc;

create or replace view V_MODULE_INVENTORY_LIST AS
    Select 
        MD.MODULE_MOD AS Modelo_del_modulo,
        MD.MODULE_SERIAL_NO AS "Serial_modelo",
        D.DEV_HOST_NAME AS Host_Name,
        D.DEV_LOCATION AS Ubicacion,
        D.DEV_IP AS IP,
        D.DEV_SERIAL_NO AS "Serial_equipo",
        D.DEV_MOD AS Modelo_del_equipo, 
		MT.MODULE_TYPE AS Familia,
		MT.MODULE_PART_NO AS Numero_de_parte,
        MT.MODULE_OS_VERSION AS Software
		FROM network_inventory.module_device AS MD
    INNER JOIN DEVICE AS D ON MD.DEV_ID = D.DEV_ID
    INNER JOIN MODULE_TYPE AS MT ON MD.MODULE_MOD = MT.MODULE_MOD;

