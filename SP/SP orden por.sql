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
	
	SET query_orden = CONCAT('SELECT * FROM network_inventory.device ', orderen_equipo);
    SELECT query_orden;
    -- ejecutar la consulta
   
	PREPARE runSQL FROM @query_orden;

	EXECUTE runSQL; 

	DEALLOCATE PREPARE runSQL;
END
//
DELIMITER ;


call SP_NETWORK_INVENTORY_ORDER ('DEV_HOST_NAME')

