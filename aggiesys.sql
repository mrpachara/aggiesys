--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.1
-- Dumped by pg_dump version 9.4.1
-- Started on 2015-03-21 14:24:50 ICT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 210 (class 3079 OID 11895)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2344 (class 0 OID 0)
-- Dependencies: 210
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 209 (class 3079 OID 16387)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 2345 (class 0 OID 0)
-- Dependencies: 209
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- TOC entry 211 (class 3079 OID 16396)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 2346 (class 0 OID 0)
-- Dependencies: 211
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 172 (class 1259 OID 16431)
-- Name: billheader; Type: TABLE; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE TABLE billheader (
    id bigint NOT NULL,
    code character varying(64) NOT NULL,
    date timestamp with time zone NOT NULL,
    id_debtor bigint,
    fullname character varying(128) NOT NULL,
    address text NOT NULL,
    tstmp time with time zone DEFAULT transaction_timestamp() NOT NULL,
    id_creator bigint NOT NULL
);


ALTER TABLE billheader OWNER TO aggiesys;

--
-- TOC entry 173 (class 1259 OID 16438)
-- Name: billheader_id_seq; Type: SEQUENCE; Schema: public; Owner: aggiesys
--

CREATE SEQUENCE billheader_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE billheader_id_seq OWNER TO aggiesys;

--
-- TOC entry 2347 (class 0 OID 0)
-- Dependencies: 173
-- Name: billheader_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aggiesys
--

ALTER SEQUENCE billheader_id_seq OWNED BY billheader.id;


--
-- TOC entry 174 (class 1259 OID 16440)
-- Name: carriage; Type: TABLE; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE TABLE carriage (
    id bigint NOT NULL,
    code character varying(64) NOT NULL,
    registration character varying(32) NOT NULL,
    code_typecarriage character varying(16) NOT NULL,
    name character varying(128) NOT NULL
);


ALTER TABLE carriage OWNER TO aggiesys;

--
-- TOC entry 175 (class 1259 OID 16443)
-- Name: carriage_id_seq; Type: SEQUENCE; Schema: public; Owner: aggiesys
--

CREATE SEQUENCE carriage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE carriage_id_seq OWNER TO aggiesys;

--
-- TOC entry 2348 (class 0 OID 0)
-- Dependencies: 175
-- Name: carriage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aggiesys
--

ALTER SEQUENCE carriage_id_seq OWNED BY carriage.id;


--
-- TOC entry 176 (class 1259 OID 16445)
-- Name: customer; Type: TABLE; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE TABLE customer (
    id bigint NOT NULL,
    code character varying(64) NOT NULL,
    name character varying(128) NOT NULL,
    address text
);


ALTER TABLE customer OWNER TO aggiesys;

--
-- TOC entry 177 (class 1259 OID 16451)
-- Name: customer_id_seq; Type: SEQUENCE; Schema: public; Owner: aggiesys
--

CREATE SEQUENCE customer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customer_id_seq OWNER TO aggiesys;

--
-- TOC entry 2349 (class 0 OID 0)
-- Dependencies: 177
-- Name: customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aggiesys
--

ALTER SEQUENCE customer_id_seq OWNED BY customer.id;


--
-- TOC entry 178 (class 1259 OID 16453)
-- Name: deliverydetail; Type: TABLE; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE TABLE deliverydetail (
    id bigint NOT NULL,
    id_docdetail bigint NOT NULL,
    id_vegetable bigint NOT NULL
);


ALTER TABLE deliverydetail OWNER TO aggiesys;

--
-- TOC entry 179 (class 1259 OID 16456)
-- Name: deliverydetail_id_seq; Type: SEQUENCE; Schema: public; Owner: aggiesys
--

CREATE SEQUENCE deliverydetail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE deliverydetail_id_seq OWNER TO aggiesys;

--
-- TOC entry 2350 (class 0 OID 0)
-- Dependencies: 179
-- Name: deliverydetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aggiesys
--

ALTER SEQUENCE deliverydetail_id_seq OWNED BY deliverydetail.id;


--
-- TOC entry 180 (class 1259 OID 16458)
-- Name: deliveryhead; Type: TABLE; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE TABLE deliveryhead (
    id bigint NOT NULL,
    id_farm bigint NOT NULL,
    fullname character varying(128) NOT NULL,
    address text NOT NULL,
    id_doc bigint NOT NULL
);


ALTER TABLE deliveryhead OWNER TO aggiesys;

--
-- TOC entry 181 (class 1259 OID 16464)
-- Name: deliveryhead_id_seq; Type: SEQUENCE; Schema: public; Owner: aggiesys
--

CREATE SEQUENCE deliveryhead_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE deliveryhead_id_seq OWNER TO aggiesys;

--
-- TOC entry 2351 (class 0 OID 0)
-- Dependencies: 181
-- Name: deliveryhead_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aggiesys
--

ALTER SEQUENCE deliveryhead_id_seq OWNED BY deliveryhead.id;


--
-- TOC entry 182 (class 1259 OID 16466)
-- Name: doc; Type: TABLE; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE TABLE doc (
    id bigint NOT NULL,
    code character varying(32) NOT NULL,
    date timestamp with time zone NOT NULL,
    type character varying(16) NOT NULL,
    id_creator bigint NOT NULL,
    tstmp timestamp with time zone DEFAULT now() NOT NULL,
    id_doc bigint
);


ALTER TABLE doc OWNER TO aggiesys;

--
-- TOC entry 183 (class 1259 OID 16470)
-- Name: doc_id_seq; Type: SEQUENCE; Schema: public; Owner: aggiesys
--

CREATE SEQUENCE doc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE doc_id_seq OWNER TO aggiesys;

--
-- TOC entry 2352 (class 0 OID 0)
-- Dependencies: 183
-- Name: doc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aggiesys
--

ALTER SEQUENCE doc_id_seq OWNED BY doc.id;


