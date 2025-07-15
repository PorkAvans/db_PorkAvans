CREATE
    OR REPLACE FUNCTION contabilidad_cerdos.agregar_producto(
    in_product_type_id NUMERIC,
    in_product_imagen TEXT,
    in_product_name TEXT,
    in_product_content NUMERIC,
    in_product_unidad_medida TEXT,
    in_product_description TEXT,
    in_product_precio NUMERIC
)
    RETURNS TABLE
            (
                out_codigo_respuesta TEXT,
                out_mensaje_salida   TEXT
            )
    LANGUAGE 'plpgsql'
AS
$$
DECLARE
    codigo_error       TEXT;
    mensaje_error      TEXT;
    local_precio_id    INT;
    success_code       TEXT DEFAULT 'M0001';
    success_message    TEXT;
    error_code_checked VARCHAR(20) DEFAULT 'D0001';
BEGIN
    -- Validaciones de entrada
    IF
        in_product_type_id IS NULL OR in_product_type_id = 0 THEN
        RAISE EXCEPTION 'El tipo de producto no puede ir vacío' USING ERRCODE = error_code_checked;
    END IF;

    IF
        in_product_imagen IS NULL OR in_product_imagen = '' THEN
        RAISE EXCEPTION 'La imagen del producto no puede ir vacío' USING ERRCODE = error_code_checked;
    END IF;

    IF
        in_product_name IS NULL OR in_product_name = '' THEN
        RAISE EXCEPTION 'El nombre del producto no puede ir vacío o ser nulo' USING ERRCODE = error_code_checked;
    END IF;

    IF
        in_product_content IS NULL OR in_product_content = 0 THEN
        RAISE EXCEPTION 'El contenido no puede ser nulo o 0' USING ERRCODE = error_code_checked;
    END IF;

    IF
        in_product_unidad_medida IS NULL OR in_product_unidad_medida = '' THEN
        RAISE EXCEPTION 'La unidad de medida no puede ir vacío' USING ERRCODE = error_code_checked;
    END IF;

    IF
        in_product_description IS NULL OR in_product_description = '' THEN
        RAISE EXCEPTION 'La descripcion no puede ir vacío' USING ERRCODE = error_code_checked;
    END IF;

    IF
        in_product_precio IS NULL THEN
        RAISE EXCEPTION 'El precio no puede ser nulo' USING ERRCODE = error_code_checked;
    END IF;


    --validar si el tipo de producto existe
    IF NOT EXISTS(SELECT 1 FROM contabilidad_cerdos.product_type WHERE product_type_id = in_product_type_id) THEN
        RAISE EXCEPTION 'El tipo de producto no se encuentra en la base de datos' USING ERRCODE = error_code_checked;
    END IF;

    SELECT product_price_id INTO local_precio_id FROM contabilidad_cerdos.product_price WHERE price = in_product_precio;

    IF local_precio_id IS NULL OR local_precio_id = 0 THEN
        INSERT INTO contabilidad_cerdos.product_price(price)
        VALUES (in_product_precio)
        RETURNING product_price_id INTO local_precio_id;
    END IF;

    INSERT INTO contabilidad_cerdos.products(product_type_id, product_imagen, product_name, product_content,
                                             product_unidad_medida, product_description, product_price_id)
    VALUES (in_product_type_id, decode(in_product_imagen, 'base64'), UPPER(in_product_name), in_product_content,
            in_product_unidad_medida, in_product_description, local_precio_id);

    success_message
        := 'El producto fue agregado correctamente';

    RETURN QUERY SELECT success_code, success_message;

EXCEPTION
    WHEN OTHERS THEN
        codigo_error := SQLSTATE;
        mensaje_error
            := SQLERRM;
        RETURN QUERY SELECT codigo_error, mensaje_error;
END;
$$;
