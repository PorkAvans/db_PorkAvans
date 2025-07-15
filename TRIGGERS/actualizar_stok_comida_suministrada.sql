CREATE FUNCTION contabilidad_cerdos.actualizar_stock_producto_suministrado() RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    contenido_unitario NUMERIC;
    cantidad_producto_actual
                       NUMERIC;
    cantidad_producto_a_restar
                       NUMERIC;
    nuevo_contenido_neto
                       NUMERIC;
    tipo_producto
                       INT;
BEGIN
    -- Obtener el contenido unitario del producto y el tipo de producto
    SELECT p.product_content, p.product_type_id
    INTO contenido_unitario, tipo_producto
    FROM contabilidad_cerdos.products p
    WHERE p.product_id = NEW.comida_suministrada_producto_id;

-- Verificar si existe el producto en el stock
    IF
        EXISTS (SELECT 1
                FROM contabilidad_cerdos.stock_productos
                WHERE producto_id = NEW.comida_suministrada_producto_id) THEN
        -- Obtener la cantidad actual de producto en stock antes de actualizar
        SELECT cantidad_producto
        INTO cantidad_producto_actual
        FROM contabilidad_cerdos.stock_productos
        WHERE producto_id = NEW.comida_suministrada_producto_id;

-- Dependiendo del tipo de producto, ajustar el cálculo
        IF
            tipo_producto = 1 THEN
            -- COMIDA HUMEDA (por ejemplo, baldes)
            cantidad_producto_a_restar := NEW.comida_suministrada_cantidad;
            nuevo_contenido_neto
                := (cantidad_producto_actual - cantidad_producto_a_restar) * contenido_unitario;

        ELSIF
            tipo_producto = 2 THEN
            -- COMIDA SECA (por ejemplo, purina)
            -- Asumiendo que comida_suministrada_cantidad es en kilos
            cantidad_producto_a_restar := NEW.comida_suministrada_cantidad / contenido_unitario;
            nuevo_contenido_neto
                := (cantidad_producto_actual - cantidad_producto_a_restar) * contenido_unitario;

        ELSE
            RAISE EXCEPTION 'Tipo de producto desconocido: %', tipo_producto;
        END IF;

        -- Actualizar la cantidad del producto en el stock restando la cantidad suministrada
        UPDATE contabilidad_cerdos.stock_productos
        SET cantidad_producto          = CASE
                                             WHEN cantidad_producto IS NULL THEN 0 - cantidad_producto_a_restar
                                             ELSE cantidad_producto - cantidad_producto_a_restar
            END,
            contenido_neto             = CASE
                                             WHEN nuevo_contenido_neto < 0 THEN 0
                                             ELSE nuevo_contenido_neto
                END,
            fecha_ultima_actualizacion = CURRENT_TIMESTAMP
        WHERE producto_id = NEW.comida_suministrada_producto_id;

-- Ajustar valores negativos a cero
        UPDATE contabilidad_cerdos.stock_productos
        SET cantidad_producto = 0
        WHERE producto_id = NEW.comida_suministrada_producto_id
          AND cantidad_producto < 0;

        UPDATE contabilidad_cerdos.stock_productos
        SET contenido_neto = 0
        WHERE producto_id = NEW.comida_suministrada_producto_id
          AND contenido_neto < 0;
    ELSE
        RAISE EXCEPTION 'EL PRODUCTO NO SE ENCUENTRA REGISTRADJO EN STOCK';
    END IF;

    RETURN NEW;
END;
$$;

-- Crear el trigger para ejecutar la función después de insertar en comida_suministrada
CREATE TRIGGER trg_actualizar_stock_producto_suministrado
    AFTER INSERT
    ON contabilidad_cerdos.comida_suministrada
    FOR EACH ROW
EXECUTE FUNCTION contabilidad_cerdos.actualizar_stock_producto_suministrado();
