--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.5
-- Dumped by pg_dump version 9.3.5
-- Started on 2015-03-09 10:30:11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 208 (class 3079 OID 11750)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2244 (class 0 OID 0)
-- Dependencies: 208
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 207 (class 3079 OID 49511)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 2245 (class 0 OID 0)
-- Dependencies: 207
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- TOC entry 209 (class 3079 OID 57989)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 2246 (class 0 OID 0)
-- Dependencies: 209
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET search_path = public, pg_catalog;

SET default_with_oids = false;

--
-- TOC entry 170 (class 1259 OID 58023)
-- Name: billheader; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 171 (class 1259 OID 58030)
-- Name: billheader_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE billheader_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2247 (class 0 OID 0)
-- Dependencies: 171
-- Name: billheader_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE billheader_id_seq OWNED BY billheader.id;


--
-- TOC entry 172 (class 1259 OID 58032)
-- Name: carriage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE carriage (
    id bigint NOT NULL,
    code character varying(64) NOT NULL,
    registration character varying(32) NOT NULL,
    code_typecarriage character varying(16) NOT NULL,
    name character varying(128) NOT NULL
);


--
-- TOC entry 173 (class 1259 OID 58035)
-- Name: carriage_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE carriage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2248 (class 0 OID 0)
-- Dependencies: 173
-- Name: carriage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE carriage_id_seq OWNED BY carriage.id;


--
-- TOC entry 174 (class 1259 OID 58037)
-- Name: customer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE customer (
    id bigint NOT NULL,
    code character varying(64) NOT NULL,
    name character varying(128) NOT NULL,
    address text
);


--
-- TOC entry 175 (class 1259 OID 58043)
-- Name: customer_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2249 (class 0 OID 0)
-- Dependencies: 175
-- Name: customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customer_id_seq OWNED BY customer.id;


--
-- TOC entry 176 (class 1259 OID 58045)
-- Name: deliverydetail; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE deliverydetail (
    id bigint NOT NULL,
    id_docdetail bigint NOT NULL,
    id_vegetable bigint NOT NULL
);


--
-- TOC entry 177 (class 1259 OID 58051)
-- Name: deliverydetail_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE deliverydetail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2250 (class 0 OID 0)
-- Dependencies: 177
-- Name: deliverydetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE deliverydetail_id_seq OWNED BY deliverydetail.id;


--
-- TOC entry 178 (class 1259 OID 58053)
-- Name: deliveryhead; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE deliveryhead (
    id bigint NOT NULL,
    id_farm bigint NOT NULL,
    fullname character varying(128) NOT NULL,
    address text NOT NULL,
    id_doc bigint NOT NULL
);


--
-- TOC entry 179 (class 1259 OID 58060)
-- Name: deliveryhead_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE deliveryhead_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2251 (class 0 OID 0)
-- Dependencies: 179
-- Name: deliveryhead_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE deliveryhead_id_seq OWNED BY deliveryhead.id;


--
-- TOC entry 200 (class 1259 OID 58287)
-- Name: doc; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 199 (class 1259 OID 58285)
-- Name: doc_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE doc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2252 (class 0 OID 0)
-- Dependencies: 199
-- Name: doc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE doc_id_seq OWNED BY doc.id;


--
-- TOC entry 202 (class 1259 OID 58322)
-- Name: docdetail; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE docdetail (
    id bigint NOT NULL,
    item character varying(256) NOT NULL,
    qty numeric NOT NULL,
    price numeric NOT NULL,
    id_doc bigint NOT NULL
);


--
-- TOC entry 201 (class 1259 OID 58320)
-- Name: docdetail_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE docdetail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2253 (class 0 OID 0)
-- Dependencies: 201
-- Name: docdetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE docdetail_id_seq OWNED BY docdetail.id;


--
-- TOC entry 206 (class 1259 OID 58375)
-- Name: docref; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE docref (
    id bigint NOT NULL,
    id_doc bigint NOT NULL,
    id_ref bigint NOT NULL
);


--
-- TOC entry 205 (class 1259 OID 58373)
-- Name: docref_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE docref_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2254 (class 0 OID 0)
-- Dependencies: 205
-- Name: docref_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE docref_id_seq OWNED BY docref.id;


