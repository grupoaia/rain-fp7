--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.10
-- Dumped by pg_dump version 9.4.0
-- Started on 2017-04-25 16:28:05

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 7 (class 2615 OID 27560)
-- Name: alpine; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA alpine;


ALTER SCHEMA alpine OWNER TO postgres;

SET search_path = alpine, pg_catalog;

--
-- TOC entry 211 (class 1259 OID 27764)
-- Name: cases_id_seq; Type: SEQUENCE; Schema: alpine; Owner: postgres
--

CREATE SEQUENCE cases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cases_id_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 212 (class 1259 OID 27766)
-- Name: cases; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE cases (
    id integer DEFAULT nextval('cases_id_seq'::regclass) NOT NULL,
    id_grid integer NOT NULL,
    id_region_map integer NOT NULL,
    id_region_landslide integer NOT NULL
);


ALTER TABLE cases OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 27902)
-- Name: cases_ewe; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE cases_ewe (
    id_case integer NOT NULL,
    ewe character varying NOT NULL,
    variable_name character varying NOT NULL,
    value double precision
);


ALTER TABLE cases_ewe OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 27853)
-- Name: cases_towers_status; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE cases_towers_status (
    id_case integer NOT NULL,
    id_grid integer NOT NULL,
    id_tower integer NOT NULL,
    type_ character varying,
    id_type_tower integer,
    id_type_element integer
);


ALTER TABLE cases_towers_status OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 28148)
-- Name: elements_id_seq; Type: SEQUENCE; Schema: alpine; Owner: postgres
--

CREATE SEQUENCE elements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE elements_id_seq OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 28159)
-- Name: elements; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE elements (
    id integer DEFAULT nextval('elements_id_seq'::regclass) NOT NULL,
    name character varying
);


ALTER TABLE elements OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 28197)
-- Name: eng_measures_id_seq; Type: SEQUENCE; Schema: alpine; Owner: postgres
--

CREATE SEQUENCE eng_measures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE eng_measures_id_seq OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 28199)
-- Name: eng_measures; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE eng_measures (
    id integer DEFAULT nextval('eng_measures_id_seq'::regclass) NOT NULL,
    id_element integer,
    id_type_element integer,
    name character varying,
    improvement numeric,
    cost_improvement numeric,
    description character varying
);


ALTER TABLE eng_measures OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 27894)
-- Name: ewes; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE ewes (
    name character varying NOT NULL,
    variable_n integer NOT NULL,
    variable_names character varying,
    variable_min character varying,
    variable_max character varying,
    variable_units character varying
);


ALTER TABLE ewes OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 27920)
-- Name: foundations_id_seq; Type: SEQUENCE; Schema: alpine; Owner: postgres
--

CREATE SEQUENCE foundations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE foundations_id_seq OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 27591)
-- Name: grid_id_seq; Type: SEQUENCE; Schema: alpine; Owner: postgres
--

CREATE SEQUENCE grid_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE grid_id_seq OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 27593)
-- Name: grid; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE grid (
    id integer DEFAULT nextval('grid_id_seq'::regclass) NOT NULL,
    name character varying
);


ALTER TABLE grid OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 27633)
-- Name: grid_lines; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE grid_lines (
    id_grid integer NOT NULL,
    label character varying NOT NULL,
    group_ character varying,
    from_ character varying,
    to_ character varying
);


ALTER TABLE grid_lines OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 27995)
-- Name: grid_stations_id_seq; Type: SEQUENCE; Schema: alpine; Owner: postgres
--

CREATE SEQUENCE grid_stations_id_seq
    START WITH 690
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE grid_stations_id_seq OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 27602)
-- Name: grid_stations; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE grid_stations (
    id_grid integer NOT NULL,
    name character varying NOT NULL,
    name_extra character varying,
    group_ character varying,
    x double precision,
    y double precision,
    color_background character varying,
    color_border character varying,
    id integer DEFAULT nextval('grid_stations_id_seq'::regclass) NOT NULL,
    image character varying
);


ALTER TABLE grid_stations OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 28068)
-- Name: grid_stations_status; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE grid_stations_status (
    id_grid integer NOT NULL,
    id_station integer NOT NULL,
    type_ character varying,
    id_type_element integer
);


ALTER TABLE grid_stations_status OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 28048)
-- Name: grid_stations_susc; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE grid_stations_susc (
    id_grid integer NOT NULL,
    id_station integer NOT NULL,
    id_map integer NOT NULL,
    susc double precision
);


ALTER TABLE grid_stations_susc OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 27656)
-- Name: grid_towers_id_seq; Type: SEQUENCE; Schema: alpine; Owner: postgres
--

CREATE SEQUENCE grid_towers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE grid_towers_id_seq OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 27658)
-- Name: grid_towers; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE grid_towers (
    id_grid integer NOT NULL,
    id integer DEFAULT nextval('grid_towers_id_seq'::regclass) NOT NULL,
    label_line character varying,
    group_ character varying,
    x double precision,
    y double precision,
    height double precision,
    slope double precision,
    land_type character varying,
    id_osm character varying
);


ALTER TABLE grid_towers OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 27876)
-- Name: grid_towers_status; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE grid_towers_status (
    id_grid integer NOT NULL,
    id_tower integer NOT NULL,
    type_ character varying,
    id_type_element integer
);


ALTER TABLE grid_towers_status OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 27810)
-- Name: grid_towers_susc; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE grid_towers_susc (
    id_grid integer NOT NULL,
    id_tower integer NOT NULL,
    id_map integer NOT NULL,
    susc double precision
);


ALTER TABLE grid_towers_susc OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 28225)
-- Name: land_transportation_id_seq; Type: SEQUENCE; Schema: alpine; Owner: postgres
--

CREATE SEQUENCE land_transportation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE land_transportation_id_seq OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 28227)
-- Name: land_transportation; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE land_transportation (
    id integer DEFAULT nextval('land_transportation_id_seq'::regclass) NOT NULL,
    name character varying
);


ALTER TABLE land_transportation OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 27572)
-- Name: region_landslide_id_seq; Type: SEQUENCE; Schema: alpine; Owner: postgres
--

CREATE SEQUENCE region_landslide_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE region_landslide_id_seq OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 27569)
-- Name: region_landslide; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE region_landslide (
    id integer DEFAULT nextval('region_landslide_id_seq'::regclass) NOT NULL,
    name character varying,
    filename character varying
);


ALTER TABLE region_landslide OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 27580)
-- Name: region_map_id_seq; Type: SEQUENCE; Schema: alpine; Owner: postgres
--

CREATE SEQUENCE region_map_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE region_map_id_seq OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 27582)
-- Name: region_map; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE region_map (
    id integer DEFAULT nextval('region_map_id_seq'::regclass) NOT NULL,
    name character varying
);


ALTER TABLE region_map OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 28093)
-- Name: station_types_id_seq; Type: SEQUENCE; Schema: alpine; Owner: postgres
--

CREATE SEQUENCE station_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE station_types_id_seq OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 28236)
-- Name: trans_elements_id_seq; Type: SEQUENCE; Schema: alpine; Owner: postgres
--

CREATE SEQUENCE trans_elements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE trans_elements_id_seq OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 28238)
-- Name: trans_elements; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE trans_elements (
    id_land_transportation integer NOT NULL,
    id integer DEFAULT nextval('trans_elements_id_seq'::regclass) NOT NULL,
    name character varying,
    way_name character varying,
    basic_element_type character varying,
    means_transportation character varying,
    segment_name character varying
);


ALTER TABLE trans_elements OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 28283)
-- Name: trans_elements_status; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE trans_elements_status (
    id_land_transportation integer NOT NULL,
    id_trans_elements integer NOT NULL,
    type_ character varying,
    id_type_element integer
);


ALTER TABLE trans_elements_status OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 28306)
-- Name: trans_elements_susc; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE trans_elements_susc (
    id_land_transportation integer NOT NULL,
    id_trans_elements integer NOT NULL,
    id_map integer NOT NULL,
    susc double precision
);


ALTER TABLE trans_elements_susc OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 28146)
-- Name: type_element_id_seq; Type: SEQUENCE; Schema: alpine; Owner: postgres
--

CREATE SEQUENCE type_element_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE type_element_id_seq OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 28168)
-- Name: type_element; Type: TABLE; Schema: alpine; Owner: postgres; Tablespace: 
--

CREATE TABLE type_element (
    id integer DEFAULT nextval('type_element_id_seq'::regclass) NOT NULL,
    id_element integer,
    name character varying,
    prob_failure numeric,
    cost_rep numeric
);


ALTER TABLE type_element OWNER TO postgres;

--
-- TOC entry 2241 (class 0 OID 27766)
-- Dependencies: 212
-- Data for Name: cases; Type: TABLE DATA; Schema: alpine; Owner: postgres
--



--
-- TOC entry 2246 (class 0 OID 27902)
-- Dependencies: 217
-- Data for Name: cases_ewe; Type: TABLE DATA; Schema: alpine; Owner: postgres
--



--
-- TOC entry 2268 (class 0 OID 0)
-- Dependencies: 211
-- Name: cases_id_seq; Type: SEQUENCE SET; Schema: alpine; Owner: postgres
--

SELECT pg_catalog.setval('cases_id_seq', 1, false);


--
-- TOC entry 2243 (class 0 OID 27853)
-- Dependencies: 214
-- Data for Name: cases_towers_status; Type: TABLE DATA; Schema: alpine; Owner: postgres
--



--
-- TOC entry 2254 (class 0 OID 28159)
-- Dependencies: 225
-- Data for Name: elements; Type: TABLE DATA; Schema: alpine; Owner: postgres
--

INSERT INTO elements VALUES (1, 'Station');
INSERT INTO elements VALUES (2, 'Tower');
INSERT INTO elements VALUES (3, 'Road bridge');
INSERT INTO elements VALUES (4, 'Road tunnel');
INSERT INTO elements VALUES (5, 'Railway bridge');
INSERT INTO elements VALUES (6, 'Railway tunnel');


--
-- TOC entry 2269 (class 0 OID 0)
-- Dependencies: 224
-- Name: elements_id_seq; Type: SEQUENCE SET; Schema: alpine; Owner: postgres
--

SELECT pg_catalog.setval('elements_id_seq', 6, true);


--
-- TOC entry 2257 (class 0 OID 28199)
-- Dependencies: 228
-- Data for Name: eng_measures; Type: TABLE DATA; Schema: alpine; Owner: postgres
--

INSERT INTO eng_measures VALUES (3, 2, 0, 'Measure YY', 75, 25000, 'Tecnique YY applied to all kind of towers');
INSERT INTO eng_measures VALUES (2, 2, 3, 'Measure XX', 50, 9000, 'Tecnique XX applied to poles improves their foundations');
INSERT INTO eng_measures VALUES (1, 1, 0, 'Test Measure Station', 80, 100000, 'Superinvestment in any kind of station.');


--
-- TOC entry 2270 (class 0 OID 0)
-- Dependencies: 227
-- Name: eng_measures_id_seq; Type: SEQUENCE SET; Schema: alpine; Owner: postgres
--

SELECT pg_catalog.setval('eng_measures_id_seq', 3, true);


--
-- TOC entry 2245 (class 0 OID 27894)
-- Dependencies: 216
-- Data for Name: ewes; Type: TABLE DATA; Schema: alpine; Owner: postgres
--

INSERT INTO ewes VALUES ('Precipitation', 2, 'intensity, cumulative', '0, 0', '60, 700', 'mm/h, mm');


--
-- TOC entry 2271 (class 0 OID 0)
-- Dependencies: 218
-- Name: foundations_id_seq; Type: SEQUENCE SET; Schema: alpine; Owner: postgres
--

SELECT pg_catalog.setval('foundations_id_seq', 1, true);


--
-- TOC entry 2235 (class 0 OID 27593)
-- Dependencies: 206
-- Data for Name: grid; Type: TABLE DATA; Schema: alpine; Owner: postgres
--

INSERT INTO grid VALUES (1, 'Alpine Case');


--
-- TOC entry 2272 (class 0 OID 0)
-- Dependencies: 205
-- Name: grid_id_seq; Type: SEQUENCE SET; Schema: alpine; Owner: postgres
--

SELECT pg_catalog.setval('grid_id_seq', 1, true);


--
-- TOC entry 2237 (class 0 OID 27633)
-- Dependencies: 208
-- Data for Name: grid_lines; Type: TABLE DATA; Schema: alpine; Owner: postgres
--

INSERT INTO grid_lines VALUES (1, 'Hh1', '132k', 'SIHa', 'S9');
INSERT INTO grid_lines VALUES (1, 'Hh2', '132k', 'S9', 'SIHb');
INSERT INTO grid_lines VALUES (1, 'h1', '60k', 'SIhh', 'S1');
INSERT INTO grid_lines VALUES (1, 'h2', '60k', 'SIhh', 'S1');
INSERT INTO grid_lines VALUES (1, 'h3', '60k', 'S1', 'S2');
INSERT INTO grid_lines VALUES (1, 'h4', '60k', 'S1', 'S2');
INSERT INTO grid_lines VALUES (1, 'h5', '60k', 'S2', 'S3');
INSERT INTO grid_lines VALUES (1, 'h6', '60k', 'S2', 'S3');
INSERT INTO grid_lines VALUES (1, 'h7', '60k', 'S3', 'S4');
INSERT INTO grid_lines VALUES (1, 'h8', '60k', 'S3', 'S4');
INSERT INTO grid_lines VALUES (1, 'h9', '60k', 'S4', 'S5');
INSERT INTO grid_lines VALUES (1, 'h10', '60k', 'S4', 'S5');
INSERT INTO grid_lines VALUES (1, 'h11', '60k', 'S5', 'S6');
INSERT INTO grid_lines VALUES (1, 'h12', '60k', 'S5', 'S6');
INSERT INTO grid_lines VALUES (1, 'h13', '60k', 'S6', 'S7');
INSERT INTO grid_lines VALUES (1, 'h14', '60k', 'S6', 'S7');
INSERT INTO grid_lines VALUES (1, 'h15', '60k', 'S7', 'S8');
INSERT INTO grid_lines VALUES (1, 'h16', '60k', 'S7', 'S8');
INSERT INTO grid_lines VALUES (1, 'h17', '60k', 'S8', 'S9');
INSERT INTO grid_lines VALUES (1, 'h18', '60k', 'S8', 'S9');
INSERT INTO grid_lines VALUES (1, 'm1', 'minor', 'Sem1', 'S1');
INSERT INTO grid_lines VALUES (1, 'm2', 'minor', 'S1', 'S01');
INSERT INTO grid_lines VALUES (1, 'm3', 'minor', 'S01', 'S2');
INSERT INTO grid_lines VALUES (1, 'm4', 'minor', 'S2', 'Sem4');
INSERT INTO grid_lines VALUES (1, 'm5', 'minor', 'S3', 'S02');
INSERT INTO grid_lines VALUES (1, 'm6', 'minor', 'S02', 'S03');
INSERT INTO grid_lines VALUES (1, 'm7', 'minor', 'S03', 'Sem7');
INSERT INTO grid_lines VALUES (1, 'm8', 'minor', 'S03', 'Sem8');
INSERT INTO grid_lines VALUES (1, 'm9', 'minor', 'S02', 'Sem9');
INSERT INTO grid_lines VALUES (1, 'm10', 'minor', 'S4', 'S04');
INSERT INTO grid_lines VALUES (1, 'm11', 'minor', 'S04', 'S5');
INSERT INTO grid_lines VALUES (1, 'm12', 'minor', 'S5', 'S6');
INSERT INTO grid_lines VALUES (1, 'm13', 'minor', 'S6', 'S05');
INSERT INTO grid_lines VALUES (1, 'm14', 'minor', 'S05', 'Sem14');
INSERT INTO grid_lines VALUES (1, 'm15', 'minor', 'S05', 'S06');
INSERT INTO grid_lines VALUES (1, 'm16', 'minor', 'S06', 'Sem16');
INSERT INTO grid_lines VALUES (1, 'm17', 'minor', 'S06', 'S7');
INSERT INTO grid_lines VALUES (1, 'm18', 'minor', 'S7', 'S8');
INSERT INTO grid_lines VALUES (1, 'm19', 'minor', 'S8', 'S07');
INSERT INTO grid_lines VALUES (1, 'm20', 'minor', 'S07', 'S08');
INSERT INTO grid_lines VALUES (1, 'm21', 'minor', 'S08', 'Sem21');
INSERT INTO grid_lines VALUES (1, 'm22', 'minor', 'S08', 'S09');
INSERT INTO grid_lines VALUES (1, 'm23', 'minor', 'S09', 'Sem23');
INSERT INTO grid_lines VALUES (1, 'm24', 'minor', 'S09', 'Sem24');
INSERT INTO grid_lines VALUES (1, 'm25', 'minor', 'S9', 'Sem25');
INSERT INTO grid_lines VALUES (1, 'm26', 'minor', 'S9', 'Sem26');
INSERT INTO grid_lines VALUES (1, 'm27', 'minor', 'S9', 'Sem27');


--
-- TOC entry 2236 (class 0 OID 27602)
-- Dependencies: 207
-- Data for Name: grid_stations; Type: TABLE DATA; Schema: alpine; Owner: postgres
--

INSERT INTO grid_stations VALUES (1, 'Sem24', 'Sem24', 'Only minor', 13.4870184969185, 46.500771895628198, 'cornflowerblue', 'blue', 24, 'distributiontransformer2.jpg');
INSERT INTO grid_stations VALUES (1, 'Sem25', 'Sem25', 'Only minor', 13.492017880698601, 46.489123171629402, 'cornflowerblue', 'blue', 25, 'distributiontransformer.jpg');
INSERT INTO grid_stations VALUES (1, 'Sem26', 'Sem26', 'Only minor', 13.541704064112601, 46.507071756475199, 'cornflowerblue', 'blue', 26, 'distributiontransformer3.jpg');
INSERT INTO grid_stations VALUES (1, 'S4', 'S4hhm', '60k Minor', 13.3224714711579, 46.508064315032797, 'chocolate', 'red', 13, 'substation.jpg');
INSERT INTO grid_stations VALUES (1, 'Sem8', 'Sem8', 'Only minor', 13.2733525255189, 46.520886541840603, 'cornflowerblue', 'blue', 30, 'distributiontransformer.jpg');
INSERT INTO grid_stations VALUES (1, 'SIhh', 'SIhh', '60k', 13.295984351323201, 46.459950707757201, 'chocolate', 'black', 34, 'substation2.jpg');
INSERT INTO grid_stations VALUES (1, 'SIHb', 'SIHb', '132k', 13.5280903575115, 46.5050601155449, 'gray', 'black', 33, 'substation.jpg');
INSERT INTO grid_stations VALUES (1, 'Sem27', 'Sem27', 'Only minor', 13.532628259711901, 46.505854193226099, 'cornflowerblue', 'blue', 27, 'distributiontransformer2.jpg');
INSERT INTO grid_stations VALUES (1, 'S3', 'S3hhm', '60k Minor', 13.3027815904241, 46.508487801167902, 'chocolate', 'red', 12, 'substation2.jpg');
INSERT INTO grid_stations VALUES (1, 'Sem4', 'Sem4', 'Only minor', 13.3006568523176, 46.496853966959101, 'cornflowerblue', 'blue', 28, 'distributiontransformer2.jpg');
INSERT INTO grid_stations VALUES (1, 'S07', 'S07mm', 'Only minor', 13.440793425352201, 46.5045174891249, 'cornflowerblue', 'blue', 7, 'substation.jpg');
INSERT INTO grid_stations VALUES (1, 'SIHa', 'SIHa', '132k', 13.293580801428901, 46.4600301819154, 'gray', 'black', 32, 'substation4.jpg');
INSERT INTO grid_stations VALUES (1, 'S9', 'S9Hhhmmm', '132k 60k Minor', 13.5006802745174, 46.500176282777304, 'chocolate', 'red', 18, 'substation4.jpg');
INSERT INTO grid_stations VALUES (1, 'S01', 'S01mm', 'Only minor', 13.2948787183718, 46.471870535153698, 'cornflowerblue', 'blue', 1, 'distributiontransformer.jpg');
INSERT INTO grid_stations VALUES (1, 'S02', 'S02mmm', 'Only minor', 13.297330339264001, 46.515183737115898, 'cornflowerblue', 'blue', 2, 'distributiontransformer2.jpg');
INSERT INTO grid_stations VALUES (1, 'S03', 'S03mmm', 'Only minor', 13.2896774364007, 46.516229075587901, 'cornflowerblue', 'blue', 3, 'distributiontransformer3.jpg');
INSERT INTO grid_stations VALUES (1, 'S04', 'S04mm', 'Only minor', 13.352554301634401, 46.506727665278, 'cornflowerblue', 'blue', 4, 'distributiontransformer.jpg');
INSERT INTO grid_stations VALUES (1, 'S05', 'S05mm', 'Only minor', 13.4009714107042, 46.499924799836798, 'cornflowerblue', 'blue', 5, 'distributiontransformer3.jpg');
INSERT INTO grid_stations VALUES (1, 'S08', 'S08mmm', 'Only minor', 13.44925392098, 46.505099819704498, 'cornflowerblue', 'blue', 8, 'distributiontransformer.jpg');
INSERT INTO grid_stations VALUES (1, 'S09', 'S09mmm', 'Only minor', 13.4783657172992, 46.508567204450898, 'cornflowerblue', 'blue', 9, 'distributiontransformer.jpg');
INSERT INTO grid_stations VALUES (1, 'Sem9', 'Sem9', 'Only minor', 13.3020412970567, 46.529141978162798, 'cornflowerblue', 'blue', 31, 'distributiontransformer2.jpg');
INSERT INTO grid_stations VALUES (1, 'S06', 'S06mmm', 'Only minor', 13.412046968616901, 46.500096867237602, 'cornflowerblue', 'blue', 6, 'distributiontransformer2.jpg');
INSERT INTO grid_stations VALUES (1, 'S1', 'S1hhmm', '60k Minor', 13.294224952800599, 46.4619905077626, 'chocolate', 'red', 10, 'distributiontransformer3.jpg');
INSERT INTO grid_stations VALUES (1, 'S2', 'S2hhm', '60k Minor', 13.3007049233155, 46.483284633895501, 'chocolate', 'red', 11, 'distributiontransformer3.jpg');
INSERT INTO grid_stations VALUES (1, 'Sem7', 'Sem7', 'Only minor', 13.269122277705, 46.507177630251498, 'cornflowerblue', 'blue', 29, 'distributiontransformer3.jpg');
INSERT INTO grid_stations VALUES (1, 'S5', 'S5hhmm', '60k Minor', 13.3703117282531, 46.501817511295698, 'chocolate', 'red', 14, 'distributiontransformer2.jpg');
INSERT INTO grid_stations VALUES (1, 'S6', 'S6hhmm', '60k Minor', 13.392616671271799, 46.499223288644501, 'chocolate', 'red', 15, 'distributiontransformer2.jpg');
INSERT INTO grid_stations VALUES (1, 'S7', 'S7hhmm', '60k Minor', 13.4189980349111, 46.499276233201201, 'chocolate', 'red', 16, 'distributiontransformer3.jpg');
INSERT INTO grid_stations VALUES (1, 'Sem1', 'Sem1', 'Only minor', 13.2985032716124, 46.458771827455003, 'cornflowerblue', 'blue', 19, 'distributiontransformer.jpg');
INSERT INTO grid_stations VALUES (1, 'Sem14', 'Sem14', 'Only minor', 13.3967988480878, 46.504848359537597, 'cornflowerblue', 'blue', 20, 'distributiontransformer.jpg');
INSERT INTO grid_stations VALUES (1, 'S8', 'S8hhmm', '60k Minor', 13.4295351976475, 46.502293987714999, 'chocolate', 'red', 17, 'distributiontransformer.jpg');
INSERT INTO grid_stations VALUES (1, 'Sem16', 'Sem16', 'Only minor', 13.420411322248899, 46.5050601155449, 'cornflowerblue', 'blue', 21, 'distributiontransformer3.jpg');
INSERT INTO grid_stations VALUES (1, 'Sem21', 'Sem21', 'Only minor', 13.4526381192311, 46.506489447019398, 'cornflowerblue', 'blue', 22, 'distributiontransformer.jpg');
INSERT INTO grid_stations VALUES (1, 'Sem23', 'Sem23', 'Only minor', 13.470097505663, 46.534909455173299, 'cornflowerblue', 'blue', 23, 'distributiontransformer2.jpg');


--
-- TOC entry 2273 (class 0 OID 0)
-- Dependencies: 219
-- Name: grid_stations_id_seq; Type: SEQUENCE SET; Schema: alpine; Owner: postgres
--

SELECT pg_catalog.setval('grid_stations_id_seq', 690, false);


--
-- TOC entry 2250 (class 0 OID 28068)
-- Dependencies: 221
-- Data for Name: grid_stations_status; Type: TABLE DATA; Schema: alpine; Owner: postgres
--

