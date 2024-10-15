DO
$$
    DECLARE
        out_codigo_respuesta TEXT;
        out_mensaje_salida   TEXT;
    BEGIN
        -- Llamada al procedimiento almacenado
        select *
        into out_codigo_respuesta,
            out_mensaje_salida
        from contabilidad_cerdos.agregar_producto_recolectada(
                'USRDCC013',
                'MULTIPOLLO CENTRO', -- reemplazar 'imagen_base64' con la imagen en formato base64
                '2024-06-28', -- reemplazar 'Nombre Apellido' con el nombre y apellido del usuario
                '2', -- reemplazar 'Password123' con la contraseña
                '1'-- reemplazar 'ACTIVO' con el estado del usuario
             );

-- Imprimir los resultados
        RAISE NOTICE 'Código de respuesta: %', out_codigo_respuesta;
        RAISE NOTICE 'Mensaje de salida: %', out_mensaje_salida;
    END;
$$;
