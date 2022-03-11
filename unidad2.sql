-- 1. Cargar el respaldo de la base de datos unidad2.sql.
psql -U postgres unidad2 < unidad2.sql

-- 2. El cliente usuario01 ha realizado la siguiente compra: 
-- producto: producto9. 
-- cantidad: 5. 
-- fecha: fecha del sistema. 
-- Mediante el uso de transacciones, realiza las consultas correspondientes para este requerimiento y luego consulta la tabla producto para validar 
-- si fue efectivamente descontado en el stock.
select * from producto where id = 9;

begin transaction;

insert into compra (cliente_id, fecha) values (1, CURRENT_DATE);
insert into detalle_compra (producto_id, compra_id, cantidad) values (9, 39, 5);
update producto set stock = stock - 5 where id = 9;

commit;

select * from producto where id = 9;

-- 3. El cliente usuario02 ha realizado la siguiente compra:
-- producto: producto1, producto 2, producto 8.
-- cantidad: 3 de cada producto.
-- fecha: fecha del sistema.
-- Mediante el uso de transacciones, realiza las consultas correspondientes para este
-- requerimiento y luego consulta la tabla producto para validar que si alguno de ellos
-- se queda sin stock, no se realice la compra.
begin transaction;

insert into compra (cliente_id, fecha) values (2, CURRENT_DATE);

insert into detalle_compra (producto_id, compra_id, cantidad) values (1, 40, 3);
update producto set stock = stock - 3 where id = 1;

insert into detalle_compra (producto_id, compra_id, cantidad) values (2, 40, 3);
update producto set stock = stock - 3 where id = 2;

insert into detalle_compra (producto_id, compra_id, cantidad) values (8, 40, 3);
update producto set stock = stock - 3 where id = 8; -- error

rollback;

-- 4. Realizar las siguientes consultas:
-- a. Deshabilitar el AUTOCOMMIT.
\set AUTOCOMMIT off;

-- b. Insertar un nuevo cliente.
begin transaction;

insert into cliente (nombre, email) values ('usuario11', 'usuario011@hotmail.com');

-- c. Confirmar que fue agregado en la tabla cliente.
select * from cliente;

-- d. Realizar un ROLLBACK.
rollback;

-- e. Confirmar que se restauró la información, sin considerar la inserción del
-- punto b.
select * from cliente;

-- f. Habilitar de nuevo el AUTOCOMMIT.
\set AUTOCOMMIT on;