--
-- TOC entry 184 (class 1259 OID 16472)
-- Name: docdetail; Type: TABLE; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE TABLE docdetail (
    id bigint NOT NULL,
    item character varying(256) NOT NULL,
    qty numeric NOT NULL,
    price numeric NOT NULL,
    id_doc bigint NOT NULL
);


ALTER TABLE docdetail OWNER TO aggiesys;

--
-- TOC entry 185 (class 1259 OID 16478)
-- Name: docdetail_id_seq; Type: SEQUENCE; Schema: public; Owner: aggiesys
--

CREATE SEQUENCE docdetail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE docdetail_id_seq OWNER TO aggiesys;

--
-- TOC entry 2353 (class 0 OID 0)
-- Dependencies: 185
-- Name: docdetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aggiesys
--

ALTER SEQUENCE docdetail_id_seq OWNED BY docdetail.id;


--
-- TOC entry 186 (class 1259 OID 16480)
-- Name: docref; Type: TABLE; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE TABLE docref (
    id bigint NOT NULL,
    id_doc bigint NOT NULL,
    id_ref bigint NOT NULL
);


ALTER TABLE docref OWNER TO aggiesys;

--
-- TOC entry 187 (class 1259 OID 16483)
-- Name: docref_id_seq; Type: SEQUENCE; Schema: public; Owner: aggiesys
--

CREATE SEQUENCE docref_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE docref_id_seq OWNER TO aggiesys;

--
-- TOC entry 2354 (class 0 OID 0)
-- Dependencies: 187
-- Name: docref_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aggiesys
--

ALTER SEQUENCE docref_id_seq OWNED BY docref.id;


--
-- TOC entry 188 (class 1259 OID 16485)
-- Name: etc; Type: TABLE; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE TABLE etc (
    id bigint NOT NULL,
    code character varying(16) NOT NULL,
    name character varying(128) NOT NULL
);


ALTER TABLE etc OWNER TO aggiesys;

--
-- TOC entry 189 (class 1259 OID 16488)
-- Name: etc_id_seq; Type: SEQUENCE; Schema: public; Owner: aggiesys
--

CREATE SEQUENCE etc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE etc_id_seq OWNER TO aggiesys;

--
-- TOC entry 2355 (class 0 OID 0)
-- Dependencies: 189
-- Name: etc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aggiesys
--

ALTER SEQUENCE etc_id_seq OWNED BY etc.id;


--
-- TOC entry 190 (class 1259 OID 16490)
-- Name: etcitem; Type: TABLE; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE TABLE etcitem (
    id bigint NOT NULL,
    id_etc bigint NOT NULL,
    code character varying(16) NOT NULL,
    value character varying(128) NOT NULL
);


ALTER TABLE etcitem OWNER TO aggiesys;

--
-- TOC entry 191 (class 1259 OID 16493)
-- Name: etcitem_id_seq; Type: SEQUENCE; Schema: public; Owner: aggiesys
--

CREATE SEQUENCE etcitem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE etcitem_id_seq OWNER TO aggiesys;

--
-- TOC entry 2356 (class 0 OID 0)
-- Dependencies: 191
-- Name: etcitem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aggiesys
--

ALTER SEQUENCE etcitem_id_seq OWNED BY etcitem.id;


--
-- TOC entry 192 (class 1259 OID 16495)
-- Name: farm; Type: TABLE; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE TABLE farm (
    id bigint NOT NULL,
    code character varying(64) NOT NULL,
    name character varying(128) NOT NULL,
    address text
);


ALTER TABLE farm OWNER TO aggiesys;

--
-- TOC entry 193 (class 1259 OID 16501)
-- Name: farm_id_seq; Type: SEQUENCE; Schema: public; Owner: aggiesys
--

CREATE SEQUENCE farm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE farm_id_seq OWNER TO aggiesys;

--
-- TOC entry 2357 (class 0 OID 0)
-- Dependencies: 193
-- Name: farm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aggiesys
--

ALTER SEQUENCE farm_id_seq OWNED BY farm.id;


--
-- TOC entry 194 (class 1259 OID 16503)
-- Name: generator; Type: TABLE; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE TABLE generator (
    id bigint NOT NULL,
    code character varying(32) NOT NULL,
    length integer NOT NULL,
    code_reuse character varying(32) NOT NULL,
    num integer NOT NULL
);


ALTER TABLE generator OWNER TO aggiesys;

--
-- TOC entry 195 (class 1259 OID 16506)
-- Name: generator_id_seq; Type: SEQUENCE; Schema: public; Owner: aggiesys
--

CREATE SEQUENCE generator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE generator_id_seq OWNER TO aggiesys;

--
-- TOC entry 2358 (class 0 OID 0)
-- Dependencies: 195
-- Name: generator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aggiesys
--

ALTER SEQUENCE generator_id_seq OWNED BY generator.id;


--
-- TOC entry 196 (class 1259 OID 16508)
-- Name: product; Type: TABLE; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE TABLE product (
    id bigint NOT NULL,
    code character varying(64),
    name character varying(128)
);


ALTER TABLE product OWNER TO aggiesys;

--
-- TOC entry 197 (class 1259 OID 16511)
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: aggiesys
--

CREATE SEQUENCE product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE product_id_seq OWNER TO aggiesys;

--
-- TOC entry 2359 (class 0 OID 0)
-- Dependencies: 197
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aggiesys
--

ALTER SEQUENCE product_id_seq OWNED BY product.id;


--
-- TOC entry 198 (class 1259 OID 16513)
-- Name: saledetail; Type: TABLE; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE TABLE saledetail (
    id bigint NOT NULL,
    id_docdetail bigint NOT NULL,
    id_vegetable bigint NOT NULL
);


ALTER TABLE saledetail OWNER TO aggiesys;

--
-- TOC entry 199 (class 1259 OID 16516)
-- Name: saledetail_id_seq; Type: SEQUENCE; Schema: public; Owner: aggiesys
--

CREATE SEQUENCE saledetail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE saledetail_id_seq OWNER TO aggiesys;

