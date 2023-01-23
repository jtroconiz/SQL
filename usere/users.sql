create user 'am_pepito' identified by '1234';
-- garantizar permisos de lectura Alta y modificacion de datos sin poder eliminar 
grant select, insert, update on *.* to 'am_pepito';
show grants  for 'am_pepito';
-- drop user am_devices;

select * from network_inventory.device;	
update network_inventory.device
	set DEV_HOST_NAME = 'hola mundo'
where DEV_ID = 'Abu_10.10.0.1';
select * from network_inventory.device;	


create user 'vs_devices' identified by '1234';
-- solo permiso de seleccion / lectura para todas las tablas 
grant select on *.* to 'vs_devices';
show grants  for 'vs_devices';
-- ver permisos ototgados 
select * from network_inventory.device;	
update network_inventory.device
	set DEV_HOST_NAME = 'hola mundo'
where DEV_ID = 'Abu_10.10.0.1'