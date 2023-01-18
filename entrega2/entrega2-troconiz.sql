-- Creacion de tablas 
CREATE DATABASE NETWORK_INVENTORY;
use NETWORK_INVENTORY;
-- Prueba 
-- CREATE DATABASE NETWORK;
-- use NETWORK;

-- Tabla con los tipos de dispositivos
CREATE TABLE DEVICE_TYPE (
DEV_MOD VARCHAR(30) primary key not null,
DEV_TYPE VARCHAR(30) NOT NULL,
DEV_OS_VERSION VARCHAR(30) NOT NULL,
DEV_PART_NO VARCHAR(30) NOT NULL
);

-- Inventario de dispostitivos
CREATE TABLE DEVICE (
DEV_MOD  VARCHAR(30) NOT NULL,
DEV_HOST_NAME  VARCHAR(30) NOT NULL,
DEV_LOCATION  VARCHAR(30) NULL,
DEV_IP  VARCHAR(16) NOT NULL,
DEV_SERIAL_NO  VARCHAR(30) NOT NULL,
DEV_ID  VARCHAR(50) PRIMARY KEY NOT NULL, /*(DEV_IP, DEV_HOST_NAME) */
foreign key (DEV_MOD) references DEVICE_TYPE(DEV_MOD)
);
-- Tabla con los modelis de dispositivos
CREATE TABLE MODULE_TYPE (
MODULE_MOD  VARCHAR(30)  primary key not null,
MODULE_TYPE  VARCHAR(15) NOT NULL,
MODULE_OS_VERSION  VARCHAR(30) NOT NULL,
MODULE_PART_NO  VARCHAR(30) NOT NULL
);

-- Inventario de modulos
CREATE TABLE MODULE_DEVICE (
MODULE_MOD  VARCHAR(30)  not null,
DEV_ID  VARCHAR(50) primary key NOT NULL,
MODULE_SERIAL_NO VARCHAR(30)  not null,
foreign key (MODULE_MOD) references MODULE_TYPE(MODULE_MOD),
foreign key (DEV_ID) references DEVICE(DEV_ID)
);

-- Inventario de interfacez de dispostitivos
CREATE TABLE DEVICE_INTERFACES (
INT_NAME  VARCHAR(30) NOT NULL,
INT_DESC  VARCHAR(30) NULL,
INT_TYPE  VARCHAR(30) NOT NULL,
INT_IP  VARCHAR(30) NOT NULL,
DEV_ID VARCHAR(50) NOT NULL,
INT_ID  VARCHAR(60) PRIMARY KEY  NOt NULL, -- (INT_IP, INT_NAME)
foreign key (DEV_ID) references MODULE_DEVICE(DEV_ID)
);

-- Creacion de vistas 

-- Vista de lista de tipos dispositivos
create or replace view V_DEVICES_TYPE_LIST AS   
    Select 
        D.DEV_MOD AS Modelo,
        D.DEV_TYPE AS Tipo,
        D.DEV_OS_VERSION AS Software,
        D.DEV_PART_NO AS Numero_de_Parte
    from network_inventory.device_type AS D;

-- Vista de conteo de dispositivos
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

-- Vista de inventario de dispositivos
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

-- Vista de tipos de modulos
create or replace view V_MODULE_TYPE_LIST AS   
    Select 
        M.MODULE_MOD AS Modelo,
        M.MODULE_TYPE AS Tipo,
        M.MODULE_OS_VERSION AS Software,
        M.MODULE_PART_NO AS Numero_de_Parte
    from network_inventory.module_type AS M;

-- Vista de conteo de modulos
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

-- Vista de conteo de modulos por equipo
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
    
 -- Funciones    
--  Funcion que cuenta la cantidad de interfaces 
DELIMITER //
CREATE FUNCTION FUN_CUENTA_INTERFAZ (ID char(60))
RETURNS int
READS SQL DATA
BEGIN
	declare CUENTA int;
    SELECT count(device_interfaces.INT_ID)
	INTO CUENTA
		from device
		inner join device_interfaces on device_interfaces.DEV_ID = device.DEV_ID
		where device.DEV_ID = ID;
	RETURN CUENTA;
END
// DELIMITER  ;

-- select FUN_CUENTA_INTERFAZ ("Abu_10.10.0.1")  AS ID_EQUIPO

-- Esta funcion sirve para buscar los datos de un equipo, es constante que se tiene la ip y no el nombre del equipo 
DELIMITER //
CREATE FUNCTION FUN_BUSQUEDA_EQUIPO (IP char(60))
RETURNS int
READS SQL DATA
BEGIN
	declare DEV_ID int;
    SELECT device.DEV_ID
	INTO DEV_ID
		from device
		where device.DEV_IP = IP;
	RETURN DEV_ID;
END
// DELIMITER ;

-- select FUN_BUSQUEDA_EQUIPO ("10.10.0.1")  AS ID_EQUIPO

-- Creacion de Stpre Procedures

-- procedure de busqueda de equipos por la IP 
DELIMITER //
CREATE PROCEDURE SP_NETWORK_INVENTORY_BY_IP (IN IP VARCHAR(60))
BEGIN
-- procedure de busqueda de equipos
    SELECT * FROM network_inventory.device
    WHERE DEV_IP = IP; 
