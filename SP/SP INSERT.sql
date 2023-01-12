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

CALL SP_insert_device("N9504", "Caracas_192.168.1.1", "caracas", "192.168.1.1", "xckdlep", "Caracas_192.168.1.1");
;


call SP_NETWORK_INVENTORY_ORDER ('DEV_HOST_NAME')
call SP_NETWORK_INVENTORY_ORDER ('DEV_MOD')


