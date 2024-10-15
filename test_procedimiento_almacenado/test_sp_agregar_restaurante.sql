DO
$$
    DECLARE
        v_codigo_respuesta TEXT;
        v_mensaje_salida   TEXT;
    BEGIN
        -- Llamada al procedimiento almacenado
        select *
        into v_codigo_respuesta, -- variable para recibir el código de respuesta
            v_mensaje_salida
        from contabilidad_cerdos.agregar_distribuidor(
                'PENSION NIRIA',
                'Calle 7 # 28 - 11 PRIMERO DE MAYO',
                '31444444',
                NULL,
                '1',
                '2'
            -- variable para recibir el mensaje de salida
             );

-- Imprimir los resultados
        RAISE NOTICE 'Código de respuesta: %', v_codigo_respuesta;
        RAISE NOTICE 'Mensaje de salida: %', v_mensaje_salida;
    END;
$$;


-- SELECT DISTINCT (1) FROM contabilidad_cerdos.restaurantes WHERE nombre = in_restaurante_nombre