END
//
Delimiter ;

-- call SP_NETWORK_INVENTORY_BY_IP ("10.10.0.1");

-- Funcion para ordenar los datos mostrados 
DELIMITER //
CREATE PROCEDURE SP_NETWORK_INVENTORY_ORDER (IN ordenpor CHAR(20))
BEGIN
	DECLARE orderen_equipo VARCHAR(100);
	--     variable 
    DECLARE query_orden VARCHAR(250);
    -- si existe concatena
		IF ordenpor <> ' ' THEN
			set orderen_equipo = CONCAT('ORDER BY ', ordenpor);
	END IF;
	
	SET @query_orden = CONCAT('SELECT * FROM network_inventory.device ', orderen_equipo);
    SELECT query_orden;
    -- ejecutar la consulta
   
	PREPARE ejecutar FROM @query_orden;

	EXECUTE ejecutar; 

	DEALLOCATE PREPARE ejecutar;
END
//
DELIMITER ;

-- call SP_NETWORK_INVENTORY_ORDER ('DEV_HOST_NAME');
-- call SP_NETWORK_INVENTORY_ORDER ('DEV_MOD');

-- Insercion de datos de equipos 
DELIMITER //
CREATE PROCEDURE SP_insert_device (IN DEV_MOD varchar(30), 
								IN DEV_HOST_NAME varchar(30), 
								IN DEV_LOCATION varchar(30), 
								IN DEV_IP varchar(16), 
								IN DEV_SERIAL_NO varchar(30),
                                IN DEV_ID varchar(50))
BEGIN
	INSERT INTO device VALUES
    (DEV_MOD, DEV_HOST_NAME, DEV_LOCATION, DEV_IP, DEV_SERIAL_NO, DEV_ID);

END
//
DELIMITER ;

-- CALL SP_insert_device("N9504", "Caracas_192.168.1.1", "caracas", "192.168.1.1", "xckdlep", "Caracas_192.168.1.1");

-- Triggers 
-- Crear tabla para el control de modificaciones del inventario de dispositivos
CREATE TABLE LOG_INVENTARIO_EQUIPO (
	ID_CHANGE INT unsigned AUTO_INCREMENT PRIMARY KEY,
    DEV_ID VARCHAR(50),
    DEV_SERIAL_NO  VARCHAR(30),
    TIPE_CHANGE VARCHAR(30),
    USER_DB VARCHAR(50),
    MODIFY_DATE TIMESTAMP NOT NULL
);
  
--   Registro de log de nuevos dispositivos 
DELIMITER //
CREATE TRIGGER TR_LOG_EQUIPOS_IN
AFTER INSERT ON DEVICE
FOR EACH ROW

BEGIN
	INSERT INTO LOG_INVENTARIO_EQUIPO (ID_CHANGE, DEV_ID, DEV_SERIAL_NO, TIPE_CHANGE, USER_DB, MODIFY_DATE)
  VALUES (
	NULL , NEW.DEV_ID, NEW.DEV_SERIAL_NO, "Insert", SYSTEM_USER(), current_timestamp()
  );
END // 
DELIMITER ;

--   Registro de log de eliminacion de dispositivos 
DELIMITER //
CREATE TRIGGER TR_LOG_EQUIPOS_DELETE
BEFORE DELETE ON DEVICE
FOR EACH ROW
BEGIN
	INSERT INTO LOG_INVENTARIO_EQUIPO ( DEV_ID, DEV_SERIAL_NO, TIPE_CHANGE, USER_DB, MODIFY_DATE)
  VALUES (
	 OLD.DEV_ID, OLD.DEV_SERIAL_NO, "DELETED", SYSTEM_USER(), current_timestamp()
  );
END // 
DELIMITER ;

-- Prueba de nuevo registro 
-- INSERT INTO device (`DEV_MOD`,`DEV_HOST_NAME`,`DEV_LOCATION`,`DEV_IP`,`DEV_SERIAL_NO`,`DEV_ID`) VALUES ('C9300','test_192.168.20.1','test','192.168.20.1','v5mjo2YS','test_192.168.20.1');
-- INSERT INTO device (`DEV_MOD`,`DEV_HOST_NAME`,`DEV_LOCATION`,`DEV_IP`,`DEV_SERIAL_NO`,`DEV_ID`) VALUES ('C9300','test_192.168.20.2','test','192.168.20.2','v5Pjo2YS','test_192.168.20.2');
-- INSERT INTO device (`DEV_MOD`,`DEV_HOST_NAME`,`DEV_LOCATION`,`DEV_IP`,`DEV_SERIAL_NO`,`DEV_ID`) VALUES ('C9300','test_192.168.20.3','test','192.168.20.3','v5PLo2YS','test_192.168.20.3');

-- prueba de eliminacion de registro  
-- DELETE FROM device where DEV_ID = "test_192.168.20.1" ;
-- DELETE FROM device where DEV_ID = "test_192.168.20.2" ;
-- DELETE FROM device where DEV_ID = "test_192.168.20.3" ;