--
-- TOC entry 2360 (class 0 OID 0)
-- Dependencies: 199
-- Name: saledetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aggiesys
--

ALTER SEQUENCE saledetail_id_seq OWNED BY saledetail.id;


--
-- TOC entry 200 (class 1259 OID 16518)
-- Name: salehead; Type: TABLE; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE TABLE salehead (
    id_customer bigint NOT NULL,
    fullname character varying(128) NOT NULL,
    id_doc bigint NOT NULL,
    address text NOT NULL,
    id_carriage bigint,
    id bigint NOT NULL
);


ALTER TABLE salehead OWNER TO aggiesys;

--
-- TOC entry 208 (class 1259 OID 16748)
-- Name: salehead_id_seq; Type: SEQUENCE; Schema: public; Owner: aggiesys
--

CREATE SEQUENCE salehead_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE salehead_id_seq OWNER TO aggiesys;

--
-- TOC entry 2361 (class 0 OID 0)
-- Dependencies: 208
-- Name: salehead_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aggiesys
--

ALTER SEQUENCE salehead_id_seq OWNED BY salehead.id;


--
-- TOC entry 201 (class 1259 OID 16526)
-- Name: sessions; Type: TABLE; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE TABLE sessions (
    expires timestamp with time zone,
    data text,
    id_user bigint,
    id character varying(32) NOT NULL
);


ALTER TABLE sessions OWNER TO aggiesys;

--
-- TOC entry 202 (class 1259 OID 16532)
-- Name: user; Type: TABLE; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE TABLE "user" (
    id bigint NOT NULL,
    username character varying(64),
    password character varying(128),
    fullname character varying(256),
    isterminated boolean DEFAULT false NOT NULL
);


ALTER TABLE "user" OWNER TO aggiesys;

--
-- TOC entry 203 (class 1259 OID 16536)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: aggiesys
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_id_seq OWNER TO aggiesys;

--
-- TOC entry 2362 (class 0 OID 0)
-- Dependencies: 203
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aggiesys
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- TOC entry 204 (class 1259 OID 16538)
-- Name: userrole; Type: TABLE; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE TABLE userrole (
    id bigint NOT NULL,
    id_user bigint,
    role character varying(64)
);


ALTER TABLE userrole OWNER TO aggiesys;

--
-- TOC entry 205 (class 1259 OID 16541)
-- Name: userrole_id_seq; Type: SEQUENCE; Schema: public; Owner: aggiesys
--

CREATE SEQUENCE userrole_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE userrole_id_seq OWNER TO aggiesys;

--
-- TOC entry 2363 (class 0 OID 0)
-- Dependencies: 205
-- Name: userrole_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aggiesys
--

ALTER SEQUENCE userrole_id_seq OWNED BY userrole.id;


--
-- TOC entry 206 (class 1259 OID 16543)
-- Name: vegetable; Type: TABLE; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE TABLE vegetable (
    id bigint NOT NULL,
    code character varying(64),
    name character varying(128),
    price_buy numeric DEFAULT 0 NOT NULL,
    price_sell numeric DEFAULT 0 NOT NULL
);


ALTER TABLE vegetable OWNER TO aggiesys;

--
-- TOC entry 207 (class 1259 OID 16551)
-- Name: vegetable_id_seq; Type: SEQUENCE; Schema: public; Owner: aggiesys
--

CREATE SEQUENCE vegetable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE vegetable_id_seq OWNER TO aggiesys;

--
-- TOC entry 2364 (class 0 OID 0)
-- Dependencies: 207
-- Name: vegetable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aggiesys
--

ALTER SEQUENCE vegetable_id_seq OWNED BY vegetable.id;


--
-- TOC entry 2070 (class 2604 OID 16553)
-- Name: id; Type: DEFAULT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY billheader ALTER COLUMN id SET DEFAULT nextval('billheader_id_seq'::regclass);


--
-- TOC entry 2071 (class 2604 OID 16554)
-- Name: id; Type: DEFAULT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY carriage ALTER COLUMN id SET DEFAULT nextval('carriage_id_seq'::regclass);


--
-- TOC entry 2072 (class 2604 OID 16555)
-- Name: id; Type: DEFAULT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY customer ALTER COLUMN id SET DEFAULT nextval('customer_id_seq'::regclass);


--
-- TOC entry 2073 (class 2604 OID 16556)
-- Name: id; Type: DEFAULT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY deliverydetail ALTER COLUMN id SET DEFAULT nextval('deliverydetail_id_seq'::regclass);


--
-- TOC entry 2074 (class 2604 OID 16557)
-- Name: id; Type: DEFAULT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY deliveryhead ALTER COLUMN id SET DEFAULT nextval('deliveryhead_id_seq'::regclass);


--
-- TOC entry 2076 (class 2604 OID 16558)
-- Name: id; Type: DEFAULT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY doc ALTER COLUMN id SET DEFAULT nextval('doc_id_seq'::regclass);


--
-- TOC entry 2077 (class 2604 OID 16559)
-- Name: id; Type: DEFAULT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY docdetail ALTER COLUMN id SET DEFAULT nextval('docdetail_id_seq'::regclass);


--
-- TOC entry 2078 (class 2604 OID 16560)
-- Name: id; Type: DEFAULT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY docref ALTER COLUMN id SET DEFAULT nextval('docref_id_seq'::regclass);


--
-- TOC entry 2079 (class 2604 OID 16561)
-- Name: id; Type: DEFAULT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY etc ALTER COLUMN id SET DEFAULT nextval('etc_id_seq'::regclass);


--
-- TOC entry 2080 (class 2604 OID 16562)
-- Name: id; Type: DEFAULT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY etcitem ALTER COLUMN id SET DEFAULT nextval('etcitem_id_seq'::regclass);


--
-- TOC entry 2081 (class 2604 OID 16563)
-- Name: id; Type: DEFAULT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY farm ALTER COLUMN id SET DEFAULT nextval('farm_id_seq'::regclass);


