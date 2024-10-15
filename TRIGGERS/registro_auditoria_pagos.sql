CREATE OR REPLACE FUNCTION contabilidad_cerdos.registro_auditoria_pagos()
    RETURNS TRIGGER AS
$$
DECLARE
    previous_parameters JSON;
    new_parameters   JSON;
BEGIN
    SET TIME ZONE 'America/Bogota';

    IF TG_OP = 'INSERT' THEN
        INSERT INTO contabilidad_cerdos.audit (affected_table, exchange_rate, affected_record_id,
                                                   previous_parameters, new_parameters, user_modification,
                                                   registration_date)
        VALUES (TG_TABLE_NAME, 'INSERT', NEW.pago_id, NULL, to_json(NEW), NEW.registrado_por, CURRENT_TIMESTAMP);
    ELSIF TG_OP = 'UPDATE' THEN
        previous_parameters := to_json(OLD);
        new_parameters := to_json(NEW);

        INSERT INTO contabilidad_cerdos.audit (affected_table, exchange_rate, affected_record_id,
                                                   previous_parameters, new_parameters, user_modification,
                                                   registration_date)
        VALUES (TG_TABLE_NAME, 'UPDATE', NEW.pago_id, previous_parameters, new_parameters, NEW.registrado_por,
                CURRENT_TIMESTAMP);

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO contabilidad_cerdos.audit (affected_table, exchange_rate, affected_record_id,
                                                   previous_parameters, new_parameters, user_modification,
                                                   registration_date)
        VALUES (TG_TABLE_NAME, 'DELETE', OLD.pago_id, to_json(OLD), NULL, NEW.registrado_por, CURRENT_TIMESTAMP);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER auditar_pagos
    AFTER INSERT OR UPDATE OR DELETE
    ON contabilidad_cerdos.pagos
    FOR EACH ROW
EXECUTE FUNCTION contabilidad_cerdos.registro_auditoria_pagos();