--Practica MIA
--Josué Carlos Pérez Montenegro
--201403546

--CREATE SCHEMA "Practica1"
 --   AUTHORIZATION postgres;
	
-- PLANTAMIENTO 1: CREACION DE TABLAS
CREATE TABLE PROFESION
(
    cod_prof int NOT NULL,
    nombre varchar(50) NOT NULL,
    CONSTRAINT PK_PROFESION_codprof PRIMARY KEY(cod_prof),
    CONSTRAINT U_PROFESION_nombre UNIQUE(nombre)
);

CREATE TABLE PAIS
(
    cod_pais int NOT NULL,
    nombre varchar(50) NOT NULL,
    CONSTRAINT PK_PAIS_codpais PRIMARY KEY(cod_pais),
    CONSTRAINT U_PAIS_nombre UNIQUE(nombre)
);

CREATE TABLE PUESTO
(
    cod_puesto int NOT NULL,
    nombre varchar(50) NOT NULL,
    CONSTRAINT PK_PUESTO_codpuesto PRIMARY KEY(cod_puesto),
    CONSTRAINT U_PUESTO_nombre UNIQUE(nombre)
);

CREATE TABLE DEPARTAMENTO
(
    cod_depto int NOT NULL,
    nombre varchar(50) NOT NULL,
    CONSTRAINT PK_DEPTO_coddepto PRIMARY KEY(cod_depto),
    CONSTRAINT U_DEPTO_nombre UNIQUE(nombre)
);

CREATE TABLE MIEMBRO
(
    cod_miembro integer NOT NULL,
    PAIS_cod_pais integer NOT NULL,
    PROFESION_cod_prof integer NOT NULL,
    nombre varchar(100) NOT NULL,
    apellido varchar(100) NOT NULL,
    edad integer NOT NULL,
    telefono integer,
    residencia varchar(100),
    CONSTRAINT PK_MIEMBRO_cod_miembro PRIMARY KEY(cod_miembro),
    CONSTRAINT FK_PAIS_cod_pais FOREIGN KEY(PAIS_cod_pais) REFERENCES PAIS(cod_pais) ON DELETE CASCADE,
    CONSTRAINT FK_PROFESION_cod_prof FOREIGN KEY(PROFESION_cod_prof) REFERENCES PROFESION(cod_prof) ON DELETE CASCADE
);

CREATE TABLE PUESTO_MIEMBRO
(
    MIEMBRO_cod_miembro integer NOT NULL,
    PUESTO_cod_puesto integer NOT NULL,
    DEPARTAMENTO_cod_depto integer NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date,
    CONSTRAINT PK_PUESTO_MIEMBRO PRIMARY KEY (MIEMBRO_cod_miembro, PUESTO_cod_puesto, DEPARTAMENTO_cod_depto),
    CONSTRAINT FK_MIEMBRO_cod_miembro FOREIGN KEY(MIEMBRO_cod_miembro) REFERENCES MIEMBRO(cod_miembro) ON DELETE CASCADE,
    CONSTRAINT FK_PUESTO_cod_puesto FOREIGN KEY(PUESTO_cod_puesto) REFERENCES PUESTO(cod_puesto) ON DELETE CASCADE,
    CONSTRAINT FK_DEPARTAMENTO_cod_depto FOREIGN KEY(DEPARTAMENTO_cod_depto) REFERENCES DEPARTAMENTO(cod_depto) ON DELETE CASCADE
    
);

CREATE TABLE TIPO_MEDALLA
(
    cod_tipo integer NOT NULL,
    medalla varchar(20) NOT NULL,
    CONSTRAINT PK_TIPO_MEDALLA_cod_tipo PRIMARY KEY(cod_tipo),
    CONSTRAINT U_TIPO_MEDALLA_medalla UNIQUE(medalla)
);

CREATE TABLE MEDALLERO
(
    PAIS_cod_pais integer NOT NULL,
    cantidad_medallas integer NOT NULL,
    TIPO_MEDALLA_cod_tipo integer NOT NULL,
    CONSTRAINT PK_MEDALLERO PRIMARY KEY (PAIS_cod_pais, TIPO_MEDALLA_cod_tipo),
    CONSTRAINT FK_PAIS_codpais FOREIGN KEY(PAIS_cod_pais) REFERENCES PAIS(cod_pais) ON DELETE CASCADE,
    CONSTRAINT FK_TIPO_MEDALLA_codtipo FOREIGN KEY(TIPO_MEDALLA_cod_tipo) REFERENCES TIPO_MEDALLA(cod_tipo) ON DELETE CASCADE
);