--
-- TOC entry 180 (class 1259 OID 58062)
-- Name: etc; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE etc (
    id bigint NOT NULL,
    code character varying(16) NOT NULL,
    name character varying(128) NOT NULL
);


--
-- TOC entry 181 (class 1259 OID 58065)
-- Name: etc_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE etc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2255 (class 0 OID 0)
-- Dependencies: 181
-- Name: etc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE etc_id_seq OWNED BY etc.id;


--
-- TOC entry 182 (class 1259 OID 58067)
-- Name: etcitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE etcitem (
    id bigint NOT NULL,
    id_etc bigint NOT NULL,
    code character varying(16) NOT NULL,
    value character varying(128) NOT NULL
);


--
-- TOC entry 183 (class 1259 OID 58070)
-- Name: etcitem_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE etcitem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2256 (class 0 OID 0)
-- Dependencies: 183
-- Name: etcitem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE etcitem_id_seq OWNED BY etcitem.id;


--
-- TOC entry 184 (class 1259 OID 58072)
-- Name: farm; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE farm (
    id bigint NOT NULL,
    code character varying(64) NOT NULL,
    name character varying(128) NOT NULL,
    address text
);


--
-- TOC entry 185 (class 1259 OID 58078)
-- Name: farm_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE farm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2257 (class 0 OID 0)
-- Dependencies: 185
-- Name: farm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE farm_id_seq OWNED BY farm.id;


--
-- TOC entry 186 (class 1259 OID 58080)
-- Name: generator; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE generator (
    id bigint NOT NULL,
    code character varying(32) NOT NULL,
    length integer NOT NULL,
    code_reuse character varying(32) NOT NULL,
    num integer NOT NULL
);


--
-- TOC entry 187 (class 1259 OID 58083)
-- Name: generator_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE generator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2258 (class 0 OID 0)
-- Dependencies: 187
-- Name: generator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE generator_id_seq OWNED BY generator.id;


--
-- TOC entry 188 (class 1259 OID 58085)
-- Name: product; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE product (
    id bigint NOT NULL,
    code character varying(64),
    name character varying(128)
);


--
-- TOC entry 189 (class 1259 OID 58088)
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2259 (class 0 OID 0)
-- Dependencies: 189
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE product_id_seq OWNED BY product.id;


--
-- TOC entry 204 (class 1259 OID 58355)
-- Name: saledetail; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE saledetail (
    id bigint NOT NULL,
    id_docdetail bigint NOT NULL,
    id_vegetable bigint NOT NULL
);


--
-- TOC entry 203 (class 1259 OID 58353)
-- Name: saledetail_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE saledetail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2260 (class 0 OID 0)
-- Dependencies: 203
-- Name: saledetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE saledetail_id_seq OWNED BY saledetail.id;


--
-- TOC entry 190 (class 1259 OID 58090)
-- Name: salehead; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE salehead (
    id bigint NOT NULL,
    id_customer bigint NOT NULL,
    registration character varying(64) NOT NULL,
    fullname character varying(128) NOT NULL,
    id_doc bigint NOT NULL,
    address text NOT NULL
);


--
-- TOC entry 191 (class 1259 OID 58094)
-- Name: saleheader_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE saleheader_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2261 (class 0 OID 0)
-- Dependencies: 191
-- Name: saleheader_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE saleheader_id_seq OWNED BY salehead.id;


--
-- TOC entry 192 (class 1259 OID 58096)
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sessions (
    expires timestamp with time zone,
    data text,
    id_user bigint,
    id character varying(32) NOT NULL
);


--
-- TOC entry 193 (class 1259 OID 58102)
-- Name: user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "user" (
    id bigint NOT NULL,
    username character varying(64),
    password character varying(128),
    fullname character varying(256),
    isterminated boolean DEFAULT false NOT NULL
);


--
-- TOC entry 194 (class 1259 OID 58106)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2262 (class 0 OID 0)
-- Dependencies: 194
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- TOC entry 195 (class 1259 OID 58108)
-- Name: userrole; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE userrole (
    id bigint NOT NULL,
    id_user bigint,
    role character varying(64)
);


