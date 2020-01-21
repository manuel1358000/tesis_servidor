--
-- PostgreSQL database dump
--

-- Dumped from database version 10.10
-- Dumped by pg_dump version 10.10

-- Started on 2020-01-20 18:34:02

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 12924)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2827 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 213 (class 1255 OID 32891)
-- Name: crear_publicacion(integer, character varying, character varying, double precision, double precision, integer, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.crear_publicacion(p_tipo integer, p_nombre character varying, p_descripcion character varying, p_posicion_x double precision, p_posicion_y double precision, p_estado integer, p_cui bigint) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	insert into publicacion(tipo,nombre,descripcion,posicion_x,posicion_y,estado)values(p_tipo,p_nombre,p_descripcion,p_posicion_x,p_posicion_y,p_estado);
	insert into asignacion(cod_usuario,cod_publicacion)values((select cod_usuario from usuario where cui=p_cui),(SELECT currval(pg_get_serial_sequence('publicacion','cod_publicacion'))));
END;
$$;


ALTER FUNCTION public.crear_publicacion(p_tipo integer, p_nombre character varying, p_descripcion character varying, p_posicion_x double precision, p_posicion_y double precision, p_estado integer, p_cui bigint) OWNER TO postgres;

--
-- TOC entry 214 (class 1255 OID 32892)
-- Name: crear_publicacion(integer, character varying, character varying, double precision, double precision, integer, bigint, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.crear_publicacion(p_tipo integer, p_nombre character varying, p_descripcion character varying, p_posicion_x double precision, p_posicion_y double precision, p_estado integer, p_cui bigint, p_subtipo integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	insert into publicacion(tipo,nombre,descripcion,posicion_x,posicion_y,estado,subtipo)values(p_tipo,p_nombre,p_descripcion,p_posicion_x,p_posicion_y,p_estado,p_subtipo);
	insert into asignacion(cod_usuario,cod_publicacion)values((select cod_usuario from usuario where cui=p_cui),(SELECT currval(pg_get_serial_sequence('publicacion','cod_publicacion'))));
END;
$$;


ALTER FUNCTION public.crear_publicacion(p_tipo integer, p_nombre character varying, p_descripcion character varying, p_posicion_x double precision, p_posicion_y double precision, p_estado integer, p_cui bigint, p_subtipo integer) OWNER TO postgres;

--
-- TOC entry 215 (class 1255 OID 32893)
-- Name: crear_publicacion(integer, character varying, character varying, double precision, double precision, integer, bigint, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.crear_publicacion(p_tipo integer, p_nombre character varying, p_descripcion character varying, p_posicion_x double precision, p_posicion_y double precision, p_estado integer, p_cui bigint, p_subtipo integer, p_fechahora character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	insert into publicacion(tipo,nombre,descripcion,posicion_x,posicion_y,estado,subtipo,fechahora)values(p_tipo,p_nombre,p_descripcion,p_posicion_x,p_posicion_y,p_estado,p_subtipo,TO_TIMESTAMP(p_fechahora,'YYYY/MM/DD HH24:MI:SS'));
	insert into asignacion(cod_usuario,cod_publicacion)values((select cod_usuario from usuario where cui=p_cui),(SELECT currval(pg_get_serial_sequence('publicacion','cod_publicacion'))));
END;
$$;


ALTER FUNCTION public.crear_publicacion(p_tipo integer, p_nombre character varying, p_descripcion character varying, p_posicion_x double precision, p_posicion_y double precision, p_estado integer, p_cui bigint, p_subtipo integer, p_fechahora character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 200 (class 1259 OID 24703)
-- Name: asignacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asignacion (
    fecha date,
    hora time without time zone,
    cod_usuario integer NOT NULL,
    cod_publicacion integer NOT NULL
);


ALTER TABLE public.asignacion OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 24695)
-- Name: publicacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publicacion (
    cod_publicacion integer NOT NULL,
    tipo integer NOT NULL,
    nombre character varying(500) NOT NULL,
    descripcion character varying(2000) NOT NULL,
    posicion_x double precision NOT NULL,
    posicion_y double precision NOT NULL,
    estado integer NOT NULL,
    subtipo integer,
    fechahora timestamp with time zone
);


ALTER TABLE public.publicacion OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 24693)
-- Name: publicacion_cod_publicacion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.publicacion ALTER COLUMN cod_publicacion ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.publicacion_cod_publicacion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 197 (class 1259 OID 24682)
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    cod_usuario integer NOT NULL,
    cui bigint NOT NULL,
    nombre character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    tipo integer NOT NULL,
    estado integer NOT NULL,
    imagen character varying(255)
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 24680)
-- Name: usuario_cod_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_cod_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuario_cod_usuario_seq OWNER TO postgres;

--
-- TOC entry 2828 (class 0 OID 0)
-- Dependencies: 196
-- Name: usuario_cod_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_cod_usuario_seq OWNED BY public.usuario.cod_usuario;


--
-- TOC entry 2685 (class 2604 OID 24685)
-- Name: usuario cod_usuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario ALTER COLUMN cod_usuario SET DEFAULT nextval('public.usuario_cod_usuario_seq'::regclass);


--
-- TOC entry 2819 (class 0 OID 24703)
-- Dependencies: 200
-- Data for Name: asignacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asignacion (fecha, hora, cod_usuario, cod_publicacion) FROM stdin;
\N	\N	160	114
\N	\N	160	116
\N	\N	160	118
\N	\N	163	119
\N	\N	173	120
\N	\N	173	129
\N	\N	137	131
\N	\N	137	132
\N	\N	137	133
\N	\N	137	134
\N	\N	137	135
\N	\N	137	136
\N	\N	137	137
\N	\N	137	138
\N	\N	137	139
\N	\N	137	140
\N	\N	137	141
\N	\N	137	142
\N	\N	137	143
\N	\N	137	144
\N	\N	137	145
\N	\N	137	146
\N	\N	137	147
\N	\N	137	148
\N	\N	137	149
\N	\N	137	151
\N	\N	169	158
\N	\N	169	159
\N	\N	169	160
\N	\N	169	161
\N	\N	169	162
\N	\N	174	163
\N	\N	174	164
\N	\N	174	165
\N	\N	174	166
\N	\N	174	167
\N	\N	174	168
\N	\N	174	169
\N	\N	174	170
\N	\N	174	171
\N	\N	174	172
\N	\N	174	173
\N	\N	174	174
\N	\N	174	175
\N	\N	174	176
\N	\N	174	177
\N	\N	174	178
\N	\N	174	179
\.


--
-- TOC entry 2818 (class 0 OID 24695)
-- Dependencies: 199
-- Data for Name: publicacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publicacion (cod_publicacion, tipo, nombre, descripcion, posicion_x, posicion_y, estado, subtipo, fechahora) FROM stdin;
147	1	aaa	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.624257333333333	-90.563536983333321	1	1	2019-11-26 20:55:00-06
158	1	lll	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.623636425885369	-90.562527732580961	1	1	2019-11-26 20:55:00-06
159	1	lll	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.623636425885369	-90.562527732580961	1	1	2019-11-26 20:55:00-06
160	1	Alerta Seguridad	Boton de panico activado por el usuario manuel	14.623920300000002	-90.562788149999989	1	1	2020-01-18 10:38:51-06
161	1	Alerta Seguridad	Boton de panico activado por el usuario manuel	14.623920300000002	-90.562788149999989	1	1	2020-01-18 10:38:51-06
162	1	Alerta Seguridad	Boton de panico activado por el usuario manuel	14.623920300000002	-90.562788149999989	1	1	2020-01-18 10:38:51-06
163	1	Alerta Seguridad	Boton de panico activado por el usuario manuel	14.623758746090548	-90.562816054835238	1	1	2020-01-18 10:42:03-06
164	1	Alerta Seguridad	Boton de panico activado por el usuario manuel	14.623758746090548	-90.562816054835238	1	1	2020-01-18 10:42:03-06
165	1	Alerta Seguridad	Boton de panico activado por el usuario manuel	14.623758746090548	-90.562816054835238	1	1	2020-01-18 10:42:12-06
108	1	Primera Publicacion	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	15.119999999999999	10.15	1	1	2019-11-26 20:55:00-06
131	1	aa	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.623890822651124	-90.562813821820185	1	1	2019-11-26 20:55:00-06
132	1	aass	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.623890822651124	-90.562813821820185	1	1	2019-11-26 20:55:00-06
133	1	aadd	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.623890822651124	-90.562813821820185	1	1	2019-11-26 20:55:00-06
134	1	ayy	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.623890822651124	-90.562813821820185	1	1	2019-11-26 20:55:00-06
148	1	aaa	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.624257333333333	-90.563536983333321	1	1	2019-11-26 20:55:00-06
166	1	Alerta Seguridad	Boton de panico activado por el usuario manuel	14.623758746090548	-90.562816054835238	1	1	2020-01-18 10:42:16-06
167	1	Alerta Seguridad	Boton de panico activado por el usuario manuel	14.623758746090548	-90.562816054835238	1	1	2020-01-18 10:44:26-06
111	1	PUBLICACION	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	10	10	1	1	2019-11-26 20:55:00-06
169	1	Alerta Seguridad c3	Boton de panico activado por el usuario Manuel incendio	14.623758746090548	-90.562816054835238	1	6	2020-01-18 11:14:36-06
114	1	PUBLICACION final	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	10	10	1	1	2019-11-26 20:55:00-06
116	1	PUBLICACION final	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	10	10	1	1	2019-11-26 20:55:00-06
118	1	PUBLICACION prueba	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	10	10	1	1	2019-11-26 20:55:00-06
119	1	PUBLICACION prueba	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	10	10	1	1	2019-11-26 20:55:00-06
135	1	qqq	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.623890822651124	-90.562813821820185	1	1	2019-11-26 20:55:00-06
149	1	fff	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.624257333333333	-90.563536983333321	1	1	2019-11-26 20:55:00-06
174	1	Alerta Seguridad	Boton de panico activado por el usuario manuel	14.623920300000002	-90.562788149999989	1	15	2020-01-18 12:20:09-06
170	2	prueba	prueba	14.623758746090548	-90.562816054835238	2	1	2020-01-31 18:15:00-06
171	2	prueba 3	prueba 3	14.623758746090548	-90.562816054835238	2	1	2020-01-05 16:20:00-06
172	2	prueba 4	prueba 5	14.623758746090548	-90.562816054835238	2	1	2020-01-05 09:24:00-06
173	2	prueba5	prueba5	14.623758746090548	-90.562816054835238	2	11	2020-01-12 19:25:00-06
168	1	Alerta Seguridad	Boton de panico activado por el usuario manuel	14.623758746090548	-90.562816054835238	1	1	2020-01-18 11:11:56-06
120	1	Primera Publicacion	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	15.119999999999999	10.15	1	1	2019-11-26 20:55:00-06
129	1	Primera Publicacion	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	15.119999999999999	10.15	1	1	2019-11-26 20:55:00-06
136	1	asa	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.623870583333334	-90.562323233333331	1	1	2019-11-26 20:55:00-06
137	1	ddd	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.623870583333334	-90.562323233333331	1	1	2019-11-26 20:55:00-06
138	1	aaa	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.623870583333334	-90.562323233333331	1	1	2019-11-26 20:55:00-06
139	1	ytfr	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.623870583333334	-90.562323233333331	1	1	2019-11-26 20:55:00-06
140	1	rhrhrh	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.623870583333334	-90.562323233333331	1	1	2019-11-26 20:55:00-06
141	1	rhrhrh	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.623870583333334	-90.562323233333331	1	1	2019-11-26 20:55:00-06
142	1	hggg	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.623870583333334	-90.562323233333331	1	1	2019-11-26 20:55:00-06
143	1	yggg	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.623870583333334	-90.562323233333331	1	1	2019-11-26 20:55:00-06
144	1	gjtj	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.623870583333334	-90.562323233333331	1	1	2019-11-26 20:55:00-06
145	1	df	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.6237946	-90.562776400000004	1	1	2019-11-26 20:55:00-06
146	1	df	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.6237946	-90.562776400000004	1	1	2019-11-26 20:55:00-06
151	1	ttt	Texto de prueba que vamos a verificar si cabe en la tarjeta sino vamos a tener que modificar la informacion para que pueda entrar toda, esto lo vamos a tener que eliminar si tiene demaciado texto vamos a verificar la informacion	14.624257333333333	-90.563536983333321	1	1	2019-11-26 20:55:00-06
175	2	verificar2	Verificar2	14.621250733333333	-90.562879983333332	2	14	2020-01-21 16:30:00-06
176	2	verificar2	Verificar2	14.621250733333333	-90.562879983333332	2	14	2020-01-21 16:30:00-06
177	2	verificar2	Verificar2	14.621250733333333	-90.562879983333332	2	14	2020-01-21 16:30:00-06
179	2	verificar4	Verificar4	14.621250733333333	-90.562879983333332	2	14	2020-01-21 17:37:00-06
178	2	verificar c1	Verificar2	14.621250733333333	-90.562879983333332	2	13	2020-01-30 02:32:00-06
\.


--
-- TOC entry 2816 (class 0 OID 24682)
-- Dependencies: 197
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (cod_usuario, cui, nombre, password, tipo, estado, imagen) FROM stdin;
161	3	a	a	1	1	\N
162	4	a	a	1	1	\N
163	20	20	30	1	1	\N
164	123	a	a	1	1	\N
165	54	a	a	1	1	\N
166	99	a	a	1	1	\N
167	36	a	a	1	1	\N
170	2433	a	a	1	1	\N
171	1436	a	a	1	1	\N
172	243343655	manuel fuentes	manuel	1	1	\N
173	2433436551202	manuel	manuel	1	1	\N
175	111	a	a	1	1	\N
177	1111	a	a	1	1	\N
179	1231	a	a	1	1	\N
180	1223	a	a	1	1	\N
182	8000	Manuel Antonio Fuentes Fuentes	manuel	1	1	\N
183	2020	mmn	m	1	1	\N
184	2021	uhgsgsgd 	m	1	1	\N
185	2022	hhh	gg	1	1	\N
186	2023	ttt	gttt	1	1	\N
187	4000	man	man	1	1	\N
188	2025	man	man	1	1	\N
189	2026	man	man	1	1	\N
190	2027	man	man	1	1	\N
191	2028	man	man	1	1	\N
192	2029	ma	ma	1	1	\N
194	2030	manu	man	1	1	\N
196	2031	man	man	1	1	\N
197	2032	n	h	1	1	\N
198	2034	j	h	1	1	\N
199	2036	b	hh	1	1	\N
200	2037	m	g	1	1	\N
202	2038	m	n	1	1	\N
203	2039	mm	n	1	1	\N
204	2041	j	j	1	1	\N
205	2042	j	k	1	1	\N
207	2043	k	k	1	1	\N
137	1	a	a	1	1	\N
208	2045	k	k	1	1	\N
209	2050	oo	ppp	1	1	\N
169	1233	manuel	a	1	1	\N
160	2000	a	a	1	1	\N
211	1212	foto	foto	1	1	1212_13.jpg
212	1213	foto	foto	1	1	1213_13.jpg
213	1214	foto	foto	1	1	1214_Holiday Christmas Poster.png
214	1215	foto	foto	1	1	1215_Holiday_Christmas_Poster.png
174	1000	manuel	admin	2	1	1000_14.jpg
215	2222222	manuel1	ttt	1	1	664593_FB_IMG_1579265770174.jpg
\.


--
-- TOC entry 2829 (class 0 OID 0)
-- Dependencies: 198
-- Name: publicacion_cod_publicacion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.publicacion_cod_publicacion_seq', 179, true);


--
-- TOC entry 2830 (class 0 OID 0)
-- Dependencies: 196
-- Name: usuario_cod_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_cod_usuario_seq', 215, true);


--
-- TOC entry 2687 (class 2606 OID 24692)
-- Name: usuario constraint_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT constraint_name UNIQUE (cui);


--
-- TOC entry 2691 (class 2606 OID 24699)
-- Name: publicacion publicacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publicacion
    ADD CONSTRAINT publicacion_pkey PRIMARY KEY (cod_publicacion);


--
-- TOC entry 2689 (class 2606 OID 24690)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (cod_usuario);


--
-- TOC entry 2693 (class 2606 OID 24711)
-- Name: asignacion fk_cod_publicacion; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asignacion
    ADD CONSTRAINT fk_cod_publicacion FOREIGN KEY (cod_publicacion) REFERENCES public.publicacion(cod_publicacion);


--
-- TOC entry 2692 (class 2606 OID 24706)
-- Name: asignacion fk_cod_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asignacion
    ADD CONSTRAINT fk_cod_usuario FOREIGN KEY (cod_usuario) REFERENCES public.usuario(cod_usuario);


-- Completed on 2020-01-20 18:34:05

--
-- PostgreSQL database dump complete
--