INSERT INTO grid_stations_status VALUES (1, 30, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 31, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 32, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 33, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 34, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 3, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 4, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 5, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 6, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 7, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 8, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 9, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 10, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 11, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 12, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 13, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 14, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 15, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 16, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 17, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 18, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 19, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 20, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 21, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 22, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 23, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 24, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 25, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 26, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 27, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 28, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 29, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 1, 'station', 1);
INSERT INTO grid_stations_status VALUES (1, 2, 'station', 1);


--
-- TOC entry 2249 (class 0 OID 28048)
-- Dependencies: 220
-- Data for Name: grid_stations_susc; Type: TABLE DATA; Schema: alpine; Owner: postgres
--

INSERT INTO grid_stations_susc VALUES (1, 1, 1, 5);
INSERT INTO grid_stations_susc VALUES (1, 2, 1, 5);
INSERT INTO grid_stations_susc VALUES (1, 3, 1, 0);
INSERT INTO grid_stations_susc VALUES (1, 4, 1, 1);
INSERT INTO grid_stations_susc VALUES (1, 5, 1, 1);
INSERT INTO grid_stations_susc VALUES (1, 6, 1, 1);
INSERT INTO grid_stations_susc VALUES (1, 7, 1, 1);
INSERT INTO grid_stations_susc VALUES (1, 8, 1, 3);
INSERT INTO grid_stations_susc VALUES (1, 9, 1, 1);
INSERT INTO grid_stations_susc VALUES (1, 10, 1, 5);
INSERT INTO grid_stations_susc VALUES (1, 11, 1, 3);
INSERT INTO grid_stations_susc VALUES (1, 12, 1, 2);
INSERT INTO grid_stations_susc VALUES (1, 13, 1, 3);
INSERT INTO grid_stations_susc VALUES (1, 14, 1, 2);
INSERT INTO grid_stations_susc VALUES (1, 15, 1, 1);
INSERT INTO grid_stations_susc VALUES (1, 16, 1, 1);
INSERT INTO grid_stations_susc VALUES (1, 17, 1, 4);
INSERT INTO grid_stations_susc VALUES (1, 18, 1, 1);
INSERT INTO grid_stations_susc VALUES (1, 19, 1, 3);
INSERT INTO grid_stations_susc VALUES (1, 20, 1, 5);
INSERT INTO grid_stations_susc VALUES (1, 21, 1, 1);
INSERT INTO grid_stations_susc VALUES (1, 28, 1, 1);
INSERT INTO grid_stations_susc VALUES (1, 33, 1, 3);
INSERT INTO grid_stations_susc VALUES (1, 34, 1, 4);
INSERT INTO grid_stations_susc VALUES (1, 32, 1, 3);
INSERT INTO grid_stations_susc VALUES (1, 22, 1, 2);
INSERT INTO grid_stations_susc VALUES (1, 23, 1, 1);
INSERT INTO grid_stations_susc VALUES (1, 24, 1, 1);
INSERT INTO grid_stations_susc VALUES (1, 25, 1, 1);
INSERT INTO grid_stations_susc VALUES (1, 26, 1, 0);
INSERT INTO grid_stations_susc VALUES (1, 27, 1, 1);
INSERT INTO grid_stations_susc VALUES (1, 29, 1, 0);
INSERT INTO grid_stations_susc VALUES (1, 30, 1, 3);
INSERT INTO grid_stations_susc VALUES (1, 31, 1, 3);


--
-- TOC entry 2239 (class 0 OID 27658)
-- Dependencies: 210
-- Data for Name: grid_towers; Type: TABLE DATA; Schema: alpine; Owner: postgres
--