--
-- TOC entry 196 (class 1259 OID 58111)
-- Name: userrole_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE userrole_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2263 (class 0 OID 0)
-- Dependencies: 196
-- Name: userrole_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE userrole_id_seq OWNED BY userrole.id;


--
-- TOC entry 197 (class 1259 OID 58113)
-- Name: vegetable; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE vegetable (
    id bigint NOT NULL,
    code character varying(64),
    name character varying(128),
    price_buy numeric DEFAULT 0 NOT NULL,
    price_sell numeric DEFAULT 0 NOT NULL
);


--
-- TOC entry 198 (class 1259 OID 58116)
-- Name: vegetable_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vegetable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2264 (class 0 OID 0)
-- Dependencies: 198
-- Name: vegetable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vegetable_id_seq OWNED BY vegetable.id;


--
-- TOC entry 1974 (class 2604 OID 58118)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY billheader ALTER COLUMN id SET DEFAULT nextval('billheader_id_seq'::regclass);


--
-- TOC entry 1975 (class 2604 OID 58119)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY carriage ALTER COLUMN id SET DEFAULT nextval('carriage_id_seq'::regclass);


--
-- TOC entry 1976 (class 2604 OID 58120)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer ALTER COLUMN id SET DEFAULT nextval('customer_id_seq'::regclass);


--
-- TOC entry 1977 (class 2604 OID 58121)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliverydetail ALTER COLUMN id SET DEFAULT nextval('deliverydetail_id_seq'::regclass);


--
-- TOC entry 1978 (class 2604 OID 58122)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliveryhead ALTER COLUMN id SET DEFAULT nextval('deliveryhead_id_seq'::regclass);


--
-- TOC entry 1991 (class 2604 OID 58290)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY doc ALTER COLUMN id SET DEFAULT nextval('doc_id_seq'::regclass);


--
-- TOC entry 1993 (class 2604 OID 58325)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY docdetail ALTER COLUMN id SET DEFAULT nextval('docdetail_id_seq'::regclass);


--
-- TOC entry 1995 (class 2604 OID 58378)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY docref ALTER COLUMN id SET DEFAULT nextval('docref_id_seq'::regclass);


--
-- TOC entry 1979 (class 2604 OID 58123)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY etc ALTER COLUMN id SET DEFAULT nextval('etc_id_seq'::regclass);


--
-- TOC entry 1980 (class 2604 OID 58124)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY etcitem ALTER COLUMN id SET DEFAULT nextval('etcitem_id_seq'::regclass);


--
-- TOC entry 1981 (class 2604 OID 58125)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY farm ALTER COLUMN id SET DEFAULT nextval('farm_id_seq'::regclass);


--
-- TOC entry 1982 (class 2604 OID 58126)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY generator ALTER COLUMN id SET DEFAULT nextval('generator_id_seq'::regclass);


--
-- TOC entry 1983 (class 2604 OID 58127)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY product ALTER COLUMN id SET DEFAULT nextval('product_id_seq'::regclass);


--
-- TOC entry 1994 (class 2604 OID 58358)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY saledetail ALTER COLUMN id SET DEFAULT nextval('saledetail_id_seq'::regclass);


--
-- TOC entry 1984 (class 2604 OID 58128)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY salehead ALTER COLUMN id SET DEFAULT nextval('saleheader_id_seq'::regclass);


--
-- TOC entry 1986 (class 2604 OID 58129)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- TOC entry 1987 (class 2604 OID 58130)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY userrole ALTER COLUMN id SET DEFAULT nextval('userrole_id_seq'::regclass);


--
-- TOC entry 1988 (class 2604 OID 58131)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vegetable ALTER COLUMN id SET DEFAULT nextval('vegetable_id_seq'::regclass);


--
-- TOC entry 2202 (class 0 OID 58023)
-- Dependencies: 170
-- Data for Name: billheader; Type: TABLE DATA; Schema: public; Owner: -
--

COPY billheader (id, code, date, id_debtor, fullname, address, tstmp, id_creator) FROM stdin;
\.


