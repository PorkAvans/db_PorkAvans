INSERT INTO contabilidad_cerdos.fase_crianza (nombre_fase, descripcion_fase, edad_min_semanas, edad_max_semanas,
                                              peso_min_kg, peso_max_kg, consumo_alimento_dia_kg,
                                              consumo_agua_dia_litros, ganancia_diaria_gr, tipo_alimento,
                                              duracion_dias_estimada, creado_por)
VALUES
-- 1. Gestación
('Gestación', 'Fase en la que las cerdas están preñadas', 0, 16, 100, 180, 2.0, 8.0, 600, 'Gestación', 112, 'admin'),

-- 2. Lactancia
('Lactancia', 'Fase en la que los lechones son alimentados por la madre', 0, 3, 1.2, 5.0, 0.3, 1.0, 150,
 'Leche materna', 21, 'admin'),

-- 3. Destete
('Destete', 'Transición del lechón de la leche materna a alimento sólido', 3, 6, 5.0, 12.0, 0.5, 2.5, 300,
 'Preiniciador', 28, 'admin'),

-- 4. Recría
('Recría', 'Fase de crecimiento inicial post-destete', 6, 10, 12.0, 25.0, 1.2, 3.0, 500, 'Iniciador', 28, 'admin'),

-- 5. Engorde
('Engorde', 'Fase de mayor aumento de peso antes de la venta o sacrificio', 10, 24, 25.0, 110.0, 2.5, 6.0, 800,
 'Engorde', 98, 'admin'),

-- 6. Terminación
('Terminación', 'Fase final antes del sacrificio para maximizar el peso', 24, 28, 110.0, 130.0, 3.0, 7.0, 850,
 'Terminador', 28, 'admin');
