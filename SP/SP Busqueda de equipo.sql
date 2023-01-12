DELIMITER //
CREATE PROCEDURE SP_NETWORK_INVENTORY_BY_IP (IN IP VARCHAR(60))
BEGIN
-- procedure de busqueda de equipos
    SELECT * FROM network_inventory.device
    WHERE DEV_IP = IP; 
END
//
Delimiter ;

call SP_NETWORK_INVENTORY_BY_IP ("10.10.0.1");