--
-- TOC entry 2265 (class 0 OID 0)
-- Dependencies: 171
-- Name: billheader_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('billheader_id_seq', 1, false);


--
-- TOC entry 2204 (class 0 OID 58032)
-- Dependencies: 172
-- Data for Name: carriage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY carriage (id, code, registration, code_typecarriage, name) FROM stdin;
3	truck001	ฮ 4321	TRUCK	Truck 001
2	pickup001	กข 1234	PICKUP	Pickup 001
\.


--
-- TOC entry 2266 (class 0 OID 0)
-- Dependencies: 173
-- Name: carriage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('carriage_id_seq', 3, true);


--
-- TOC entry 2206 (class 0 OID 58037)
-- Dependencies: 174
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: -
--

COPY customer (id, code, name, address) FROM stdin;
2	C002	Customer 002	123\nabc\ndef
3	C001	Customer 001	123\nd\nd
\.


--
-- TOC entry 2267 (class 0 OID 0)
-- Dependencies: 175
-- Name: customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('customer_id_seq', 3, true);


--
-- TOC entry 2208 (class 0 OID 58045)
-- Dependencies: 176
-- Data for Name: deliverydetail; Type: TABLE DATA; Schema: public; Owner: -
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
\.


--
-- TOC entry 2268 (class 0 OID 0)
-- Dependencies: 177
-- Name: deliverydetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('deliverydetail_id_seq', 70, true);


--
-- TOC entry 2210 (class 0 OID 58053)
-- Dependencies: 178
-- Data for Name: deliveryhead; Type: TABLE DATA; Schema: public; Owner: -
--

COPY deliveryhead (id, id_farm, fullname, address, id_doc) FROM stdin;
27	2	Farm 001	123\nabc\ndef	13
28	2	Farm 001	123\nabc\ndef	14
29	2	Farm 001	123\nabc\ndef	15
30	3	Farm 002	123\nabc\ndef	16
\.


--
-- TOC entry 2269 (class 0 OID 0)
-- Dependencies: 179
-- Name: deliveryhead_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('deliveryhead_id_seq', 30, true);


--
-- TOC entry 2232 (class 0 OID 58287)
-- Dependencies: 200
-- Data for Name: doc; Type: TABLE DATA; Schema: public; Owner: -
--

COPY doc (id, code, date, type, id_creator, tstmp, id_doc) FROM stdin;
16	111503080016	2015-03-08 21:10:32+07	DEBIT	3	2015-03-08 21:10:55.029+07	\N
15	111503080015	2015-03-08 18:11:46+07	DEBIT	3	2015-03-08 18:14:07.585+07	\N
14	111503080014	2015-03-08 17:38:15+07	DEBIT	3	2015-03-08 18:01:43.205+07	\N
13	111503080013	2015-03-08 17:38:15+07	DEBIT	3	2015-03-08 17:39:32.195+07	14
19	xxx	2015-03-08 21:10:32+07	TEST	3	2015-03-08 21:32:39.054+07	\N
\.


--
-- TOC entry 2270 (class 0 OID 0)
-- Dependencies: 199
-- Name: doc_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('doc_id_seq', 20, true);


--
-- TOC entry 2234 (class 0 OID 58322)
-- Dependencies: 202
-- Data for Name: docdetail; Type: TABLE DATA; Schema: public; Owner: -
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
\.


--
-- TOC entry 2271 (class 0 OID 0)
-- Dependencies: 201
-- Name: docdetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('docdetail_id_seq', 10, true);


--
-- TOC entry 2238 (class 0 OID 58375)
-- Dependencies: 206
-- Data for Name: docref; Type: TABLE DATA; Schema: public; Owner: -
--

COPY docref (id, id_doc, id_ref) FROM stdin;
1	19	14
2	19	15
\.


--
-- TOC entry 2272 (class 0 OID 0)
-- Dependencies: 205
-- Name: docref_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('docref_id_seq', 2, true);


--
-- TOC entry 2212 (class 0 OID 58062)
-- Dependencies: 180
-- Data for Name: etc; Type: TABLE DATA; Schema: public; Owner: -
--

