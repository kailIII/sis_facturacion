CREATE OR REPLACE FUNCTION fac.ft_actividad_economica_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Factura
 FUNCION: 		fac.ft_actividad_economica_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'fac.tactividad_economica'
 AUTOR: 		 (ada.torrico)
 FECHA:	        18-11-2014 19:22:12
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:
 AUTOR:
 FECHA:
***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_actividad_economica	integer;

BEGIN

    v_nombre_funcion = 'fac.ft_actividad_economica_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'FAC_AECO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		ada.torrico
 	#FECHA:		18-11-2014 19:22:12
	***********************************/

	if(p_transaccion='FAC_AECO_INS')then

        begin
        	--Sentencia de la insercion
        	insert into fac.tactividad_economica(
			nombre_actividad,
			estado_reg,
			codigo_actividad,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.nombre_actividad,
			'activo',
			v_parametros.codigo_actividad,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null



			)RETURNING id_actividad_economica into v_id_actividad_economica;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Actividad Economica almacenado(a) con exito (id_actividad_economica'||v_id_actividad_economica||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_actividad_economica',v_id_actividad_economica::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'FAC_AECO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		ada.torrico
 	#FECHA:		18-11-2014 19:22:12
	***********************************/

	elsif(p_transaccion='FAC_AECO_MOD')then

		begin
			--Sentencia de la modificacion
			update fac.tactividad_economica set
			nombre_actividad = v_parametros.nombre_actividad,
			codigo_actividad = v_parametros.codigo_actividad,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_actividad_economica=v_parametros.id_actividad_economica;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Actividad Economica modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_actividad_economica',v_parametros.id_actividad_economica::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'FAC_AECO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		ada.torrico
 	#FECHA:		18-11-2014 19:22:12
	***********************************/

	elsif(p_transaccion='FAC_AECO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from fac.tactividad_economica
            where id_actividad_economica=v_parametros.id_actividad_economica;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Actividad Economica eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_actividad_economica',v_parametros.id_actividad_economica::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	else

    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

EXCEPTION

	WHEN OTHERS THEN
		v_resp='';
		v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
		v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
		v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
		raise exception '%',v_resp;

END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;
