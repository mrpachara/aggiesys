--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.5
-- Dumped by pg_dump version 9.3.5
-- Started on 2015-02-12 13:05:40

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 199 (class 3079 OID 11750)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2183 (class 0 OID 0)
-- Dependencies: 199
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 200 (class 3079 OID 24889)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 2184 (class 0 OID 0)
-- Dependencies: 200
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 170 (class 1259 OID 24718)
-- Name: billheader; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE billheader (
    id bigint NOT NULL,
    code character varying(64) NOT NULL,
    date timestamp without time zone NOT NULL,
    id_debtor bigint,
    fullname character varying(128) NOT NULL,
    address text NOT NULL,
    tstmp timestamp with time zone DEFAULT transaction_timestamp() NOT NULL,
    id_creator bigint NOT NULL
);


ALTER TABLE public.billheader OWNER TO ere;

--
-- TOC entry 171 (class 1259 OID 24725)
-- Name: billheader_id_seq; Type: SEQUENCE; Schema: public; Owner: ere
--

CREATE SEQUENCE billheader_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.billheader_id_seq OWNER TO ere;

--
-- TOC entry 2185 (class 0 OID 0)
-- Dependencies: 171
-- Name: billheader_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE billheader_id_seq OWNED BY billheader.id;


--
-- TOC entry 194 (class 1259 OID 25034)
-- Name: carriage; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE carriage (
    id bigint NOT NULL,
    code character varying(64) NOT NULL,
    registration character varying(32) NOT NULL,
    code_typecarriage character varying(16) NOT NULL
);


ALTER TABLE public.carriage OWNER TO ere;

--
-- TOC entry 193 (class 1259 OID 25032)
-- Name: carriage_id_seq; Type: SEQUENCE; Schema: public; Owner: ere
--

CREATE SEQUENCE carriage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.carriage_id_seq OWNER TO ere;

--
-- TOC entry 2186 (class 0 OID 0)
-- Dependencies: 193
-- Name: carriage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE carriage_id_seq OWNED BY carriage.id;


--
-- TOC entry 172 (class 1259 OID 24727)
-- Name: customer; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE customer (
    id bigint NOT NULL,
    code character varying(64) NOT NULL,
    name character varying(128) NOT NULL,
    address text
);


ALTER TABLE public.customer OWNER TO ere;

--
-- TOC entry 173 (class 1259 OID 24733)
-- Name: customer_id_seq; Type: SEQUENCE; Schema: public; Owner: ere
--

CREATE SEQUENCE customer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_id_seq OWNER TO ere;

--
-- TOC entry 2187 (class 0 OID 0)
-- Dependencies: 173
-- Name: customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE customer_id_seq OWNED BY customer.id;


--
-- TOC entry 192 (class 1259 OID 25015)
-- Name: deliverydetail; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE deliverydetail (
    id bigint NOT NULL,
    id_deliveryhead bigint NOT NULL,
    id_vegetable bigint NOT NULL,
    qty double precision NOT NULL,
    price money NOT NULL
);


ALTER TABLE public.deliverydetail OWNER TO ere;

--
-- TOC entry 191 (class 1259 OID 25013)
-- Name: deliverydetail_id_seq; Type: SEQUENCE; Schema: public; Owner: ere
--

CREATE SEQUENCE deliverydetail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.deliverydetail_id_seq OWNER TO ere;

--
-- TOC entry 2188 (class 0 OID 0)
-- Dependencies: 191
-- Name: deliverydetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE deliverydetail_id_seq OWNED BY deliverydetail.id;