COPY etc (id, code, name) FROM stdin;
1	TYPE_CARRIAGE	Carriage Type
2	PREFIX_NAME	Prefix Name
4	TYPE_DOC	Type of document
\.


--
-- TOC entry 2273 (class 0 OID 0)
-- Dependencies: 181
-- Name: etc_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('etc_id_seq', 4, true);


--
-- TOC entry 2214 (class 0 OID 58067)
-- Dependencies: 182
-- Data for Name: etcitem; Type: TABLE DATA; Schema: public; Owner: -
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
-- TOC entry 2274 (class 0 OID 0)
-- Dependencies: 183
-- Name: etcitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('etcitem_id_seq', 81, true);


--
-- TOC entry 2216 (class 0 OID 58072)
-- Dependencies: 184
-- Data for Name: farm; Type: TABLE DATA; Schema: public; Owner: -
--

COPY farm (id, code, name, address) FROM stdin;
3	F002	Farm 002	123\nabc\ndef
2	F001	Farm 001	123\nabc\ndef
4	910001	asdf	asdf\nasdf\nasdf
\.


--
-- TOC entry 2275 (class 0 OID 0)
-- Dependencies: 185
-- Name: farm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('farm_id_seq', 4, true);


--
-- TOC entry 2218 (class 0 OID 58080)
-- Dependencies: 186
-- Data for Name: generator; Type: TABLE DATA; Schema: public; Owner: -
--

COPY generator (id, code, length, code_reuse, num) FROM stdin;
3	81	4		17
6	13	4	150225	1
7	15	4	150225	1
8	17	4	150225	1
9	19	4	150225	1
11	92	4		1
10	91	4		2
12	00	4	150308	3
4	11	4	150308	17
\.


--
-- TOC entry 2276 (class 0 OID 0)
-- Dependencies: 187
-- Name: generator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('generator_id_seq', 12, true);


--
-- TOC entry 2220 (class 0 OID 58085)
-- Dependencies: 188
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: -
--

COPY product (id, code, name) FROM stdin;
\.


--
-- TOC entry 2277 (class 0 OID 0)
-- Dependencies: 189
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('product_id_seq', 1, false);


--
-- TOC entry 2236 (class 0 OID 58355)
-- Dependencies: 204
-- Data for Name: saledetail; Type: TABLE DATA; Schema: public; Owner: -
--

COPY saledetail (id, id_docdetail, id_vegetable) FROM stdin;
\.


--
-- TOC entry 2278 (class 0 OID 0)
-- Dependencies: 203
-- Name: saledetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('saledetail_id_seq', 1, false);


--
-- TOC entry 2222 (class 0 OID 58090)
-- Dependencies: 190
-- Data for Name: salehead; Type: TABLE DATA; Schema: public; Owner: -
--

COPY salehead (id, id_customer, registration, fullname, id_doc, address) FROM stdin;
1	2	ddd	ffff	19	tttt
\.


--
-- TOC entry 2279 (class 0 OID 0)
-- Dependencies: 191
-- Name: saleheader_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('saleheader_id_seq', 1, true);


--
-- TOC entry 2224 (class 0 OID 58096)
-- Dependencies: 192
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY sessions (expires, data, id_user, id) FROM stdin;
2015-03-09 02:18:28.508+07	__GSESSION__|a:1:{s:9:"__tmpsess";N;}	3	ddh2cjjuqd0i5ptrc3fjsu9fg7
\.


--
-- TOC entry 2225 (class 0 OID 58102)
-- Dependencies: 193
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: -
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
-- TOC entry 2280 (class 0 OID 0)
-- Dependencies: 194
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('user_id_seq', 38, true);


--
-- TOC entry 2227 (class 0 OID 58108)
-- Dependencies: 195
-- Data for Name: userrole; Type: TABLE DATA; Schema: public; Owner: -
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
-- TOC entry 2281 (class 0 OID 0)
-- Dependencies: 196
-- Name: userrole_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('userrole_id_seq', 125, true);


--
-- TOC entry 2229 (class 0 OID 58113)
-- Dependencies: 197
-- Data for Name: vegetable; Type: TABLE DATA; Schema: public; Owner: -
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
-- TOC entry 2282 (class 0 OID 0)
-- Dependencies: 198
-- Name: vegetable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('vegetable_id_seq', 21, true);


