DO $$
    DECLARE
out_codigo_respuesta TEXT;
        out_mensaje_salida TEXT;
BEGIN
        -- Llamada al procedimiento almacenado
CALL contabilidad_cerdos.sp_agregar_pago(
                'Daniel Chacon Carrascal',
                '47', -- reemplazar 'imagen_base64' con la imagen en formato base64
                '2024-02-07', -- reemplazar 'Nombre Apellido' con el nombre y apellido del usuario
                '10000',
                out_codigo_respuesta, -- variable para recibir el código de respuesta
                out_mensaje_salida -- variable para recibir el mensaje de salida
             );

-- Imprimir los resultados
RAISE NOTICE 'Código de respuesta: %', out_codigo_respuesta;
        RAISE NOTICE 'Mensaje de salida: %', out_mensaje_salida;
END;
$$;