CREATE TABLE DISCIPLINA
(
    cod_disciplina integer NOT NULL,
    nombre varchar(50) NOT NULL,
    descripcion varchar(150),
    CONSTRAINT PK_DISCIPLINA PRIMARY KEY (cod_disciplina)
);

CREATE TABLE ATLETA
(
    cod_atleta integer NOT NULL,
    nombre varchar(50) NOT NULL,
    apellido varchar(50) NOT NULL,
    edad integer NOT NULL,
    participaciones varchar(100) NOT NULL,
    DISCIPLINA_cod_disciplina integer NOT NULL,
    PAIS_cod_pais integer NOT NULL,
    CONSTRAINT PK_ATLETA PRIMARY KEY (cod_atleta),
    CONSTRAINT FK_ATLETA_PAIS_cod_pais FOREIGN KEY(PAIS_cod_pais) REFERENCES PAIS(cod_pais) ON DELETE CASCADE,
    CONSTRAINT FK_DISCIPLINA_cod_disciplina FOREIGN KEY(DISCIPLINA_cod_disciplina) REFERENCES DISCIPLINA(cod_disciplina) ON DELETE CASCADE
);

CREATE TABLE CATEGORIA
(
    cod_categoria integer NOT NULL,
    categoria varchar(50) NOT NULL,
    CONSTRAINT PK_CATEGORIA PRIMARY KEY (cod_categoria)
);

CREATE TABLE TIPO_PARTICIPACION
(
    cod_participacion integer NOT NULL,
    tipo_participacion varchar(100) NOT NULL,
    CONSTRAINT PK_TIPO_PARTICIPACION PRIMARY KEY (cod_participacion)
);

CREATE TABLE EVENTO
(
    cod_evento integer NOT NULL,
    fecha date NOT NULL,
    ubicacion varchar(50) NOT NULL,
    hora date NOT NULL,
    DISCIPLINA_cod_disciplina integer NOT NULL,
    TIPO_PARTICIPACION_cod_participacion integer NOT NULL,
    CATEGORIA_cod_categoria integer NOT NULL,
    
    CONSTRAINT PK_cod_evento PRIMARY KEY (cod_evento),
    CONSTRAINT FK_EVENTO_DISCIPLINA_cod_disciplina FOREIGN KEY(DISCIPLINA_cod_disciplina) REFERENCES DISCIPLINA(cod_disciplina) ON DELETE CASCADE,
    CONSTRAINT FK_TIPO_PARTICIPACION_cod_participacion FOREIGN KEY(TIPO_PARTICIPACION_cod_participacion) REFERENCES TIPO_PARTICIPACION(cod_participacion) ON DELETE CASCADE,
    CONSTRAINT FK_CATEGORIA_cod_categoria FOREIGN KEY(CATEGORIA_cod_categoria) REFERENCES CATEGORIA(cod_categoria) ON DELETE CASCADE    
);

CREATE TABLE EVENTO_ATLETA
(
    ATLETA_cod_atleta integer NOT NULL,
    EVENTO_cod_evento integer NOT NULL,
    CONSTRAINT PK_EVENTO_ATLETA PRIMARY KEY (ATLETA_cod_atleta, EVENTO_cod_evento),
    CONSTRAINT FK_ATLETA_cod_atleta FOREIGN KEY(ATLETA_cod_atleta) REFERENCES ATLETA(cod_atleta) ON DELETE CASCADE,
    CONSTRAINT FK_EVENTO_cod_evento FOREIGN KEY(EVENTO_cod_evento) REFERENCES EVENTO(cod_evento) ON DELETE CASCADE
);

CREATE TABLE TELEVISORA
(
    cod_televisora integer NOT NULL,
    nombre varchar(50) NOT NULL,
    CONSTRAINT PK_cod_televisora PRIMARY KEY (cod_televisora) 
);

CREATE TABLE COSTO_EVENTO
(
    EVENTO_cod_evento integer NOT NULL,
    TELEVISORA_cod_televisora integer NOT NULL,
    tarifa integer NOT NULL, 
    CONSTRAINT PK_COSTO_EVENTO PRIMARY KEY (EVENTO_cod_evento, TELEVISORA_cod_televisora),
    CONSTRAINT FK_COSTO_EVENTO_cod_evento FOREIGN KEY(EVENTO_cod_evento) REFERENCES EVENTO(cod_evento) ON DELETE CASCADE,
    CONSTRAINT FK_TELEVISORA_cod_televisora FOREIGN KEY(TELEVISORA_cod_televisora) REFERENCES TELEVISORA(cod_televisora) ON DELETE CASCADE
    
);