--
-- TOC entry 2082 (class 2604 OID 16564)
-- Name: id; Type: DEFAULT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY generator ALTER COLUMN id SET DEFAULT nextval('generator_id_seq'::regclass);


--
-- TOC entry 2083 (class 2604 OID 16565)
-- Name: id; Type: DEFAULT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY product ALTER COLUMN id SET DEFAULT nextval('product_id_seq'::regclass);


--
-- TOC entry 2084 (class 2604 OID 16566)
-- Name: id; Type: DEFAULT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY saledetail ALTER COLUMN id SET DEFAULT nextval('saledetail_id_seq'::regclass);


--
-- TOC entry 2085 (class 2604 OID 16750)
-- Name: id; Type: DEFAULT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY salehead ALTER COLUMN id SET DEFAULT nextval('salehead_id_seq'::regclass);


--
-- TOC entry 2087 (class 2604 OID 16568)
-- Name: id; Type: DEFAULT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- TOC entry 2088 (class 2604 OID 16569)
-- Name: id; Type: DEFAULT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY userrole ALTER COLUMN id SET DEFAULT nextval('userrole_id_seq'::regclass);


--
-- TOC entry 2091 (class 2604 OID 16570)
-- Name: id; Type: DEFAULT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY vegetable ALTER COLUMN id SET DEFAULT nextval('vegetable_id_seq'::regclass);


--
-- TOC entry 2300 (class 0 OID 16431)
-- Dependencies: 172
-- Data for Name: billheader; Type: TABLE DATA; Schema: public; Owner: aggiesys
--

COPY billheader (id, code, date, id_debtor, fullname, address, tstmp, id_creator) FROM stdin;
\.


--
-- TOC entry 2365 (class 0 OID 0)
-- Dependencies: 173
-- Name: billheader_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aggiesys
--

SELECT pg_catalog.setval('billheader_id_seq', 1, false);


--
-- TOC entry 2302 (class 0 OID 16440)
-- Dependencies: 174
-- Data for Name: carriage; Type: TABLE DATA; Schema: public; Owner: aggiesys
--

COPY carriage (id, code, registration, code_typecarriage, name) FROM stdin;
3	truck001	ฮ 4321	TRUCK	Truck 001
2	pickup001	กข 1234	PICKUP	Pickup 001
\.


--
-- TOC entry 2366 (class 0 OID 0)
-- Dependencies: 175
-- Name: carriage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aggiesys
--

SELECT pg_catalog.setval('carriage_id_seq', 3, true);


--
-- TOC entry 2304 (class 0 OID 16445)
-- Dependencies: 176
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: aggiesys
--

COPY customer (id, code, name, address) FROM stdin;
2	C002	Customer 002	123\nabc\ndef
3	C001	Customer 001	123\nd\nd
\.


--
-- TOC entry 2367 (class 0 OID 0)
-- Dependencies: 177
-- Name: customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aggiesys
--

SELECT pg_catalog.setval('customer_id_seq', 3, true);


--
-- TOC entry 2306 (class 0 OID 16453)
-- Dependencies: 178
-- Data for Name: deliverydetail; Type: TABLE DATA; Schema: public; Owner: aggiesys
--

COPY deliverydetail (id, id_docdetail, id_vegetable) FROM stdin;
62	2	6
63	3	12
64	4	6
65	5	12
66	6	20
67	7	19
68	8	13
69	9	12
70	10	6
71	11	6
72	12	12
73	13	6
74	14	8
\.


--
-- TOC entry 2368 (class 0 OID 0)
-- Dependencies: 179
-- Name: deliverydetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aggiesys
--

SELECT pg_catalog.setval('deliverydetail_id_seq', 74, true);


--
-- TOC entry 2308 (class 0 OID 16458)
-- Dependencies: 180
-- Data for Name: deliveryhead; Type: TABLE DATA; Schema: public; Owner: aggiesys
--

COPY deliveryhead (id, id_farm, fullname, address, id_doc) FROM stdin;
27	2	Farm 001	123\nabc\ndef	13
28	2	Farm 001	123\nabc\ndef	14
29	2	Farm 001	123\nabc\ndef	15
30	3	Farm 002	123\nabc\ndef	16
31	2	Farm 001	123\nabc\ndef	21
32	4	asdf	asdf\nasdf\nasdf	22
\.


--
-- TOC entry 2369 (class 0 OID 0)
-- Dependencies: 181
-- Name: deliveryhead_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aggiesys
--

SELECT pg_catalog.setval('deliveryhead_id_seq', 32, true);


--
-- TOC entry 2310 (class 0 OID 16466)
-- Dependencies: 182
-- Data for Name: doc; Type: TABLE DATA; Schema: public; Owner: aggiesys
--

COPY doc (id, code, date, type, id_creator, tstmp, id_doc) FROM stdin;
16	111503080016	2015-03-08 21:10:32+07	DEBIT	3	2015-03-08 21:10:55.029+07	\N
15	111503080015	2015-03-08 18:11:46+07	DEBIT	3	2015-03-08 18:14:07.585+07	\N
14	111503080014	2015-03-08 17:38:15+07	DEBIT	3	2015-03-08 18:01:43.205+07	\N
13	111503080013	2015-03-08 17:38:15+07	DEBIT	3	2015-03-08 17:39:32.195+07	14
21	111503180001	2015-03-18 15:33:48+07	DEBIT	3	2015-03-18 15:34:16.494067+07	\N
30	001503180001	2015-03-18 17:10:46.834771+07	CANCEL	3	2015-03-18 17:10:46.834771+07	\N
29	131503180007	2015-03-18 17:10:16+07	CREDIT	3	2015-03-18 17:10:32.061792+07	30
28	131503180006	2015-03-18 16:12:30+07	CREDIT	3	2015-03-18 16:24:19.995124+07	33
34	131503180011	2015-03-18 18:29:26+07	CREDIT	3	2015-03-18 18:29:44.178191+07	\N
35	001503190001	2015-03-19 15:34:09.469252+07	CANCEL	3	2015-03-19 15:34:09.469252+07	\N
33	131503180010	2015-03-18 16:12:30+07	CREDIT	3	2015-03-18 18:23:04.667752+07	35
36	001503190002	2015-03-19 15:34:24.166802+07	CANCEL	3	2015-03-19 15:34:24.166802+07	\N
22	111503180002	2015-03-18 15:34:28+07	DEBIT	3	2015-03-18 15:34:53.264892+07	36
\.