INSERT INTO grid_towers VALUES (1, 2, 'Hh1', '132k', 13.292555999999999, 46.465553999999997, 567, 23.236049999999999, 'wood', 'n748572218');
INSERT INTO grid_towers VALUES (1, 4, 'Hh1', '132k', 13.293647, 46.460062000000001, 595, 21.212399999999999, 'wood', 'n748572343');
INSERT INTO grid_towers VALUES (1, 5, 'Hh1', '132k', 13.291779999999999, 46.469422999999999, 567, 23.495249999999999, 'wood', 'n748572348');
INSERT INTO grid_towers VALUES (1, 6, 'Hh1', '132k', 13.296738, 46.486173000000001, 722, 25.131550000000001, 'wood', 'n748774057');
INSERT INTO grid_towers VALUES (1, 7, 'Hh1', '132k', 13.295258, 46.481420999999997, 685, 20.921060000000001, 'wood', 'n748774059');
INSERT INTO grid_towers VALUES (1, 8, 'Hh1', '132k', 13.308973, 46.511668, 673, 21.34995, 'wood', 'n748774060');
INSERT INTO grid_towers VALUES (1, 9, 'Hh1', '132k', 13.297469, 46.508088000000001, 799, 17.658359999999998, 'wood', 'n748774069');
INSERT INTO grid_towers VALUES (1, 10, 'Hh1', '132k', 13.297008, 46.487434999999998, 680, 27.096450000000001, 'wood', 'n748774070');
INSERT INTO grid_towers VALUES (1, 12, 'Hh1', '132k', 13.297032, 46.499462999999999, 633, 16.199629999999999, 'wood', 'n748774094');
INSERT INTO grid_towers VALUES (1, 13, 'Hh1', '132k', 13.294693000000001, 46.479762000000001, 610, 20.211780000000001, 'wood', 'n748774101');
INSERT INTO grid_towers VALUES (1, 14, 'Hh1', '132k', 13.300939, 46.51097, 617, 6.1405799999999999, 'forest', 'n748774103');
INSERT INTO grid_towers VALUES (1, 15, 'Hh1', '132k', 13.296260999999999, 46.507038999999999, 799, 17.658359999999998, 'wood', 'n748774109');
INSERT INTO grid_towers VALUES (1, 16, 'Hh1', '132k', 13.296298, 46.501489999999997, 687, 19.9785, 'wood', 'n748774111');
INSERT INTO grid_towers VALUES (1, 17, 'Hh1', '132k', 13.294072, 46.478090000000002, 539, 13.246409999999999, 'wood', 'n748774114');
INSERT INTO grid_towers VALUES (1, 18, 'Hh1', '132k', 13.294689, 46.505775999999997, 854, 14.34107, 'wood', 'n748774118');
INSERT INTO grid_towers VALUES (1, 20, 'Hh1', '132k', 13.296034000000001, 46.483316000000002, 664, 23.560279999999999, 'wood', 'n748774133');
INSERT INTO grid_towers VALUES (1, 21, 'Hh1', '132k', 13.474468, 46.497962999999999, 947, 7.49261, 'forest', 'n748784391');
INSERT INTO grid_towers VALUES (1, 22, 'Hh1', '132k', 13.465835999999999, 46.498508999999999, 941, 4.8729699999999996, 'forest', 'n748784394');
INSERT INTO grid_towers VALUES (1, 23, 'Hh1', '132k', 13.47049, 46.498333000000002, 967, 4.04216, 'forest', 'n748784440');
INSERT INTO grid_towers VALUES (1, 24, 'Hh1', '132k', 13.453585, 46.501770999999998, 832, 15.37866, 'forest', 'n748784460');
INSERT INTO grid_towers VALUES (1, 25, 'Hh1', '132k', 13.457421, 46.500514000000003, 850, 7.0600800000000001, 'forest', 'n748784492');
INSERT INTO grid_towers VALUES (1, 26, 'Hh1', '132k', 13.463127999999999, 46.498677999999998, 925, 6.4982100000000003, 'forest', 'n748784514');
INSERT INTO grid_towers VALUES (1, 28, 'Hh2', '132k', 13.521039999999999, 46.503743999999998, 912, 21.312840000000001, 'forest', 'n748817442');
INSERT INTO grid_towers VALUES (1, 29, 'Hh2', '132k', 13.524362999999999, 46.504539999999999, 835, 13.284800000000001, 'forest', 'n748817444');
INSERT INTO grid_towers VALUES (1, 30, 'Hh1', '132k', 13.502238999999999, 46.499505999999997, 817, 8.0339299999999998, 'NA', 'n748817451');
INSERT INTO grid_towers VALUES (1, 31, 'Hh2', '132k', 13.513356, 46.502003000000002, 824, 17.046749999999999, 'forest', 'n748817458');
INSERT INTO grid_towers VALUES (1, 32, 'Hh1', '132k', 13.500662999999999, 46.500331000000003, 785, 2.8679399999999999, 'NA', 'n748817465');
INSERT INTO grid_towers VALUES (1, 33, 'Hh2', '132k', 13.527473000000001, 46.505239000000003, 860, 19.230879999999999, 'forest', 'n748817466');
INSERT INTO grid_towers VALUES (1, 34, 'Hh2', '132k', 13.505692, 46.500298000000001, 818, 6.6100000000000003, 'NA', 'n748817473');
INSERT INTO grid_towers VALUES (1, 35, 'Hh2', '132k', 13.516494, 46.502726000000003, 856, 22.584409999999998, 'forest', 'n748817480');
INSERT INTO grid_towers VALUES (1, 36, 'Hh2', '132k', 13.508834, 46.500996999999998, 844, 11.995939999999999, 'NA', 'n748817482');
INSERT INTO grid_towers VALUES (1, 38, 'Hh1', '132k', 13.373023, 46.498832, 683, 19.847529999999999, 'scrub', 'n776113951');
INSERT INTO grid_towers VALUES (1, 39, 'Hh1', '132k', 13.379773, 46.497542000000003, 709, 17.744620000000001, 'grassland', 'n776113975');
INSERT INTO grid_towers VALUES (1, 40, 'Hh1', '132k', 13.316378, 46.512211000000001, 613, 18.23779, 'scrub', 'n776113983');
INSERT INTO grid_towers VALUES (1, 41, 'Hh1', '132k', 13.421685, 46.497940999999997, 791, 17.229240000000001, 'grassland', 'n776114114');
INSERT INTO grid_towers VALUES (1, 42, 'Hh1', '132k', 13.330996000000001, 46.508868, 610, 14.557729999999999, 'wood', 'n776114136');
INSERT INTO grid_towers VALUES (1, 43, 'Hh1', '132k', 13.428623, 46.499614000000001, 886, 13.71428, 'grassland', 'n776114156');
INSERT INTO grid_towers VALUES (1, 44, 'Hh1', '132k', 13.336921999999999, 46.508175000000001, 662, 11.830450000000001, 'wood', 'n776114268');
INSERT INTO grid_towers VALUES (1, 46, 'Hh1', '132k', 13.447988, 46.502225000000003, 818, 19.772570000000002, 'forest', 'n776114328');
INSERT INTO grid_towers VALUES (1, 47, 'Hh1', '132k', 13.298804000000001, 46.495134, 592, 9.5720700000000001, 'NA', 'n776114396');
INSERT INTO grid_towers VALUES (1, 48, 'Hh1', '132k', 13.361295999999999, 46.502077999999997, 703, 9.8797800000000002, 'scrub', 'n776114422');
INSERT INTO grid_towers VALUES (1, 49, 'Hh1', '132k', 13.39479, 46.497093, 754, 15.913410000000001, 'wood', 'n776114459');
INSERT INTO grid_towers VALUES (1, 50, 'Hh1', '132k', 13.405690999999999, 46.497214, 797, 15.37398, 'wood', 'n776114517');
INSERT INTO grid_towers VALUES (1, 51, 'Hh1', '132k', 13.414016999999999, 46.497064999999999, 756, 12.695959999999999, 'wood', 'n776114538');
INSERT INTO grid_towers VALUES (1, 52, 'Hh1', '132k', 13.343527999999999, 46.507398000000002, 685, 18.835719999999998, 'wood', 'n776114564');
INSERT INTO grid_towers VALUES (1, 53, 'Hh1', '132k', 13.424303999999999, 46.498663000000001, 846, 17.2257, 'grassland', 'n776114587');
INSERT INTO grid_towers VALUES (1, 55, 'Hh1', '132k', 13.370476, 46.499527, 726, 24.171189999999999, 'meadow', 'n776114665');
INSERT INTO grid_towers VALUES (1, 56, 'Hh1', '132k', 13.374025, 46.498562, 683, 19.847529999999999, 'scrub', 'n776114690');
INSERT INTO grid_towers VALUES (1, 57, 'Hh1', '132k', 13.383267999999999, 46.497214999999997, 750, 20.317019999999999, 'wood', 'n776114705');
INSERT INTO grid_towers VALUES (1, 58, 'Hh1', '132k', 13.321914, 46.510944000000002, 598, 8.8207599999999999, 'meadow', 'n776114727');
INSERT INTO grid_towers VALUES (1, 59, 'Hh1', '132k', 13.397608, 46.496713999999997, 770, 16.352309999999999, 'wood', 'n776114750');
INSERT INTO grid_towers VALUES (1, 60, 'Hh1', '132k', 13.332357, 46.508709000000003, 621, 15.61321, 'wood', 'n776114781');
INSERT INTO grid_towers VALUES (1, 61, 'Hh1', '132k', 13.432821000000001, 46.500183999999997, 771, 14.98929, 'forest', 'n776114791');
INSERT INTO grid_towers VALUES (1, 62, 'Hh1', '132k', 13.338867, 46.507947000000001, 687, 12.78851, 'wood', 'n776114816');
INSERT INTO grid_towers VALUES (1, 64, 'Hh1', '132k', 13.347239, 46.506287999999998, 637, 13.57024, 'NA', 'n776114863');
INSERT INTO grid_towers VALUES (1, 65, 'Hh1', '132k', 13.298071, 46.497011000000001, 587, 9.69224, 'NA', 'n776114892');
INSERT INTO grid_towers VALUES (1, 66, 'Hh1', '132k', 13.363845, 46.501325999999999, 714, 14.708729999999999, 'scrub', 'n776114895');
INSERT INTO grid_towers VALUES (1, 67, 'Hh1', '132k', 13.371861000000001, 46.499149000000003, 703, 22.63374, 'meadow', 'n776114898');
INSERT INTO grid_towers VALUES (1, 68, 'Hh1', '132k', 13.409338999999999, 46.497436, 777, 14.560320000000001, 'wood', 'n776114901');
INSERT INTO grid_towers VALUES (1, 69, 'Hh1', '132k', 13.313343, 46.511974000000002, 621, 18.748740000000002, 'scrub', 'n776114904');
INSERT INTO grid_towers VALUES (1, 70, 'Hh1', '132k', 13.417551, 46.496794000000001, 754, 16.504709999999999, 'forest', 'n776114907');
INSERT INTO grid_towers VALUES (1, 71, 'Hh1', '132k', 13.325837999999999, 46.510047, 589, 9.0127799999999993, 'NA', 'n776114908');
INSERT INTO grid_towers VALUES (1, 73, 'Hh1', '132k', 13.358359, 46.502958, 711, 10.551830000000001, 'scrub', 'n776114914');
INSERT INTO grid_towers VALUES (1, 74, 'Hh1', '132k', 13.435387, 46.500520000000002, 836, 22.176749999999998, 'forest', 'n776114917');
INSERT INTO grid_towers VALUES (1, 75, 'Hh1', '132k', 13.298237, 46.492694, 585, 10.58117, 'meadow', 'n776114937');
INSERT INTO grid_towers VALUES (1, 76, 'Hh1', '132k', 13.376754999999999, 46.497824000000001, 676, 14.57363, 'scrub', 'n776114961');
INSERT INTO grid_towers VALUES (1, 77, 'Hh1', '132k', 13.389571, 46.497808999999997, 694, 8.6559799999999996, 'wood', 'n776115011');
INSERT INTO grid_towers VALUES (1, 78, 'Hh1', '132k', 13.402165999999999, 46.496993000000003, 782, 17.464099999999998, 'wood', 'n776115038');
INSERT INTO grid_towers VALUES (1, 79, 'Hh1', '132k', 13.334281000000001, 46.508482999999998, 622, 13.112299999999999, 'wood', 'n776115068');
INSERT INTO grid_towers VALUES (1, 80, 'Hh1', '132k', 13.411844, 46.497239, 752, 13.910410000000001, 'wood', 'n776115095');
INSERT INTO grid_towers VALUES (1, 81, 'Hh1', '132k', 13.342058, 46.507573000000001, 685, 18.835719999999998, 'wood', 'n776115111');
INSERT INTO grid_towers VALUES (1, 83, 'Hh1', '132k', 13.351214000000001, 46.505091999999998, 683, 15.51984, 'scrub', 'n776115168');
INSERT INTO grid_towers VALUES (1, 84, 'Hh1', '132k', 13.490527999999999, 46.496886000000003, 789, 1.26935, 'meadow', 'n776204714');
INSERT INTO grid_towers VALUES (1, 85, 'Hh1', '132k', 13.494377, 46.497763999999997, 798, 1.0581, 'forest', 'n776204841');
INSERT INTO grid_towers VALUES (1, 87, 'Hh1', '132k', 13.476988, 46.497776000000002, 955, 23.01859, 'forest', 'n776205476');
INSERT INTO grid_towers VALUES (1, 88, 'Hh1', '132k', 13.482307, 46.497422999999998, 863, 14.831469999999999, 'forest', 'n776205930');
INSERT INTO grid_towers VALUES (1, 89, 'Hh1', '132k', 13.486058, 46.49718, 803, 5.9842700000000004, 'meadow', 'n776206091');
INSERT INTO grid_towers VALUES (1, 90, 'h7', '60k', 13.319697, 46.511257000000001, 594, 11.993980000000001, 'meadow', 'n747742312');
INSERT INTO grid_towers VALUES (1, 91, 'h8', '60k', 13.317246000000001, 46.511372999999999, 610, 15.38256, 'scrub', 'n747742314');
INSERT INTO grid_towers VALUES (1, 93, 'h7', '60k', 13.316326, 46.511775999999998, 613, 18.23779, 'scrub', 'n747742326');
INSERT INTO grid_towers VALUES (1, 94, 'h7', '60k', 13.313897000000001, 46.511259000000003, 621, 18.748740000000002, 'NA', 'n747742327');
INSERT INTO grid_towers VALUES (1, 95, 'h8', '60k', 13.308631, 46.509833999999998, 583, 12.936820000000001, 'wood', 'n747742335');
INSERT INTO grid_towers VALUES (1, 96, 'h7', '60k', 13.312683, 46.511001, 621, 18.748740000000002, 'NA', 'n747742337');
INSERT INTO grid_towers VALUES (1, 97, 'h8', '60k', 13.313948, 46.511094, 621, 18.748740000000002, 'NA', 'n747742342');
INSERT INTO grid_towers VALUES (1, 98, 'h8', '60k', 13.31273, 46.510829000000001, 621, 18.748740000000002, 'NA', 'n747742344');
INSERT INTO grid_towers VALUES (1, 99, 'h7', '60k', 13.308611000000001, 46.509996999999998, 583, 12.936820000000001, 'wood', 'n747742346');
INSERT INTO grid_towers VALUES (1, 100, 'h8', '60k', 13.319597, 46.511094, 594, 11.993980000000001, 'meadow', 'n747742348');
INSERT INTO grid_towers VALUES (1, 102, 'h1', '60k', 13.295436, 46.460431999999997, 495, 11.976509999999999, 'wood', 'n748572169');
INSERT INTO grid_towers VALUES (1, 103, 'h3', '60k', 13.292804, 46.468026999999999, 574, 25.369450000000001, 'wood', 'n748572208');
INSERT INTO grid_towers VALUES (1, 104, 'h4', '60k', 13.293797, 46.462595, 492, 7.29718, 'wood', 'n748572228');
INSERT INTO grid_towers VALUES (1, 105, 'h4', '60k', 13.292764, 46.469118000000002, 567, 23.495249999999999, 'wood', 'n748572232');
INSERT INTO grid_towers VALUES (1, 106, 'h3', '60k', 13.293094, 46.466403, 567, 23.236049999999999, 'wood', 'n748572255');
INSERT INTO grid_towers VALUES (1, 107, 'h3', '60k', 13.293597999999999, 46.462524999999999, 549, 17.86861, 'wood', 'n748572257');
INSERT INTO grid_towers VALUES (1, 108, 'h3', '60k', 13.292403999999999, 46.470185000000001, 567, 23.495249999999999, 'wood', 'n748572275');
INSERT INTO grid_towers VALUES (1, 109, 'h3', '60k', 13.293374999999999, 46.464866000000001, 567, 23.236049999999999, 'wood', 'n748572281');
INSERT INTO grid_towers VALUES (1, 110, 'h2', '60k', 13.295643999999999, 46.460521, 495, 11.976509999999999, 'wood', 'n748572296');
INSERT INTO grid_towers VALUES (1, 111, 'h4', '60k', 13.292961, 46.468044999999996, 574, 25.369450000000001, 'wood', 'n748572301');
INSERT INTO grid_towers VALUES (1, 112, 'h3', '60k', 13.292982, 46.467030999999999, 574, 25.369450000000001, 'wood', 'n748572311');
INSERT INTO grid_towers VALUES (1, 113, 'h4', '60k', 13.293267999999999, 46.466374999999999, 567, 23.236049999999999, 'wood', 'n748572340');
INSERT INTO grid_towers VALUES (1, 114, 'h3', '60k', 13.292548, 46.470990999999998, 536, 20.314910000000001, 'wood', 'n748572347');
INSERT INTO grid_towers VALUES (1, 115, 'h4', '60k', 13.292615, 46.470233999999998, 567, 23.495249999999999, 'wood', 'n748572368');
INSERT INTO grid_towers VALUES (1, 116, 'h4', '60k', 13.293139, 46.467078000000001, 574, 25.369450000000001, 'wood', 'n748572370');
INSERT INTO grid_towers VALUES (1, 117, 'h3', '60k', 13.292612999999999, 46.469099999999997, 567, 23.495249999999999, 'wood', 'n748572377');
INSERT INTO grid_towers VALUES (1, 118, 'h4', '60k', 13.293557, 46.464888000000002, 567, 23.236049999999999, 'wood', 'n748572388');
INSERT INTO grid_towers VALUES (1, 119, 'h5', '60k', 13.301603, 46.505696, 623, 18.218889999999998, 'NA', 'n748774055');
INSERT INTO grid_towers VALUES (1, 120, 'h7', '60k', 13.310487, 46.510455, 634, 19.8062, 'NA', 'n748774063');
INSERT INTO grid_towers VALUES (1, 122, 'h5', '60k', 13.301318999999999, 46.502799000000003, 611, 16.895990000000001, 'wood', 'n748774065');
INSERT INTO grid_towers VALUES (1, 123, 'h7', '60k', 13.302910000000001, 46.508656999999999, 586, 4.23081, 'NA', 'n748774068');
INSERT INTO grid_towers VALUES (1, 124, 'h5', '60k', 13.299685999999999, 46.485692, 592, 18.678139999999999, 'wood', 'n748774074');
INSERT INTO grid_towers VALUES (1, 125, 'h5', '60k', 13.299533, 46.492716999999999, 585, 10.58117, 'wood', 'n748774075');
INSERT INTO grid_towers VALUES (1, 126, 'h6', '60k', 13.301526000000001, 46.502800999999998, 611, 16.895990000000001, 'wood', 'n748774077');
INSERT INTO grid_towers VALUES (1, 127, 'h6', '60k', 13.301653999999999, 46.504626000000002, 623, 18.218889999999998, 'NA', 'n748774080');
INSERT INTO grid_towers VALUES (1, 128, 'h5', '60k', 13.299732000000001, 46.484758999999997, 576, 16.75432, 'wood', 'n748774081');
INSERT INTO grid_towers VALUES (1, 129, 'h8', '60k', 13.31057, 46.510303999999998, 634, 19.8062, 'NA', 'n748774083');
INSERT INTO grid_towers VALUES (1, 130, 'h5', '60k', 13.301406, 46.507790999999997, 626, 16.7286, 'NA', 'n748774085');
INSERT INTO grid_towers VALUES (1, 131, 'h5', '60k', 13.301488000000001, 46.506917000000001, 626, 16.7286, 'wood', 'n748774088');
INSERT INTO grid_towers VALUES (1, 132, 'h8', '60k', 13.305281000000001, 46.509093999999997, 596, 10.524229999999999, 'NA', 'n748774090');
INSERT INTO grid_towers VALUES (1, 133, 'h5', '60k', 13.299454000000001, 46.486784, 592, 18.678139999999999, 'wood', 'n748774091');
INSERT INTO grid_towers VALUES (1, 135, 'h5', '60k', 13.300533, 46.499772, 553, 1.6236999999999999, 'NA', 'n748774096');
INSERT INTO grid_towers VALUES (1, 136, 'h5', '60k', 13.300128000000001, 46.493572999999998, 543, 5.2934900000000003, 'wood', 'n748774104');
INSERT INTO grid_towers VALUES (1, 137, 'h6', '60k', 13.301565, 46.507786000000003, 626, 16.7286, 'NA', 'n748774108');
INSERT INTO grid_towers VALUES (1, 138, 'h6', '60k', 13.301783, 46.505693999999998, 623, 18.218889999999998, 'NA', 'n748774112');
INSERT INTO grid_towers VALUES (1, 139, 'h5', '60k', 13.297908, 46.490571000000003, 543, 12.30645, 'wood', 'n748774116');
INSERT INTO grid_towers VALUES (1, 140, 'h5', '60k', 13.301500000000001, 46.504643000000002, 623, 18.218889999999998, 'NA', 'n748774120');
INSERT INTO grid_towers VALUES (1, 141, 'h5', '60k', 13.300117999999999, 46.494256, 553, 4.4256799999999998, 'forest', 'n748774123');
INSERT INTO grid_towers VALUES (1, 142, 'h5', '60k', 13.300041999999999, 46.496212999999997, 549, 4.02637, 'NA', 'n748774131');
INSERT INTO grid_towers VALUES (1, 144, 'h7', '60k', 13.305039000000001, 46.509163000000001, 596, 10.524229999999999, 'NA', 'n748774138');
INSERT INTO grid_towers VALUES (1, 145, 'h5', '60k', 13.298595000000001, 46.487808000000001, 563, 17.55002, 'wood', 'n748774139');
INSERT INTO grid_towers VALUES (1, 146, 'h8', '60k', 13.303008999999999, 46.508566000000002, 586, 4.23081, 'NA', 'n748774144');
INSERT INTO grid_towers VALUES (1, 147, 'h5', '60k', 13.298659000000001, 46.491692999999998, 585, 10.58117, 'wood', 'n748774146');
INSERT INTO grid_towers VALUES (1, 148, 'h12', '60k', 13.38693, 46.499341000000001, 686, 10.46617, 'scrub', 'n748784363');
INSERT INTO grid_towers VALUES (1, 149, 'h17', '60k', 13.456773999999999, 46.501665000000003, 850, 7.0600800000000001, 'NA', 'n748784365');
INSERT INTO grid_towers VALUES (1, 150, 'h18', '60k', 13.467905, 46.498950000000001, 952, 5.8430600000000004, 'forest', 'n748784366');
INSERT INTO grid_towers VALUES (1, 151, 'h17', '60k', 13.450044, 46.503971, 786, 14.36117, 'forest', 'n748784367');
INSERT INTO grid_towers VALUES (1, 153, 'h12', '60k', 13.375225, 46.500712999999998, 651, 5.4568000000000003, 'grassland', 'n748784369');
INSERT INTO grid_towers VALUES (1, 154, 'h10', '60k', 13.345338999999999, 46.507244999999998, 658, 17.364450000000001, 'wood', 'n748784370');
INSERT INTO grid_towers VALUES (1, 155, 'h10', '60k', 13.361471, 46.503413000000002, 703, 9.8797800000000002, 'wood', 'n748784371');
INSERT INTO grid_towers VALUES (1, 156, 'h10', '60k', 13.328115, 46.507798999999999, 674, 18.829190000000001, 'wood', 'n748784372');
INSERT INTO grid_towers VALUES (1, 157, 'h11', '60k', 13.384397, 46.499552000000001, 675, 11.380520000000001, 'scrub', 'n748784373');
INSERT INTO grid_towers VALUES (1, 158, 'h9', '60k', 13.34365, 46.508018, 658, 17.364450000000001, 'NA', 'n748784374');
INSERT INTO grid_towers VALUES (1, 159, 'h15', '60k', 13.420351, 46.500154999999999, 698, 8.8973499999999994, 'grassland', 'n748784376');
INSERT INTO grid_towers VALUES (1, 160, 'h11', '60k', 13.386936, 46.499490999999999, 686, 10.46617, 'scrub', 'n748784377');
INSERT INTO grid_towers VALUES (1, 161, 'h18', '60k', 13.461537, 46.499960999999999, 903, 12.600210000000001, 'forest', 'n748784378');
INSERT INTO grid_towers VALUES (1, 163, 'h18', '60k', 13.454475, 46.502263999999997, 810, 8.6637000000000004, 'forest', 'n748784381');
INSERT INTO grid_towers VALUES (1, 164, 'h10', '60k', 13.330373, 46.508218999999997, 610, 14.557729999999999, 'wood', 'n748784382');
INSERT INTO grid_towers VALUES (1, 165, 'h18', '60k', 13.492025999999999, 46.500008999999999, 791, 0.57545000000000002, 'meadow', 'n748784383');
INSERT INTO grid_towers VALUES (1, 166, 'h18', '60k', 13.480931, 46.498581999999999, 847, 9.7281899999999997, 'meadow', 'n748784385');
INSERT INTO grid_towers VALUES (1, 167, 'h11', '60k', 13.375285999999999, 46.500867, 651, 5.4568000000000003, 'grassland', 'n748784386');
INSERT INTO grid_towers VALUES (1, 168, 'h10', '60k', 13.34911, 46.506076999999998, 691, 18.058689999999999, 'NA', 'n748784387');
INSERT INTO grid_towers VALUES (1, 169, 'h13', '60k', 13.407370999999999, 46.499034999999999, 736, 13.226760000000001, 'scrub', 'n748784388');
INSERT INTO grid_towers VALUES (1, 170, 'h9', '60k', 13.333447, 46.508411000000002, 622, 13.112299999999999, 'wood', 'n748784389');
INSERT INTO grid_towers VALUES (1, 171, 'h10', '60k', 13.332302, 46.508305999999997, 621, 15.61321, 'wood', 'n748784392');
INSERT INTO grid_towers VALUES (1, 173, 'h14', '60k', 13.414384999999999, 46.498975999999999, 709, 8.0316100000000006, 'meadow', 'n748784395');
INSERT INTO grid_towers VALUES (1, 174, 'h9', '60k', 13.332008999999999, 46.508471999999998, 621, 15.61321, 'wood', 'n748784396');
INSERT INTO grid_towers VALUES (1, 175, 'h17', '60k', 13.467914, 46.499071999999998, 952, 5.8430600000000004, 'NA', 'n748784397');
INSERT INTO grid_towers VALUES (1, 177, 'h17', '60k', 13.472846000000001, 46.499237999999998, 947, 7.49261, 'NA', 'n748784399');
INSERT INTO grid_towers VALUES (1, 179, 'h9', '60k', 13.356909999999999, 46.504432999999999, 667, 9.7460599999999999, 'wood', 'n748784401');
INSERT INTO grid_towers VALUES (1, 180, 'h11', '60k', 13.377488, 46.500432000000004, 656, 4.6386700000000003, 'grassland', 'n748784402');
INSERT INTO grid_towers VALUES (1, 181, 'h13', '60k', 13.402317, 46.499155999999999, 726, 12.52816, 'scrub', 'n748784403');
INSERT INTO grid_towers VALUES (1, 182, 'h10', '60k', 13.343522, 46.507824999999997, 685, 18.835719999999998, 'wood', 'n748784404');
INSERT INTO grid_towers VALUES (1, 183, 'h10', '60k', 13.33394, 46.508240999999998, 622, 13.112299999999999, 'wood', 'n748784405');
INSERT INTO grid_towers VALUES (1, 184, 'h10', '60k', 13.326008, 46.507545999999998, 662, 19.533919999999998, 'wood', 'n748784406');
INSERT INTO grid_towers VALUES (1, 185, 'h12', '60k', 13.384376, 46.499386999999999, 675, 11.380520000000001, 'scrub', 'n748784407');
INSERT INTO grid_towers VALUES (1, 186, 'h14', '60k', 13.404818000000001, 46.498924000000002, 739, 12.887460000000001, 'NA', 'n748784408');
INSERT INTO grid_towers VALUES (1, 187, 'h13', '60k', 13.418782999999999, 46.499276000000002, 742, 13.63435, 'meadow', 'n748784409');
INSERT INTO grid_towers VALUES (1, 188, 'h18', '60k', 13.459116, 46.500762999999999, 867, 8.26708, 'NA', 'n748784410');
INSERT INTO grid_towers VALUES (1, 190, 'h17', '60k', 13.454551, 46.502378, 810, 8.6637000000000004, 'NA', 'n748784413');
INSERT INTO grid_towers VALUES (1, 191, 'h9', '60k', 13.330114, 46.508336999999997, 610, 14.557729999999999, 'wood', 'n748784414');
INSERT INTO grid_towers VALUES (1, 192, 'h18', '60k', 13.488548, 46.499099999999999, 784, 0.92286999999999997, 'meadow', 'n748784415');
INSERT INTO grid_towers VALUES (1, 193, 'h17', '60k', 13.466013999999999, 46.499173999999996, 941, 4.8729699999999996, 'NA', 'n748784416');
INSERT INTO grid_towers VALUES (1, 194, 'h17', '60k', 13.478536, 46.498705000000001, 882, 12.025230000000001, 'forest', 'n748784417');
INSERT INTO grid_towers VALUES (1, 195, 'h15', '60k', 13.427911, 46.502096999999999, 722, 14.03181, 'NA', 'n748784418');
INSERT INTO grid_towers VALUES (1, 196, 'h17', '60k', 13.480907, 46.498750000000001, 847, 9.7281899999999997, 'meadow', 'n748784420');
INSERT INTO grid_towers VALUES (1, 197, 'h9', '60k', 13.34919, 46.506210000000003, 627, 10.8226, 'NA', 'n748784421');
INSERT INTO grid_towers VALUES (1, 199, 'h9', '60k', 13.337134000000001, 46.508603000000001, 623, 10.31794, 'wood', 'n748784423');
INSERT INTO grid_towers VALUES (1, 200, 'h18', '60k', 13.430622, 46.502401999999996, 719, 11.750389999999999, 'forest', 'n748784424');
INSERT INTO grid_towers VALUES (1, 201, 'h13', '60k', 13.414356, 46.499144000000001, 709, 8.0316100000000006, 'meadow', 'n748784425');
INSERT INTO grid_towers VALUES (1, 202, 'h17', '60k', 13.495520000000001, 46.501054000000003, 790, 0.37380999999999998, 'meadow', 'n748784426');
INSERT INTO grid_towers VALUES (1, 203, 'h18', '60k', 13.435124999999999, 46.502999000000003, 713, 12.36506, 'meadow', 'n748784429');
INSERT INTO grid_towers VALUES (1, 204, 'h9', '60k', 13.341820999999999, 46.508187, 685, 18.835719999999998, 'wood', 'n748784431');
INSERT INTO grid_towers VALUES (1, 205, 'h18', '60k', 13.483356000000001, 46.498657999999999, 802, 7.1531000000000002, 'meadow', 'n748784432');
INSERT INTO grid_towers VALUES (1, 206, 'h18', '60k', 13.472835999999999, 46.499122, 947, 7.49261, 'NA', 'n748784433');
INSERT INTO grid_towers VALUES (1, 207, 'h17', '60k', 13.444642, 46.504418999999999, 723, 8.3096399999999999, 'meadow', 'n748784434');
INSERT INTO grid_towers VALUES (1, 209, 'h12', '60k', 13.377411, 46.500275999999999, 656, 4.6386700000000003, 'grassland', 'n748784436');
INSERT INTO grid_towers VALUES (1, 210, 'h9', '60k', 13.351452, 46.505456000000002, 683, 15.51984, 'wood', 'n748784438');
INSERT INTO grid_towers VALUES (1, 211, 'h10', '60k', 13.323233, 46.507292999999997, 660, 23.415839999999999, 'wood', 'n748784439');
INSERT INTO grid_towers VALUES (1, 212, 'h13', '60k', 13.404857, 46.499088999999998, 739, 12.887460000000001, 'scrub', 'n748784441');
INSERT INTO grid_towers VALUES (1, 213, 'h10', '60k', 13.337101000000001, 46.508454, 623, 10.31794, 'wood', 'n748784442');
INSERT INTO grid_towers VALUES (1, 214, 'h17', '60k', 13.476184999999999, 46.499070000000003, 921, 11.562749999999999, 'forest', 'n748784443');
INSERT INTO grid_towers VALUES (1, 215, 'h13', '60k', 13.416586000000001, 46.499220999999999, 720, 8.9923199999999994, 'meadow', 'n748784444');
INSERT INTO grid_towers VALUES (1, 216, 'h13', '60k', 13.412172999999999, 46.499077, 712, 9.5200999999999993, 'scrub', 'n748784445');
INSERT INTO grid_towers VALUES (1, 217, 'h14', '60k', 13.402304000000001, 46.49897, 726, 12.52816, 'scrub', 'n748784446');
INSERT INTO grid_towers VALUES (1, 219, 'h18', '60k', 13.465899, 46.499084000000003, 941, 4.8729699999999996, 'forest', 'n748784449');
INSERT INTO grid_towers VALUES (1, 220, 'h18', '60k', 13.478543999999999, 46.498550000000002, 882, 12.025230000000001, 'forest', 'n748784450');
INSERT INTO grid_towers VALUES (1, 221, 'h16', '60k', 13.427934, 46.502006000000002, 722, 14.03181, 'NA', 'n748784451');
INSERT INTO grid_towers VALUES (1, 222, 'h12', '60k', 13.370716, 46.501587000000001, 646, 9.0374099999999995, 'grassland', 'n748784452');
INSERT INTO grid_towers VALUES (1, 223, 'h14', '60k', 13.409993, 46.498826000000001, 725, 11.973420000000001, 'scrub', 'n748784453');
INSERT INTO grid_towers VALUES (1, 224, 'h7', '60k', 13.321078999999999, 46.509270000000001, 575, 5.2977800000000004, 'NA', 'n748784454');
INSERT INTO grid_towers VALUES (1, 225, 'h17', '60k', 13.432371, 46.502802000000003, 715, 10.138719999999999, 'meadow', 'n748784455');
INSERT INTO grid_towers VALUES (1, 227, 'h17', '60k', 13.435078000000001, 46.503155, 713, 12.36506, 'meadow', 'n748784459');
INSERT INTO grid_towers VALUES (1, 228, 'h10', '60k', 13.34179, 46.507921000000003, 685, 18.835719999999998, 'wood', 'n748784462');
INSERT INTO grid_towers VALUES (1, 229, 'h18', '60k', 13.463867, 46.499192999999998, 925, 6.4982100000000003, 'forest', 'n748784463');
INSERT INTO grid_towers VALUES (1, 230, 'h17', '60k', 13.442143, 46.504094000000002, 721, 4.6864800000000004, 'NA', 'n748784464');
INSERT INTO grid_towers VALUES (1, 231, 'h10', '60k', 13.356854, 46.504305000000002, 667, 9.7460599999999999, 'wood', 'n748784465');
INSERT INTO grid_towers VALUES (1, 232, 'h15', '60k', 13.425264, 46.501809999999999, 809, 18.466470000000001, 'NA', 'n748784466');
INSERT INTO grid_towers VALUES (1, 233, 'h13', '60k', 13.397038, 46.499256000000003, 713, 13.11876, 'scrub', 'n748784467');
INSERT INTO grid_towers VALUES (1, 234, 'h18', '60k', 13.449593, 46.503494000000003, 818, 19.772570000000002, 'forest', 'n748784468');
INSERT INTO grid_towers VALUES (1, 235, 'h9', '60k', 13.368402, 46.502203000000002, 648, 5.4856600000000002, 'grassland', 'n748784470');
INSERT INTO grid_towers VALUES (1, 237, 'h11', '60k', 13.392018, 46.499350999999997, 690, 9.1201799999999995, 'scrub', 'n748784474');
INSERT INTO grid_towers VALUES (1, 238, 'h15', '60k', 13.422901, 46.501513000000003, 771, 16.748159999999999, 'meadow', 'n748784475');
INSERT INTO grid_towers VALUES (1, 239, 'h17', '60k', 13.437526999999999, 46.503475000000002, 741, 13.197419999999999, 'meadow', 'n748784477');
INSERT INTO grid_towers VALUES (1, 240, 'h14', '60k', 13.397027, 46.499097999999996, 713, 13.11876, 'scrub', 'n748784478');
INSERT INTO grid_towers VALUES (1, 241, 'h18', '60k', 13.452076999999999, 46.502927999999997, 793, 9.6045700000000007, 'NA', 'n748784479');
INSERT INTO grid_towers VALUES (1, 242, 'h13', '60k', 13.399678, 46.499198, 707, 13.1008, 'scrub', 'n748784480');
INSERT INTO grid_towers VALUES (1, 243, 'h11', '60k', 13.37077, 46.501742999999998, 646, 9.0374099999999995, 'grassland', 'n748784482');
INSERT INTO grid_towers VALUES (1, 245, 'h7', '60k', 13.320833, 46.510561000000003, 598, 8.8207599999999999, 'meadow', 'n748784485');
INSERT INTO grid_towers VALUES (1, 246, 'h17', '60k', 13.430598, 46.502535999999999, 719, 11.750389999999999, 'meadow', 'n748784486');
INSERT INTO grid_towers VALUES (1, 247, 'h17', '60k', 13.488486999999999, 46.499254999999998, 784, 0.92286999999999997, 'meadow', 'n748784488');
INSERT INTO grid_towers VALUES (1, 248, 'h12', '60k', 13.389396, 46.499263999999997, 694, 9.4805799999999998, 'scrub', 'n748784489');
INSERT INTO grid_towers VALUES (1, 249, 'h18', '60k', 13.437576, 46.503326000000001, 741, 13.197419999999999, 'meadow', 'n748784491');
INSERT INTO grid_towers VALUES (1, 250, 'h17', '60k', 13.463918, 46.499294999999996, 925, 6.4982100000000003, 'forest', 'n748784493');
INSERT INTO grid_towers VALUES (1, 251, 'h16', '60k', 13.425292000000001, 46.5017, 809, 18.466470000000001, 'NA', 'n748784494');
INSERT INTO grid_towers VALUES (1, 252, 'h18', '60k', 13.447112000000001, 46.504553000000001, 736, 10.026059999999999, 'forest', 'n748784495');
INSERT INTO grid_towers VALUES (1, 254, 'h9', '60k', 13.354029000000001, 46.504962999999996, 666, 10.33259, 'wood', 'n748784498');
INSERT INTO grid_towers VALUES (1, 255, 'h9', '60k', 13.366045, 46.502684000000002, 668, 7.8867700000000003, 'scrub', 'n748784499');
INSERT INTO grid_towers VALUES (1, 256, 'h8', '60k', 13.320634, 46.510511999999999, 594, 11.993980000000001, 'meadow', 'n748784501');
INSERT INTO grid_towers VALUES (1, 257, 'h15', '60k', 13.422026000000001, 46.501004999999999, 729, 13.752269999999999, 'forest', 'n748784502');
INSERT INTO grid_towers VALUES (1, 258, 'h17', '60k', 13.440013, 46.503799000000001, 751, 12.04195, 'forest', 'n748784504');
INSERT INTO grid_towers VALUES (1, 259, 'h14', '60k', 13.399672000000001, 46.499063, 707, 13.1008, 'scrub', 'n748784505');
INSERT INTO grid_towers VALUES (1, 260, 'h10', '60k', 13.36835, 46.502046, 648, 5.4856600000000002, 'grassland', 'n748784506');
INSERT INTO grid_towers VALUES (1, 261, 'h7', '60k', 13.320739, 46.509278999999999, 575, 5.2977800000000004, 'NA', 'n748784507');
INSERT INTO grid_towers VALUES (1, 263, 'h17', '60k', 13.486001, 46.499023000000001, 787, 3.89405, 'meadow', 'n748784510');
INSERT INTO grid_towers VALUES (1, 264, 'h11', '60k', 13.389405, 46.499437999999998, 694, 9.4805799999999998, 'scrub', 'n748784511');
INSERT INTO grid_towers VALUES (1, 265, 'h17', '60k', 13.459155000000001, 46.500867999999997, 867, 8.26708, 'NA', 'n748784512');
INSERT INTO grid_towers VALUES (1, 268, 'h17', '60k', 13.483302, 46.498832999999998, 802, 7.1531000000000002, 'meadow', 'n748784516');
INSERT INTO grid_towers VALUES (1, 269, 'h18', '60k', 13.444682999999999, 46.504266999999999, 723, 8.3096399999999999, 'meadow', 'n748784517');
INSERT INTO grid_towers VALUES (1, 270, 'h12', '60k', 13.373016, 46.501140999999997, 646, 6.6704499999999998, 'grassland', 'n748784518');
INSERT INTO grid_towers VALUES (1, 271, 'h10', '60k', 13.353979000000001, 46.504845000000003, 667, 12.51763, 'wood', 'n748784519');
INSERT INTO grid_towers VALUES (1, 272, 'h9', '60k', 13.361489000000001, 46.503535999999997, 703, 9.8797800000000002, 'wood', 'n748784520');
INSERT INTO grid_towers VALUES (1, 273, 'h9', '60k', 13.32602, 46.507753999999998, 662, 19.533919999999998, 'wood', 'n748784521');
INSERT INTO grid_towers VALUES (1, 274, 'h11', '60k', 13.38189, 46.499592, 672, 10.367279999999999, 'scrub', 'n748784522');
INSERT INTO grid_towers VALUES (1, 275, 'h10', '60k', 13.331135, 46.508349000000003, 621, 15.61321, 'wood', 'n748784524');
INSERT INTO grid_towers VALUES (1, 276, 'h16', '60k', 13.422953, 46.501409000000002, 771, 16.748159999999999, 'meadow', 'n748784527');
INSERT INTO grid_towers VALUES (1, 278, 'h11', '60k', 13.379702999999999, 46.499999000000003, 658, 3.64567, 'grassland', 'n748784530');
INSERT INTO grid_towers VALUES (1, 279, 'h14', '60k', 13.412184, 46.498913999999999, 712, 9.5200999999999993, 'scrub', 'n748784531');
INSERT INTO grid_towers VALUES (1, 280, 'h10', '60k', 13.366031, 46.502544999999998, 668, 7.8867700000000003, 'wood', 'n748784532');
INSERT INTO grid_towers VALUES (1, 281, 'h9', '60k', 13.323321, 46.507505000000002, 660, 23.415839999999999, 'wood', 'n748784533');
INSERT INTO grid_towers VALUES (1, 282, 'h9', '60k', 13.34544, 46.507390000000001, 658, 17.364450000000001, 'wood', 'n748784534');
INSERT INTO grid_towers VALUES (1, 283, 'h17', '60k', 13.461592, 46.500051999999997, 903, 12.600210000000001, 'forest', 'n748784535');
INSERT INTO grid_towers VALUES (1, 284, 'h16', '60k', 13.420465999999999, 46.500017999999997, 698, 8.8973499999999994, 'forest', 'n748784536');
INSERT INTO grid_towers VALUES (1, 285, 'h18', '60k', 13.456693, 46.501559999999998, 850, 7.0600800000000001, 'NA', 'n748784538');
INSERT INTO grid_towers VALUES (1, 286, 'h13', '60k', 13.39479, 46.499291999999997, 702, 11.582789999999999, 'scrub', 'n748784539');
INSERT INTO grid_towers VALUES (1, 287, 'h18', '60k', 13.495588, 46.500928999999999, 790, 0.37380999999999998, 'meadow', 'n748784540');
INSERT INTO grid_towers VALUES (1, 289, 'h18', '60k', 13.442194000000001, 46.503953000000003, 764, 16.71039, 'NA', 'n748784542');
INSERT INTO grid_towers VALUES (1, 290, 'h10', '60k', 13.351374, 46.505302, 683, 15.51984, 'wood', 'n748784544');
INSERT INTO grid_towers VALUES (1, 291, 'h9', '60k', 13.328110000000001, 46.507945999999997, 674, 18.829190000000001, 'wood', 'n748784545');
INSERT INTO grid_towers VALUES (1, 292, 'h9', '60k', 13.359335, 46.503965000000001, 711, 10.551830000000001, 'meadow', 'n748784547');
INSERT INTO grid_towers VALUES (1, 293, 'h9', '60k', 13.331077000000001, 46.508524999999999, 610, 14.557729999999999, 'wood', 'n748784549');
INSERT INTO grid_towers VALUES (1, 294, 'h17', '60k', 13.500368999999999, 46.500391, 785, 2.8679399999999999, 'NA', 'n748817446');
INSERT INTO grid_towers VALUES (1, 295, 'h18', '60k', 13.499358000000001, 46.500872000000001, 786, 4.3269500000000001, 'NA', 'n748817456');
INSERT INTO grid_towers VALUES (1, 296, 'h18', '60k', 13.500254999999999, 46.500338999999997, 785, 2.8679399999999999, 'NA', 'n748817462');
INSERT INTO grid_towers VALUES (1, 297, 'h17', '60k', 13.499485, 46.500960999999997, 786, 4.3269500000000001, 'NA', 'n748817487');
INSERT INTO grid_towers VALUES (1, 298, 'h17', '60k', 13.497669999999999, 46.501562999999997, 786, 2.9586299999999999, 'NA', 'n748817494');
INSERT INTO grid_towers VALUES (1, 300, 'h6', '60k', 13.301882000000001, 46.494128000000003, 553, 4.4256799999999998, 'wood', 'n762820369');
INSERT INTO grid_towers VALUES (1, 301, 'h6', '60k', 13.300700000000001, 46.486105000000002, 544, 11.11525, 'meadow', 'n762820371');
INSERT INTO grid_towers VALUES (1, 302, 'h7', '60k', 13.321109, 46.509135999999998, 575, 5.2977800000000004, 'NA', 'n762820373');
INSERT INTO grid_towers VALUES (1, 303, 'h6', '60k', 13.300535, 46.498010999999998, 553, 1.6236999999999999, 'NA', 'n762820374');
INSERT INTO grid_towers VALUES (1, 304, 'h6', '60k', 13.300720999999999, 46.500008000000001, 570, 11.550750000000001, 'NA', 'n762820377');
INSERT INTO grid_towers VALUES (1, 305, 'h4', '60k', 13.296944999999999, 46.473655000000001, 556, 21.16253, 'wood', 'n762820378');
INSERT INTO grid_towers VALUES (1, 306, 'h6', '60k', 13.301024999999999, 46.488349999999997, 537, 10.764010000000001, 'wood', 'n762820380');
INSERT INTO grid_towers VALUES (1, 307, 'h3', '60k', 13.300285000000001, 46.479444999999998, 544, 10.75043, 'residential', 'n762820382');
INSERT INTO grid_towers VALUES (1, 308, 'h4', '60k', 13.301375999999999, 46.481160000000003, 536, 11.32333, 'wood', 'n762820384');
INSERT INTO grid_towers VALUES (1, 309, 'h3', '60k', 13.295294999999999, 46.472127, 498, 7.4025299999999996, 'wood', 'n762820385');
INSERT INTO grid_towers VALUES (1, 311, 'h10', '60k', 13.335424, 46.508628000000002, 623, 10.31794, 'wood', 'n762820388');
INSERT INTO grid_towers VALUES (1, 312, 'h3', '60k', 13.29744, 46.474829999999997, 556, 21.16253, 'wood', 'n762820389');
INSERT INTO grid_towers VALUES (1, 313, 'h10', '60k', 13.339980000000001, 46.508048000000002, 679, 16.807939999999999, 'wood', 'n762820391');
INSERT INTO grid_towers VALUES (1, 314, 'h6', '60k', 13.303001, 46.492609999999999, 603, 18.056470000000001, 'wood', 'n762820392');
INSERT INTO grid_towers VALUES (1, 315, 'h6', '60k', 13.300939, 46.483708, 537, 11.43628, 'meadow', 'n762820394');
INSERT INTO grid_towers VALUES (1, 316, 'h4', '60k', 13.300383999999999, 46.479422, 544, 10.75043, 'residential', 'n762820395');
INSERT INTO grid_towers VALUES (1, 317, 'h6', '60k', 13.300195, 46.496366999999999, 549, 4.02637, 'NA', 'n762820396');
INSERT INTO grid_towers VALUES (1, 318, 'h3', '60k', 13.296715000000001, 46.47372, 556, 21.16253, 'wood', 'n762820397');
INSERT INTO grid_towers VALUES (1, 319, 'h4', '60k', 13.295445000000001, 46.472003000000001, 498, 7.4025299999999996, 'wood', 'n762820398');
INSERT INTO grid_towers VALUES (1, 320, 'h3', '60k', 13.301131, 46.481138999999999, 536, 11.32333, 'meadow', 'n762820400');
INSERT INTO grid_towers VALUES (1, 321, 'h7', '60k', 13.32034, 46.509248999999997, 571, 2.2008999999999999, 'railway', 'n762820401');
INSERT INTO grid_towers VALUES (1, 322, 'h4', '60k', 13.297256000000001, 46.474141000000003, 556, 21.16253, 'wood', 'n762820403');
INSERT INTO grid_towers VALUES (1, 324, 'h6', '60k', 13.300610000000001, 46.499144999999999, 553, 1.6236999999999999, 'military', 'n762820407');
INSERT INTO grid_towers VALUES (1, 325, 'h6', '60k', 13.301824, 46.501514, 570, 11.550750000000001, 'NA', 'n762820408');
INSERT INTO grid_towers VALUES (1, 326, 'h5', '60k', 13.300711, 46.501936999999998, 570, 11.550750000000001, 'wood', 'n762820410');
INSERT INTO grid_towers VALUES (1, 327, 'h6', '60k', 13.301316, 46.490743999999999, 541, 6.3864599999999996, 'meadow', 'n762820411');
INSERT INTO grid_towers VALUES (1, 328, 'h4', '60k', 13.301252, 46.482635999999999, 536, 11.32333, 'wood', 'n762820412');
INSERT INTO grid_towers VALUES (1, 329, 'h4', '60k', 13.299479, 46.477806999999999, 523, 7.5126900000000001, 'wood', 'n762820414');
INSERT INTO grid_towers VALUES (1, 330, 'h9', '60k', 13.334939, 46.508839999999999, 622, 13.112299999999999, 'wood', 'n762820415');
INSERT INTO grid_towers VALUES (1, 331, 'h3', '60k', 13.297001, 46.474142999999998, 556, 21.16253, 'wood', 'n762820416');
INSERT INTO grid_towers VALUES (1, 332, 'h4', '60k', 13.292681, 46.470742000000001, 536, 20.314910000000001, 'wood', 'n762820418');
INSERT INTO grid_towers VALUES (1, 333, 'h3', '60k', 13.301031999999999, 46.482624000000001, 536, 11.32333, 'wood', 'n762820419');
INSERT INTO grid_towers VALUES (1, 334, 'h9', '60k', 13.339804000000001, 46.508397000000002, 606, 10.57944, 'NA', 'n762820421');
INSERT INTO grid_towers VALUES (1, 335, 'h18', '60k', 13.498312, 46.500489999999999, 786, 4.3269500000000001, 'NA', 'n2170919707');
INSERT INTO grid_towers VALUES (1, 337, 'm25', 'minor', 13.501661, 46.500219999999999, 785, 2.8679399999999999, 'NA', 'n2170919699');
INSERT INTO grid_towers VALUES (1, 338, 'm27', 'minor', 13.503719, 46.500607000000002, 797, 3.2450800000000002, 'NA', 'n2170919716');
INSERT INTO grid_towers VALUES (1, 339, 'm27', 'minor', 13.505818, 46.500999, 818, 6.6100000000000003, 'NA', 'n2170919717');
INSERT INTO grid_towers VALUES (1, 340, 'm27', 'minor', 13.508063, 46.501413999999997, 837, 9.2142999999999997, 'NA', 'n2170919721');
INSERT INTO grid_towers VALUES (1, 341, 'm27', 'minor', 13.510524999999999, 46.501871999999999, 876, 16.812149999999999, 'NA', 'n2170919725');
INSERT INTO grid_towers VALUES (1, 342, 'm27', 'minor', 13.513184000000001, 46.502353999999997, 824, 17.046749999999999, 'forest', 'n2170919728');
INSERT INTO grid_towers VALUES (1, 344, 'm27', 'minor', 13.516712, 46.503008999999999, 882, 25.208770000000001, 'forest', 'n2170919734');
INSERT INTO grid_towers VALUES (1, 345, 'm27', 'minor', 13.517931000000001, 46.503376000000003, 882, 25.208770000000001, 'forest', 'n2170919740');
INSERT INTO grid_towers VALUES (1, 346, 'm27', 'minor', 13.519269, 46.503762999999999, 901, 24.934480000000001, 'forest', 'n2170919745');
INSERT INTO grid_towers VALUES (1, 347, 'm27', 'minor', 13.520630000000001, 46.503928000000002, 901, 24.934480000000001, 'forest', 'n2170919747');
INSERT INTO grid_towers VALUES (1, 348, 'm27', 'minor', 13.522199000000001, 46.504105000000003, 819, 11.835649999999999, 'forest', 'n2170919753');
INSERT INTO grid_towers VALUES (1, 349, 'm27', 'minor', 13.523949999999999, 46.505062000000002, 835, 13.284800000000001, 'forest', 'n2170919772');
INSERT INTO grid_towers VALUES (1, 350, 'm27', 'minor', 13.525572, 46.505338999999999, 848, 15.80213, 'forest', 'n2170919780');
INSERT INTO grid_towers VALUES (1, 351, 'm27', 'minor', 13.527309000000001, 46.505454, 860, 19.230879999999999, 'forest', 'n2170919786');
INSERT INTO grid_towers VALUES (1, 353, 'm12', 'minor', 13.392566, 46.498927000000002, 690, 9.1201799999999995, 'scrub', 'n2419588821');
INSERT INTO grid_towers VALUES (1, 354, 'm17', 'minor', 13.419086, 46.499119, 742, 13.63435, 'forest', 'n2419588824');
INSERT INTO grid_towers VALUES (1, 357, 'm13', 'minor', 13.396841, 46.499459999999999, 713, 13.11876, 'scrub', 'n2419588831');
INSERT INTO grid_towers VALUES (1, 358, 'm13', 'minor', 13.399687, 46.499594000000002, 707, 13.1008, 'scrub', 'n2419588833');
INSERT INTO grid_towers VALUES (1, 359, 'm13', 'minor', 13.394735000000001, 46.499594000000002, 702, 11.582789999999999, 'scrub', 'n2419588836');
INSERT INTO grid_towers VALUES (1, 360, 'm12', 'minor', 13.371803, 46.499710999999998, 703, 22.63374, 'meadow', 'n2419588838');
INSERT INTO grid_towers VALUES (1, 361, 'm12', 'minor', 13.392752, 46.499724999999998, 690, 9.1201799999999995, 'scrub', 'n2419588841');
INSERT INTO grid_towers VALUES (1, 362, 'm15', 'minor', 13.402870999999999, 46.499782000000003, 726, 12.52816, 'scrub', 'n2419588843');
INSERT INTO grid_towers VALUES (1, 363, 'm15', 'minor', 13.404657, 46.499839000000001, 739, 12.887460000000001, 'scrub', 'n2419588846');
INSERT INTO grid_towers VALUES (1, 364, 'm12', 'minor', 13.390715, 46.499862, 663, 3.2763599999999999, 'scrub', 'n2419588849');
INSERT INTO grid_towers VALUES (1, 366, 'm15', 'minor', 13.408003000000001, 46.499954000000002, 680, 4.4819599999999999, 'scrub', 'n2419588857');
INSERT INTO grid_towers VALUES (1, 367, 'm12', 'minor', 13.389037, 46.499969, 659, 3.2617799999999999, 'scrub', 'n2419588859');
INSERT INTO grid_towers VALUES (1, 368, 'm15', 'minor', 13.410054000000001, 46.500024000000003, 677, 3.55844, 'scrub', 'n2419588861');
INSERT INTO grid_towers VALUES (1, 369, 'm15', 'minor', 13.412046, 46.500081999999999, 681, 3.4610300000000001, 'scrub', 'n2419588864');
INSERT INTO grid_towers VALUES (1, 370, 'm12', 'minor', 13.386748000000001, 46.500115000000001, 658, 3.01451, 'scrub', 'n2419588867');
INSERT INTO grid_towers VALUES (1, 371, 'm17', 'minor', 13.414296999999999, 46.500131000000003, 690, 3.9924599999999999, 'meadow', 'n2419588869');
INSERT INTO grid_towers VALUES (1, 372, 'm17', 'minor', 13.416334000000001, 46.500174999999999, 692, 4.4624300000000003, 'meadow', 'n2419588872');
INSERT INTO grid_towers VALUES (1, 373, 'm17', 'minor', 13.418414, 46.500225999999998, 693, 5.4484700000000004, 'forest', 'n2419588875');
INSERT INTO grid_towers VALUES (1, 375, 'm12', 'minor', 13.382932, 46.500351000000002, 653, 2.84456, 'scrub', 'n2419588879');
INSERT INTO grid_towers VALUES (1, 376, 'm12', 'minor', 13.381608, 46.500436999999998, 653, 2.84456, 'scrub', 'n2419588885');
INSERT INTO grid_towers VALUES (1, 377, 'm12', 'minor', 13.379467999999999, 46.500573000000003, 658, 3.64567, 'grassland', 'n2419588890');
INSERT INTO grid_towers VALUES (1, 378, 'm14', 'minor', 13.401135, 46.500611999999997, 667, 5.9956100000000001, 'scrub', 'n2419588893');
INSERT INTO grid_towers VALUES (1, 379, 'm16', 'minor', 13.412191, 46.500701999999997, 681, 3.4610300000000001, 'scrub', 'n2419588895');
INSERT INTO grid_towers VALUES (1, 380, 'm12', 'minor', 13.37106, 46.500743, 646, 9.0374099999999995, 'grassland', 'n2419588902');
INSERT INTO grid_towers VALUES (1, 381, 'm18', 'minor', 13.420021999999999, 46.500745999999999, 698, 8.8973499999999994, 'NA', 'n2419588905');
INSERT INTO grid_towers VALUES (1, 382, 'm16', 'minor', 13.412297000000001, 46.501190000000001, 681, 3.4610300000000001, 'NA', 'n2419588908');
INSERT INTO grid_towers VALUES (1, 383, 'm14', 'minor', 13.400674, 46.50121, 667, 5.9956100000000001, 'NA', 'n2419588910');
INSERT INTO grid_towers VALUES (1, 385, 'm12', 'minor', 13.377485999999999, 46.501314000000001, 656, 4.6386700000000003, 'grassland', 'n2419588919');
INSERT INTO grid_towers VALUES (1, 386, 'm24', 'minor', 13.486903, 46.501404000000001, 780, 1.3304199999999999, 'meadow', 'n2419588924');
INSERT INTO grid_towers VALUES (1, 387, 'm12', 'minor', 13.375957, 46.501407999999998, 651, 5.4568000000000003, 'grassland', 'n2419588926');
INSERT INTO grid_towers VALUES (1, 388, 'm18', 'minor', 13.430376000000001, 46.501435000000001, 788, 15.64517, 'forest', 'n2419588929');
INSERT INTO grid_towers VALUES (1, 389, 'm12', 'minor', 13.373957000000001, 46.501528999999998, 646, 6.6704499999999998, 'grassland', 'n2419588931');
INSERT INTO grid_towers VALUES (1, 390, 'm12', 'minor', 13.371892000000001, 46.501660000000001, 646, 9.0374099999999995, 'grassland', 'n2419588933');
INSERT INTO grid_towers VALUES (1, 391, 'm18', 'minor', 13.422910999999999, 46.501676000000003, 771, 16.748159999999999, 'meadow', 'n2419588936');
INSERT INTO grid_towers VALUES (1, 392, 'm14', 'minor', 13.399127999999999, 46.501860000000001, 657, 6.0457400000000003, 'NA', 'n2419588938');
INSERT INTO grid_towers VALUES (1, 394, 'm12', 'minor', 13.370288, 46.502046, 631, 1.3383100000000001, 'grassland', 'n2419588943');
INSERT INTO grid_towers VALUES (1, 395, 'm18', 'minor', 13.424302000000001, 46.502124999999999, 724, 10.27031, 'NA', 'n2419588946');
INSERT INTO grid_towers VALUES (1, 396, 'm14', 'minor', 13.398225999999999, 46.502240999999998, 659, 8.6292299999999997, 'NA', 'n2419588948');
INSERT INTO grid_towers VALUES (1, 397, 'm18', 'minor', 13.427021, 46.502395, 722, 14.03181, 'NA', 'n2419588951');
INSERT INTO grid_towers VALUES (1, 398, 'm11', 'minor', 13.370074000000001, 46.502555999999998, 631, 1.3383100000000001, 'grassland', 'n2419588953');
INSERT INTO grid_towers VALUES (1, 399, 'm14', 'minor', 13.397435, 46.502569000000001, 655, 6.2764100000000003, 'NA', 'n2419588956');
INSERT INTO grid_towers VALUES (1, 400, 'm14', 'minor', 13.402677000000001, 46.50264, 687, 15.083600000000001, 'NA', 'n2419588961');
INSERT INTO grid_towers VALUES (1, 402, 'm14', 'minor', 13.403231999999999, 46.502884999999999, 687, 15.083600000000001, 'NA', 'n2419588966');
INSERT INTO grid_towers VALUES (1, 403, 'm14', 'minor', 13.404477999999999, 46.502890000000001, 687, 17.159279999999999, 'NA', 'n2419588967');
INSERT INTO grid_towers VALUES (1, 404, 'm14', 'minor', 13.396625999999999, 46.502901000000001, 655, 6.2764100000000003, 'NA', 'n2419588968');
INSERT INTO grid_towers VALUES (1, 405, 'm18', 'minor', 13.428841, 46.502913999999997, 722, 14.03181, 'NA', 'n2419588969');
INSERT INTO grid_towers VALUES (1, 406, 'm14', 'minor', 13.403902, 46.502916999999997, 687, 15.083600000000001, 'NA', 'n2419588971');
INSERT INTO grid_towers VALUES (1, 407, 'm16', 'minor', 13.412723, 46.502979000000003, 677, 5.46286, 'NA', 'n2419588973');
INSERT INTO grid_towers VALUES (1, 408, 'm24', 'minor', 13.485962000000001, 46.502988000000002, 784, 1.5903799999999999, 'forest', 'n2419588976');
INSERT INTO grid_towers VALUES (1, 409, 'm14', 'minor', 13.405682000000001, 46.502988999999999, 687, 17.159279999999999, 'NA', 'n2419588978');
INSERT INTO grid_towers VALUES (1, 411, 'm14', 'minor', 13.405837, 46.503041000000003, 687, 17.159279999999999, 'NA', 'n2419588985');
INSERT INTO grid_towers VALUES (1, 412, 'm14', 'minor', 13.396355, 46.503324999999997, 655, 6.2764100000000003, 'NA', 'n2419588987');
INSERT INTO grid_towers VALUES (1, 413, 'm19', 'minor', 13.431155, 46.503414999999997, 715, 10.138719999999999, 'meadow', 'n2419588990');
INSERT INTO grid_towers VALUES (1, 414, 'm11', 'minor', 13.365005999999999, 46.503490999999997, 668, 7.8867700000000003, 'wood', 'n2419588993');
INSERT INTO grid_towers VALUES (1, 415, 'm11', 'minor', 13.366951, 46.503539000000004, 648, 5.4856600000000002, 'wood', 'n2419588995');
INSERT INTO grid_towers VALUES (1, 416, 'm19', 'minor', 13.433453999999999, 46.503672000000002, 713, 12.36506, 'meadow', 'n2419588998');
INSERT INTO grid_towers VALUES (1, 417, 'm14', 'minor', 13.396471, 46.503810000000001, 655, 6.2764100000000003, 'NA', 'n2419589000');
INSERT INTO grid_towers VALUES (1, 418, 'm11', 'minor', 13.363906, 46.504125999999999, 651, 6.8112300000000001, 'wood', 'n2419589009');
INSERT INTO grid_towers VALUES (1, 420, 'm20', 'minor', 13.441694, 46.504305000000002, 721, 4.6864800000000004, 'NA', 'n2419589014');
INSERT INTO grid_towers VALUES (1, 421, 'm19', 'minor', 13.439999, 46.504387999999999, 723, 2.9470000000000001, 'NA', 'n2419589016');
INSERT INTO grid_towers VALUES (1, 422, 'm24', 'minor', 13.485039, 46.504576, 794, 9.1331500000000005, 'forest', 'n2419589025');
INSERT INTO grid_towers VALUES (1, 423, 'm20', 'minor', 13.444016, 46.504610999999997, 723, 8.3096399999999999, 'meadow', 'n2419589029');
INSERT INTO grid_towers VALUES (1, 424, 'm16', 'minor', 13.413948, 46.504747999999999, 728, 18.414090000000002, 'NA', 'n2419589033');
INSERT INTO grid_towers VALUES (1, 425, 'm11', 'minor', 13.362761000000001, 46.504778999999999, 651, 6.8112300000000001, 'wood', 'n2419589037');
INSERT INTO grid_towers VALUES (1, 426, 'm14', 'minor', 13.396837, 46.504826000000001, 689, 8.4530200000000004, 'NA', 'n2419589045');
INSERT INTO grid_towers VALUES (1, 428, 'm22', 'minor', 13.449968, 46.504891000000001, 754, 5.1113499999999998, 'meadow', 'n2419589052');
INSERT INTO grid_towers VALUES (1, 429, 'm20', 'minor', 13.447331999999999, 46.504962999999996, 736, 10.026059999999999, 'meadow', 'n2419589057');
INSERT INTO grid_towers VALUES (1, 430, 'm16', 'minor', 13.420583000000001, 46.505034999999999, 700, 6.7271299999999998, 'NA', 'n2419589062');
INSERT INTO grid_towers VALUES (1, 431, 'm22', 'minor', 13.451409, 46.505040000000001, 754, 5.1113499999999998, 'meadow', 'n2419589064');
INSERT INTO grid_towers VALUES (1, 432, 'm20', 'minor', 13.449274000000001, 46.505091, 742, 8.2648299999999999, 'NA', 'n2419589067');
INSERT INTO grid_towers VALUES (1, 433, 'm16', 'minor', 13.415934, 46.505223000000001, 707, 12.60534, 'NA', 'n2419589085');
INSERT INTO grid_towers VALUES (1, 434, 'm19', 'minor', 13.439895, 46.505239000000003, 723, 2.9470000000000001, 'forest', 'n2419589092');
INSERT INTO grid_towers VALUES (1, 435, 'm22', 'minor', 13.45345, 46.505254000000001, 761, 4.3938100000000002, 'meadow', 'n2419589095');
INSERT INTO grid_towers VALUES (1, 437, 'm16', 'minor', 13.416608, 46.505338000000002, 705, 8.9595000000000002, 'NA', 'n2419589104');
INSERT INTO grid_towers VALUES (1, 438, 'm16', 'minor', 13.417272000000001, 46.505451000000001, 705, 8.9595000000000002, 'NA', 'n2419589108');
INSERT INTO grid_towers VALUES (1, 440, 'm21', 'minor', 13.449688999999999, 46.505488, 742, 8.2648299999999999, 'meadow', 'n2419589115');
INSERT INTO grid_towers VALUES (1, 441, 'm24', 'minor', 13.484545000000001, 46.505496999999998, 794, 9.1331500000000005, 'forest', 'n2419589119');
INSERT INTO grid_towers VALUES (1, 442, 'm11', 'minor', 13.359935999999999, 46.505512000000003, 667, 9.8782899999999998, 'meadow', 'n2419589121');
INSERT INTO grid_towers VALUES (1, 443, 'm22', 'minor', 13.45556, 46.505567999999997, 774, 6.0251099999999997, 'forest', 'n2419589122');
INSERT INTO grid_towers VALUES (1, 444, 'm16', 'minor', 13.417973, 46.505589999999998, 705, 8.9595000000000002, 'NA', 'n2419589123');
INSERT INTO grid_towers VALUES (1, 445, 'm11', 'minor', 13.359971, 46.505611999999999, 667, 9.8782899999999998, 'meadow', 'n2419589126');
INSERT INTO grid_towers VALUES (1, 447, 'm21', 'minor', 13.450101999999999, 46.505887000000001, 754, 5.1113499999999998, 'meadow', 'n2419589131');
INSERT INTO grid_towers VALUES (1, 448, 'm24', 'minor', 13.484048, 46.505969999999998, 794, 9.1331500000000005, 'forest', 'n2419589170');
INSERT INTO grid_towers VALUES (1, 449, 'm21', 'minor', 13.453851, 46.506163000000001, 775, 7.1895600000000002, 'NA', 'n2419589175');
INSERT INTO grid_towers VALUES (1, 450, 'm11', 'minor', 13.355992000000001, 46.506214, 633, 6.4404700000000004, 'meadow', 'n2419589180');
INSERT INTO grid_towers VALUES (1, 451, 'm21', 'minor', 13.454800000000001, 46.50638, 766, 2.2387700000000001, 'NA', 'n2419589184');
INSERT INTO grid_towers VALUES (1, 452, 'm21', 'minor', 13.450635, 46.506402000000001, 749, 10.851139999999999, 'meadow', 'n2419589188');
INSERT INTO grid_towers VALUES (1, 453, 'm21', 'minor', 13.452491, 46.506428, 775, 7.1895600000000002, 'NA', 'n2419589192');
INSERT INTO grid_towers VALUES (1, 454, 'm24', 'minor', 13.484045, 46.506436999999998, 773, 1.4248400000000001, 'NA', 'n2419589196');
INSERT INTO grid_towers VALUES (1, 456, 'm10', 'minor', 13.352551999999999, 46.506723000000001, 632, 7.3229300000000004, 'meadow', 'n2419589205');
INSERT INTO grid_towers VALUES (1, 457, 'm21', 'minor', 13.451962999999999, 46.506926, 775, 7.1895600000000002, 'NA', 'n2419589209');
INSERT INTO grid_towers VALUES (1, 458, 'm10', 'minor', 13.351129, 46.506928000000002, 628, 8.9632199999999997, 'NA', 'n2419589212');
INSERT INTO grid_towers VALUES (1, 459, 'm11', 'minor', 13.354286999999999, 46.507117999999998, 633, 6.4404700000000004, 'scrub', 'n2419589214');
INSERT INTO grid_towers VALUES (1, 460, 'm11', 'minor', 13.354162000000001, 46.507134999999998, 633, 6.4404700000000004, 'meadow', 'n2419589219');
INSERT INTO grid_towers VALUES (1, 461, 'm10', 'minor', 13.349149000000001, 46.507218999999999, 627, 10.8226, 'NA', 'n2419589222');
INSERT INTO grid_towers VALUES (1, 462, 'm21', 'minor', 13.451916000000001, 46.507297999999999, 749, 10.851139999999999, 'NA', 'n2419589227');
INSERT INTO grid_towers VALUES (1, 463, 'm22', 'minor', 13.459303999999999, 46.507444, 765, 8.9181500000000007, 'meadow', 'n2419589230');
INSERT INTO grid_towers VALUES (1, 464, 'm10', 'minor', 13.347434, 46.507460000000002, 637, 13.57024, 'NA', 'n2419589235');
INSERT INTO grid_towers VALUES (1, 466, 'm24', 'minor', 13.482578, 46.507665000000003, 774, 6.40177, 'NA', 'n2419589249');
INSERT INTO grid_towers VALUES (1, 467, 'm10', 'minor', 13.322876000000001, 46.507933999999999, 660, 23.415839999999999, 'wood', 'n2419589252');
INSERT INTO grid_towers VALUES (1, 468, 'm10', 'minor', 13.346778, 46.508204999999997, 602, 3.4607600000000001, 'NA', 'n2419589262');
INSERT INTO grid_towers VALUES (1, 469, 'm22', 'minor', 13.461269, 46.508234000000002, 759, 3.5917300000000001, 'meadow', 'n2419589265');
INSERT INTO grid_towers VALUES (1, 470, 'm24', 'minor', 13.480721000000001, 46.508381, 784, 14.751519999999999, 'meadow', 'n2419589267');
INSERT INTO grid_towers VALUES (1, 471, 'm10', 'minor', 13.324678, 46.508496999999998, 583, 7.38544, 'wood', 'n2419589271');
INSERT INTO grid_towers VALUES (1, 472, 'm24', 'minor', 13.478413, 46.508561999999998, 774, 11.5831, 'meadow', 'n2419589285');
INSERT INTO grid_towers VALUES (1, 474, 'm22', 'minor', 13.475994, 46.508631999999999, 769, 6.4340400000000004, 'meadow', 'n2419589304');
INSERT INTO grid_towers VALUES (1, 475, 'm10', 'minor', 13.344573, 46.508690999999999, 600, 6.8636900000000001, 'NA', 'n2419589309');
INSERT INTO grid_towers VALUES (1, 476, 'm10', 'minor', 13.325165, 46.508698000000003, 589, 9.0127799999999993, 'wood', 'n2419589313');
INSERT INTO grid_towers VALUES (1, 477, 'm22', 'minor', 13.473502999999999, 46.508721999999999, 769, 2.21, 'meadow', 'n2419589314');
INSERT INTO grid_towers VALUES (1, 478, 'm22', 'minor', 13.463412999999999, 46.508732999999999, 763, 6.6036000000000001, 'meadow', 'n2419589315');
INSERT INTO grid_towers VALUES (1, 479, 'm10', 'minor', 13.325956, 46.508735999999999, 589, 9.0127799999999993, 'NA', 'n2419589318');
INSERT INTO grid_towers VALUES (1, 480, 'm22', 'minor', 13.471266, 46.508788000000003, 768, 1.05084, 'meadow', 'n2419589323');
INSERT INTO grid_towers VALUES (1, 481, 'm10', 'minor', 13.34337, 46.508791000000002, 601, 9.4152400000000007, 'NA', 'n2419589326');
INSERT INTO grid_towers VALUES (1, 483, 'm10', 'minor', 13.342205, 46.508887000000001, 601, 9.4152400000000007, 'NA', 'n2419589336');
INSERT INTO grid_towers VALUES (1, 484, 'm22', 'minor', 13.467466999999999, 46.508915000000002, 762, 4.99892, 'meadow', 'n2419589339');
INSERT INTO grid_towers VALUES (1, 485, 'm10', 'minor', 13.329893, 46.508952999999998, 610, 14.557729999999999, 'wood', 'n2419589352');
INSERT INTO grid_towers VALUES (1, 486, 'm22', 'minor', 13.465522999999999, 46.508989, 764, 7.7694200000000002, 'NA', 'n2419589360');
INSERT INTO grid_towers VALUES (1, 487, 'm10', 'minor', 13.330957, 46.509014000000001, 610, 14.557729999999999, 'wood', 'n2419589372');
INSERT INTO grid_towers VALUES (1, 488, 'm10', 'minor', 13.333097, 46.509134000000003, 621, 15.61321, 'wood', 'n2419589392');
INSERT INTO grid_towers VALUES (1, 489, 'm10', 'minor', 13.346263, 46.509135000000001, 602, 3.4607600000000001, 'NA', 'n2419589397');
INSERT INTO grid_towers VALUES (1, 491, 'm23', 'minor', 13.477948, 46.509338, 774, 11.5831, 'meadow', 'n2419589429');
INSERT INTO grid_towers VALUES (1, 492, 'm10', 'minor', 13.345999000000001, 46.509824000000002, 602, 3.4607600000000001, 'NA', 'n2419589444');
INSERT INTO grid_towers VALUES (1, 493, 'm22', 'minor', 13.468228999999999, 46.509915999999997, 762, 4.99892, 'NA', 'n2419589448');
INSERT INTO grid_towers VALUES (1, 494, 'm10', 'minor', 13.336618, 46.510018000000002, 623, 10.31794, 'NA', 'n2419589452');
INSERT INTO grid_towers VALUES (1, 495, 'm23', 'minor', 13.477275000000001, 46.510491000000002, 863, 26.33351, 'forest', 'n2419589456');
INSERT INTO grid_towers VALUES (1, 496, 'm10', 'minor', 13.338027, 46.510589000000003, 591, 8.3324499999999997, 'NA', 'n2419589459');
INSERT INTO grid_towers VALUES (1, 497, 'm23', 'minor', 13.476372, 46.511043000000001, 807, 18.32855, 'forest', 'n2419589481');
INSERT INTO grid_towers VALUES (1, 498, 'm10', 'minor', 13.345545, 46.511057999999998, 604, 16.513780000000001, 'NA', 'n2419589484');
INSERT INTO grid_towers VALUES (1, 499, 'm10', 'minor', 13.345523999999999, 46.511150999999998, 604, 16.513780000000001, 'NA', 'n2419589487');
INSERT INTO grid_towers VALUES (1, 501, 'm10', 'minor', 13.337915000000001, 46.512022000000002, 591, 8.3324499999999997, 'NA', 'n2419589504');
INSERT INTO grid_towers VALUES (1, 502, 'm10', 'minor', 13.335623, 46.512112999999999, 596, 5.60093, 'NA', 'n2419589508');
INSERT INTO grid_towers VALUES (1, 503, 'm23', 'minor', 13.474738, 46.512166000000001, 779, 9.2543399999999991, 'NA', 'n2419589512');
INSERT INTO grid_towers VALUES (1, 504, 'm10', 'minor', 13.332939, 46.512177999999999, 585, 4.7486100000000002, 'NA', 'n2419589517');
INSERT INTO grid_towers VALUES (1, 505, 'm10', 'minor', 13.335055000000001, 46.512340999999999, 594, 4.6012899999999997, 'NA', 'n2419589526');
INSERT INTO grid_towers VALUES (1, 506, 'm23', 'minor', 13.474676000000001, 46.512889000000001, 815, 19.92548, 'NA', 'n2419589529');
INSERT INTO grid_towers VALUES (1, 507, 'm23', 'minor', 13.473622000000001, 46.513235999999999, 815, 19.92548, 'NA', 'n2419589531');
INSERT INTO grid_towers VALUES (1, 509, 'm23', 'minor', 13.473572000000001, 46.515261000000002, 934, 26.078029999999998, 'forest', 'n2419589538');
INSERT INTO grid_towers VALUES (1, 510, 'm23', 'minor', 13.472189, 46.516770999999999, 979, 22.385739999999998, 'forest', 'n2419589541');
INSERT INTO grid_towers VALUES (1, 511, 'm23', 'minor', 13.471045999999999, 46.518017, 979, 22.385739999999998, 'forest', 'n2419589545');
INSERT INTO grid_towers VALUES (1, 512, 'm23', 'minor', 13.470853999999999, 46.519114000000002, 1039, 13.81906, 'forest', 'n2419589550');
INSERT INTO grid_towers VALUES (1, 513, 'm23', 'minor', 13.471315000000001, 46.520021, 1039, 13.81906, 'forest', 'n2419589554');
INSERT INTO grid_towers VALUES (1, 514, 'm23', 'minor', 13.473393, 46.521521, 1056, 16.238389999999999, 'forest', 'n2419589558');
INSERT INTO grid_towers VALUES (1, 515, 'm23', 'minor', 13.473798, 46.523453000000003, 1055, 10.877330000000001, 'forest', 'n2419589562');
INSERT INTO grid_towers VALUES (1, 517, 'm23', 'minor', 13.473965, 46.526766000000002, 1064, 3.3320099999999999, 'NA', 'n2419589570');
INSERT INTO grid_towers VALUES (1, 518, 'm23', 'minor', 13.472105000000001, 46.527520000000003, 1089, 2.52312, 'NA', 'n2419589585');
INSERT INTO grid_towers VALUES (1, 519, 'm23', 'minor', 13.470867999999999, 46.528275000000001, 1089, 2.52312, 'NA', 'n2419589596');
INSERT INTO grid_towers VALUES (1, 520, 'm23', 'minor', 13.469768999999999, 46.529283999999997, 1093, 2.9317500000000001, 'NA', 'n2419589610');
INSERT INTO grid_towers VALUES (1, 521, 'm23', 'minor', 13.469844, 46.530396000000003, 1093, 2.9317500000000001, 'meadow', 'n2419589615');
INSERT INTO grid_towers VALUES (1, 522, 'm23', 'minor', 13.469979, 46.532656000000003, 1095, 4.8450699999999998, 'forest', 'n2419589628');
INSERT INTO grid_towers VALUES (1, 524, 'm23', 'minor', 13.468674999999999, 46.534635000000002, 1111, 7.6985299999999999, 'forest', 'n2419589640');
INSERT INTO grid_towers VALUES (1, 525, 'm25', 'minor', 13.49235, 46.489328, 826, 4.7177499999999997, 'NA', 'n2420048774');
INSERT INTO grid_towers VALUES (1, 526, 'm25', 'minor', 13.492527000000001, 46.489801999999997, 813, 3.8475999999999999, 'NA', 'n2420048776');
INSERT INTO grid_towers VALUES (1, 527, 'm25', 'minor', 13.492715, 46.490054000000001, 813, 3.8475999999999999, 'NA', 'n2420048777');
INSERT INTO grid_towers VALUES (1, 528, 'm25', 'minor', 13.492951, 46.490848999999997, 813, 3.8475999999999999, 'NA', 'n2420048778');
INSERT INTO grid_towers VALUES (1, 530, 'm25', 'minor', 13.493429000000001, 46.491985999999997, 805, 2.8091200000000001, 'NA', 'n2420048782');
INSERT INTO grid_towers VALUES (1, 531, 'm25', 'minor', 13.493627, 46.492488999999999, 814, 6.6752399999999996, 'NA', 'n2420048784');
INSERT INTO grid_towers VALUES (1, 532, 'm25', 'minor', 13.493845, 46.493040000000001, 814, 6.6752399999999996, 'NA', 'n2420048785');
INSERT INTO grid_towers VALUES (1, 533, 'm25', 'minor', 13.494517999999999, 46.493445000000001, 814, 6.6752399999999996, 'NA', 'n2420048787');
INSERT INTO grid_towers VALUES (1, 534, 'm25', 'minor', 13.494983, 46.493749999999999, 801, 3.4794200000000002, 'meadow', 'n2420048788');
INSERT INTO grid_towers VALUES (1, 535, 'm25', 'minor', 13.496274, 46.494517999999999, 804, 7.9739300000000002, 'NA', 'n2420048791');
INSERT INTO grid_towers VALUES (1, 536, 'm25', 'minor', 13.497558, 46.495184999999999, 804, 7.9739300000000002, 'NA', 'n2420048793');
INSERT INTO grid_towers VALUES (1, 538, 'm25', 'minor', 13.499098999999999, 46.496085000000001, 796, 4.7436100000000003, 'NA', 'n2420048795');
INSERT INTO grid_towers VALUES (1, 539, 'm25', 'minor', 13.501613000000001, 46.496088, 802, 11.233750000000001, 'forest', 'n2420048796');
INSERT INTO grid_towers VALUES (1, 540, 'm25', 'minor', 13.499907, 46.496492000000003, 802, 11.233750000000001, 'NA', 'n2420048798');
INSERT INTO grid_towers VALUES (1, 541, 'm25', 'minor', 13.501711999999999, 46.499045000000002, 793, 4.0705200000000001, 'NA', 'n2420048800');
INSERT INTO grid_towers VALUES (1, 542, 'm25', 'minor', 13.502129, 46.499608000000002, 817, 8.0339299999999998, 'NA', 'n2420048801');
INSERT INTO grid_towers VALUES (1, 543, 'm25', 'minor', 13.502511999999999, 46.500126000000002, 797, 3.2450800000000002, 'NA', 'n2420048802');
INSERT INTO grid_towers VALUES (1, 544, 'm26', 'minor', 13.500885999999999, 46.500653, 785, 2.8679399999999999, 'NA', 'n2420048803');
INSERT INTO grid_towers VALUES (1, 546, 'm26', 'minor', 13.503453, 46.501398000000002, 797, 3.2450800000000002, 'NA', 'n2420048805');
INSERT INTO grid_towers VALUES (1, 547, 'm26', 'minor', 13.505155999999999, 46.501820000000002, 818, 6.6100000000000003, 'NA', 'n2420048806');
INSERT INTO grid_towers VALUES (1, 548, 'm26', 'minor', 13.506778000000001, 46.502212999999998, 799, 0.78261000000000003, 'NA', 'n2420048807');
INSERT INTO grid_towers VALUES (1, 549, 'm26', 'minor', 13.508124, 46.502535000000002, 799, 0.78261000000000003, 'NA', 'n2420048808');
INSERT INTO grid_towers VALUES (1, 550, 'm26', 'minor', 13.50916, 46.502780000000001, 801, 4.0686499999999999, 'NA', 'n2420048809');
INSERT INTO grid_towers VALUES (1, 551, 'm26', 'minor', 13.510585000000001, 46.503301999999998, 807, 9.7920400000000001, 'NA', 'n2420048810');
INSERT INTO grid_towers VALUES (1, 552, 'm26', 'minor', 13.51257, 46.503700000000002, 824, 17.046749999999999, 'NA', 'n2420048811');
INSERT INTO grid_towers VALUES (1, 553, 'm26', 'minor', 13.514635999999999, 46.504108000000002, 806, 3.2966500000000001, 'NA', 'n2420048812');
INSERT INTO grid_towers VALUES (1, 555, 'm26', 'minor', 13.518587, 46.504897, 810, 6.95566, 'NA', 'n2420048814');
INSERT INTO grid_towers VALUES (1, 556, 'm26', 'minor', 13.519311, 46.505682999999998, 812, 9.8040599999999998, 'forest', 'n2420048815');
INSERT INTO grid_towers VALUES (1, 557, 'm26', 'minor', 13.520576, 46.506132000000001, 820, 7.6672700000000003, 'meadow', 'n2420048816');
INSERT INTO grid_towers VALUES (1, 558, 'm26', 'minor', 13.521849, 46.506583999999997, 813, 3.52969, 'meadow', 'n2420048821');
INSERT INTO grid_towers VALUES (1, 559, 'm26', 'minor', 13.52328, 46.506698999999998, 809, 0.18038999999999999, 'meadow', 'n2420048822');
INSERT INTO grid_towers VALUES (1, 560, 'm26', 'minor', 13.524875, 46.506822, 803, 3.0189300000000001, 'meadow', 'n2420048824');
INSERT INTO grid_towers VALUES (1, 562, 'm26', 'minor', 13.522309999999999, 46.506965999999998, 813, 3.52969, 'meadow', 'n2420048827');
INSERT INTO grid_towers VALUES (1, 563, 'm26', 'minor', 13.527981, 46.507063000000002, 800, 6.1367399999999996, 'meadow', 'n2420048828');
INSERT INTO grid_towers VALUES (1, 564, 'm26', 'minor', 13.541574000000001, 46.507080999999999, 819, 3.8967399999999999, 'meadow', 'n2420048829');
INSERT INTO grid_towers VALUES (1, 565, 'm26', 'minor', 13.529773, 46.507201999999999, 803, 8.0604600000000008, 'scrub', 'n2420048830');
INSERT INTO grid_towers VALUES (1, 566, 'm26', 'minor', 13.530976000000001, 46.507297999999999, 803, 8.0604600000000008, 'meadow', 'n2420048831');
INSERT INTO grid_towers VALUES (1, 567, 'm26', 'minor', 13.539268, 46.507314000000001, 815, 5.1836399999999996, 'meadow', 'n2420048832');
INSERT INTO grid_towers VALUES (1, 568, 'm26', 'minor', 13.532282, 46.507401000000002, 802, 7.6427300000000002, 'meadow', 'n2420048833');
INSERT INTO grid_towers VALUES (1, 569, 'm26', 'minor', 13.522887000000001, 46.507446000000002, 809, 0.18038999999999999, 'NA', 'n2420048834');
INSERT INTO grid_towers VALUES (1, 571, 'm26', 'minor', 13.523304, 46.507787999999998, 809, 0.18038999999999999, 'NA', 'n2420048836');
INSERT INTO grid_towers VALUES (1, 572, 'm26', 'minor', 13.531917999999999, 46.507939999999998, 802, 7.6427300000000002, 'meadow', 'n2420048837');
INSERT INTO grid_towers VALUES (1, 573, 'm26', 'minor', 13.541919999999999, 46.508170999999997, 819, 3.8967399999999999, 'NA', 'n2420048838');
INSERT INTO grid_towers VALUES (1, 574, 'm26', 'minor', 13.531549, 46.508422000000003, 807, 2.4742099999999998, 'meadow', 'n2420048839');
INSERT INTO grid_towers VALUES (1, 575, 'm26', 'minor', 13.542107, 46.508761999999997, 807, 0.65039000000000002, 'NA', 'n2420048840');
INSERT INTO grid_towers VALUES (1, 576, 'm26', 'minor', 13.540214000000001, 46.509011999999998, 808, 0.34171000000000001, 'NA', 'n2420048842');
INSERT INTO grid_towers VALUES (1, 577, 'm26', 'minor', 13.539182, 46.509059999999998, 807, 0.94438999999999995, 'NA', 'n2420048843');
INSERT INTO grid_towers VALUES (1, 578, 'm26', 'minor', 13.538397, 46.509062, 807, 0.94438999999999995, 'NA', 'n2420048844');
INSERT INTO grid_towers VALUES (1, 579, 'm26', 'minor', 13.537020999999999, 46.509126999999999, 806, 1.39568, 'NA', 'n2420048845');
INSERT INTO grid_towers VALUES (1, 581, 'm26', 'minor', 13.541781, 46.509307, 807, 0.65039000000000002, 'NA', 'n2420048848');
INSERT INTO grid_towers VALUES (1, 582, 'm26', 'minor', 13.542876, 46.509771999999998, 807, 0.65039000000000002, 'NA', 'n2420048857');
INSERT INTO grid_towers VALUES (1, 583, 'm26', 'minor', 13.542559000000001, 46.510778000000002, 816, 13.078099999999999, 'NA', 'n2420048858');
INSERT INTO grid_towers VALUES (1, 584, 'm1', 'minor', 13.298048, 46.459479000000002, 458, 3.9336600000000002, 'NA', 'n2420100689');
INSERT INTO grid_towers VALUES (1, 585, 'm1', 'minor', 13.301448000000001, 46.459646999999997, 456, 5.4913400000000001, 'wood', 'n2420100693');
INSERT INTO grid_towers VALUES (1, 586, 'm1', 'minor', 13.301909, 46.459705999999997, 456, 5.4913400000000001, 'wood', 'n2420100695');
INSERT INTO grid_towers VALUES (1, 587, 'm1', 'minor', 13.300481, 46.459735999999999, 456, 5.4913400000000001, 'wood', 'n2420100698');
INSERT INTO grid_towers VALUES (1, 589, 'm1', 'minor', 13.298690000000001, 46.460349999999998, 517, 21.29391, 'wood', 'n2420100704');
INSERT INTO grid_towers VALUES (1, 590, 'm1', 'minor', 13.297178000000001, 46.460799000000002, 476, 8.6122099999999993, 'NA', 'n2420100707');
INSERT INTO grid_towers VALUES (1, 591, 'm1', 'minor', 13.295362000000001, 46.461472999999998, 495, 11.976509999999999, 'wood', 'n2420100708');
INSERT INTO grid_towers VALUES (1, 592, 'm1', 'minor', 13.295925, 46.461548000000001, 476, 8.6122099999999993, 'NA', 'n2420100709');
INSERT INTO grid_towers VALUES (1, 593, 'm1', 'minor', 13.296378000000001, 46.461604999999999, 476, 8.6122099999999993, 'NA', 'n2420100710');
INSERT INTO grid_towers VALUES (1, 594, 'm2', 'minor', 13.295256999999999, 46.462710999999999, 492, 7.29718, 'NA', 'n2420100713');
INSERT INTO grid_towers VALUES (1, 595, 'm2', 'minor', 13.294923000000001, 46.464106000000001, 492, 7.29718, 'NA', 'n2420100714');
INSERT INTO grid_towers VALUES (1, 596, 'm2', 'minor', 13.294688000000001, 46.465040999999999, 506, 8.7824000000000009, 'NA', 'n2420100716');
INSERT INTO grid_towers VALUES (1, 598, 'm2', 'minor', 13.295233, 46.466960999999998, 489, 8.4565300000000008, 'wood', 'n2420100722');
INSERT INTO grid_towers VALUES (1, 599, 'm2', 'minor', 13.295000999999999, 46.468226999999999, 489, 8.4565300000000008, 'wood', 'n2420100723');
INSERT INTO grid_towers VALUES (1, 600, 'm2', 'minor', 13.295401, 46.469315000000002, 499, 7.2766099999999998, 'wood', 'n2420100725');
INSERT INTO grid_towers VALUES (1, 601, 'm2', 'minor', 13.294978, 46.469968000000001, 499, 7.2766099999999998, 'wood', 'n2420100727');
INSERT INTO grid_towers VALUES (1, 602, 'm2', 'minor', 13.294876, 46.470996999999997, 498, 7.4025299999999996, 'wood', 'n2420100729');
INSERT INTO grid_towers VALUES (1, 603, 'm3', 'minor', 13.294881, 46.472434999999997, 498, 7.4025299999999996, 'wood', 'n2420100730');
INSERT INTO grid_towers VALUES (1, 604, 'm3', 'minor', 13.295802999999999, 46.473343999999997, 556, 21.16253, 'wood', 'n2420100732');
INSERT INTO grid_towers VALUES (1, 605, 'm3', 'minor', 13.296383000000001, 46.473914000000001, 556, 21.16253, 'wood', 'n2420100733');
INSERT INTO grid_towers VALUES (1, 607, 'm3', 'minor', 13.297751, 46.476427999999999, 503, 8.7009000000000007, 'meadow', 'n2420100737');
INSERT INTO grid_towers VALUES (1, 1, 'Hh1', '132k', 13.292156, 46.467632000000002, 574, 25.369450000000001, 'wood', 'n748572156');
INSERT INTO grid_towers VALUES (1, 609, 'm3', 'minor', 13.298749000000001, 46.478951000000002, 523, 7.5126900000000001, 'residential', 'n2420100742');
INSERT INTO grid_towers VALUES (1, 610, 'm3', 'minor', 13.297307, 46.479695, 552, 15.78928, 'meadow', 'n2420100743');
INSERT INTO grid_towers VALUES (1, 611, 'm4', 'minor', 13.300708999999999, 46.482802, 536, 11.32333, 'wood', 'n2420100747');
INSERT INTO grid_towers VALUES (1, 612, 'm4', 'minor', 13.30105, 46.483699000000001, 537, 11.43628, 'wood', 'n2420100749');
INSERT INTO grid_towers VALUES (1, 613, 'm4', 'minor', 13.300908, 46.484909999999999, 537, 11.43628, 'wood', 'n2420100755');
INSERT INTO grid_towers VALUES (1, 614, 'm4', 'minor', 13.301054000000001, 46.486131999999998, 544, 11.11525, 'meadow', 'n2420100759');
INSERT INTO grid_towers VALUES (1, 615, 'm4', 'minor', 13.301225000000001, 46.487547999999997, 537, 10.764010000000001, 'wood', 'n2420100763');
INSERT INTO grid_towers VALUES (1, 617, 'm4', 'minor', 13.301145999999999, 46.488844, 537, 10.764010000000001, 'wood', 'n2420100768');
INSERT INTO grid_towers VALUES (1, 618, 'm4', 'minor', 13.302018, 46.489814000000003, 595, 18.973849999999999, 'meadow', 'n2420100772');
INSERT INTO grid_towers VALUES (1, 619, 'm4', 'minor', 13.302633999999999, 46.491422, 595, 18.973849999999999, 'wood', 'n2420100780');
INSERT INTO grid_towers VALUES (1, 620, 'm4', 'minor', 13.303144, 46.492694, 603, 18.056470000000001, 'wood', 'n2420100783');
INSERT INTO grid_towers VALUES (1, 621, 'm4', 'minor', 13.302569, 46.493862999999997, 634, 20.130649999999999, 'wood', 'n2420100787');
INSERT INTO grid_towers VALUES (1, 622, 'm4', 'minor', 13.301659000000001, 46.495728, 549, 4.02637, 'wood', 'n2420100801');
INSERT INTO grid_towers VALUES (1, 623, 'm4', 'minor', 13.300716, 46.496783999999998, 549, 4.02637, 'NA', 'n2420100803');
INSERT INTO grid_towers VALUES (1, 624, 'm7', 'minor', 13.269169, 46.507140999999997, 876, 6.43872, 'meadow', 'n2420100846');
INSERT INTO grid_towers VALUES (1, 626, 'm7', 'minor', 13.273066999999999, 46.507522000000002, 870, 14.893219999999999, 'meadow', 'n2420100848');
INSERT INTO grid_towers VALUES (1, 627, 'm7', 'minor', 13.275449, 46.507752000000004, 854, 18.93609, 'meadow', 'n2420100849');
INSERT INTO grid_towers VALUES (1, 628, 'm5', 'minor', 13.303890000000001, 46.507841999999997, 571, 5.0102799999999998, 'NA', 'n2420100850');
INSERT INTO grid_towers VALUES (1, 629, 'm5', 'minor', 13.303732, 46.507987, 571, 5.0102799999999998, 'NA', 'n2420100851');
INSERT INTO grid_towers VALUES (1, 630, 'm5', 'minor', 13.304309, 46.508077, 569, 3.4367299999999998, 'NA', 'n2420100852');
INSERT INTO grid_towers VALUES (1, 631, 'm5', 'minor', 13.303291, 46.508156, 571, 5.0102799999999998, 'NA', 'n2420100854');
INSERT INTO grid_towers VALUES (1, 632, 'm7', 'minor', 13.273296, 46.508284000000003, 831, 8.1009399999999996, 'meadow', 'n2420100855');
INSERT INTO grid_towers VALUES (1, 633, 'm5', 'minor', 13.302928, 46.508290000000002, 586, 4.23081, 'NA', 'n2420100856');
INSERT INTO grid_towers VALUES (1, 635, 'm7', 'minor', 13.277165999999999, 46.508645000000001, 796, 10.913819999999999, 'meadow', 'n2420100858');
INSERT INTO grid_towers VALUES (1, 636, 'm5', 'minor', 13.30134, 46.508988000000002, 584, 9.8137299999999996, 'NA', 'n2420100859');
INSERT INTO grid_towers VALUES (1, 637, 'm7', 'minor', 13.278223000000001, 46.509193000000003, 796, 10.913819999999999, 'meadow', 'n2420100860');
INSERT INTO grid_towers VALUES (1, 638, 'm5', 'minor', 13.300874, 46.509971, 584, 9.8137299999999996, 'NA', 'n2420100861');
INSERT INTO grid_towers VALUES (1, 639, 'm7', 'minor', 13.279923, 46.510081999999997, 783, 13.76707, 'NA', 'n2420100862');
INSERT INTO grid_towers VALUES (1, 640, 'm7', 'minor', 13.282194, 46.510598999999999, 724, 7.6394299999999999, 'NA', 'n2420100863');
INSERT INTO grid_towers VALUES (1, 641, 'm5', 'minor', 13.300361000000001, 46.511015, 617, 6.1405799999999999, 'forest', 'n2420100864');
INSERT INTO grid_towers VALUES (1, 642, 'm7', 'minor', 13.284490999999999, 46.511764999999997, 738, 14.201230000000001, 'NA', 'n2420100865');
INSERT INTO grid_towers VALUES (1, 644, 'm7', 'minor', 13.283493999999999, 46.512127999999997, 738, 14.201230000000001, 'NA', 'n2420100868');
INSERT INTO grid_towers VALUES (1, 645, 'm5', 'minor', 13.299802, 46.512250999999999, 601, 7.7429300000000003, 'forest', 'n2420100871');
INSERT INTO grid_towers VALUES (1, 646, 'm5', 'minor', 13.299105000000001, 46.513049000000002, 665, 8.2620199999999997, 'forest', 'n2420100872');
INSERT INTO grid_towers VALUES (1, 647, 'm7', 'minor', 13.284779, 46.513762999999997, 694, 3.3752, 'wood', 'n2420100873');
INSERT INTO grid_towers VALUES (1, 648, 'm5', 'minor', 13.298401999999999, 46.513897, 665, 8.2620199999999997, 'forest', 'n2420100874');
INSERT INTO grid_towers VALUES (1, 649, 'm7', 'minor', 13.285544, 46.514733, 698, 7.0818399999999997, 'wood', 'n2420100876');
INSERT INTO grid_towers VALUES (1, 651, 'm5', 'minor', 13.297338, 46.515174000000002, 694, 7.45167, 'wood', 'n2420100878');
INSERT INTO grid_towers VALUES (1, 652, 'm6', 'minor', 13.293682, 46.515269000000004, 672, 7.1958200000000003, 'forest', 'n2420100879');
INSERT INTO grid_towers VALUES (1, 653, 'm7', 'minor', 13.286163, 46.515520000000002, 698, 7.0818399999999997, 'wood', 'n2420100880');
INSERT INTO grid_towers VALUES (1, 654, 'm9', 'minor', 13.299018999999999, 46.515751000000002, 688, 7.0250599999999999, 'forest', 'n2420100884');
INSERT INTO grid_towers VALUES (1, 655, 'm6', 'minor', 13.290603000000001, 46.515979999999999, 661, 13.427339999999999, 'wood', 'n2420100885');
INSERT INTO grid_towers VALUES (1, 656, 'm9', 'minor', 13.300034999999999, 46.516134999999998, 643, 5.8101700000000003, 'forest', 'n2420100886');
INSERT INTO grid_towers VALUES (1, 657, 'm6', 'minor', 13.289661000000001, 46.516196000000001, 661, 13.427339999999999, 'wood', 'n2420100887');
INSERT INTO grid_towers VALUES (1, 658, 'm7', 'minor', 13.288093, 46.516258999999998, 672, 11.13578, 'wood', 'n2420100888');
INSERT INTO grid_towers VALUES (1, 660, 'm9', 'minor', 13.298923, 46.516435999999999, 688, 7.0250599999999999, 'forest', 'n2420100891');
INSERT INTO grid_towers VALUES (1, 661, 'm8', 'minor', 13.289130999999999, 46.517170999999998, 638, 2.0136599999999998, 'NA', 'n2420100892');
INSERT INTO grid_towers VALUES (1, 662, 'm8', 'minor', 13.288366999999999, 46.517530999999998, 638, 2.0136599999999998, 'NA', 'n2420100893');
INSERT INTO grid_towers VALUES (1, 663, 'm8', 'minor', 13.288835000000001, 46.517583000000002, 638, 2.0136599999999998, 'NA', 'n2420100894');
INSERT INTO grid_towers VALUES (1, 664, 'm8', 'minor', 13.288187000000001, 46.517868999999997, 638, 2.0136599999999998, 'NA', 'n2420100895');
INSERT INTO grid_towers VALUES (1, 665, 'm9', 'minor', 13.298586999999999, 46.517921000000001, 701, 10.36702, 'forest', 'n2420100896');
INSERT INTO grid_towers VALUES (1, 666, 'm8', 'minor', 13.287329, 46.517969000000001, 648, 6.5844899999999997, 'NA', 'n2420100897');
INSERT INTO grid_towers VALUES (1, 667, 'm8', 'minor', 13.286365999999999, 46.518087000000001, 648, 6.5844899999999997, 'NA', 'n2420100898');
INSERT INTO grid_towers VALUES (1, 669, 'm8', 'minor', 13.281069, 46.518711000000003, 649, 3.6126100000000001, 'wood', 'n2420100900');
INSERT INTO grid_towers VALUES (1, 670, 'm8', 'minor', 13.279299, 46.518971000000001, 649, 3.6126100000000001, 'NA', 'n2420100901');
INSERT INTO grid_towers VALUES (1, 671, 'm9', 'minor', 13.298348000000001, 46.519036999999997, 756, 19.447510000000001, 'meadow', 'n2420100902');
INSERT INTO grid_towers VALUES (1, 672, 'm8', 'minor', 13.278454999999999, 46.519095, 647, 9.0762400000000003, 'NA', 'n2420100903');
INSERT INTO grid_towers VALUES (1, 673, 'm8', 'minor', 13.277561, 46.519227999999998, 647, 9.0762400000000003, 'NA', 'n2420100904');
INSERT INTO grid_towers VALUES (1, 674, 'm8', 'minor', 13.276667, 46.519663000000001, 669, 12.64992, 'NA', 'n2420100905');
INSERT INTO grid_towers VALUES (1, 675, 'm8', 'minor', 13.275753999999999, 46.520108999999998, 669, 12.64992, 'NA', 'n2420100906');
INSERT INTO grid_towers VALUES (1, 676, 'm9', 'minor', 13.299268, 46.520302000000001, 756, 19.447510000000001, 'forest', 'n2420100907');
INSERT INTO grid_towers VALUES (1, 677, 'm8', 'minor', 13.273293000000001, 46.520791000000003, 667, 14.56104, 'NA', 'n2420100908');
INSERT INTO grid_towers VALUES (1, 679, 'm9', 'minor', 13.299538999999999, 46.521473, 844, 19.687850000000001, 'forest', 'n2420100910');
INSERT INTO grid_towers VALUES (1, 680, 'm9', 'minor', 13.299639000000001, 46.522171999999998, 844, 19.687850000000001, 'forest', 'n2420100911');
INSERT INTO grid_towers VALUES (1, 681, 'm9', 'minor', 13.299583999999999, 46.522883, 830, 18.815180000000002, 'forest', 'n2420100912');
INSERT INTO grid_towers VALUES (1, 682, 'm9', 'minor', 13.299499000000001, 46.523929000000003, 830, 18.815180000000002, 'forest', 'n2420100913');
INSERT INTO grid_towers VALUES (1, 683, 'm9', 'minor', 13.299386999999999, 46.525249000000002, 814, 16.846810000000001, 'forest', 'n2420100914');
INSERT INTO grid_towers VALUES (1, 684, 'm9', 'minor', 13.299412999999999, 46.526136000000001, 814, 16.846810000000001, 'forest', 'n2420100915');
INSERT INTO grid_towers VALUES (1, 685, 'm9', 'minor', 13.299288000000001, 46.526612999999998, 814, 16.846810000000001, 'forest', 'n2420100916');
INSERT INTO grid_towers VALUES (1, 687, 'm9', 'minor', 13.301841, 46.529035999999998, 889, 18.68975, 'wood', 'n2420100918');
INSERT INTO grid_towers VALUES (1, 688, 'm19', 'minor', 13.435845, 46.503950000000003, 726, 14.545249999999999, 'meadow', 'n3010217236');
INSERT INTO grid_towers VALUES (1, 689, 'm12', 'minor', 13.370618, 46.501395000000002, 654, 11.711220000000001, 'grassland', 'n3024667033');
INSERT INTO grid_towers VALUES (1, 3, 'Hh1', '132k', 13.291497, 46.471173, 653, 28.238479999999999, 'wood', 'n748572237');
INSERT INTO grid_towers VALUES (1, 11, 'Hh1', '132k', 13.293355, 46.476146, 582, 15.24403, 'wood', 'n748774084');
INSERT INTO grid_towers VALUES (1, 19, 'Hh1', '132k', 13.29538, 46.504027999999998, 854, 14.34107, 'wood', 'n748774122');
INSERT INTO grid_towers VALUES (1, 27, 'Hh1', '132k', 13.459460999999999, 46.499853999999999, 895, 9.95303, 'forest', 'n748784525');
INSERT INTO grid_towers VALUES (1, 37, 'Hh1', '132k', 13.366775000000001, 46.500520000000002, 673, 13.389340000000001, 'scrub', 'n776113940');
INSERT INTO grid_towers VALUES (1, 45, 'Hh1', '132k', 13.438045000000001, 46.500877000000003, 837, 18.92576, 'forest', 'n776114285');
INSERT INTO grid_towers VALUES (1, 54, 'Hh1', '132k', 13.355566, 46.503790000000002, 715, 13.736929999999999, 'scrub', 'n776114609');
INSERT INTO grid_towers VALUES (1, 63, 'Hh1', '132k', 13.443210000000001, 46.501579999999997, 855, 16.473579999999998, 'forest', 'n776114838');
INSERT INTO grid_towers VALUES (1, 72, 'Hh1', '132k', 13.426826999999999, 46.499389999999998, 882, 14.77824, 'grassland', 'n776114911');
INSERT INTO grid_towers VALUES (1, 82, 'Hh1', '132k', 13.445591, 46.501907000000003, 906, 17.79449, 'forest', 'n776115138');
INSERT INTO grid_towers VALUES (1, 86, 'Hh1', '132k', 13.498094999999999, 46.498604, 795, 1.4962, 'NA', 'n776205085');
INSERT INTO grid_towers VALUES (1, 92, 'h8', '60k', 13.316316, 46.511608000000003, 613, 18.23779, 'scrub', 'n747742319');
INSERT INTO grid_towers VALUES (1, 101, 'h7', '60k', 13.317307, 46.511538999999999, 610, 15.38256, 'scrub', 'n747742358');
INSERT INTO grid_towers VALUES (1, 121, 'h5', '60k', 13.29771, 46.488805999999997, 680, 27.096450000000001, 'wood', 'n748774064');
INSERT INTO grid_towers VALUES (1, 134, 'h5', '60k', 13.300375000000001, 46.498024999999998, 553, 1.6236999999999999, 'NA', 'n748774092');
INSERT INTO grid_towers VALUES (1, 143, 'h6', '60k', 13.301660999999999, 46.506869000000002, 626, 16.7286, 'NA', 'n748774136');
INSERT INTO grid_towers VALUES (1, 152, 'h12', '60k', 13.379621999999999, 46.499834, 674, 7.7501699999999998, 'grassland', 'n748784368');
INSERT INTO grid_towers VALUES (1, 162, 'h14', '60k', 13.418855000000001, 46.499124999999999, 742, 13.63435, 'meadow', 'n748784379');
INSERT INTO grid_towers VALUES (1, 172, 'h18', '60k', 13.432434000000001, 46.50264, 715, 10.138719999999999, 'meadow', 'n748784393');
INSERT INTO grid_towers VALUES (1, 176, 'h18', '60k', 13.486041, 46.498871999999999, 787, 3.89405, 'meadow', 'n748784398');
INSERT INTO grid_towers VALUES (1, 178, 'h17', '60k', 13.447494000000001, 46.504812000000001, 736, 10.026059999999999, 'meadow', 'n748784400');
INSERT INTO grid_towers VALUES (1, 189, 'h14', '60k', 13.416599, 46.499063, 720, 8.9923199999999994, 'meadow', 'n748784411');
INSERT INTO grid_towers VALUES (1, 198, 'h13', '60k', 13.410002, 46.498978999999999, 725, 11.973420000000001, 'scrub', 'n748784422');
INSERT INTO grid_towers VALUES (1, 208, 'h10', '60k', 13.359325, 46.503827999999999, 711, 10.551830000000001, 'meadow', 'n748784435');
INSERT INTO grid_towers VALUES (1, 218, 'h17', '60k', 13.452318, 46.503247000000002, 793, 9.6045700000000007, 'forest', 'n748784447');
INSERT INTO grid_towers VALUES (1, 226, 'h17', '60k', 13.491979000000001, 46.500143999999999, 791, 0.57545000000000002, 'meadow', 'n748784457');
INSERT INTO grid_towers VALUES (1, 236, 'h18', '60k', 13.476172999999999, 46.498959999999997, 921, 11.562749999999999, 'forest', 'n748784472');
INSERT INTO grid_towers VALUES (1, 244, 'h14', '60k', 13.407358, 46.498874999999998, 736, 13.226760000000001, 'scrub', 'n748784484');
INSERT INTO grid_towers VALUES (1, 253, 'h11', '60k', 13.373096, 46.501291999999999, 646, 6.6704499999999998, 'grassland', 'n748784497');
INSERT INTO grid_towers VALUES (1, 262, 'h12', '60k', 13.381859, 46.499428000000002, 672, 10.367279999999999, 'scrub', 'n748784508');
INSERT INTO grid_towers VALUES (1, 266, 'h16', '60k', 13.422124999999999, 46.500903000000001, 729, 13.752269999999999, 'NA', 'n748784513');
INSERT INTO grid_towers VALUES (1, 267, 'h12', '60k', 13.392001, 46.499198999999997, 690, 9.1201799999999995, 'scrub', 'n748784515');
INSERT INTO grid_towers VALUES (1, 277, 'h18', '60k', 13.440072000000001, 46.503658000000001, 751, 12.04195, 'forest', 'n748784529');
INSERT INTO grid_towers VALUES (1, 288, 'h14', '60k', 13.394780000000001, 46.499133999999998, 702, 11.582789999999999, 'scrub', 'n748784541');
INSERT INTO grid_towers VALUES (1, 299, 'h7', '60k', 13.320364, 46.509141999999997, 571, 2.2008999999999999, 'railway', 'n762820259');
INSERT INTO grid_towers VALUES (1, 310, 'h4', '60k', 13.297648000000001, 46.474763000000003, 556, 21.16253, 'wood', 'n762820387');
INSERT INTO grid_towers VALUES (1, 323, 'h3', '60k', 13.299383000000001, 46.477806999999999, 523, 7.5126900000000001, 'wood', 'n762820404');
INSERT INTO grid_towers VALUES (1, 336, 'h18', '60k', 13.497023, 46.501336999999999, 786, 2.9586299999999999, 'NA', 'n2170919720');
INSERT INTO grid_towers VALUES (1, 343, 'm27', 'minor', 13.514923, 46.502676000000001, 856, 22.584409999999998, 'forest', 'n2170919732');
INSERT INTO grid_towers VALUES (1, 352, 'm12', 'minor', 13.392481, 46.498466000000001, 690, 9.1201799999999995, 'scrub', 'n2419588815');
INSERT INTO grid_towers VALUES (1, 355, 'm12', 'minor', 13.373563000000001, 46.499229999999997, 683, 19.847529999999999, 'grass', 'n2419588827');
INSERT INTO grid_towers VALUES (1, 356, 'm12', 'minor', 13.372736, 46.499457, 703, 22.63374, 'meadow', 'n2419588828');
INSERT INTO grid_towers VALUES (1, 365, 'm17', 'minor', 13.418787, 46.499943000000002, 698, 8.8973499999999994, 'meadow', 'n2419588854');
INSERT INTO grid_towers VALUES (1, 374, 'm12', 'minor', 13.384734, 46.500238000000003, 650, 2.7098900000000001, 'scrub', 'n2419588877');
INSERT INTO grid_towers VALUES (1, 384, 'm18', 'minor', 13.430623000000001, 46.501271000000003, 788, 15.64517, 'forest', 'n2419588917');
INSERT INTO grid_towers VALUES (1, 393, 'm14', 'minor', 13.401391, 46.502026999999998, 673, 12.599930000000001, 'NA', 'n2419588940');
INSERT INTO grid_towers VALUES (1, 401, 'm11', 'minor', 13.368614000000001, 46.502673999999999, 631, 1.3383100000000001, 'wood', 'n2419588963');
INSERT INTO grid_towers VALUES (1, 410, 'm11', 'minor', 13.369878, 46.503025000000001, 631, 1.3383100000000001, 'grassland', 'n2419588983');
INSERT INTO grid_towers VALUES (1, 419, 'm19', 'minor', 13.437756, 46.504143999999997, 716, 2.62473, 'NA', 'n2419589011');
INSERT INTO grid_towers VALUES (1, 427, 'm20', 'minor', 13.446145, 46.504885999999999, 736, 10.026059999999999, 'meadow', 'n2419589049');
INSERT INTO grid_towers VALUES (1, 436, 'm11', 'minor', 13.361794, 46.505336, 664, 9.4650999999999996, 'wood', 'n2419589100');
INSERT INTO grid_towers VALUES (1, 439, 'm16', 'minor', 13.418723999999999, 46.505471, 700, 6.7271299999999998, 'NA', 'n2419589111');
INSERT INTO grid_towers VALUES (1, 446, 'm11', 'minor', 13.358471, 46.505839999999999, 667, 9.8782899999999998, 'meadow', 'n2419589128');
INSERT INTO grid_towers VALUES (1, 455, 'm22', 'minor', 13.457459, 46.506515, 763, 3.5358900000000002, 'meadow', 'n2419589200');
INSERT INTO grid_towers VALUES (1, 465, 'm21', 'minor', 13.451738000000001, 46.507575000000003, 749, 10.851139999999999, 'NA', 'n2419589241');
INSERT INTO grid_towers VALUES (1, 473, 'm10', 'minor', 13.327931, 46.508588000000003, 592, 11.30687, 'NA', 'n2419589298');
INSERT INTO grid_towers VALUES (1, 482, 'm22', 'minor', 13.468987, 46.508856000000002, 767, 1.37357, 'meadow', 'n2419589331');
INSERT INTO grid_towers VALUES (1, 490, 'm10', 'minor', 13.335289, 46.509256000000001, 623, 10.31794, 'meadow', 'n2419589425');
INSERT INTO grid_towers VALUES (1, 500, 'm23', 'minor', 13.475422999999999, 46.511631999999999, 807, 18.32855, 'NA', 'n2419589498');
INSERT INTO grid_towers VALUES (1, 508, 'm23', 'minor', 13.474235999999999, 46.514516, 934, 26.078029999999998, 'NA', 'n2419589534');
INSERT INTO grid_towers VALUES (1, 516, 'm23', 'minor', 13.474170000000001, 46.524976000000002, 1064, 3.3320099999999999, 'forest', 'n2419589567');
INSERT INTO grid_towers VALUES (1, 523, 'm23', 'minor', 13.468982, 46.533540000000002, 1111, 7.6985299999999999, 'forest', 'n2419589635');
INSERT INTO grid_towers VALUES (1, 529, 'm25', 'minor', 13.493143999999999, 46.491416000000001, 813, 3.8475999999999999, 'NA', 'n2420048780');
INSERT INTO grid_towers VALUES (1, 537, 'm25', 'minor', 13.498377, 46.495682000000002, 817, 16.291519999999998, 'NA', 'n2420048794');
INSERT INTO grid_towers VALUES (1, 545, 'm26', 'minor', 13.503216, 46.501078, 797, 3.2450800000000002, 'NA', 'n2420048804');
INSERT INTO grid_towers VALUES (1, 554, 'm26', 'minor', 13.516598999999999, 46.504502000000002, 810, 6.95566, 'NA', 'n2420048813');
INSERT INTO grid_towers VALUES (1, 561, 'm26', 'minor', 13.526320999999999, 46.506934000000001, 803, 3.0189300000000001, 'meadow', 'n2420048826');
INSERT INTO grid_towers VALUES (1, 570, 'm26', 'minor', 13.541727, 46.507562999999998, 819, 3.8967399999999999, 'meadow', 'n2420048835');
INSERT INTO grid_towers VALUES (1, 580, 'm26', 'minor', 13.537794, 46.509225999999998, 807, 0.94438999999999995, 'NA', 'n2420048847');
INSERT INTO grid_towers VALUES (1, 588, 'm1', 'minor', 13.299499000000001, 46.459893999999998, 458, 3.9336600000000002, 'wood', 'n2420100701');
INSERT INTO grid_towers VALUES (1, 597, 'm2', 'minor', 13.295061, 46.465778999999998, 506, 8.7824000000000009, 'wood', 'n2420100719');
INSERT INTO grid_towers VALUES (1, 606, 'm3', 'minor', 13.297437, 46.475194000000002, 503, 8.7009000000000007, 'wood', 'n2420100735');
INSERT INTO grid_towers VALUES (1, 608, 'm3', 'minor', 13.298159, 46.478054, 523, 7.5126900000000001, 'wood', 'n2420100739');
INSERT INTO grid_towers VALUES (1, 616, 'm4', 'minor', 13.301519000000001, 46.488551999999999, 537, 10.764010000000001, 'wood', 'n2420100767');
INSERT INTO grid_towers VALUES (1, 625, 'm7', 'minor', 13.271293999999999, 46.507348999999998, 881, 10.758240000000001, 'meadow', 'n2420100847');
INSERT INTO grid_towers VALUES (1, 634, 'm5', 'minor', 13.302664999999999, 46.508634999999998, 586, 4.23081, 'NA', 'n2420100857');
INSERT INTO grid_towers VALUES (1, 643, 'm7', 'minor', 13.284036, 46.511929000000002, 738, 14.201230000000001, 'NA', 'n2420100866');
INSERT INTO grid_towers VALUES (1, 650, 'm6', 'minor', 13.295975, 46.514744, 694, 7.45167, 'meadow', 'n2420100877');
INSERT INTO grid_towers VALUES (1, 659, 'm7', 'minor', 13.286788, 46.516309, 698, 7.0818399999999997, 'wood', 'n2420100890');
INSERT INTO grid_towers VALUES (1, 668, 'm8', 'minor', 13.283740999999999, 46.518394999999998, 693, 12.736599999999999, 'wood', 'n2420100899');
INSERT INTO grid_towers VALUES (1, 678, 'm8', 'minor', 13.273342, 46.520929000000002, 667, 14.56104, 'NA', 'n2420100909');
INSERT INTO grid_towers VALUES (1, 686, 'm9', 'minor', 13.29918, 46.527757999999999, 839, 17.803550000000001, 'forest', 'n2420100917');


