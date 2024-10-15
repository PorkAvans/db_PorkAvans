CREATE OR REPLACE FUNCTION contabilidad_cerdos.agregar_comida_suministrada(
    in_user TEXT,
    in_corral_id INT, -- identificador único del corral
    in_producto_id INT, --identificador unico del producto
    in_cantidad NUMERIC --cantidad suministrada


)
    RETURNS TABLE
            (
                out_codigo_salida  TEXT,
                out_mensaje_salida TEXT
            )
    LANGUAGE 'plpgsql'
AS
$$
DECLARE
    codigo_error       TEXT;
    mensaje_error      TEXT;
    success_code       TEXT DEFAULT 'M0001';
    success_message    TEXT;
    error_code_checked VARCHAR(20) DEFAULT 'D0001'; -- Variable para asignar código de error controlado
BEGIN
    -- Validaciones de campos vacíos
    IF in_user IS NULL OR in_user = '' THEN
        RAISE EXCEPTION 'El usuario no puede ir vacío' USING ERRCODE = error_code_checked;
    END IF;

    IF in_corral_id IS NULL OR in_corral_id = 0 THEN
        RAISE EXCEPTION 'El identificador del corral no puede ir vacío' USING ERRCODE = error_code_checked;
    END IF;

    IF in_producto_id IS NULL OR in_producto_id = 0 THEN
        RAISE EXCEPTION 'El identificador del producto no puede ir vacío' USING ERRCODE = error_code_checked;
    END IF;

    IF in_cantidad IS NULL OR in_cantidad = 0 THEN
        RAISE EXCEPTION 'La cantidad no puede ser nula o 0' USING ERRCODE = error_code_checked;
    END IF;

    -- Validación que el usuario exista
    IF NOT EXISTS (SELECT 1 FROM contabilidad_cerdos.users WHERE user_id = in_user) THEN
        RAISE EXCEPTION 'El usuario "%s" no se encuentra en la base de datos', in_user USING ERRCODE = error_code_checked;
    END IF;

    -- Validación que el corral exista
    IF NOT EXISTS (SELECT 1
                   FROM contabilidad_cerdos.corral
                   WHERE corral_id = in_corral_id::INT) THEN
        RAISE EXCEPTION 'El corral con el identificador "%" no se encuentra en la base de datos', in_corral_id USING ERRCODE = error_code_checked;
    END IF;

    -- Validación que el producto exista
    IF NOT EXISTS (SELECT 1
                   FROM contabilidad_cerdos.products
                   WHERE product_id = in_producto_id::INT) THEN
        RAISE EXCEPTION 'El producto con el identificador "%" no se encuentra en la base de datos', in_producto_id USING ERRCODE = error_code_checked;
    END IF;

    -- Insertar el nuevo pago
    INSERT INTO contabilidad_cerdos.comida_suministrada (comida_suministrada_corral_id, comida_suministrada_producto_id,
                                                         comida_suministrada_cantidad, comida_suministrada_fecha,
                                                         comida_suministrada_por)
    VALUES (in_corral_id::INT, in_producto_id, in_cantidad,CURRENT_TIMESTAMP, in_user);

    success_message := 'El suministro de comida se registró correctamente';

    RETURN QUERY SELECT success_code, success_message;

EXCEPTION
    WHEN OTHERS THEN
        codigo_error := SQLSTATE;
        mensaje_error := SQLERRM;
        RETURN QUERY SELECT codigo_error, mensaje_error;
END ;
$$;
