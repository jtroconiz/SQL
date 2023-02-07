use network_inventory;
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
INSERT INTO device (`DEV_MOD`,`DEV_HOST_NAME`,`DEV_LOCATION`,`DEV_IP`,`DEV_SERIAL_NO`,`DEV_ID`) VALUES ('C9300','test_192.168.20.1','test','192.168.20.1','v5mjo2YS','test_192.168.20.1');
INSERT INTO device (`DEV_MOD`,`DEV_HOST_NAME`,`DEV_LOCATION`,`DEV_IP`,`DEV_SERIAL_NO`,`DEV_ID`) VALUES ('C9300','test_192.168.20.2','test','192.168.20.2','v5Pjo2YS','test_192.168.20.2');
INSERT INTO device (`DEV_MOD`,`DEV_HOST_NAME`,`DEV_LOCATION`,`DEV_IP`,`DEV_SERIAL_NO`,`DEV_ID`) VALUES ('C9300','test_192.168.20.3','test','192.168.20.3','v5PLo2YS','test_192.168.20.3');

-- prueba de eliminacion de registro  
DELETE FROM device where DEV_ID = "test_192.168.20.1" ;
DELETE FROM device where DEV_ID = "test_192.168.20.2" ;
DELETE FROM device where DEV_ID = "test_192.168.20.3" ;

drop table LOG_INVENTARIO_EQUIPO;
drop trigger TR_LOG_EQUIPOS_IN;
drop trigger TR_LOG_EQUIPOS_DELETE; 
SELECT * FROM network_inventory.log_inventario_equipo;