--
-- TOC entry 2274 (class 0 OID 0)
-- Dependencies: 209
-- Name: grid_towers_id_seq; Type: SEQUENCE SET; Schema: alpine; Owner: postgres
--

SELECT pg_catalog.setval('grid_towers_id_seq', 690, true);


--
-- TOC entry 2244 (class 0 OID 27876)
-- Dependencies: 215
-- Data for Name: grid_towers_status; Type: TABLE DATA; Schema: alpine; Owner: postgres
--

INSERT INTO grid_towers_status VALUES (1, 62, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 63, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 64, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 65, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 66, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 67, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 68, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 69, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 70, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 71, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 72, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 73, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 74, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 75, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 76, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 77, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 78, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 79, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 80, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 81, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 82, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 83, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 84, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 85, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 86, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 87, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 88, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 89, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 150, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 151, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 152, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 153, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 154, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 155, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 156, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 157, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 158, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 159, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 160, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 161, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 162, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 163, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 164, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 165, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 166, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 167, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 168, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 169, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 170, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 171, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 172, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 173, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 174, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 175, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 176, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 177, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 178, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 179, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 180, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 181, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 182, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 183, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 184, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 185, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 186, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 187, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 188, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 189, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 190, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 191, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 192, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 193, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 194, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 195, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 196, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 197, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 198, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 199, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 200, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 201, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 202, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 203, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 204, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 205, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 206, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 207, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 208, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 209, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 210, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 211, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 212, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 213, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 214, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 215, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 216, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 217, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 218, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 219, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 220, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 221, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 222, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 223, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 224, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 225, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 226, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 227, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 228, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 229, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 230, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 231, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 232, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 233, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 234, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 235, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 236, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 237, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 238, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 239, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 240, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 241, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 242, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 243, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 244, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 245, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 246, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 247, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 248, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 249, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 250, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 251, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 252, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 253, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 254, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 255, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 256, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 257, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 258, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 259, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 260, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 261, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 262, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 263, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 264, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 265, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 266, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 267, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 268, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 269, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 270, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 271, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 272, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 273, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 274, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 275, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 276, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 277, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 278, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 279, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 280, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 281, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 282, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 283, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 284, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 285, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 286, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 287, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 288, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 289, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 290, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 291, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 292, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 293, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 294, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 295, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 296, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 297, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 298, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 299, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 300, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 301, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 302, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 352, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 353, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 354, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 355, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 356, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 357, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 358, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 359, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 360, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 361, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 362, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 363, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 364, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 365, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 366, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 367, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 368, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 369, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 370, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 371, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 372, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 373, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 374, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 375, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 376, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 377, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 378, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 379, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 380, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 381, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 382, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 383, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 384, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 385, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 386, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 387, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 389, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 390, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 391, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 392, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 393, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 394, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 395, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 396, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 397, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 398, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 399, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 400, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 401, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 402, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 403, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 404, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 405, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 406, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 407, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 408, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 409, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 410, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 411, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 412, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 413, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 414, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 415, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 416, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 417, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 418, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 419, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 420, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 421, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 422, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 423, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 424, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 425, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 426, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 427, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 428, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 429, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 430, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 431, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 432, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 433, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 434, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 435, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 436, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 437, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 438, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 439, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 440, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 441, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 442, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 443, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 444, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 445, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 446, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 447, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 448, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 449, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 450, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 451, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 454, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 455, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 456, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 457, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 458, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 459, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 460, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 461, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 462, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 463, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 464, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 465, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 466, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 467, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 468, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 469, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 470, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 471, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 472, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 473, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 526, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 527, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 528, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 529, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 530, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 531, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 532, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 533, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 534, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 535, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 536, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 537, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 538, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 539, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 540, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 541, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 542, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 543, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 544, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 545, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 546, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 547, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 548, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 549, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 550, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 1, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 2, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 3, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 4, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 5, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 6, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 7, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 8, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 9, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 10, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 11, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 12, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 13, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 14, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 15, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 16, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 17, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 18, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 19, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 20, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 21, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 22, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 23, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 24, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 25, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 26, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 27, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 28, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 29, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 30, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 31, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 32, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 33, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 34, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 35, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 36, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 37, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 38, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 39, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 40, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 41, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 42, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 43, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 44, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 45, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 46, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 47, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 48, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 49, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 50, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 51, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 52, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 53, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 54, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 55, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 56, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 57, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 58, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 59, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 60, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 61, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 474, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 475, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 476, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 477, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 478, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 479, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 480, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 481, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 482, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 483, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 484, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 485, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 486, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 487, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 488, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 489, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 490, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 491, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 492, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 493, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 494, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 495, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 496, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 497, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 498, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 499, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 500, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 501, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 502, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 503, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 504, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 505, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 506, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 507, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 508, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 509, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 510, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 511, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 512, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 513, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 514, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 515, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 516, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 517, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 518, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 519, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 520, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 521, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 522, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 523, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 524, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 525, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 551, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 552, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 553, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 554, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 555, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 556, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 557, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 558, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 559, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 560, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 561, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 562, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 563, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 564, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 565, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 566, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 567, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 603, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 604, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 605, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 606, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 607, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 608, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 609, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 610, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 611, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 612, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 613, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 614, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 615, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 616, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 617, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 618, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 619, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 620, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 621, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 622, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 623, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 624, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 625, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 626, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 627, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 628, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 629, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 630, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 631, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 632, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 633, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 634, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 635, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 636, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 637, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 638, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 639, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 640, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 641, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 642, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 643, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 644, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 645, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 646, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 647, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 648, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 649, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 650, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 651, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 652, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 653, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 654, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 655, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 656, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 657, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 658, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 659, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 660, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 661, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 662, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 663, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 664, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 665, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 666, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 667, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 668, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 669, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 670, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 671, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 672, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 673, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 674, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 675, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 676, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 677, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 678, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 679, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 680, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 681, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 682, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 683, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 684, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 685, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 686, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 687, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 688, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 689, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 90, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 91, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 92, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 93, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 94, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 95, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 96, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 97, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 98, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 99, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 100, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 101, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 102, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 103, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 104, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 105, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 106, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 107, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 108, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 109, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 110, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 111, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 112, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 113, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 114, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 115, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 116, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 117, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 118, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 119, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 120, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 121, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 122, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 123, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 124, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 125, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 126, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 127, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 128, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 129, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 130, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 131, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 132, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 133, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 134, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 135, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 136, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 137, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 138, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 139, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 140, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 141, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 142, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 143, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 144, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 145, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 146, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 147, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 148, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 149, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 303, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 304, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 305, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 306, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 307, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 308, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 309, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 310, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 311, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 312, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 313, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 314, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 315, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 316, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 317, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 318, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 319, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 320, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 321, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 322, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 323, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 324, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 325, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 326, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 327, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 328, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 329, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 330, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 331, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 332, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 333, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 334, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 335, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 336, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 337, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 338, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 339, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 340, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 341, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 342, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 343, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 344, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 345, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 346, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 347, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 348, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 349, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 350, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 351, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 388, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 452, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 453, 'tower', 2);
INSERT INTO grid_towers_status VALUES (1, 568, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 569, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 570, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 571, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 572, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 573, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 574, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 575, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 576, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 577, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 578, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 579, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 580, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 581, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 582, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 583, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 584, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 585, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 586, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 587, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 588, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 589, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 590, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 591, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 592, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 593, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 594, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 595, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 596, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 597, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 598, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 599, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 600, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 601, 'pole', 3);
INSERT INTO grid_towers_status VALUES (1, 602, 'pole', 3);