--
-- TOC entry 2370 (class 0 OID 0)
-- Dependencies: 183
-- Name: doc_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aggiesys
--

SELECT pg_catalog.setval('doc_id_seq', 36, true);


--
-- TOC entry 2312 (class 0 OID 16472)
-- Dependencies: 184
-- Data for Name: docdetail; Type: TABLE DATA; Schema: public; Owner: aggiesys
--

COPY docdetail (id, item, qty, price, id_doc) FROM stdin;
2	abcd	100	10000	13
3	ijk	100	30000	13
4	abcd	100	10000	14
5	ijk	150	45000	14
6	piupi	300	210000	14
7	asdf	200	120000	15
8	987	150	60000	15
9	ijk	100	30000	16
10	abcd	200	20000	16
11	abcd	100	10000	21
12	ijk	150	45000	21
13	abcd	100	10000	22
14	xyz	150	30000	22
15	abcd	300	33000	28
16	xyz	150	33000	28
17	ijk	100	33000	28
18	abcd	200	22000	29
19	ijk	300	99000	29
20	piupi	300	240000	29
21	abcd	300	33000	33
22	xyz	150	33000	33
23	ijk	100	33000	33
24	abcd	200	22000	34
25	ijk	300	99000	34
26	piupi	300	240000	34
\.


--
-- TOC entry 2371 (class 0 OID 0)
-- Dependencies: 185
-- Name: docdetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aggiesys
--

SELECT pg_catalog.setval('docdetail_id_seq', 26, true);


--
-- TOC entry 2314 (class 0 OID 16480)
-- Dependencies: 186
-- Data for Name: docref; Type: TABLE DATA; Schema: public; Owner: aggiesys
--

COPY docref (id, id_doc, id_ref) FROM stdin;
13	28	16
14	28	22
15	29	14
16	29	21
21	33	16
22	33	22
23	34	14
24	34	21
\.


--
-- TOC entry 2372 (class 0 OID 0)
-- Dependencies: 187
-- Name: docref_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aggiesys
--

SELECT pg_catalog.setval('docref_id_seq', 24, true);


--
-- TOC entry 2316 (class 0 OID 16485)
-- Dependencies: 188
-- Data for Name: etc; Type: TABLE DATA; Schema: public; Owner: aggiesys
--

COPY etc (id, code, name) FROM stdin;
1	TYPE_CARRIAGE	Carriage Type
2	PREFIX_NAME	Prefix Name
4	TYPE_DOC	Type of document
\.


--
-- TOC entry 2373 (class 0 OID 0)
-- Dependencies: 189
-- Name: etc_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aggiesys
--

SELECT pg_catalog.setval('etc_id_seq', 4, true);


--
-- TOC entry 2318 (class 0 OID 16490)
-- Dependencies: 190
-- Data for Name: etcitem; Type: TABLE DATA; Schema: public; Owner: aggiesys
--

COPY etcitem (id, id_etc, code, value) FROM stdin;
58	1	PICKUP	Picup
59	1	TRUCK	Truck
71	2	MISS	Miss
72	2	MS	Ms.
73	2	PICKUP	wrong coded
79	4	CANCEL	Cancel
80	4	CREDIT	Credit
81	4	DEBIT	Debit
\.


--
-- TOC entry 2374 (class 0 OID 0)
-- Dependencies: 191
-- Name: etcitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aggiesys
--

SELECT pg_catalog.setval('etcitem_id_seq', 81, true);


--
-- TOC entry 2320 (class 0 OID 16495)
-- Dependencies: 192
-- Data for Name: farm; Type: TABLE DATA; Schema: public; Owner: aggiesys
--

COPY farm (id, code, name, address) FROM stdin;
3	F002	Farm 002	123\nabc\ndef
2	F001	Farm 001	123\nabc\ndef
4	910001	asdf	asdf\nasdf\nasdf
\.


--
-- TOC entry 2375 (class 0 OID 0)
-- Dependencies: 193
-- Name: farm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aggiesys
--

SELECT pg_catalog.setval('farm_id_seq', 4, true);


--
-- TOC entry 2322 (class 0 OID 16503)
-- Dependencies: 194
-- Data for Name: generator; Type: TABLE DATA; Schema: public; Owner: aggiesys
--

COPY generator (id, code, length, code_reuse, num) FROM stdin;
3	81	4		17
7	15	4	150225	1
8	17	4	150225	1
9	19	4	150225	1
11	92	4		1
10	91	4		2
4	11	4	150318	3
6	13	4	150318	12
12	00	4	150319	3
\.


--
-- TOC entry 2376 (class 0 OID 0)
-- Dependencies: 195
-- Name: generator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aggiesys
--

SELECT pg_catalog.setval('generator_id_seq', 12, true);


--
-- TOC entry 2324 (class 0 OID 16508)
-- Dependencies: 196
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: aggiesys
--

COPY product (id, code, name) FROM stdin;
\.


--
-- TOC entry 2377 (class 0 OID 0)
-- Dependencies: 197
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aggiesys
--

SELECT pg_catalog.setval('product_id_seq', 1, false);


--
-- TOC entry 2326 (class 0 OID 16513)
-- Dependencies: 198
-- Data for Name: saledetail; Type: TABLE DATA; Schema: public; Owner: aggiesys
--

COPY saledetail (id, id_docdetail, id_vegetable) FROM stdin;
1	15	6
2	16	8
3	17	12
4	18	6
5	19	12
6	20	20
7	21	6
8	22	8
9	23	12
10	24	6
11	25	12
12	26	20
\.