--
-- TOC entry 1997 (class 2606 OID 58133)
-- Name: billheader_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_code_key UNIQUE (code);


--
-- TOC entry 2000 (class 2606 OID 58135)
-- Name: billheader_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_pkey PRIMARY KEY (id);


--
-- TOC entry 2003 (class 2606 OID 58137)
-- Name: carriage_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY carriage
    ADD CONSTRAINT carriage_code_key UNIQUE (code);


--
-- TOC entry 2006 (class 2606 OID 58139)
-- Name: carriage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY carriage
    ADD CONSTRAINT carriage_pkey PRIMARY KEY (id);


--
-- TOC entry 2009 (class 2606 OID 58141)
-- Name: customer_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_code_key UNIQUE (code);


--
-- TOC entry 2011 (class 2606 OID 58143)
-- Name: customer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- TOC entry 2013 (class 2606 OID 58342)
-- Name: deliverydetail_id_docdetail_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliverydetail
    ADD CONSTRAINT deliverydetail_id_docdetail_key UNIQUE (id_docdetail);


--
-- TOC entry 2015 (class 2606 OID 58145)
-- Name: deliverydetail_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliverydetail
    ADD CONSTRAINT deliverydetail_pkey PRIMARY KEY (id);


--
-- TOC entry 2017 (class 2606 OID 58319)
-- Name: deliveryhead_id_doc_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliveryhead
    ADD CONSTRAINT deliveryhead_id_doc_key UNIQUE (id_doc);


--
-- TOC entry 2019 (class 2606 OID 58149)
-- Name: deliveryhead_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliveryhead
    ADD CONSTRAINT deliveryhead_pkey PRIMARY KEY (id);


--
-- TOC entry 2062 (class 2606 OID 58299)
-- Name: doc_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY doc
    ADD CONSTRAINT doc_code_key UNIQUE (code);


--
-- TOC entry 2064 (class 2606 OID 58317)
-- Name: doc_id_doc_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY doc
    ADD CONSTRAINT doc_id_doc_key UNIQUE (id_doc);


--
-- TOC entry 2066 (class 2606 OID 58292)
-- Name: doc_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY doc
    ADD CONSTRAINT doc_pkey PRIMARY KEY (id);


--
-- TOC entry 2068 (class 2606 OID 58330)
-- Name: docdetail_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY docdetail
    ADD CONSTRAINT docdetail_pkey PRIMARY KEY (id);


--
-- TOC entry 2074 (class 2606 OID 58382)
-- Name: docref_id_doc_id_ref_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY docref
    ADD CONSTRAINT docref_id_doc_id_ref_key UNIQUE (id_doc, id_ref);


--
-- TOC entry 2076 (class 2606 OID 58380)
-- Name: docref_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY docref
    ADD CONSTRAINT docref_pkey PRIMARY KEY (id);


--
-- TOC entry 2021 (class 2606 OID 58151)
-- Name: etc_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY etc
    ADD CONSTRAINT etc_code_key UNIQUE (code);


--
-- TOC entry 2023 (class 2606 OID 58153)
-- Name: etc_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY etc
    ADD CONSTRAINT etc_pkey PRIMARY KEY (id);


--
-- TOC entry 2025 (class 2606 OID 58155)
-- Name: etcitem_id_etc_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY etcitem
    ADD CONSTRAINT etcitem_id_etc_code_key UNIQUE (id_etc, code);


--
-- TOC entry 2027 (class 2606 OID 58157)
-- Name: etcitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY etcitem
    ADD CONSTRAINT etcitem_pkey PRIMARY KEY (id);


--
-- TOC entry 2029 (class 2606 OID 58159)
-- Name: farm_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY farm
    ADD CONSTRAINT farm_code_key UNIQUE (code);


--
-- TOC entry 2031 (class 2606 OID 58161)
-- Name: farm_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY farm
    ADD CONSTRAINT farm_pkey PRIMARY KEY (id);