--
-- TOC entry 2242 (class 0 OID 27810)
-- Dependencies: 213
-- Data for Name: grid_towers_susc; Type: TABLE DATA; Schema: alpine; Owner: postgres
--

INSERT INTO grid_towers_susc VALUES (1, 1, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 2, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 3, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 4, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 5, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 6, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 7, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 8, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 9, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 10, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 11, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 12, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 13, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 14, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 15, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 16, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 17, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 18, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 19, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 20, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 21, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 22, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 23, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 24, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 25, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 26, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 27, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 28, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 29, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 30, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 31, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 32, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 33, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 34, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 35, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 36, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 37, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 38, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 39, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 40, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 41, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 42, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 43, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 44, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 45, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 46, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 47, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 48, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 49, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 50, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 51, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 52, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 53, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 54, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 55, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 56, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 57, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 58, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 59, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 60, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 61, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 62, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 63, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 64, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 65, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 66, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 67, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 68, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 69, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 70, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 71, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 72, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 73, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 74, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 75, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 76, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 77, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 78, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 79, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 80, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 81, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 82, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 83, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 84, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 85, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 86, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 87, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 88, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 89, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 90, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 91, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 92, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 93, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 94, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 95, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 96, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 97, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 98, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 99, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 100, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 101, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 102, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 103, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 104, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 105, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 106, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 107, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 108, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 109, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 110, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 111, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 112, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 113, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 114, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 115, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 116, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 117, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 118, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 119, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 120, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 121, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 122, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 123, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 124, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 125, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 126, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 127, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 128, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 129, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 130, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 131, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 132, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 133, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 134, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 135, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 136, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 137, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 138, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 139, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 140, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 141, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 142, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 143, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 144, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 145, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 146, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 147, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 148, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 149, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 150, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 151, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 152, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 153, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 154, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 155, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 156, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 157, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 158, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 159, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 160, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 161, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 162, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 163, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 164, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 165, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 166, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 167, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 168, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 169, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 170, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 171, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 172, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 173, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 174, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 175, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 176, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 177, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 178, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 179, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 180, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 181, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 182, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 183, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 184, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 185, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 186, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 187, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 188, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 189, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 190, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 191, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 192, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 193, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 194, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 195, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 196, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 197, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 198, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 199, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 200, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 201, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 202, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 203, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 204, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 205, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 206, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 207, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 208, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 209, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 210, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 211, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 212, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 213, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 214, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 215, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 216, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 217, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 218, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 219, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 220, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 221, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 222, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 223, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 224, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 225, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 226, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 227, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 228, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 229, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 230, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 231, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 232, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 233, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 234, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 235, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 236, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 237, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 238, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 239, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 240, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 241, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 242, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 243, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 244, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 245, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 246, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 247, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 248, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 249, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 250, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 251, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 252, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 253, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 254, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 255, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 256, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 257, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 258, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 259, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 260, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 261, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 262, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 263, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 264, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 265, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 266, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 267, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 268, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 269, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 270, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 271, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 272, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 273, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 274, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 275, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 276, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 277, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 278, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 279, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 280, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 281, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 282, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 283, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 284, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 285, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 286, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 287, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 288, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 289, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 290, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 291, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 292, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 293, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 294, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 295, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 296, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 297, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 298, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 299, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 300, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 301, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 302, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 303, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 304, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 305, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 306, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 307, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 308, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 309, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 310, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 311, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 312, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 313, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 314, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 315, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 316, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 317, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 318, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 319, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 320, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 321, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 322, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 323, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 324, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 325, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 326, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 327, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 328, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 329, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 330, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 331, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 332, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 333, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 334, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 335, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 336, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 337, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 338, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 339, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 340, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 341, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 342, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 343, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 344, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 345, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 346, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 347, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 348, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 349, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 350, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 351, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 352, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 353, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 354, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 355, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 356, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 357, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 358, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 359, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 360, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 361, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 362, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 363, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 364, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 365, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 366, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 367, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 368, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 369, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 370, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 371, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 372, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 373, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 374, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 375, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 376, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 377, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 378, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 379, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 380, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 381, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 382, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 383, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 384, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 385, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 386, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 387, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 388, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 389, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 390, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 391, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 392, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 393, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 394, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 395, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 396, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 397, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 398, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 399, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 400, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 401, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 402, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 403, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 404, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 405, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 406, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 407, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 408, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 409, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 410, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 411, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 412, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 413, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 414, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 415, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 416, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 417, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 418, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 419, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 420, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 421, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 422, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 423, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 424, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 425, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 426, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 427, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 428, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 429, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 430, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 431, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 432, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 433, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 434, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 435, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 436, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 437, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 438, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 439, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 440, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 441, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 442, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 443, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 444, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 445, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 446, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 447, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 448, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 449, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 450, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 451, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 452, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 453, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 454, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 455, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 456, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 457, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 458, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 459, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 460, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 461, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 462, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 463, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 464, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 465, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 466, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 467, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 468, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 469, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 470, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 471, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 472, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 473, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 474, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 475, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 476, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 477, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 478, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 479, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 480, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 481, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 482, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 483, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 484, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 485, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 486, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 487, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 488, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 489, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 490, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 491, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 492, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 493, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 494, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 495, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 496, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 497, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 498, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 499, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 500, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 501, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 502, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 503, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 504, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 505, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 506, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 507, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 508, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 509, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 510, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 511, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 512, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 513, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 514, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 515, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 516, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 517, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 518, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 519, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 520, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 521, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 522, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 523, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 524, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 525, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 526, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 527, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 528, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 529, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 530, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 531, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 532, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 533, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 534, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 535, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 536, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 537, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 538, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 539, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 540, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 541, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 542, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 543, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 544, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 545, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 546, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 547, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 548, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 549, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 550, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 551, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 552, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 553, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 554, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 555, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 556, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 557, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 558, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 559, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 560, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 561, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 562, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 563, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 564, 1, 0);
INSERT INTO grid_towers_susc VALUES (1, 565, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 566, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 567, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 568, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 569, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 570, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 571, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 572, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 573, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 574, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 575, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 576, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 577, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 578, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 579, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 580, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 581, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 582, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 583, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 584, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 585, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 586, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 587, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 588, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 589, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 590, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 591, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 592, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 593, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 594, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 595, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 596, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 597, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 598, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 599, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 600, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 601, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 602, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 603, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 604, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 605, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 606, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 607, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 608, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 609, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 610, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 611, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 612, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 613, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 614, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 615, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 616, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 617, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 618, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 619, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 620, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 621, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 622, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 623, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 624, 1, 0);
INSERT INTO grid_towers_susc VALUES (1, 625, 1, 0);
INSERT INTO grid_towers_susc VALUES (1, 626, 1, 0);
INSERT INTO grid_towers_susc VALUES (1, 627, 1, 0);
INSERT INTO grid_towers_susc VALUES (1, 628, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 629, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 630, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 631, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 632, 1, 0);
INSERT INTO grid_towers_susc VALUES (1, 633, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 634, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 635, 1, 0);
INSERT INTO grid_towers_susc VALUES (1, 636, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 637, 1, 0);
INSERT INTO grid_towers_susc VALUES (1, 638, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 639, 1, 0);
INSERT INTO grid_towers_susc VALUES (1, 640, 1, 0);
INSERT INTO grid_towers_susc VALUES (1, 641, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 642, 1, 0);
INSERT INTO grid_towers_susc VALUES (1, 643, 1, 0);
INSERT INTO grid_towers_susc VALUES (1, 644, 1, 0);
INSERT INTO grid_towers_susc VALUES (1, 645, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 646, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 647, 1, 0);
INSERT INTO grid_towers_susc VALUES (1, 648, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 649, 1, 0);
INSERT INTO grid_towers_susc VALUES (1, 650, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 651, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 652, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 653, 1, 0);
INSERT INTO grid_towers_susc VALUES (1, 654, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 655, 1, 0);
INSERT INTO grid_towers_susc VALUES (1, 656, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 657, 1, 0);
INSERT INTO grid_towers_susc VALUES (1, 658, 1, 0);
INSERT INTO grid_towers_susc VALUES (1, 659, 1, 0);
INSERT INTO grid_towers_susc VALUES (1, 660, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 661, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 662, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 663, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 664, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 665, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 666, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 667, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 668, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 669, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 670, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 671, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 672, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 673, 1, 2);
INSERT INTO grid_towers_susc VALUES (1, 674, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 675, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 676, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 677, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 678, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 679, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 680, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 681, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 682, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 683, 1, 5);
INSERT INTO grid_towers_susc VALUES (1, 684, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 685, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 686, 1, 4);
INSERT INTO grid_towers_susc VALUES (1, 687, 1, 3);
INSERT INTO grid_towers_susc VALUES (1, 688, 1, 1);
INSERT INTO grid_towers_susc VALUES (1, 689, 1, 1);