--
-- TOC entry 2378 (class 0 OID 0)
-- Dependencies: 199
-- Name: saledetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aggiesys
--

SELECT pg_catalog.setval('saledetail_id_seq', 12, true);


--
-- TOC entry 2328 (class 0 OID 16518)
-- Dependencies: 200
-- Data for Name: salehead; Type: TABLE DATA; Schema: public; Owner: aggiesys
--

COPY salehead (id_customer, fullname, id_doc, address, id_carriage, id) FROM stdin;
3	Customer 001	28	123\nd\nd	\N	1
3	Customer 001	29	123\nd\nd	2	2
3	Customer 001	33	123\nd\nd	3	3
3	Customer 001	34	123\nd\nd	2	4
\.


--
-- TOC entry 2379 (class 0 OID 0)
-- Dependencies: 208
-- Name: salehead_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aggiesys
--

SELECT pg_catalog.setval('salehead_id_seq', 4, true);


--
-- TOC entry 2329 (class 0 OID 16526)
-- Dependencies: 201
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: aggiesys
--

COPY sessions (expires, data, id_user, id) FROM stdin;
2015-03-21 17:06:30.065605+07	__GSESSION__|a:1:{s:9:"__tmpsess";N;}	3	ifgluao4ta4mdmm6bn2c22usm7
\.


--
-- TOC entry 2330 (class 0 OID 16532)
-- Dependencies: 202
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: aggiesys
--

COPY "user" (id, username, password, fullname, isterminated) FROM stdin;
1	root	$2a$06$TU8HLGppHoCZPV16el/77Ombju9tBNeU2buuMmmEQjJn/RE3tFc3K	Root	f
4	admin02	\N	Admin 02	f
33	test02	$2a$06$eqwR8/46z8ML4FJHGw5q.uVi3ytr/2m0Y1uL3t9ThUGZZDkBp35aq	Test 02	f
34	test01	$2a$06$IfDCTkGfiSvu7W5LoIQvIuPRF/d0z8limKKtb9gLAMuA5OsnBzIFq	Test 01	f
29	user02	$2a$06$sA4X9YoYOzFgdi5U1KgR6./h4F5qkM1SPAAx6vvcQuimDo4vEmWeq	User 02	f
5	user	$2a$06$w9p2q3Z9bPQVN0bHd9Bk5OAv5/QmULex5VXMdlCPzgKME9e7gyl92	User	f
35	test03	$2a$06$KIEkxHmDr94rs07DJiPg8ekQ3nY8fWyUueS6uS/WAw5WWvf3hA9Yy	Test 03	f
2	admin	$2a$06$NtN3o3lJ2ECjMt/u.B.Sr.maK7YEVWjZbY1TSpNNXq/tcCIq/2nma	Administrator	f
3	admin01	$2a$06$9CG6hIoI//DN.gutFxHz3.OCjnCpFe.MsulSdIJ2KHyX962hdVAtq	Admin 01	f
38	manager01	$2a$06$xntvH3F73rVlvFM/oNyOzO3sSvhHTqDm/0sqibFdBw1CgZf6GVSf2	Manager 01	t
\.


--
-- TOC entry 2380 (class 0 OID 0)
-- Dependencies: 203
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aggiesys
--

SELECT pg_catalog.setval('user_id_seq', 38, true);


--
-- TOC entry 2332 (class 0 OID 16538)
-- Dependencies: 204
-- Data for Name: userrole; Type: TABLE DATA; Schema: public; Owner: aggiesys
--

COPY userrole (id, id_user, role) FROM stdin;
4	4	ADMIN
5	4	USER
69	33	USER
70	33	STAFF
76	34	USER
80	29	USER
81	29	STAFF
93	5	USER
95	35	USER
104	3	ADMIN
49	2	ADMIN
122	3	MANAGER
123	3	STAFF
124	38	MANAGER
125	38	STAFF
\.


--
-- TOC entry 2381 (class 0 OID 0)
-- Dependencies: 205
-- Name: userrole_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aggiesys
--

SELECT pg_catalog.setval('userrole_id_seq', 125, true);


--
-- TOC entry 2334 (class 0 OID 16543)
-- Dependencies: 206
-- Data for Name: vegetable; Type: TABLE DATA; Schema: public; Owner: aggiesys
--

COPY vegetable (id, code, name, price_buy, price_sell) FROM stdin;
6	810001	abcd	100	110
8	810003	xyz	200	220
12	810007	ijk	300	330
13	810008	987	400	440
14	810009	jkl	500	600
19	810014	asdf	600	700
20	810015	piupi	700	800
\.


--
-- TOC entry 2382 (class 0 OID 0)
-- Dependencies: 207
-- Name: vegetable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aggiesys
--

SELECT pg_catalog.setval('vegetable_id_seq', 21, true);


--
-- TOC entry 2093 (class 2606 OID 16572)
-- Name: billheader_code_key; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_code_key UNIQUE (code);


--
-- TOC entry 2096 (class 2606 OID 16574)
-- Name: billheader_pkey; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_pkey PRIMARY KEY (id);


--
-- TOC entry 2099 (class 2606 OID 16576)
-- Name: carriage_code_key; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY carriage
    ADD CONSTRAINT carriage_code_key UNIQUE (code);


--
-- TOC entry 2102 (class 2606 OID 16578)
-- Name: carriage_pkey; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY carriage
    ADD CONSTRAINT carriage_pkey PRIMARY KEY (id);


--
-- TOC entry 2105 (class 2606 OID 16580)
-- Name: customer_code_key; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_code_key UNIQUE (code);


--
-- TOC entry 2107 (class 2606 OID 16582)
-- Name: customer_pkey; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- TOC entry 2109 (class 2606 OID 16584)
-- Name: deliverydetail_id_docdetail_key; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY deliverydetail
    ADD CONSTRAINT deliverydetail_id_docdetail_key UNIQUE (id_docdetail);