--
-- TOC entry 2033 (class 2606 OID 58163)
-- Name: generator_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY generator
    ADD CONSTRAINT generator_code_key UNIQUE (code);


--
-- TOC entry 2035 (class 2606 OID 58165)
-- Name: generator_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY generator
    ADD CONSTRAINT generator_pkey PRIMARY KEY (id);


--
-- TOC entry 2037 (class 2606 OID 58167)
-- Name: product_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_code_key UNIQUE (code);


--
-- TOC entry 2039 (class 2606 OID 58169)
-- Name: product_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- TOC entry 2070 (class 2606 OID 58372)
-- Name: saledetail_id_docdetail_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY saledetail
    ADD CONSTRAINT saledetail_id_docdetail_key UNIQUE (id_docdetail);


--
-- TOC entry 2072 (class 2606 OID 58360)
-- Name: saledetail_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY saledetail
    ADD CONSTRAINT saledetail_pkey PRIMARY KEY (id);


--
-- TOC entry 2041 (class 2606 OID 58349)
-- Name: salehead_id_doc_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY salehead
    ADD CONSTRAINT salehead_id_doc_key UNIQUE (id_doc);


--
-- TOC entry 2043 (class 2606 OID 58173)
-- Name: salehead_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY salehead
    ADD CONSTRAINT salehead_pkey PRIMARY KEY (id);


--
-- TOC entry 2047 (class 2606 OID 58175)
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 2050 (class 2606 OID 58177)
-- Name: user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 2052 (class 2606 OID 58179)
-- Name: user_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- TOC entry 2054 (class 2606 OID 58181)
-- Name: userrole_id_user_role_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_id_user_role_key UNIQUE (id_user, role);


--
-- TOC entry 2056 (class 2606 OID 58183)
-- Name: userrole_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_pkey PRIMARY KEY (id);


--
-- TOC entry 2058 (class 2606 OID 58185)
-- Name: vegetable_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vegetable
    ADD CONSTRAINT vegetable_code_key UNIQUE (code);


--
-- TOC entry 2060 (class 2606 OID 58187)
-- Name: vegetable_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vegetable
    ADD CONSTRAINT vegetable_pkey PRIMARY KEY (id);


--
-- TOC entry 1998 (class 1259 OID 58188)
-- Name: billheader_date_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX billheader_date_idx ON billheader USING btree (date);


--
-- TOC entry 2001 (class 1259 OID 58189)
-- Name: billheader_tstmp_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX billheader_tstmp_idx ON billheader USING btree (tstmp);


--
-- TOC entry 2004 (class 1259 OID 58190)
-- Name: carriage_code_typecarriage_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX carriage_code_typecarriage_idx ON carriage USING btree (code_typecarriage);


--
-- TOC entry 2007 (class 1259 OID 58191)
-- Name: carriage_registration_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX carriage_registration_idx ON carriage USING btree (registration);


--
-- TOC entry 2044 (class 1259 OID 58194)
-- Name: salehead_registration_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX salehead_registration_idx ON salehead USING btree (registration);


--
-- TOC entry 2045 (class 1259 OID 58196)
-- Name: sessions_expires_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sessions_expires_idx ON sessions USING btree (expires);


--
-- TOC entry 2048 (class 1259 OID 58197)
-- Name: user_isterminated_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_isterminated_idx ON "user" USING btree (isterminated);


--
-- TOC entry 2077 (class 2606 OID 58198)
-- Name: billheader_id_creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_id_creator_fkey FOREIGN KEY (id_creator) REFERENCES "user"(id) ON DELETE RESTRICT;


--
-- TOC entry 2078 (class 2606 OID 58203)
-- Name: billheader_id_debtor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_id_debtor_fkey FOREIGN KEY (id_debtor) REFERENCES farm(id) ON DELETE RESTRICT;


--
-- TOC entry 2079 (class 2606 OID 58336)
-- Name: deliverydetail_id_docdetail_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliverydetail
    ADD CONSTRAINT deliverydetail_id_docdetail_fkey FOREIGN KEY (id_docdetail) REFERENCES docdetail(id) ON DELETE CASCADE;