-- PLANTAMIENTO 2: 
-- INCISO A : ELIMINAR COLUMNAS
ALTER TABLE EVENTO DROP COLUMN fecha;

ALTER TABLE EVENTO DROP COLUMN hora;

-- INCISO B : AGREGAR COLUMNA

ALTER TABLE EVENTO ADD fecha_hora TIMESTAMP NOT NULL;

-- PLANTAMIENTO 3: check_date
alter table EVENTO
add constraint fecha_inicio check (fecha_hora >= to_date('2020-07-24 09:00:00', 'yyyy-mm-dd hh24:mi:ss'));

alter table EVENTO
add constraint fecha_fin check (fecha_hora <= to_date('2020-08-09 20:00:00', 'yyyy-mm-dd hh24:mi:ss'));

-- PLANTAMIENTO 4: 
-- INCISO A: Creacion tabla
CREATE TABLE SEDE
(
    codigo integer NOT NULL,
    sede varchar(50) NOT NULL,
    CONSTRAINT PK_codigo PRIMARY KEY(codigo)
);
-- INCISO B: MODIFICAR TIPO DE DATO
ALTER TABLE EVENTO ALTER COLUMN ubicacion TYPE INTEGER USING(ubicacion::integer);

-- INCISO C: CREACION LLAVE FORANEA
ALTER TABLE EVENTO 
ADD CONSTRAINT FK_EVENTO_UBICACION 
FOREIGN KEY(ubicacion)
REFERENCES SEDE(codigo) 
ON DELETE CASCADE;

--PLANTAMIENTO 5: DEFAULT 0
ALTER TABLE MIEMBRO ALTER COLUMN telefono SET DEFAULT 0;

--PLANTAMIENTO 6: INCERCION DE DATOS
INSERT INTO PAIS (cod_pais, nombre) 
VALUES  (1, 'Guatemala'),
		(2, 'Francia'),
		(3, 'Argentina'),
		(4, 'Alemania'),
		(5, 'Italia'),
		(6, 'Brasil'),
		(7, 'Estados Unidos');

INSERT INTO PROFESION (cod_prof, nombre) VALUES
(1, 'Médico'),(2, 'Arquitecto'),(3, 'Ingeniero'),(4, 'Secretaria'),(5, 'Auditor');

INSERT INTO MIEMBRO(cod_miembro, nombre, apellido, edad, residencia, PAIS_cod_pais, profesion_cod_prof) 
VALUES(1,'Scott', 'Mitchell', 32, '1092 Highland Drive Manitowoc, WI 54220', 7, 3),
	(3,'Laura', 'Cunha Silva', 55, 'Rua Onze, 86 Uberaba MG', 6, 5),
	(6,'Jeuel', 'Villalpando', 31, 'Acuña de Figeroa 6106 80101 Playa Pascual', 3, 5);

INSERT INTO MIEMBRO(cod_miembro, nombre, apellido, edad, telefono, residencia, PAIS_cod_pais, profesion_cod_prof) 
VALUES(2,'Fanette', 'Poulin', 25, 25075853, '49, boulevard Aristide Briand 76120 LE GRAND-QUEVILLY', 2, 4),
	(4,'Juan José', 'López', 38, 36985247, '26 calle 4-10 zona 11', 1, 2),
	(5,'Arcangela', 'Panicucci', 39, 391664921, 'Via Santa Teresa, 114 90010-Geraci Siculo PA', 5, 1);
	
INSERT INTO DISCIPLINA(cod_disciplina, nombre, descripcion)
VALUES(1, 'Atletismo', 'Saltos de longitud y triples, de altura y con pértiga o garrocha; las pruebas de lanzamiento de martillo, jabalina y disco.'),
		(4, 'Judo', 'Es un arte marcial que se originó en Japón alrededor de 1880'),
		(8, 'Natación', 'Está presente como deporte en los Juegos desde la primera edición de la era moderna, en Atenas, Grecia, en 1896, donde se disputo en aguas abiertas.');

INSERT INTO DISCIPLINA(cod_disciplina, nombre)
VALUES(2, 'Bádminton'),(3, 'Ciclismo'),(5, 'Lucha'),(6, 'Tenis de Mesa'),(7, 'Boxeo'),(9, 'Esgrima'),(10, 'Vela');

INSERT INTO TIPO_MEDALLA(cod_tipo, medalla)
VALUES(1, 'Oro'),(2, 'Plata'),(3, 'Bronce'),(4, 'Platino');

INSERT INTO CATEGORIA(cod_categoria, categoria)
VALUES(1, 'Clasificatorio'),(2, 'Eliminatorio'),(3, 'Final');
    