--
-- TOC entry 2111 (class 2606 OID 16586)
-- Name: deliverydetail_pkey; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY deliverydetail
    ADD CONSTRAINT deliverydetail_pkey PRIMARY KEY (id);


--
-- TOC entry 2113 (class 2606 OID 16588)
-- Name: deliveryhead_id_doc_key; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY deliveryhead
    ADD CONSTRAINT deliveryhead_id_doc_key UNIQUE (id_doc);


--
-- TOC entry 2115 (class 2606 OID 16590)
-- Name: deliveryhead_pkey; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY deliveryhead
    ADD CONSTRAINT deliveryhead_pkey PRIMARY KEY (id);


--
-- TOC entry 2117 (class 2606 OID 16592)
-- Name: doc_code_key; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY doc
    ADD CONSTRAINT doc_code_key UNIQUE (code);


--
-- TOC entry 2119 (class 2606 OID 16594)
-- Name: doc_id_doc_key; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY doc
    ADD CONSTRAINT doc_id_doc_key UNIQUE (id_doc);


--
-- TOC entry 2121 (class 2606 OID 16596)
-- Name: doc_pkey; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY doc
    ADD CONSTRAINT doc_pkey PRIMARY KEY (id);


--
-- TOC entry 2123 (class 2606 OID 16598)
-- Name: docdetail_pkey; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY docdetail
    ADD CONSTRAINT docdetail_pkey PRIMARY KEY (id);


--
-- TOC entry 2125 (class 2606 OID 16600)
-- Name: docref_id_doc_id_ref_key; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY docref
    ADD CONSTRAINT docref_id_doc_id_ref_key UNIQUE (id_doc, id_ref);


--
-- TOC entry 2127 (class 2606 OID 16602)
-- Name: docref_pkey; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY docref
    ADD CONSTRAINT docref_pkey PRIMARY KEY (id);


--
-- TOC entry 2129 (class 2606 OID 16604)
-- Name: etc_code_key; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY etc
    ADD CONSTRAINT etc_code_key UNIQUE (code);


--
-- TOC entry 2131 (class 2606 OID 16606)
-- Name: etc_pkey; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY etc
    ADD CONSTRAINT etc_pkey PRIMARY KEY (id);


--
-- TOC entry 2133 (class 2606 OID 16608)
-- Name: etcitem_id_etc_code_key; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY etcitem
    ADD CONSTRAINT etcitem_id_etc_code_key UNIQUE (id_etc, code);


--
-- TOC entry 2135 (class 2606 OID 16610)
-- Name: etcitem_pkey; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY etcitem
    ADD CONSTRAINT etcitem_pkey PRIMARY KEY (id);


--
-- TOC entry 2137 (class 2606 OID 16612)
-- Name: farm_code_key; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY farm
    ADD CONSTRAINT farm_code_key UNIQUE (code);


--
-- TOC entry 2139 (class 2606 OID 16614)
-- Name: farm_pkey; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY farm
    ADD CONSTRAINT farm_pkey PRIMARY KEY (id);


--
-- TOC entry 2141 (class 2606 OID 16616)
-- Name: generator_code_key; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY generator
    ADD CONSTRAINT generator_code_key UNIQUE (code);


--
-- TOC entry 2143 (class 2606 OID 16618)
-- Name: generator_pkey; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY generator
    ADD CONSTRAINT generator_pkey PRIMARY KEY (id);


--
-- TOC entry 2145 (class 2606 OID 16620)
-- Name: product_code_key; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_code_key UNIQUE (code);


--
-- TOC entry 2147 (class 2606 OID 16622)
-- Name: product_pkey; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- TOC entry 2149 (class 2606 OID 16624)
-- Name: saledetail_id_docdetail_key; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY saledetail
    ADD CONSTRAINT saledetail_id_docdetail_key UNIQUE (id_docdetail);


--
-- TOC entry 2151 (class 2606 OID 16626)
-- Name: saledetail_pkey; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY saledetail
    ADD CONSTRAINT saledetail_pkey PRIMARY KEY (id);


--
-- TOC entry 2153 (class 2606 OID 16628)
-- Name: salehead_id_doc_key; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY salehead
    ADD CONSTRAINT salehead_id_doc_key UNIQUE (id_doc);


--
-- TOC entry 2155 (class 2606 OID 16759)
-- Name: salehead_pkey; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY salehead
    ADD CONSTRAINT salehead_pkey PRIMARY KEY (id);


--
-- TOC entry 2158 (class 2606 OID 16632)
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 2161 (class 2606 OID 16634)
-- Name: user_pkey; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 2163 (class 2606 OID 16636)
-- Name: user_username_key; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- TOC entry 2165 (class 2606 OID 16638)
-- Name: userrole_id_user_role_key; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_id_user_role_key UNIQUE (id_user, role);


--
-- TOC entry 2167 (class 2606 OID 16640)
-- Name: userrole_pkey; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_pkey PRIMARY KEY (id);


--
-- TOC entry 2169 (class 2606 OID 16642)
-- Name: vegetable_code_key; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY vegetable
    ADD CONSTRAINT vegetable_code_key UNIQUE (code);


--
-- TOC entry 2171 (class 2606 OID 16644)
-- Name: vegetable_pkey; Type: CONSTRAINT; Schema: public; Owner: aggiesys; Tablespace: 
--

ALTER TABLE ONLY vegetable
    ADD CONSTRAINT vegetable_pkey PRIMARY KEY (id);


--
-- TOC entry 2094 (class 1259 OID 16645)
-- Name: billheader_date_idx; Type: INDEX; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE INDEX billheader_date_idx ON billheader USING btree (date);


--
-- TOC entry 2097 (class 1259 OID 16646)
-- Name: billheader_tstmp_idx; Type: INDEX; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE INDEX billheader_tstmp_idx ON billheader USING btree (tstmp);


--
-- TOC entry 2100 (class 1259 OID 16647)
-- Name: carriage_code_typecarriage_idx; Type: INDEX; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE INDEX carriage_code_typecarriage_idx ON carriage USING btree (code_typecarriage);


