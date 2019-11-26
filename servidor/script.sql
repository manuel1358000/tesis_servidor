select * from publicacion;
select * from usuario;


CREATE OR REPLACE FUNCTION CREAR_PUBLICACION(
	p_tipo integer,
	p_nombre varchar,
	p_descripcion varchar,
	p_posicion_x float,
	p_posicion_y float,
	p_estado integer,
	p_cui bigint,
	p_subtipo integer) returns void as $$
BEGIN
	insert into publicacion(tipo,nombre,descripcion,posicion_x,posicion_y,estado,subtipo)values(p_tipo,p_nombre,p_descripcion,p_posicion_x,p_posicion_y,p_estado,p_subtipo);
	insert into asignacion(cod_usuario,cod_publicacion)values((select cod_usuario from usuario where cui=p_cui),(SELECT currval(pg_get_serial_sequence('publicacion','cod_publicacion'))));
END;
$$ LANGUAGE plpgsql;

drop function crear_publicacion;

SELECT CREAR_PUBLICACION(1,'PUBLICACION prueba','PUBLICACION',10,10,1,20);

select * from usuario;
1
select * from asignacion;

select * from publicacion;
	