--
-- TOC entry 2259 (class 0 OID 28227)
-- Dependencies: 230
-- Data for Name: land_transportation; Type: TABLE DATA; Schema: alpine; Owner: postgres
--

INSERT INTO land_transportation VALUES (1, 'Alpine Case');


--
-- TOC entry 2275 (class 0 OID 0)
-- Dependencies: 229
-- Name: land_transportation_id_seq; Type: SEQUENCE SET; Schema: alpine; Owner: postgres
--

SELECT pg_catalog.setval('land_transportation_id_seq', 1, true);


--
-- TOC entry 2230 (class 0 OID 27569)
-- Dependencies: 201
-- Data for Name: region_landslide; Type: TABLE DATA; Schema: alpine; Owner: postgres
--

INSERT INTO region_landslide VALUES (4, 'Valbruna Region 1', 'Valbruna_Region_1');
INSERT INTO region_landslide VALUES (1, 'Alpine Region case study basic model', 'landslide_initial');
INSERT INTO region_landslide VALUES (5, 'Valbruna Region New landslide data', 'Valbruna_Region_New_landslide_data');


--
-- TOC entry 2276 (class 0 OID 0)
-- Dependencies: 202
-- Name: region_landslide_id_seq; Type: SEQUENCE SET; Schema: alpine; Owner: postgres
--