--
-- TOC entry 2103 (class 1259 OID 16648)
-- Name: carriage_registration_idx; Type: INDEX; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE INDEX carriage_registration_idx ON carriage USING btree (registration);


--
-- TOC entry 2156 (class 1259 OID 16650)
-- Name: sessions_expires_idx; Type: INDEX; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE INDEX sessions_expires_idx ON sessions USING btree (expires);


--
-- TOC entry 2159 (class 1259 OID 16651)
-- Name: user_isterminated_idx; Type: INDEX; Schema: public; Owner: aggiesys; Tablespace: 
--

CREATE INDEX user_isterminated_idx ON "user" USING btree (isterminated);


--
-- TOC entry 2172 (class 2606 OID 16652)
-- Name: billheader_id_creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_id_creator_fkey FOREIGN KEY (id_creator) REFERENCES "user"(id) ON DELETE RESTRICT;


--
-- TOC entry 2173 (class 2606 OID 16657)
-- Name: billheader_id_debtor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_id_debtor_fkey FOREIGN KEY (id_debtor) REFERENCES farm(id) ON DELETE RESTRICT;


--
-- TOC entry 2174 (class 2606 OID 16662)
-- Name: deliverydetail_id_docdetail_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY deliverydetail
    ADD CONSTRAINT deliverydetail_id_docdetail_fkey FOREIGN KEY (id_docdetail) REFERENCES docdetail(id) ON DELETE CASCADE;


--
-- TOC entry 2175 (class 2606 OID 16667)
-- Name: deliverydetail_id_vegetable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY deliverydetail
    ADD CONSTRAINT deliverydetail_id_vegetable_fkey FOREIGN KEY (id_vegetable) REFERENCES vegetable(id) ON DELETE RESTRICT;


--
-- TOC entry 2176 (class 2606 OID 16672)
-- Name: deliveryhead_id_doc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY deliveryhead
    ADD CONSTRAINT deliveryhead_id_doc_fkey FOREIGN KEY (id_doc) REFERENCES doc(id) ON DELETE CASCADE;


--
-- TOC entry 2177 (class 2606 OID 16677)
-- Name: deliveryhead_id_farm_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY deliveryhead
    ADD CONSTRAINT deliveryhead_id_farm_fkey FOREIGN KEY (id_farm) REFERENCES farm(id) ON DELETE RESTRICT;


--
-- TOC entry 2178 (class 2606 OID 16682)
-- Name: doc_id_creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY doc
    ADD CONSTRAINT doc_id_creator_fkey FOREIGN KEY (id_creator) REFERENCES "user"(id) ON DELETE RESTRICT;


--
-- TOC entry 2179 (class 2606 OID 16687)
-- Name: doc_id_doc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY doc
    ADD CONSTRAINT doc_id_doc_fkey FOREIGN KEY (id_doc) REFERENCES doc(id) ON DELETE SET NULL;


--
-- TOC entry 2180 (class 2606 OID 16692)
-- Name: docdetail_id_doc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY docdetail
    ADD CONSTRAINT docdetail_id_doc_fkey FOREIGN KEY (id_doc) REFERENCES doc(id) ON DELETE CASCADE;


--
-- TOC entry 2181 (class 2606 OID 16697)
-- Name: docref_id_doc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY docref
    ADD CONSTRAINT docref_id_doc_fkey FOREIGN KEY (id_doc) REFERENCES doc(id) ON DELETE CASCADE;


--
-- TOC entry 2182 (class 2606 OID 16702)
-- Name: docref_id_ref_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY docref
    ADD CONSTRAINT docref_id_ref_fkey FOREIGN KEY (id_ref) REFERENCES doc(id) ON DELETE RESTRICT;


--
-- TOC entry 2183 (class 2606 OID 16707)
-- Name: etcitem_id_etc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY etcitem
    ADD CONSTRAINT etcitem_id_etc_fkey FOREIGN KEY (id_etc) REFERENCES etc(id) ON DELETE CASCADE;


--
-- TOC entry 2184 (class 2606 OID 16712)
-- Name: saledetail_id_docdetail_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY saledetail
    ADD CONSTRAINT saledetail_id_docdetail_fkey FOREIGN KEY (id_docdetail) REFERENCES docdetail(id) ON DELETE CASCADE;


--
-- TOC entry 2185 (class 2606 OID 16717)
-- Name: saledetail_id_vegetable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY saledetail
    ADD CONSTRAINT saledetail_id_vegetable_fkey FOREIGN KEY (id_vegetable) REFERENCES vegetable(id) ON DELETE RESTRICT;


--
-- TOC entry 2188 (class 2606 OID 16743)
-- Name: salehead_id_carriage_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY salehead
    ADD CONSTRAINT salehead_id_carriage_fkey FOREIGN KEY (id_carriage) REFERENCES carriage(id) ON DELETE RESTRICT;


--
-- TOC entry 2186 (class 2606 OID 16722)
-- Name: salehead_id_customer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY salehead
    ADD CONSTRAINT salehead_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES customer(id) ON DELETE RESTRICT;


--
-- TOC entry 2187 (class 2606 OID 16727)
-- Name: salehead_id_doc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY salehead
    ADD CONSTRAINT salehead_id_doc_fkey FOREIGN KEY (id_doc) REFERENCES doc(id) ON DELETE CASCADE;


--
-- TOC entry 2189 (class 2606 OID 16732)
-- Name: sessions_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_id_user_fkey FOREIGN KEY (id_user) REFERENCES "user"(id) ON DELETE SET NULL;


--
-- TOC entry 2190 (class 2606 OID 16737)
-- Name: userrole_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aggiesys
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_id_user_fkey FOREIGN KEY (id_user) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 2343 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: aggiesys
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM aggiesys;
GRANT ALL ON SCHEMA public TO aggiesys;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-03-21 14:24:51 ICT

--
-- PostgreSQL database dump complete
--

