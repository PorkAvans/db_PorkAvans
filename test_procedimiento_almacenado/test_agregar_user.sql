DO
$$
    DECLARE
        v_codigo_respuesta TEXT;
        v_mensaje_salida   TEXT;
    BEGIN
        -- Llamada al procedimiento almacenado
        select *
        into v_codigo_respuesta, v_mensaje_salida
        from contabilidad_cerdos.agregar_users('PEDRO LUIS PEREZ CARRASCAL',
                                               'Pedro1',
                                               '4523453453',
                                               'ADMINISTRADOR',
                                               'INACTIVO'
             );

-- Imprimir los resultados
        RAISE NOTICE 'Código de respuesta: %', v_codigo_respuesta;
        RAISE NOTICE 'Mensaje de salida: %', v_mensaje_salida;
    END ;
$$;