SELECT pg_catalog.setval('region_landslide_id_seq', 5, true);


--
-- TOC entry 2233 (class 0 OID 27582)
-- Dependencies: 204
-- Data for Name: region_map; Type: TABLE DATA; Schema: alpine; Owner: postgres
--

INSERT INTO region_map VALUES (1, 'Susceptibility');


--
-- TOC entry 2277 (class 0 OID 0)
-- Dependencies: 203
-- Name: region_map_id_seq; Type: SEQUENCE SET; Schema: alpine; Owner: postgres
--

SELECT pg_catalog.setval('region_map_id_seq', 1, true);


--
-- TOC entry 2278 (class 0 OID 0)
-- Dependencies: 222
-- Name: station_types_id_seq; Type: SEQUENCE SET; Schema: alpine; Owner: postgres
--

SELECT pg_catalog.setval('station_types_id_seq', 1, true);


--
-- TOC entry 2261 (class 0 OID 28238)
-- Dependencies: 232
-- Data for Name: trans_elements; Type: TABLE DATA; Schema: alpine; Owner: postgres
--

INSERT INTO trans_elements VALUES (1, 1, 'T8', 'A23', 'tunnel', 'road', 'NA');
INSERT INTO trans_elements VALUES (1, 2, 'T5', 'A23', 'tunnel', 'road', 'NA');
INSERT INTO trans_elements VALUES (1, 3, 'T6', 'A23', 'tunnel', 'road', 'NA');
INSERT INTO trans_elements VALUES (1, 4, 'T4', 'A23', 'tunnel', 'road', 'NA');
INSERT INTO trans_elements VALUES (1, 5, 'T3', 'A23', 'tunnel', 'road', 'NA');
INSERT INTO trans_elements VALUES (1, 6, 'T2', 'A23', 'tunnel', 'road', 'NA');
INSERT INTO trans_elements VALUES (1, 7, 'T1', 'A23', 'tunnel', 'road', 'NA');
INSERT INTO trans_elements VALUES (1, 8, 'T7', 'A23', 'tunnel', 'road', 'NA');
INSERT INTO trans_elements VALUES (1, 9, 'T9', 'A23', 'tunnel', 'road', 'NA');
INSERT INTO trans_elements VALUES (1, 10, 'B3', 'A23', 'bridge', 'road', 'A1');
INSERT INTO trans_elements VALUES (1, 11, 'B10', 'A23', 'bridge', 'road', 'A3');
INSERT INTO trans_elements VALUES (1, 12, 'B8', 'A23', 'bridge', 'road', 'A3');
INSERT INTO trans_elements VALUES (1, 13, 'B6', 'A23', 'bridge', 'road', 'A3');
INSERT INTO trans_elements VALUES (1, 14, 'B14', 'A23', 'bridge', 'road', 'A3');
INSERT INTO trans_elements VALUES (1, 15, 'B13', 'A23', 'bridge', 'road', 'A3');
INSERT INTO trans_elements VALUES (1, 16, 'B12', 'A23', 'bridge', 'road', 'A3');
INSERT INTO trans_elements VALUES (1, 17, 'B5', 'A23', 'bridge', 'road', 'A3');
INSERT INTO trans_elements VALUES (1, 18, 'B4', 'A23', 'bridge', 'road', 'A1');
INSERT INTO trans_elements VALUES (1, 19, 'B2', 'A23', 'bridge', 'road', 'A1');
INSERT INTO trans_elements VALUES (1, 20, 'B1', 'A23', 'bridge', 'road', 'A1');
INSERT INTO trans_elements VALUES (1, 21, 'B7', 'A23', 'bridge', 'road', 'A3');
INSERT INTO trans_elements VALUES (1, 22, 'B11', 'A23', 'bridge', 'road', 'A3');
INSERT INTO trans_elements VALUES (1, 23, 'B9', 'A23', 'bridge', 'road', 'A3');
INSERT INTO trans_elements VALUES (1, 24, 'B44', 'A23', 'bridge', 'road', 'NA');
INSERT INTO trans_elements VALUES (1, 29, 'T11', 'SS13', 'tunnel', 'road', 'NA');
INSERT INTO trans_elements VALUES (1, 30, 'T14', 'SS13', 'tunnel', 'road', 'NA');
INSERT INTO trans_elements VALUES (1, 31, 'T13', 'SS13', 'tunnel', 'road', 'NA');
INSERT INTO trans_elements VALUES (1, 32, 'T12', 'SS13', 'tunnel', 'road', 'NA');
INSERT INTO trans_elements VALUES (1, 33, 'T10', 'SS13', 'tunnel', 'road', 'NA');
INSERT INTO trans_elements VALUES (1, 34, 'B24', 'SS13', 'bridge', 'road', 'A3');
INSERT INTO trans_elements VALUES (1, 35, 'B25', 'SS13', 'bridge', 'road', 'A4');
INSERT INTO trans_elements VALUES (1, 36, 'B29', 'SS13', 'bridge', 'road', 'A4');
INSERT INTO trans_elements VALUES (1, 37, 'B28', 'SS13', 'bridge', 'road', 'A4');
INSERT INTO trans_elements VALUES (1, 38, 'B30', 'SS13', 'bridge', 'road', 'A4');
INSERT INTO trans_elements VALUES (1, 39, 'B31', 'SS13', 'bridge', 'road', 'A4');
INSERT INTO trans_elements VALUES (1, 41, 'B27', 'SS13', 'bridge', 'road', 'A4');
INSERT INTO trans_elements VALUES (1, 42, 'B26', 'SS13', 'bridge', 'road', 'A4');
INSERT INTO trans_elements VALUES (1, 43, 'B23', 'SS13', 'bridge', 'road', 'A3');
INSERT INTO trans_elements VALUES (1, 44, 'B22', 'SS13', 'bridge', 'road', 'A3');
INSERT INTO trans_elements VALUES (1, 45, 'B21', 'SS13', 'bridge', 'road', 'A3');
INSERT INTO trans_elements VALUES (1, 46, 'B18', 'SS13', 'bridge', 'road', 'A3');
INSERT INTO trans_elements VALUES (1, 47, 'B17', 'SS13', 'bridge', 'road', 'A3');
INSERT INTO trans_elements VALUES (1, 48, 'B16', 'SS13', 'bridge', 'road', 'A3');
INSERT INTO trans_elements VALUES (1, 49, 'B15', 'SS13', 'bridge', 'road', 'A3');
INSERT INTO trans_elements VALUES (1, 50, 'B32', 'SS13', 'bridge', 'road', 'A4');
INSERT INTO trans_elements VALUES (1, 51, 'B33', 'SS13', 'bridge', 'road', 'A4');
INSERT INTO trans_elements VALUES (1, 52, 'B37', 'SS13', 'bridge', 'road', 'A5');
INSERT INTO trans_elements VALUES (1, 53, 'B35', 'SS13', 'bridge', 'road', 'A4');
INSERT INTO trans_elements VALUES (1, 54, 'B34', 'SS13', 'bridge', 'road', 'A4');
INSERT INTO trans_elements VALUES (1, 55, 'B19', 'SS13', 'bridge', 'road', 'A3');
INSERT INTO trans_elements VALUES (1, 56, 'B38', 'SS13', 'bridge', 'road', 'A5');
INSERT INTO trans_elements VALUES (1, 57, 'B20', 'SS13', 'bridge', 'road', 'A3');
INSERT INTO trans_elements VALUES (1, 58, 'B36', 'SS13', 'bridge', 'road', 'A4');
INSERT INTO trans_elements VALUES (1, 59, 'T19', 'Railway', 'tunnel', 'Railway', 'NA');
INSERT INTO trans_elements VALUES (1, 60, 'T18', 'Railway', 'tunnel', 'Railway', 'NA');
INSERT INTO trans_elements VALUES (1, 61, 'T17', 'Railway', 'tunnel', 'Railway', 'NA');
INSERT INTO trans_elements VALUES (1, 62, 'T16', 'Railway', 'tunnel', 'Railway', 'NA');
INSERT INTO trans_elements VALUES (1, 63, 'T15', 'Railway', 'tunnel', 'Railway', 'NA');
INSERT INTO trans_elements VALUES (1, 64, 'B41', 'Railway', 'bridge', 'Railway', 'NA');
INSERT INTO trans_elements VALUES (1, 65, 'B43', 'Railway', 'bridge', 'Railway', 'NA');
INSERT INTO trans_elements VALUES (1, 66, 'B42', 'Railway', 'bridge', 'Railway', 'NA');
INSERT INTO trans_elements VALUES (1, 67, 'B40', 'Railway', 'bridge', 'Railway', 'NA');
INSERT INTO trans_elements VALUES (1, 68, 'B39', 'Railway', 'bridge', 'Railway', 'NA');
INSERT INTO trans_elements VALUES (1, 25, 'B44_2', 'A23', 'bridge', 'road', 'NA');
INSERT INTO trans_elements VALUES (1, 26, 'B44_3', 'A23', 'bridge', 'road', 'NA');
INSERT INTO trans_elements VALUES (1, 27, 'B44_4', 'A23', 'bridge', 'road', 'NA');
INSERT INTO trans_elements VALUES (1, 28, 'B44_5', 'A23', 'bridge', 'road', 'NA');
INSERT INTO trans_elements VALUES (1, 40, 'B31_2', 'SS13', 'bridge', 'road', 'A4');