INSERT INTO TIPO_PARTICIPACION(cod_participacion,tipo_participacion)
VALUES(1, 'Individual'),(2, 'Eliminatorio'),(3, 'Equipos');

INSERT INTO MEDALLERO(PAIS_cod_pais, TIPO_MEDALLA_cod_tipo, cantidad_medallas)
VALUES(5,1,3),(2,1,5),(6,3,4),(4,4,3),(7,3,10),(3,2,8),(1,1,2),(1,4,5),(5,2,7);

INSERT INTO SEDE(codigo, sede)
VALUES(1,'Gimnasio Metropolitano de Tokio'),(2,'Jardín del Palacio Imperial de Tokio'),
    (3,'Gimnasio Nacional Yoyogi'),(4,'Nippon Budokan'),(5,'Estadio Olímpico');

INSERT INTO EVENTO(cod_evento,fecha_hora,ubicacion,disciplina_cod_disciplina,tipo_participacion_cod_participacion,categoria_cod_categoria)
VALUES(1, TO_TIMESTAMP('2020-07-24 11:00:00', 'yyyy-mm-dd hh24:mi:ss'),3,2,2,1),
    (2, TO_TIMESTAMP('2020-07-26 10:30:00', 'yyyy-mm-dd hh24:mi:ss'),1,6,1,3),
    (3, TO_TIMESTAMP('2020-07-30 18:45:00', 'yyyy-mm-dd hh24:mi:ss'),5,7,1,2),
    (4, TO_TIMESTAMP('2020-08-01 12:15:00', 'yyyy-mm-dd hh24:mi:ss'),2,1,1,1),
    (5, TO_TIMESTAMP('2020-08-08 19:35:00', 'yyyy-mm-dd hh24:mi:ss'),4,10,3,1);

--PLANTAMIENTO 7: ELIMINAR LLAVES UNICAS 
ALTER TABLE PAIS DROP CONSTRAINT U_PAIS_NOMBRE;

ALTER TABLE TIPO_MEDALLA DROP CONSTRAINT U_TIPO_MEDALLA_MEDALLA;

ALTER TABLE DEPARTAMENTO DROP CONSTRAINT U_DEPTO_NOMBRE;

--PLANTAMIENTO 8
-- INCISO A: ELIMINAR LLAVE FORANEA COD_DISCIPLINA
ALTER TABLE ATLETA DROP CONSTRAINT FK_DISCIPLINA_COD_DISCIPLINA;

-- INCISO B: CREAR TABLA
CREATE TABLE DISCIPLINA_ATLETA
(
    cod_atleta integer NOT NULL,
    cod_disciplina integer NOT NULL,
    CONSTRAINT PK_DISCIPLINA_ATLETA PRIMARY KEY (cod_atleta, cod_disciplina),
    CONSTRAINT FK_D_ATLETA_cod_atleta FOREIGN KEY(cod_atleta) REFERENCES ATLETA(cod_atleta) ON DELETE CASCADE,
    CONSTRAINT FK_A_DISCIPLINA_cod_disciplina FOREIGN KEY(cod_disciplina) REFERENCES DISCIPLINA(cod_disciplina) ON DELETE CASCADE
);

-- PLANTAMIENTO 9: DECIMAL CON 2 DE PRESICION
ALTER TABLE COSTO_EVENTO ALTER COLUMN tarifa TYPE NUMERIC(2,1);

--PLANTAMIENTO 10: ELIMINAR DATO
DELETE FROM TIPO_MEDALLA 
WHERE LOWER(medalla) = 'platino';

--PLANTAMIENTO 11: ELIMINAR TABLAS
DROP TABLE COSTO_EVENTO;

DROP TABLE TELEVISORA;

--PLANTAMIENTO 12: ELIMINAR DATOS
DELETE FROM DISCIPLINA;

-- PLANTAMIENTO 13: ACTUALIZAR DATO

UPDATE MIEMBRO SET telefono = 55464601 
WHERE LOWER(nombre) = 'laura' AND LOWER(apellido) = 'cunha silva';

UPDATE MIEMBRO SET telefono = 91514243 
WHERE LOWER(nombre) = 'jeuel' AND LOWER(apellido) = 'villalpando';

UPDATE MIEMBRO SET telefono = 920686670 
WHERE LOWER(nombre) = 'scott' AND LOWER(apellido) = 'mitchell';

--PLANTAMIENTO 14: AGREGAR IMAGEN
ALTER TABLE ATLETA ADD fotografia BYTEA;

--PLANTAMIENTO 15: CHECK EDAD
ALTER TABLE ATLETA
ADD CONSTRAINT check_edad check (edad < 25);