--
-- TOC entry 190 (class 1259 OID 24955)
-- Name: deliveryhead; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE deliveryhead (
    id bigint NOT NULL,
    code character varying(64),
    date timestamp without time zone NOT NULL,
    id_farm bigint NOT NULL,
    fullname character varying(128) NOT NULL,
    address text NOT NULL,
    id_salehead bigint,
    tstmp time without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.deliveryhead OWNER TO ere;

--
-- TOC entry 189 (class 1259 OID 24953)
-- Name: deliveryhead_id_seq; Type: SEQUENCE; Schema: public; Owner: ere
--

CREATE SEQUENCE deliveryhead_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.deliveryhead_id_seq OWNER TO ere;

--
-- TOC entry 2189 (class 0 OID 0)
-- Dependencies: 189
-- Name: deliveryhead_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE deliveryhead_id_seq OWNED BY deliveryhead.id;


--
-- TOC entry 196 (class 1259 OID 25046)
-- Name: etc; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE etc (
    id bigint NOT NULL,
    code character varying(16) NOT NULL,
    name character varying(128) NOT NULL
);


ALTER TABLE public.etc OWNER TO ere;

--
-- TOC entry 195 (class 1259 OID 25044)
-- Name: etc_id_seq; Type: SEQUENCE; Schema: public; Owner: ere
--

CREATE SEQUENCE etc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.etc_id_seq OWNER TO ere;

--
-- TOC entry 2190 (class 0 OID 0)
-- Dependencies: 195
-- Name: etc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE etc_id_seq OWNED BY etc.id;


--
-- TOC entry 198 (class 1259 OID 25056)
-- Name: etcitem; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE etcitem (
    id bigint NOT NULL,
    id_etc bigint NOT NULL,
    code character varying(16) NOT NULL,
    value character varying(128) NOT NULL
);


ALTER TABLE public.etcitem OWNER TO ere;

--
-- TOC entry 197 (class 1259 OID 25054)
-- Name: etcitem_id_seq; Type: SEQUENCE; Schema: public; Owner: ere
--

CREATE SEQUENCE etcitem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.etcitem_id_seq OWNER TO ere;

--
-- TOC entry 2191 (class 0 OID 0)
-- Dependencies: 197
-- Name: etcitem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE etcitem_id_seq OWNED BY etcitem.id;


--
-- TOC entry 174 (class 1259 OID 24735)
-- Name: farm; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE farm (
    id bigint NOT NULL,
    code character varying(64) NOT NULL,
    name character varying(128) NOT NULL,
    address text
);


ALTER TABLE public.farm OWNER TO ere;

--
-- TOC entry 175 (class 1259 OID 24741)
-- Name: farm_id_seq; Type: SEQUENCE; Schema: public; Owner: ere
--

CREATE SEQUENCE farm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.farm_id_seq OWNER TO ere;

--
-- TOC entry 2192 (class 0 OID 0)
-- Dependencies: 175
-- Name: farm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE farm_id_seq OWNED BY farm.id;


--
-- TOC entry 188 (class 1259 OID 24933)
-- Name: generator; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE generator (
    id bigint NOT NULL,
    code character varying(32) NOT NULL,
    length integer NOT NULL,
    code_reuse character varying(32) NOT NULL,
    num integer NOT NULL
);


ALTER TABLE public.generator OWNER TO ere;

--
-- TOC entry 187 (class 1259 OID 24931)
-- Name: generator_id_seq; Type: SEQUENCE; Schema: public; Owner: ere
--

CREATE SEQUENCE generator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.generator_id_seq OWNER TO ere;

--
-- TOC entry 2193 (class 0 OID 0)
-- Dependencies: 187
-- Name: generator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE generator_id_seq OWNED BY generator.id;


--
-- TOC entry 176 (class 1259 OID 24743)
-- Name: product; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE product (
    id bigint NOT NULL,
    code character varying(64),
    name character varying(128)
);


ALTER TABLE public.product OWNER TO ere;

--
-- TOC entry 177 (class 1259 OID 24746)
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: ere
--

CREATE SEQUENCE product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_id_seq OWNER TO ere;

--
-- TOC entry 2194 (class 0 OID 0)
-- Dependencies: 177
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE product_id_seq OWNED BY product.id;


--
-- TOC entry 178 (class 1259 OID 24753)
-- Name: saleheader; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE saleheader (
    id bigint NOT NULL,
    code character varying(64) NOT NULL,
    date timestamp without time zone NOT NULL,
    tstmp timestamp with time zone DEFAULT transaction_timestamp() NOT NULL,
    id_customer bigint NOT NULL,
    registration character varying(64) NOT NULL,
    id_creator bigint NOT NULL,
    id_instead bigint,
    fullname character varying(128) NOT NULL
);


ALTER TABLE public.saleheader OWNER TO ere;

--
-- TOC entry 179 (class 1259 OID 24757)
-- Name: saleheader_id_seq; Type: SEQUENCE; Schema: public; Owner: ere
--

CREATE SEQUENCE saleheader_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.saleheader_id_seq OWNER TO ere;

--
-- TOC entry 2195 (class 0 OID 0)
-- Dependencies: 179
-- Name: saleheader_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE saleheader_id_seq OWNED BY saleheader.id;


--
-- TOC entry 180 (class 1259 OID 24759)
-- Name: sessions; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE sessions (
    expires timestamp without time zone,
    data text,
    id_user bigint,
    id character varying(32) NOT NULL
);


ALTER TABLE public.sessions OWNER TO ere;

--
-- TOC entry 181 (class 1259 OID 24767)
-- Name: user; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE "user" (
    id bigint NOT NULL,
    username character varying(64),
    password character varying(128),
    fullname character varying(256),
    isterminated boolean DEFAULT false NOT NULL
);


ALTER TABLE public."user" OWNER TO ere;

--
-- TOC entry 182 (class 1259 OID 24770)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: ere
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO ere;

--
-- TOC entry 2196 (class 0 OID 0)
-- Dependencies: 182
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- TOC entry 183 (class 1259 OID 24772)
-- Name: userrole; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE userrole (
    id bigint NOT NULL,
    id_user bigint,
    role character varying(64)
);


ALTER TABLE public.userrole OWNER TO ere;

--
-- TOC entry 184 (class 1259 OID 24775)
-- Name: userrole_id_seq; Type: SEQUENCE; Schema: public; Owner: ere
--

CREATE SEQUENCE userrole_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.userrole_id_seq OWNER TO ere;

--
-- TOC entry 2197 (class 0 OID 0)
-- Dependencies: 184
-- Name: userrole_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE userrole_id_seq OWNED BY userrole.id;


--
-- TOC entry 185 (class 1259 OID 24777)
-- Name: vegetable; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE vegetable (
    id bigint NOT NULL,
    code character varying(64),
    name character varying(128)
);


ALTER TABLE public.vegetable OWNER TO ere;

--
-- TOC entry 186 (class 1259 OID 24780)
-- Name: vegetable_id_seq; Type: SEQUENCE; Schema: public; Owner: ere
--

CREATE SEQUENCE vegetable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vegetable_id_seq OWNER TO ere;

--
-- TOC entry 2198 (class 0 OID 0)
-- Dependencies: 186
-- Name: vegetable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE vegetable_id_seq OWNED BY vegetable.id;


--
-- TOC entry 1945 (class 2604 OID 24782)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY billheader ALTER COLUMN id SET DEFAULT nextval('billheader_id_seq'::regclass);


--
-- TOC entry 1959 (class 2604 OID 25037)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY carriage ALTER COLUMN id SET DEFAULT nextval('carriage_id_seq'::regclass);


--
-- TOC entry 1946 (class 2604 OID 24783)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY customer ALTER COLUMN id SET DEFAULT nextval('customer_id_seq'::regclass);


--
-- TOC entry 1958 (class 2604 OID 25018)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY deliverydetail ALTER COLUMN id SET DEFAULT nextval('deliverydetail_id_seq'::regclass);


--
-- TOC entry 1956 (class 2604 OID 24958)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY deliveryhead ALTER COLUMN id SET DEFAULT nextval('deliveryhead_id_seq'::regclass);


--
-- TOC entry 1960 (class 2604 OID 25049)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY etc ALTER COLUMN id SET DEFAULT nextval('etc_id_seq'::regclass);


--
-- TOC entry 1961 (class 2604 OID 25059)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY etcitem ALTER COLUMN id SET DEFAULT nextval('etcitem_id_seq'::regclass);


--
-- TOC entry 1947 (class 2604 OID 24784)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY farm ALTER COLUMN id SET DEFAULT nextval('farm_id_seq'::regclass);


--
-- TOC entry 1955 (class 2604 OID 24936)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY generator ALTER COLUMN id SET DEFAULT nextval('generator_id_seq'::regclass);


--
-- TOC entry 1948 (class 2604 OID 24785)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY product ALTER COLUMN id SET DEFAULT nextval('product_id_seq'::regclass);


--
-- TOC entry 1950 (class 2604 OID 24787)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY saleheader ALTER COLUMN id SET DEFAULT nextval('saleheader_id_seq'::regclass);


--
-- TOC entry 1951 (class 2604 OID 24789)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- TOC entry 1953 (class 2604 OID 24790)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY userrole ALTER COLUMN id SET DEFAULT nextval('userrole_id_seq'::regclass);


--
-- TOC entry 1954 (class 2604 OID 24791)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY vegetable ALTER COLUMN id SET DEFAULT nextval('vegetable_id_seq'::regclass);


--
-- TOC entry 2148 (class 0 OID 24718)
-- Dependencies: 170
-- Data for Name: billheader; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY billheader (id, code, date, id_debtor, fullname, address, tstmp, id_creator) FROM stdin;
\.


--
-- TOC entry 2199 (class 0 OID 0)
-- Dependencies: 171
-- Name: billheader_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('billheader_id_seq', 1, false);


--
-- TOC entry 2172 (class 0 OID 25034)
-- Dependencies: 194
-- Data for Name: carriage; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY carriage (id, code, registration, code_typecarriage) FROM stdin;
\.


--
-- TOC entry 2200 (class 0 OID 0)
-- Dependencies: 193
-- Name: carriage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('carriage_id_seq', 1, false);


--
-- TOC entry 2150 (class 0 OID 24727)
-- Dependencies: 172
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY customer (id, code, name, address) FROM stdin;
2	C002	Customer 002	123\nabc\ndef
3	C001	Customer 001	123
\.


--
-- TOC entry 2201 (class 0 OID 0)
-- Dependencies: 173
-- Name: customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('customer_id_seq', 3, true);


--
-- TOC entry 2170 (class 0 OID 25015)
-- Dependencies: 192
-- Data for Name: deliverydetail; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY deliverydetail (id, id_deliveryhead, id_vegetable, qty, price) FROM stdin;
\.


--
-- TOC entry 2202 (class 0 OID 0)
-- Dependencies: 191
-- Name: deliverydetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('deliverydetail_id_seq', 1, false);


--
-- TOC entry 2168 (class 0 OID 24955)
-- Dependencies: 190
-- Data for Name: deliveryhead; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY deliveryhead (id, code, date, id_farm, fullname, address, id_salehead, tstmp) FROM stdin;
\.


--
-- TOC entry 2203 (class 0 OID 0)
-- Dependencies: 189
-- Name: deliveryhead_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('deliveryhead_id_seq', 1, false);


--
-- TOC entry 2174 (class 0 OID 25046)
-- Dependencies: 196
-- Data for Name: etc; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY etc (id, code, name) FROM stdin;
1	TYPE_CARRIAGE	Carriage Type
\.


--
-- TOC entry 2204 (class 0 OID 0)
-- Dependencies: 195
-- Name: etc_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('etc_id_seq', 1, true);


--
-- TOC entry 2176 (class 0 OID 25056)
-- Dependencies: 198
-- Data for Name: etcitem; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY etcitem (id, id_etc, code, value) FROM stdin;
1	1	PICKUP	Picup
2	1	TRUCK	Truck
\.


--
-- TOC entry 2205 (class 0 OID 0)
-- Dependencies: 197
-- Name: etcitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('etcitem_id_seq', 2, true);


--
-- TOC entry 2152 (class 0 OID 24735)
-- Dependencies: 174
-- Data for Name: farm; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY farm (id, code, name, address) FROM stdin;
3	F002	Farm 002	123 abc def
2	F001	Farm 001	123 abc def
\.


--
-- TOC entry 2206 (class 0 OID 0)
-- Dependencies: 175
-- Name: farm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('farm_id_seq', 3, true);


--
-- TOC entry 2166 (class 0 OID 24933)
-- Dependencies: 188
-- Data for Name: generator; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY generator (id, code, length, code_reuse, num) FROM stdin;
3	81	4		16
\.


--
-- TOC entry 2207 (class 0 OID 0)
-- Dependencies: 187
-- Name: generator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('generator_id_seq', 3, true);


--
-- TOC entry 2154 (class 0 OID 24743)
-- Dependencies: 176
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY product (id, code, name) FROM stdin;
\.


--
-- TOC entry 2208 (class 0 OID 0)
-- Dependencies: 177
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('product_id_seq', 1, false);


--
-- TOC entry 2156 (class 0 OID 24753)
-- Dependencies: 178
-- Data for Name: saleheader; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY saleheader (id, code, date, tstmp, id_customer, registration, id_creator, id_instead, fullname) FROM stdin;
\.


--
-- TOC entry 2209 (class 0 OID 0)
-- Dependencies: 179
-- Name: saleheader_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('saleheader_id_seq', 1, false);


--
-- TOC entry 2158 (class 0 OID 24759)
-- Dependencies: 180
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY sessions (expires, data, id_user, id) FROM stdin;
2015-02-12 07:56:03.142	__GSESSION__|a:1:{s:9:"__tmpsess";N;}	3	d6fi2kfai2u9llam4q8njhpih4
\.


--
-- TOC entry 2159 (class 0 OID 24767)
-- Dependencies: 181
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: ere
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
\.


--
-- TOC entry 2210 (class 0 OID 0)
-- Dependencies: 182
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('user_id_seq', 37, true);


--
-- TOC entry 2161 (class 0 OID 24772)
-- Dependencies: 183
-- Data for Name: userrole; Type: TABLE DATA; Schema: public; Owner: ere
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
108	3	MANAGER
109	3	STAFF
\.


--
-- TOC entry 2211 (class 0 OID 0)
-- Dependencies: 184
-- Name: userrole_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('userrole_id_seq', 109, true);


--
-- TOC entry 2163 (class 0 OID 24777)
-- Dependencies: 185
-- Data for Name: vegetable; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY vegetable (id, code, name) FROM stdin;
8	810003	xyz
12	810007	ijk
13	810008	987
14	810009	jkl
19	810014	asdf
20	810015	piupi
6	810001	abcd
\.


--
-- TOC entry 2212 (class 0 OID 0)
-- Dependencies: 186
-- Name: vegetable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('vegetable_id_seq', 20, true);


--
-- TOC entry 1963 (class 2606 OID 24793)
-- Name: billheader_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_code_key UNIQUE (code);


--
-- TOC entry 1966 (class 2606 OID 24795)
-- Name: billheader_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_pkey PRIMARY KEY (id);


--
-- TOC entry 2016 (class 2606 OID 25041)
-- Name: carriage_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY carriage
    ADD CONSTRAINT carriage_code_key UNIQUE (code);


--
-- TOC entry 2019 (class 2606 OID 25039)
-- Name: carriage_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY carriage
    ADD CONSTRAINT carriage_pkey PRIMARY KEY (id);


--
-- TOC entry 1969 (class 2606 OID 24797)
-- Name: customer_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_code_key UNIQUE (code);


--
-- TOC entry 1971 (class 2606 OID 24799)
-- Name: customer_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- TOC entry 2014 (class 2606 OID 25020)
-- Name: deliverydetail_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY deliverydetail
    ADD CONSTRAINT deliverydetail_pkey PRIMARY KEY (id);


--
-- TOC entry 2008 (class 2606 OID 24962)
-- Name: deliveryhead_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY deliveryhead
    ADD CONSTRAINT deliveryhead_code_key UNIQUE (code);


--
-- TOC entry 2011 (class 2606 OID 24960)
-- Name: deliveryhead_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY deliveryhead
    ADD CONSTRAINT deliveryhead_pkey PRIMARY KEY (id);


--
-- TOC entry 2022 (class 2606 OID 25053)
-- Name: etc_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY etc
    ADD CONSTRAINT etc_code_key UNIQUE (code);


--
-- TOC entry 2024 (class 2606 OID 25051)
-- Name: etc_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY etc
    ADD CONSTRAINT etc_pkey PRIMARY KEY (id);


--
-- TOC entry 2026 (class 2606 OID 25063)
-- Name: etcitem_id_etc_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY etcitem
    ADD CONSTRAINT etcitem_id_etc_code_key UNIQUE (id_etc, code);


--
-- TOC entry 2028 (class 2606 OID 25061)
-- Name: etcitem_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY etcitem
    ADD CONSTRAINT etcitem_pkey PRIMARY KEY (id);


--
-- TOC entry 1973 (class 2606 OID 24801)
-- Name: farm_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY farm
    ADD CONSTRAINT farm_code_key UNIQUE (code);


--
-- TOC entry 1975 (class 2606 OID 24803)
-- Name: farm_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY farm
    ADD CONSTRAINT farm_pkey PRIMARY KEY (id);


--
-- TOC entry 2004 (class 2606 OID 24945)
-- Name: generator_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY generator
    ADD CONSTRAINT generator_code_key UNIQUE (code);


--
-- TOC entry 2006 (class 2606 OID 24938)
-- Name: generator_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY generator
    ADD CONSTRAINT generator_pkey PRIMARY KEY (id);


--
-- TOC entry 1977 (class 2606 OID 24805)
-- Name: product_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_code_key UNIQUE (code);


--
-- TOC entry 1979 (class 2606 OID 24807)
-- Name: product_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- TOC entry 1981 (class 2606 OID 24811)
-- Name: saleheader_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY saleheader
    ADD CONSTRAINT saleheader_code_key UNIQUE (code);


--
-- TOC entry 1984 (class 2606 OID 24813)
-- Name: saleheader_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY saleheader
    ADD CONSTRAINT saleheader_pkey PRIMARY KEY (id);


--
-- TOC entry 1989 (class 2606 OID 24886)
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 1992 (class 2606 OID 24817)
-- Name: user_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 1994 (class 2606 OID 24819)
-- Name: user_username_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- TOC entry 1996 (class 2606 OID 24821)
-- Name: userrole_id_user_role_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_id_user_role_key UNIQUE (id_user, role);


--
-- TOC entry 1998 (class 2606 OID 24823)
-- Name: userrole_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_pkey PRIMARY KEY (id);


--
-- TOC entry 2000 (class 2606 OID 24825)
-- Name: vegetable_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY vegetable
    ADD CONSTRAINT vegetable_code_key UNIQUE (code);


--
-- TOC entry 2002 (class 2606 OID 24827)
-- Name: vegetable_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY vegetable
    ADD CONSTRAINT vegetable_pkey PRIMARY KEY (id);


--
-- TOC entry 1964 (class 1259 OID 24969)
-- Name: billheader_date_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX billheader_date_idx ON billheader USING btree (date);


--
-- TOC entry 1967 (class 1259 OID 24829)
-- Name: billheader_tstmp_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX billheader_tstmp_idx ON billheader USING btree (tstmp);


--
-- TOC entry 2017 (class 1259 OID 25043)
-- Name: carriage_code_typecarriage_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX carriage_code_typecarriage_idx ON carriage USING btree (code_typecarriage);


--
-- TOC entry 2020 (class 1259 OID 25042)
-- Name: carriage_registration_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX carriage_registration_idx ON carriage USING btree (registration);


--
-- TOC entry 2009 (class 1259 OID 24968)
-- Name: deliveryhead_date_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX deliveryhead_date_idx ON deliveryhead USING btree (date);


--
-- TOC entry 2012 (class 1259 OID 25012)
-- Name: deliveryhead_tstmp_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX deliveryhead_tstmp_idx ON deliveryhead USING btree (tstmp);


--
-- TOC entry 1982 (class 1259 OID 24980)
-- Name: saleheader_date_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX saleheader_date_idx ON saleheader USING btree (date);


--
-- TOC entry 1985 (class 1259 OID 24831)
-- Name: saleheader_registration_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX saleheader_registration_idx ON saleheader USING btree (registration);


--
-- TOC entry 1986 (class 1259 OID 24832)
-- Name: saleheader_tstmp_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX saleheader_tstmp_idx ON saleheader USING btree (tstmp);


--
-- TOC entry 1987 (class 1259 OID 24833)
-- Name: sessions_expires_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX sessions_expires_idx ON sessions USING btree (expires);


--
-- TOC entry 1990 (class 1259 OID 24930)
-- Name: user_isterminated_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX user_isterminated_idx ON "user" USING btree (isterminated);


--
-- TOC entry 2029 (class 2606 OID 24834)
-- Name: billheader_id_creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_id_creator_fkey FOREIGN KEY (id_creator) REFERENCES "user"(id) ON DELETE RESTRICT;


--
-- TOC entry 2030 (class 2606 OID 24839)
-- Name: billheader_id_debtor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_id_debtor_fkey FOREIGN KEY (id_debtor) REFERENCES farm(id) ON DELETE RESTRICT;


--
-- TOC entry 2038 (class 2606 OID 25021)
-- Name: deliverydetail_id_deliveryhead_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY deliverydetail
    ADD CONSTRAINT deliverydetail_id_deliveryhead_fkey FOREIGN KEY (id_deliveryhead) REFERENCES deliveryhead(id) ON DELETE CASCADE;


--
-- TOC entry 2039 (class 2606 OID 25026)
-- Name: deliverydetail_id_vegetable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY deliverydetail
    ADD CONSTRAINT deliverydetail_id_vegetable_fkey FOREIGN KEY (id_vegetable) REFERENCES vegetable(id) ON DELETE RESTRICT;


--
-- TOC entry 2036 (class 2606 OID 25002)
-- Name: deliveryhead_id_farm_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY deliveryhead
    ADD CONSTRAINT deliveryhead_id_farm_fkey FOREIGN KEY (id_farm) REFERENCES farm(id) ON DELETE RESTRICT;


--
-- TOC entry 2037 (class 2606 OID 25007)
-- Name: deliveryhead_id_salehead_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY deliveryhead
    ADD CONSTRAINT deliveryhead_id_salehead_fkey FOREIGN KEY (id_salehead) REFERENCES saleheader(id) ON DELETE RESTRICT;


--
-- TOC entry 2040 (class 2606 OID 25064)
-- Name: etcitem_id_etc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY etcitem
    ADD CONSTRAINT etcitem_id_etc_fkey FOREIGN KEY (id_etc) REFERENCES etc(id) ON DELETE CASCADE;


--
-- TOC entry 2031 (class 2606 OID 24859)
-- Name: saleheader_id_creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY saleheader
    ADD CONSTRAINT saleheader_id_creator_fkey FOREIGN KEY (id_creator) REFERENCES "user"(id) ON DELETE RESTRICT;


--
-- TOC entry 2032 (class 2606 OID 24864)
-- Name: saleheader_id_customer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY saleheader
    ADD CONSTRAINT saleheader_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES customer(id) ON DELETE RESTRICT;


--
-- TOC entry 2033 (class 2606 OID 24869)
-- Name: saleheader_id_instead_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY saleheader
    ADD CONSTRAINT saleheader_id_instead_fkey FOREIGN KEY (id_instead) REFERENCES saleheader(id) ON DELETE SET NULL;


--
-- TOC entry 2034 (class 2606 OID 24874)
-- Name: sessions_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_id_user_fkey FOREIGN KEY (id_user) REFERENCES "user"(id) ON DELETE SET NULL;


--
-- TOC entry 2035 (class 2606 OID 24879)
-- Name: userrole_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_id_user_fkey FOREIGN KEY (id_user) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 2182 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: ere
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM ere;
GRANT ALL ON SCHEMA public TO ere;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-02-12 13:05:43

--
-- PostgreSQL database dump complete
--