--
-- TOC entry 2080 (class 2606 OID 58213)
-- Name: deliverydetail_id_vegetable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliverydetail
    ADD CONSTRAINT deliverydetail_id_vegetable_fkey FOREIGN KEY (id_vegetable) REFERENCES vegetable(id) ON DELETE RESTRICT;


--
-- TOC entry 2081 (class 2606 OID 58306)
-- Name: deliveryhead_id_doc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliveryhead
    ADD CONSTRAINT deliveryhead_id_doc_fkey FOREIGN KEY (id_doc) REFERENCES doc(id) ON DELETE CASCADE;


--
-- TOC entry 2082 (class 2606 OID 58223)
-- Name: deliveryhead_id_farm_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliveryhead
    ADD CONSTRAINT deliveryhead_id_farm_fkey FOREIGN KEY (id_farm) REFERENCES farm(id) ON DELETE RESTRICT;


--
-- TOC entry 2088 (class 2606 OID 58300)
-- Name: doc_id_creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY doc
    ADD CONSTRAINT doc_id_creator_fkey FOREIGN KEY (id_creator) REFERENCES "user"(id) ON DELETE RESTRICT;


--
-- TOC entry 2089 (class 2606 OID 58311)
-- Name: doc_id_doc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY doc
    ADD CONSTRAINT doc_id_doc_fkey FOREIGN KEY (id_doc) REFERENCES doc(id) ON DELETE SET NULL;


--
-- TOC entry 2090 (class 2606 OID 58331)
-- Name: docdetail_id_doc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY docdetail
    ADD CONSTRAINT docdetail_id_doc_fkey FOREIGN KEY (id_doc) REFERENCES doc(id) ON DELETE CASCADE;


--
-- TOC entry 2093 (class 2606 OID 58383)
-- Name: docref_id_doc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY docref
    ADD CONSTRAINT docref_id_doc_fkey FOREIGN KEY (id_doc) REFERENCES doc(id) ON DELETE CASCADE;


--
-- TOC entry 2094 (class 2606 OID 58388)
-- Name: docref_id_ref_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY docref
    ADD CONSTRAINT docref_id_ref_fkey FOREIGN KEY (id_ref) REFERENCES doc(id) ON DELETE RESTRICT;


--
-- TOC entry 2083 (class 2606 OID 58233)
-- Name: etcitem_id_etc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY etcitem
    ADD CONSTRAINT etcitem_id_etc_fkey FOREIGN KEY (id_etc) REFERENCES etc(id) ON DELETE CASCADE;


--
-- TOC entry 2091 (class 2606 OID 58361)
-- Name: saledetail_id_docdetail_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY saledetail
    ADD CONSTRAINT saledetail_id_docdetail_fkey FOREIGN KEY (id_docdetail) REFERENCES docdetail(id) ON DELETE CASCADE;


--
-- TOC entry 2092 (class 2606 OID 58366)
-- Name: saledetail_id_vegetable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY saledetail
    ADD CONSTRAINT saledetail_id_vegetable_fkey FOREIGN KEY (id_vegetable) REFERENCES vegetable(id) ON DELETE RESTRICT;


--
-- TOC entry 2085 (class 2606 OID 58243)
-- Name: salehead_id_customer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY salehead
    ADD CONSTRAINT salehead_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES customer(id) ON DELETE RESTRICT;


--
-- TOC entry 2084 (class 2606 OID 58343)
-- Name: salehead_id_doc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY salehead
    ADD CONSTRAINT salehead_id_doc_fkey FOREIGN KEY (id_doc) REFERENCES doc(id) ON DELETE CASCADE;


--
-- TOC entry 2086 (class 2606 OID 58253)
-- Name: sessions_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_id_user_fkey FOREIGN KEY (id_user) REFERENCES "user"(id) ON DELETE SET NULL;


--
-- TOC entry 2087 (class 2606 OID 58258)
-- Name: userrole_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_id_user_fkey FOREIGN KEY (id_user) REFERENCES "user"(id) ON DELETE CASCADE;


-- Completed on 2015-03-09 10:30:11

--
-- PostgreSQL database dump complete
--