--
-- TOC entry 2279 (class 0 OID 0)
-- Dependencies: 231
-- Name: trans_elements_id_seq; Type: SEQUENCE SET; Schema: alpine; Owner: postgres
--

SELECT pg_catalog.setval('trans_elements_id_seq', 68, true);


--
-- TOC entry 2262 (class 0 OID 28283)
-- Dependencies: 233
-- Data for Name: trans_elements_status; Type: TABLE DATA; Schema: alpine; Owner: postgres
--

INSERT INTO trans_elements_status VALUES (1, 1, NULL, 6);
INSERT INTO trans_elements_status VALUES (1, 2, NULL, 6);
INSERT INTO trans_elements_status VALUES (1, 3, NULL, 6);
INSERT INTO trans_elements_status VALUES (1, 4, NULL, 6);
INSERT INTO trans_elements_status VALUES (1, 5, NULL, 6);
INSERT INTO trans_elements_status VALUES (1, 6, NULL, 6);
INSERT INTO trans_elements_status VALUES (1, 7, NULL, 6);
INSERT INTO trans_elements_status VALUES (1, 8, NULL, 6);
INSERT INTO trans_elements_status VALUES (1, 9, NULL, 6);
INSERT INTO trans_elements_status VALUES (1, 10, NULL, 4);
INSERT INTO trans_elements_status VALUES (1, 11, NULL, 4);
INSERT INTO trans_elements_status VALUES (1, 12, NULL, 4);
INSERT INTO trans_elements_status VALUES (1, 13, NULL, 4);
INSERT INTO trans_elements_status VALUES (1, 14, NULL, 4);
INSERT INTO trans_elements_status VALUES (1, 15, NULL, 4);
INSERT INTO trans_elements_status VALUES (1, 16, NULL, 4);
INSERT INTO trans_elements_status VALUES (1, 17, NULL, 4);
INSERT INTO trans_elements_status VALUES (1, 18, NULL, 4);
INSERT INTO trans_elements_status VALUES (1, 19, NULL, 4);
INSERT INTO trans_elements_status VALUES (1, 20, NULL, 4);
INSERT INTO trans_elements_status VALUES (1, 21, NULL, 4);
INSERT INTO trans_elements_status VALUES (1, 22, NULL, 4);
INSERT INTO trans_elements_status VALUES (1, 23, NULL, 4);
INSERT INTO trans_elements_status VALUES (1, 24, NULL, 4);
INSERT INTO trans_elements_status VALUES (1, 25, NULL, 4);
INSERT INTO trans_elements_status VALUES (1, 26, NULL, 4);
INSERT INTO trans_elements_status VALUES (1, 27, NULL, 4);
INSERT INTO trans_elements_status VALUES (1, 28, NULL, 4);
INSERT INTO trans_elements_status VALUES (1, 29, NULL, 7);
INSERT INTO trans_elements_status VALUES (1, 30, NULL, 7);
INSERT INTO trans_elements_status VALUES (1, 31, NULL, 7);
INSERT INTO trans_elements_status VALUES (1, 32, NULL, 7);
INSERT INTO trans_elements_status VALUES (1, 33, NULL, 7);
INSERT INTO trans_elements_status VALUES (1, 34, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 35, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 36, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 37, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 38, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 39, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 40, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 41, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 42, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 43, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 44, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 45, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 46, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 47, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 48, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 49, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 50, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 51, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 52, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 53, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 54, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 55, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 56, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 57, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 58, NULL, 5);
INSERT INTO trans_elements_status VALUES (1, 59, NULL, 10);
INSERT INTO trans_elements_status VALUES (1, 60, NULL, 10);
INSERT INTO trans_elements_status VALUES (1, 61, NULL, 10);
INSERT INTO trans_elements_status VALUES (1, 62, NULL, 10);
INSERT INTO trans_elements_status VALUES (1, 63, NULL, 10);
INSERT INTO trans_elements_status VALUES (1, 64, NULL, 9);
INSERT INTO trans_elements_status VALUES (1, 65, NULL, 9);
INSERT INTO trans_elements_status VALUES (1, 66, NULL, 9);
INSERT INTO trans_elements_status VALUES (1, 67, NULL, 9);
INSERT INTO trans_elements_status VALUES (1, 68, NULL, 9);


--
-- TOC entry 2263 (class 0 OID 28306)
-- Dependencies: 234
-- Data for Name: trans_elements_susc; Type: TABLE DATA; Schema: alpine; Owner: postgres
--

INSERT INTO trans_elements_susc VALUES (1, 1, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 2, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 3, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 4, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 5, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 6, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 7, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 8, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 9, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 10, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 11, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 12, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 13, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 14, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 15, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 16, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 17, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 18, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 19, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 20, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 21, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 22, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 23, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 24, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 25, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 26, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 27, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 28, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 29, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 30, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 31, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 32, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 33, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 34, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 35, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 36, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 37, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 38, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 39, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 40, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 41, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 42, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 43, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 44, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 45, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 46, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 47, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 48, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 49, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 50, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 51, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 52, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 53, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 54, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 55, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 56, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 57, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 58, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 59, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 60, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 61, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 62, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 63, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 64, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 65, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 66, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 67, 1, 3);
INSERT INTO trans_elements_susc VALUES (1, 68, 1, 3);


--
-- TOC entry 2255 (class 0 OID 28168)
-- Dependencies: 226
-- Data for Name: type_element; Type: TABLE DATA; Schema: alpine; Owner: postgres
--

INSERT INTO type_element VALUES (1, 1, 'Station 1', 0.5, 1000000);
INSERT INTO type_element VALUES (2, 2, 'Tower', 0.3, 100000);
INSERT INTO type_element VALUES (3, 2, 'Pole', 0.5, 45000);
INSERT INTO type_element VALUES (5, 3, 'Sec. road bridge', 0.45, 100000);
INSERT INTO type_element VALUES (4, 3, 'Highway bridge', 0.2, 750000);
INSERT INTO type_element VALUES (6, 4, 'Highway tunnel', 0.05, 1500000);
INSERT INTO type_element VALUES (7, 4, 'Sec. road tunnel', 0.05, 750000);
INSERT INTO type_element VALUES (8, 5, 'Long Railway bridge', 0.3, 800000);
INSERT INTO type_element VALUES (9, 5, 'Short Railway bridge', 0.1, 400000);
INSERT INTO type_element VALUES (10, 6, 'Railway tunnel', 0.01, 2000000);


--
-- TOC entry 2280 (class 0 OID 0)
-- Dependencies: 223
-- Name: type_element_id_seq; Type: SEQUENCE SET; Schema: alpine; Owner: postgres
--

SELECT pg_catalog.setval('type_element_id_seq', 10, true);


--
-- TOC entry 2059 (class 2606 OID 27771)
-- Name: pk_cases; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cases
    ADD CONSTRAINT pk_cases PRIMARY KEY (id);


--
-- TOC entry 2069 (class 2606 OID 27909)
-- Name: pk_cases_ewe; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cases_ewe
    ADD CONSTRAINT pk_cases_ewe PRIMARY KEY (id_case, ewe, variable_name);


--
-- TOC entry 2063 (class 2606 OID 27860)
-- Name: pk_cases_towers_status; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cases_towers_status
    ADD CONSTRAINT pk_cases_towers_status PRIMARY KEY (id_case, id_grid, id_tower);


--
-- TOC entry 2075 (class 2606 OID 28167)
-- Name: pk_elements; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY elements
    ADD CONSTRAINT pk_elements PRIMARY KEY (id);


--
-- TOC entry 2079 (class 2606 OID 28207)
-- Name: pk_eng_measures; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY eng_measures
    ADD CONSTRAINT pk_eng_measures PRIMARY KEY (id);


--
-- TOC entry 2067 (class 2606 OID 27901)
-- Name: pk_ewes; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ewes
    ADD CONSTRAINT pk_ewes PRIMARY KEY (name);


--
-- TOC entry 2049 (class 2606 OID 27601)
-- Name: pk_grid; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY grid
    ADD CONSTRAINT pk_grid PRIMARY KEY (id);


--
-- TOC entry 2055 (class 2606 OID 27640)
-- Name: pk_grid_lines; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY grid_lines
    ADD CONSTRAINT pk_grid_lines PRIMARY KEY (id_grid, label);


--
-- TOC entry 2051 (class 2606 OID 27609)
-- Name: pk_grid_stations; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY grid_stations
    ADD CONSTRAINT pk_grid_stations PRIMARY KEY (id_grid, name);


--
-- TOC entry 2073 (class 2606 OID 28075)
-- Name: pk_grid_stations_status; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY grid_stations_status
    ADD CONSTRAINT pk_grid_stations_status PRIMARY KEY (id_grid, id_station);


--
-- TOC entry 2071 (class 2606 OID 28052)
-- Name: pk_grid_stations_susc; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY grid_stations_susc
    ADD CONSTRAINT pk_grid_stations_susc PRIMARY KEY (id_grid, id_station, id_map);


--
-- TOC entry 2057 (class 2606 OID 27666)
-- Name: pk_grid_towers; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY grid_towers
    ADD CONSTRAINT pk_grid_towers PRIMARY KEY (id_grid, id);


--
-- TOC entry 2065 (class 2606 OID 27883)
-- Name: pk_grid_towers_status; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY grid_towers_status
    ADD CONSTRAINT pk_grid_towers_status PRIMARY KEY (id_grid, id_tower);


--
-- TOC entry 2061 (class 2606 OID 27814)
-- Name: pk_grid_towers_susc; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY grid_towers_susc
    ADD CONSTRAINT pk_grid_towers_susc PRIMARY KEY (id_grid, id_tower, id_map);


--
-- TOC entry 2081 (class 2606 OID 28235)
-- Name: pk_land_transportation; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY land_transportation
    ADD CONSTRAINT pk_land_transportation PRIMARY KEY (id);


--
-- TOC entry 2045 (class 2606 OID 27578)
-- Name: pk_region_landslide; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY region_landslide
    ADD CONSTRAINT pk_region_landslide PRIMARY KEY (id);


--
-- TOC entry 2047 (class 2606 OID 27590)
-- Name: pk_region_map; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY region_map
    ADD CONSTRAINT pk_region_map PRIMARY KEY (id);


--
-- TOC entry 2083 (class 2606 OID 28246)
-- Name: pk_trans_elements; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY trans_elements
    ADD CONSTRAINT pk_trans_elements PRIMARY KEY (id_land_transportation, id);


--
-- TOC entry 2085 (class 2606 OID 28290)
-- Name: pk_trans_elements_status; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY trans_elements_status
    ADD CONSTRAINT pk_trans_elements_status PRIMARY KEY (id_land_transportation, id_trans_elements);


--
-- TOC entry 2087 (class 2606 OID 28310)
-- Name: pk_trans_elements_susc; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY trans_elements_susc
    ADD CONSTRAINT pk_trans_elements_susc PRIMARY KEY (id_land_transportation, id_trans_elements, id_map);


--
-- TOC entry 2077 (class 2606 OID 28176)
-- Name: pk_type_element; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY type_element
    ADD CONSTRAINT pk_type_element PRIMARY KEY (id);


--
-- TOC entry 2053 (class 2606 OID 28047)
-- Name: unique_grid_stations; Type: CONSTRAINT; Schema: alpine; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY grid_stations
    ADD CONSTRAINT unique_grid_stations UNIQUE (id_grid, id);


--
-- TOC entry 2107 (class 2606 OID 27910)
-- Name: fk_cases_ewe_cases; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY cases_ewe
    ADD CONSTRAINT fk_cases_ewe_cases FOREIGN KEY (id_case) REFERENCES cases(id);


--
-- TOC entry 2108 (class 2606 OID 27915)
-- Name: fk_cases_ewe_ewes; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY cases_ewe
    ADD CONSTRAINT fk_cases_ewe_ewes FOREIGN KEY (ewe) REFERENCES ewes(name);


--
-- TOC entry 2094 (class 2606 OID 27772)
-- Name: fk_cases_grid; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY cases
    ADD CONSTRAINT fk_cases_grid FOREIGN KEY (id_grid) REFERENCES grid(id);


--
-- TOC entry 2096 (class 2606 OID 27782)
-- Name: fk_cases_region_landslide; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY cases
    ADD CONSTRAINT fk_cases_region_landslide FOREIGN KEY (id_region_landslide) REFERENCES region_landslide(id);


--
-- TOC entry 2095 (class 2606 OID 27777)
-- Name: fk_cases_region_map; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY cases
    ADD CONSTRAINT fk_cases_region_map FOREIGN KEY (id_region_map) REFERENCES region_map(id);


--
-- TOC entry 2100 (class 2606 OID 27861)
-- Name: fk_cases_towers_status_cases; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY cases_towers_status
    ADD CONSTRAINT fk_cases_towers_status_cases FOREIGN KEY (id_case) REFERENCES cases(id);


--
-- TOC entry 2101 (class 2606 OID 27866)
-- Name: fk_cases_towers_status_grid; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY cases_towers_status
    ADD CONSTRAINT fk_cases_towers_status_grid FOREIGN KEY (id_grid) REFERENCES grid(id);


--
-- TOC entry 2102 (class 2606 OID 27871)
-- Name: fk_cases_towers_status_towers; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY cases_towers_status
    ADD CONSTRAINT fk_cases_towers_status_towers FOREIGN KEY (id_tower, id_grid) REFERENCES grid_towers(id, id_grid);


--
-- TOC entry 2103 (class 2606 OID 28187)
-- Name: fk_cases_towers_status_type_element; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY cases_towers_status
    ADD CONSTRAINT fk_cases_towers_status_type_element FOREIGN KEY (id_type_element) REFERENCES type_element(id);


--
-- TOC entry 2116 (class 2606 OID 28208)
-- Name: fk_grid_eng_measures_elements; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY eng_measures
    ADD CONSTRAINT fk_grid_eng_measures_elements FOREIGN KEY (id_element) REFERENCES elements(id);


--
-- TOC entry 2089 (class 2606 OID 27641)
-- Name: fk_grid_lines_from; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY grid_lines
    ADD CONSTRAINT fk_grid_lines_from FOREIGN KEY (from_, id_grid) REFERENCES grid_stations(name, id_grid);


--
-- TOC entry 2091 (class 2606 OID 27651)
-- Name: fk_grid_lines_grid; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY grid_lines
    ADD CONSTRAINT fk_grid_lines_grid FOREIGN KEY (id_grid) REFERENCES grid(id);


--
-- TOC entry 2090 (class 2606 OID 27646)
-- Name: fk_grid_lines_to; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY grid_lines
    ADD CONSTRAINT fk_grid_lines_to FOREIGN KEY (to_, id_grid) REFERENCES grid_stations(name, id_grid);


--
-- TOC entry 2088 (class 2606 OID 27610)
-- Name: fk_grid_stations_grid; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY grid_stations
    ADD CONSTRAINT fk_grid_stations_grid FOREIGN KEY (id_grid) REFERENCES grid(id);


--
-- TOC entry 2112 (class 2606 OID 28081)
-- Name: fk_grid_stations_status_grid; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY grid_stations_status
    ADD CONSTRAINT fk_grid_stations_status_grid FOREIGN KEY (id_grid) REFERENCES grid(id);


--
-- TOC entry 2113 (class 2606 OID 28086)
-- Name: fk_grid_stations_status_tower; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY grid_stations_status
    ADD CONSTRAINT fk_grid_stations_status_tower FOREIGN KEY (id_station, id_grid) REFERENCES grid_stations(id, id_grid);


--
-- TOC entry 2109 (class 2606 OID 28053)
-- Name: fk_grid_stations_susc_grid; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY grid_stations_susc
    ADD CONSTRAINT fk_grid_stations_susc_grid FOREIGN KEY (id_grid) REFERENCES grid(id);


--
-- TOC entry 2110 (class 2606 OID 28058)
-- Name: fk_grid_stations_susc_map; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY grid_stations_susc
    ADD CONSTRAINT fk_grid_stations_susc_map FOREIGN KEY (id_map) REFERENCES region_map(id);


--
-- TOC entry 2111 (class 2606 OID 28063)
-- Name: fk_grid_stations_susc_tower; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY grid_stations_susc
    ADD CONSTRAINT fk_grid_stations_susc_tower FOREIGN KEY (id_station, id_grid) REFERENCES grid_stations(id, id_grid);


--
-- TOC entry 2114 (class 2606 OID 28192)
-- Name: fk_grid_stations_type_element; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY grid_stations_status
    ADD CONSTRAINT fk_grid_stations_type_element FOREIGN KEY (id_type_element) REFERENCES type_element(id);


--
-- TOC entry 2093 (class 2606 OID 27672)
-- Name: fk_grid_towers_grid; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY grid_towers
    ADD CONSTRAINT fk_grid_towers_grid FOREIGN KEY (id_grid) REFERENCES grid(id);


--
-- TOC entry 2092 (class 2606 OID 27667)
-- Name: fk_grid_towers_label_line; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY grid_towers
    ADD CONSTRAINT fk_grid_towers_label_line FOREIGN KEY (label_line, id_grid) REFERENCES grid_lines(label, id_grid);


--
-- TOC entry 2104 (class 2606 OID 27884)
-- Name: fk_grid_towers_status_grid; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY grid_towers_status
    ADD CONSTRAINT fk_grid_towers_status_grid FOREIGN KEY (id_grid) REFERENCES grid(id);


--
-- TOC entry 2105 (class 2606 OID 27889)
-- Name: fk_grid_towers_status_tower; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY grid_towers_status
    ADD CONSTRAINT fk_grid_towers_status_tower FOREIGN KEY (id_tower, id_grid) REFERENCES grid_towers(id, id_grid);


--
-- TOC entry 2106 (class 2606 OID 28182)
-- Name: fk_grid_towers_status_type_element; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY grid_towers_status
    ADD CONSTRAINT fk_grid_towers_status_type_element FOREIGN KEY (id_type_element) REFERENCES type_element(id);


--
-- TOC entry 2097 (class 2606 OID 27815)
-- Name: fk_grid_towers_susc_grid; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY grid_towers_susc
    ADD CONSTRAINT fk_grid_towers_susc_grid FOREIGN KEY (id_grid) REFERENCES grid(id);


--
-- TOC entry 2098 (class 2606 OID 27820)
-- Name: fk_grid_towers_susc_map; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY grid_towers_susc
    ADD CONSTRAINT fk_grid_towers_susc_map FOREIGN KEY (id_map) REFERENCES region_map(id);


--
-- TOC entry 2099 (class 2606 OID 27825)
-- Name: fk_grid_towers_susc_tower; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY grid_towers_susc
    ADD CONSTRAINT fk_grid_towers_susc_tower FOREIGN KEY (id_tower, id_grid) REFERENCES grid_towers(id, id_grid);


--
-- TOC entry 2118 (class 2606 OID 28291)
-- Name: fk_grid_trans_elements_status_land_transportation; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY trans_elements_status
    ADD CONSTRAINT fk_grid_trans_elements_status_land_transportation FOREIGN KEY (id_land_transportation) REFERENCES land_transportation(id);


--
-- TOC entry 2119 (class 2606 OID 28296)
-- Name: fk_grid_trans_elements_status_trans_element; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY trans_elements_status
    ADD CONSTRAINT fk_grid_trans_elements_status_trans_element FOREIGN KEY (id_trans_elements, id_land_transportation) REFERENCES trans_elements(id, id_land_transportation);


--
-- TOC entry 2115 (class 2606 OID 28177)
-- Name: fk_grid_type_element_elements; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY type_element
    ADD CONSTRAINT fk_grid_type_element_elements FOREIGN KEY (id_element) REFERENCES elements(id);


--
-- TOC entry 2117 (class 2606 OID 28247)
-- Name: fk_pk_trans_elements_land_transportation; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY trans_elements
    ADD CONSTRAINT fk_pk_trans_elements_land_transportation FOREIGN KEY (id_land_transportation) REFERENCES land_transportation(id);


--
-- TOC entry 2120 (class 2606 OID 28301)
-- Name: fk_trans_elements_status_type_element; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY trans_elements_status
    ADD CONSTRAINT fk_trans_elements_status_type_element FOREIGN KEY (id_type_element) REFERENCES type_element(id);


--
-- TOC entry 2121 (class 2606 OID 28311)
-- Name: fk_trans_elements_susc_grid; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY trans_elements_susc
    ADD CONSTRAINT fk_trans_elements_susc_grid FOREIGN KEY (id_land_transportation) REFERENCES land_transportation(id);


--
-- TOC entry 2122 (class 2606 OID 28316)
-- Name: fk_trans_elements_susc_map; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY trans_elements_susc
    ADD CONSTRAINT fk_trans_elements_susc_map FOREIGN KEY (id_map) REFERENCES region_map(id);


--
-- TOC entry 2123 (class 2606 OID 28321)
-- Name: fk_trans_elements_susc_tower; Type: FK CONSTRAINT; Schema: alpine; Owner: postgres
--

ALTER TABLE ONLY trans_elements_susc
    ADD CONSTRAINT fk_trans_elements_susc_tower FOREIGN KEY (id_trans_elements, id_land_transportation) REFERENCES trans_elements(id, id_land_transportation);


-- Completed on 2017-04-25 16:28:05

--
-- PostgreSQL database dump complete
--

