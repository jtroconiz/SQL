


USE network_inventory;

-- Esta funcion sirve para contar las intergaces de un equipo 
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
//  ;

select FUN_CUENTA_INTERFAZ ("Abu_10.10.0.1")  AS ID_EQUIPO

select FUN_CUENTA_INTERFAZ ("")  AS ID_EQUIPO



USE network_inventory;

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
//  ;

select FUN_BUSQUEDA_EQUIPO ("10.10.0.1")  AS ID_EQUIPO