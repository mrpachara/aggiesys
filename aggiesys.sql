--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.6
-- Dumped by pg_dump version 9.3.6
-- Started on 2015-02-26 18:02:57 ICT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 199 (class 3079 OID 11789)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2221 (class 0 OID 0)
-- Dependencies: 199
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 200 (class 3079 OID 17312)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 2222 (class 0 OID 0)
-- Dependencies: 200
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET search_path = public, pg_catalog;

SET default_with_oids = false;

--
-- TOC entry 170 (class 1259 OID 17065)
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
-- TOC entry 171 (class 1259 OID 17072)
-- Name: billheader_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE billheader_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2223 (class 0 OID 0)
-- Dependencies: 171
-- Name: billheader_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE billheader_id_seq OWNED BY billheader.id;


--
-- TOC entry 172 (class 1259 OID 17074)
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
-- TOC entry 173 (class 1259 OID 17077)
-- Name: carriage_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE carriage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2224 (class 0 OID 0)
-- Dependencies: 173
-- Name: carriage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE carriage_id_seq OWNED BY carriage.id;


--
-- TOC entry 174 (class 1259 OID 17079)
-- Name: customer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE customer (
    id bigint NOT NULL,
    code character varying(64) NOT NULL,
    name character varying(128) NOT NULL,
    address text
);


--
-- TOC entry 175 (class 1259 OID 17085)
-- Name: customer_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2225 (class 0 OID 0)
-- Dependencies: 175
-- Name: customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customer_id_seq OWNED BY customer.id;


--
-- TOC entry 176 (class 1259 OID 17087)
-- Name: deliverydetail; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE deliverydetail (
    id bigint NOT NULL,
    id_deliveryhead bigint NOT NULL,
    id_vegetable bigint NOT NULL,
    qty double precision NOT NULL,
    price numeric NOT NULL
);


--
-- TOC entry 177 (class 1259 OID 17093)
-- Name: deliverydetail_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE deliverydetail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2226 (class 0 OID 0)
-- Dependencies: 177
-- Name: deliverydetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE deliverydetail_id_seq OWNED BY deliverydetail.id;


--
-- TOC entry 178 (class 1259 OID 17095)
-- Name: deliveryhead; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE deliveryhead (
    id bigint NOT NULL,
    code character varying(64),
    date timestamp with time zone NOT NULL,
    id_farm bigint NOT NULL,
    fullname character varying(128) NOT NULL,
    address text NOT NULL,
    id_salehead bigint,
    tstmp timestamp with time zone DEFAULT now() NOT NULL,
    id_creator bigint NOT NULL,
    tstmp_canceled timestamp with time zone
);


--
-- TOC entry 179 (class 1259 OID 17102)
-- Name: deliveryhead_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE deliveryhead_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2227 (class 0 OID 0)
-- Dependencies: 179
-- Name: deliveryhead_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE deliveryhead_id_seq OWNED BY deliveryhead.id;


--
-- TOC entry 180 (class 1259 OID 17104)
-- Name: etc; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE etc (
    id bigint NOT NULL,
    code character varying(16) NOT NULL,
    name character varying(128) NOT NULL
);


--
-- TOC entry 181 (class 1259 OID 17107)
-- Name: etc_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE etc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2228 (class 0 OID 0)
-- Dependencies: 181
-- Name: etc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE etc_id_seq OWNED BY etc.id;


--
-- TOC entry 182 (class 1259 OID 17109)
-- Name: etcitem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE etcitem (
    id bigint NOT NULL,
    id_etc bigint NOT NULL,
    code character varying(16) NOT NULL,
    value character varying(128) NOT NULL
);


--
-- TOC entry 183 (class 1259 OID 17112)
-- Name: etcitem_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE etcitem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2229 (class 0 OID 0)
-- Dependencies: 183
-- Name: etcitem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE etcitem_id_seq OWNED BY etcitem.id;


--
-- TOC entry 184 (class 1259 OID 17114)
-- Name: farm; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE farm (
    id bigint NOT NULL,
    code character varying(64) NOT NULL,
    name character varying(128) NOT NULL,
    address text
);


--
-- TOC entry 185 (class 1259 OID 17120)
-- Name: farm_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE farm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2230 (class 0 OID 0)
-- Dependencies: 185
-- Name: farm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE farm_id_seq OWNED BY farm.id;


--
-- TOC entry 186 (class 1259 OID 17122)
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
-- TOC entry 187 (class 1259 OID 17125)
-- Name: generator_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE generator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2231 (class 0 OID 0)
-- Dependencies: 187
-- Name: generator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE generator_id_seq OWNED BY generator.id;


--
-- TOC entry 188 (class 1259 OID 17127)
-- Name: product; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE product (
    id bigint NOT NULL,
    code character varying(64),
    name character varying(128)
);


--
-- TOC entry 189 (class 1259 OID 17130)
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2232 (class 0 OID 0)
-- Dependencies: 189
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE product_id_seq OWNED BY product.id;


--
-- TOC entry 190 (class 1259 OID 17132)
-- Name: saleheader; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE saleheader (
    id bigint NOT NULL,
    code character varying(64) NOT NULL,
    date timestamp with time zone NOT NULL,
    tstmp timestamp with time zone DEFAULT transaction_timestamp() NOT NULL,
    id_customer bigint NOT NULL,
    registration character varying(64) NOT NULL,
    id_creator bigint NOT NULL,
    id_instead bigint,
    fullname character varying(128) NOT NULL
);


--
-- TOC entry 191 (class 1259 OID 17136)
-- Name: saleheader_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE saleheader_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2233 (class 0 OID 0)
-- Dependencies: 191
-- Name: saleheader_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE saleheader_id_seq OWNED BY saleheader.id;


--
-- TOC entry 192 (class 1259 OID 17138)
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sessions (
    expires timestamp with time zone,
    data text,
    id_user bigint,
    id character varying(32) NOT NULL
);


--
-- TOC entry 193 (class 1259 OID 17144)
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
-- TOC entry 194 (class 1259 OID 17148)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2234 (class 0 OID 0)
-- Dependencies: 194
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- TOC entry 195 (class 1259 OID 17150)
-- Name: userrole; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE userrole (
    id bigint NOT NULL,
    id_user bigint,
    role character varying(64)
);


--
-- TOC entry 196 (class 1259 OID 17153)
-- Name: userrole_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE userrole_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2235 (class 0 OID 0)
-- Dependencies: 196
-- Name: userrole_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE userrole_id_seq OWNED BY userrole.id;


--
-- TOC entry 197 (class 1259 OID 17155)
-- Name: vegetable; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE vegetable (
    id bigint NOT NULL,
    code character varying(64),
    name character varying(128)
);


--
-- TOC entry 198 (class 1259 OID 17158)
-- Name: vegetable_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vegetable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2236 (class 0 OID 0)
-- Dependencies: 198
-- Name: vegetable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vegetable_id_seq OWNED BY vegetable.id;


--
-- TOC entry 1983 (class 2604 OID 17160)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY billheader ALTER COLUMN id SET DEFAULT nextval('billheader_id_seq'::regclass);


--
-- TOC entry 1985 (class 2604 OID 17161)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY carriage ALTER COLUMN id SET DEFAULT nextval('carriage_id_seq'::regclass);


--
-- TOC entry 1986 (class 2604 OID 17162)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer ALTER COLUMN id SET DEFAULT nextval('customer_id_seq'::regclass);


--
-- TOC entry 1987 (class 2604 OID 17163)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliverydetail ALTER COLUMN id SET DEFAULT nextval('deliverydetail_id_seq'::regclass);


--
-- TOC entry 1988 (class 2604 OID 17164)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliveryhead ALTER COLUMN id SET DEFAULT nextval('deliveryhead_id_seq'::regclass);


--
-- TOC entry 1990 (class 2604 OID 17165)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY etc ALTER COLUMN id SET DEFAULT nextval('etc_id_seq'::regclass);


--
-- TOC entry 1991 (class 2604 OID 17166)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY etcitem ALTER COLUMN id SET DEFAULT nextval('etcitem_id_seq'::regclass);


--
-- TOC entry 1992 (class 2604 OID 17167)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY farm ALTER COLUMN id SET DEFAULT nextval('farm_id_seq'::regclass);


--
-- TOC entry 1993 (class 2604 OID 17168)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY generator ALTER COLUMN id SET DEFAULT nextval('generator_id_seq'::regclass);


--
-- TOC entry 1994 (class 2604 OID 17169)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY product ALTER COLUMN id SET DEFAULT nextval('product_id_seq'::regclass);


--
-- TOC entry 1996 (class 2604 OID 17170)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY saleheader ALTER COLUMN id SET DEFAULT nextval('saleheader_id_seq'::regclass);


--
-- TOC entry 1998 (class 2604 OID 17171)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- TOC entry 1999 (class 2604 OID 17172)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY userrole ALTER COLUMN id SET DEFAULT nextval('userrole_id_seq'::regclass);


--
-- TOC entry 2000 (class 2604 OID 17173)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vegetable ALTER COLUMN id SET DEFAULT nextval('vegetable_id_seq'::regclass);


--
-- TOC entry 2187 (class 0 OID 17065)
-- Dependencies: 170
-- Data for Name: billheader; Type: TABLE DATA; Schema: public; Owner: -
--

COPY billheader (id, code, date, id_debtor, fullname, address, tstmp, id_creator) FROM stdin;
\.


--
-- TOC entry 2237 (class 0 OID 0)
-- Dependencies: 171
-- Name: billheader_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('billheader_id_seq', 1, false);


--
-- TOC entry 2189 (class 0 OID 17074)
-- Dependencies: 172
-- Data for Name: carriage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY carriage (id, code, registration, code_typecarriage, name) FROM stdin;
3	truck001	ฮ 4321	TRUCK	Truck 001
2	pickup001	กข 1234	PICKUP	Pickup 001
\.


--
-- TOC entry 2238 (class 0 OID 0)
-- Dependencies: 173
-- Name: carriage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('carriage_id_seq', 3, true);


--
-- TOC entry 2191 (class 0 OID 17079)
-- Dependencies: 174
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: -
--

COPY customer (id, code, name, address) FROM stdin;
2	C002	Customer 002	123\nabc\ndef
3	C001	Customer 001	123\nd\nd
\.


--
-- TOC entry 2239 (class 0 OID 0)
-- Dependencies: 175
-- Name: customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('customer_id_seq', 3, true);


--
-- TOC entry 2193 (class 0 OID 17087)
-- Dependencies: 176
-- Data for Name: deliverydetail; Type: TABLE DATA; Schema: public; Owner: -
--

COPY deliverydetail (id, id_deliveryhead, id_vegetable, qty, price) FROM stdin;
10	4	6	100	400
11	4	12	200	500
12	4	13	400	1000
13	5	6	100	300
14	5	19	400	500
15	6	6	200	300
16	6	19	400	500
17	7	6	100	400
18	7	12	200	500
19	7	13	400	1000
20	7	20	1000	1000
21	8	6	100	400
22	8	12	200	500
23	8	13	400	1000
24	9	6	100	400
25	9	12	200	500
26	9	13	400	1000
27	9	20	1000	1000
28	10	13	100	2000
29	10	19	2000	2000
30	10	8	678	5679
31	11	19	10	10
32	12	19	100	2000
33	12	6	1222	3333
34	13	19	123	123
35	13	8	1234	1234
\.


--
-- TOC entry 2240 (class 0 OID 0)
-- Dependencies: 177
-- Name: deliverydetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('deliverydetail_id_seq', 35, true);


--
-- TOC entry 2195 (class 0 OID 17095)
-- Dependencies: 178
-- Data for Name: deliveryhead; Type: TABLE DATA; Schema: public; Owner: -
--

COPY deliveryhead (id, code, date, id_farm, fullname, address, id_salehead, tstmp, id_creator, tstmp_canceled) FROM stdin;
5	111502250002	2015-02-25 10:22:35+07	3	Farm 002	123\nabc\ndef	\N	2015-02-25 17:23:27.40689+07	3	2015-02-25 18:25:40.886826+07
6	111502250003	2015-02-25 03:22:35+07	3	Farm 002	123\nabc\ndef	\N	2015-02-25 18:25:40.886826+07	3	\N
4	111502250001	2015-02-25 00:22:58+07	2	Farm 001	123\nabc\ndef	\N	2015-02-25 14:24:10.77425+07	3	2015-02-25 18:32:27.207261+07
7	111502250004	2015-02-24 17:22:58+07	2	Farm 001	123\nabc\ndef	\N	2015-02-25 18:32:27.207261+07	3	2015-02-25 18:34:27.810579+07
8	111502250005	2015-02-24 10:22:58+07	2	Farm 001	123\nabc\ndef	\N	2015-02-25 18:34:27.810579+07	3	2015-02-25 18:36:32.242571+07
9	111502250006	2015-02-24 03:22:58+07	2	Farm 001	123\nabc\ndef	\N	2015-02-25 18:36:32.242571+07	3	\N
10	111502260001	2015-02-26 07:52:57+07	4	asdf	asdf\nasdf\nasdf	\N	2015-02-26 14:54:00.056499+07	3	\N
11	111502260002	2015-02-26 07:56:49+07	3	Farm 002	123\nabc\ndef	\N	2015-02-26 14:57:48.008297+07	3	\N
12	111502260003	2015-02-26 16:35:01+07	2	Farm 001	123\nabc\ndef	\N	2015-02-26 16:35:48.270592+07	3	\N
13	111502260004	2015-02-26 17:55:29+07	4	asdf	asdf\nasdf\nasdf	\N	2015-02-26 17:56:17.831865+07	3	\N
\.


--
-- TOC entry 2241 (class 0 OID 0)
-- Dependencies: 179
-- Name: deliveryhead_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('deliveryhead_id_seq', 13, true);


--
-- TOC entry 2197 (class 0 OID 17104)
-- Dependencies: 180
-- Data for Name: etc; Type: TABLE DATA; Schema: public; Owner: -
--

COPY etc (id, code, name) FROM stdin;
1	TYPE_CARRIAGE	Carriage Type
2	PREFIX_NAME	Prefix Namex
\.


--
-- TOC entry 2242 (class 0 OID 0)
-- Dependencies: 181
-- Name: etc_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('etc_id_seq', 3, true);


--
-- TOC entry 2199 (class 0 OID 17109)
-- Dependencies: 182
-- Data for Name: etcitem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY etcitem (id, id_etc, code, value) FROM stdin;
58	1	PICKUP	Picup
59	1	TRUCK	Truck
64	2	MISS	Miss
65	2	MS	Ms.
66	2	PICKUP	wrong coded
\.


--
-- TOC entry 2243 (class 0 OID 0)
-- Dependencies: 183
-- Name: etcitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('etcitem_id_seq', 68, true);


--
-- TOC entry 2201 (class 0 OID 17114)
-- Dependencies: 184
-- Data for Name: farm; Type: TABLE DATA; Schema: public; Owner: -
--

COPY farm (id, code, name, address) FROM stdin;
3	F002	Farm 002	123\nabc\ndef
2	F001	Farm 001	123\nabc\ndef
4	910001	asdf	asdf\nasdf\nasdf
\.


--
-- TOC entry 2244 (class 0 OID 0)
-- Dependencies: 185
-- Name: farm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('farm_id_seq', 4, true);


--
-- TOC entry 2203 (class 0 OID 17122)
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
4	11	4	150226	5
\.


--
-- TOC entry 2245 (class 0 OID 0)
-- Dependencies: 187
-- Name: generator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('generator_id_seq', 11, true);


--
-- TOC entry 2205 (class 0 OID 17127)
-- Dependencies: 188
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: -
--

COPY product (id, code, name) FROM stdin;
\.


--
-- TOC entry 2246 (class 0 OID 0)
-- Dependencies: 189
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('product_id_seq', 1, false);


--
-- TOC entry 2207 (class 0 OID 17132)
-- Dependencies: 190
-- Data for Name: saleheader; Type: TABLE DATA; Schema: public; Owner: -
--

COPY saleheader (id, code, date, tstmp, id_customer, registration, id_creator, id_instead, fullname) FROM stdin;
\.


--
-- TOC entry 2247 (class 0 OID 0)
-- Dependencies: 191
-- Name: saleheader_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('saleheader_id_seq', 1, false);


--
-- TOC entry 2209 (class 0 OID 17138)
-- Dependencies: 192
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY sessions (expires, data, id_user, id) FROM stdin;
2015-02-26 20:43:31.554539+07	__GSESSION__|a:1:{s:9:"__tmpsess";N;}	3	lbnaafe2mbkpfdn1pc50297gr7
2015-02-26 20:56:26.893873+07	__GSESSION__|a:1:{s:9:"__tmpsess";N;}	3	f307lgo5kl34p570gat93u7846
2015-02-26 20:36:18.897708+07	__GSESSION__|a:1:{s:9:"__tmpsess";N;}	3	rud4ft0lqgvtrgqebtpb146r40
2015-02-26 21:00:09.093363+07	__GSESSION__|a:1:{s:9:"__tmpsess";N;}	3	4h990pb3ohmo73q0emmkj0aip7
2015-02-26 20:40:21.891006+07	__GSESSION__|a:1:{s:9:"__tmpsess";N;}	3	153mk5k415uib2dkpvkf3eoh45
\.


--
-- TOC entry 2210 (class 0 OID 17144)
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
\.


--
-- TOC entry 2248 (class 0 OID 0)
-- Dependencies: 194
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('user_id_seq', 37, true);


--
-- TOC entry 2212 (class 0 OID 17150)
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
\.


--
-- TOC entry 2249 (class 0 OID 0)
-- Dependencies: 196
-- Name: userrole_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('userrole_id_seq', 123, true);


--
-- TOC entry 2214 (class 0 OID 17155)
-- Dependencies: 197
-- Data for Name: vegetable; Type: TABLE DATA; Schema: public; Owner: -
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
-- TOC entry 2250 (class 0 OID 0)
-- Dependencies: 198
-- Name: vegetable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('vegetable_id_seq', 21, true);


--
-- TOC entry 2002 (class 2606 OID 17175)
-- Name: billheader_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_code_key UNIQUE (code);


--
-- TOC entry 2005 (class 2606 OID 17177)
-- Name: billheader_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_pkey PRIMARY KEY (id);


--
-- TOC entry 2008 (class 2606 OID 17179)
-- Name: carriage_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY carriage
    ADD CONSTRAINT carriage_code_key UNIQUE (code);


--
-- TOC entry 2011 (class 2606 OID 17181)
-- Name: carriage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY carriage
    ADD CONSTRAINT carriage_pkey PRIMARY KEY (id);


--
-- TOC entry 2014 (class 2606 OID 17183)
-- Name: customer_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_code_key UNIQUE (code);


--
-- TOC entry 2016 (class 2606 OID 17185)
-- Name: customer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- TOC entry 2018 (class 2606 OID 17187)
-- Name: deliverydetail_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliverydetail
    ADD CONSTRAINT deliverydetail_pkey PRIMARY KEY (id);


--
-- TOC entry 2020 (class 2606 OID 17189)
-- Name: deliveryhead_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliveryhead
    ADD CONSTRAINT deliveryhead_code_key UNIQUE (code);


--
-- TOC entry 2023 (class 2606 OID 17191)
-- Name: deliveryhead_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliveryhead
    ADD CONSTRAINT deliveryhead_pkey PRIMARY KEY (id);


--
-- TOC entry 2025 (class 2606 OID 17193)
-- Name: etc_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY etc
    ADD CONSTRAINT etc_code_key UNIQUE (code);


--
-- TOC entry 2027 (class 2606 OID 17195)
-- Name: etc_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY etc
    ADD CONSTRAINT etc_pkey PRIMARY KEY (id);


--
-- TOC entry 2029 (class 2606 OID 17197)
-- Name: etcitem_id_etc_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY etcitem
    ADD CONSTRAINT etcitem_id_etc_code_key UNIQUE (id_etc, code);


--
-- TOC entry 2031 (class 2606 OID 17199)
-- Name: etcitem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY etcitem
    ADD CONSTRAINT etcitem_pkey PRIMARY KEY (id);


--
-- TOC entry 2033 (class 2606 OID 17201)
-- Name: farm_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY farm
    ADD CONSTRAINT farm_code_key UNIQUE (code);


--
-- TOC entry 2035 (class 2606 OID 17203)
-- Name: farm_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY farm
    ADD CONSTRAINT farm_pkey PRIMARY KEY (id);


--
-- TOC entry 2037 (class 2606 OID 17205)
-- Name: generator_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY generator
    ADD CONSTRAINT generator_code_key UNIQUE (code);


--
-- TOC entry 2039 (class 2606 OID 17207)
-- Name: generator_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY generator
    ADD CONSTRAINT generator_pkey PRIMARY KEY (id);


--
-- TOC entry 2041 (class 2606 OID 17209)
-- Name: product_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_code_key UNIQUE (code);


--
-- TOC entry 2043 (class 2606 OID 17211)
-- Name: product_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- TOC entry 2045 (class 2606 OID 17213)
-- Name: saleheader_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY saleheader
    ADD CONSTRAINT saleheader_code_key UNIQUE (code);


--
-- TOC entry 2048 (class 2606 OID 17215)
-- Name: saleheader_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY saleheader
    ADD CONSTRAINT saleheader_pkey PRIMARY KEY (id);


--
-- TOC entry 2053 (class 2606 OID 17217)
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 2056 (class 2606 OID 17219)
-- Name: user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 2058 (class 2606 OID 17221)
-- Name: user_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- TOC entry 2060 (class 2606 OID 17223)
-- Name: userrole_id_user_role_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_id_user_role_key UNIQUE (id_user, role);


--
-- TOC entry 2062 (class 2606 OID 17225)
-- Name: userrole_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_pkey PRIMARY KEY (id);


--
-- TOC entry 2064 (class 2606 OID 17227)
-- Name: vegetable_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vegetable
    ADD CONSTRAINT vegetable_code_key UNIQUE (code);


--
-- TOC entry 2066 (class 2606 OID 17229)
-- Name: vegetable_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vegetable
    ADD CONSTRAINT vegetable_pkey PRIMARY KEY (id);


--
-- TOC entry 2003 (class 1259 OID 25300)
-- Name: billheader_date_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX billheader_date_idx ON billheader USING btree (date);


--
-- TOC entry 2006 (class 1259 OID 25312)
-- Name: billheader_tstmp_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX billheader_tstmp_idx ON billheader USING btree (tstmp);


--
-- TOC entry 2009 (class 1259 OID 17232)
-- Name: carriage_code_typecarriage_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX carriage_code_typecarriage_idx ON carriage USING btree (code_typecarriage);


--
-- TOC entry 2012 (class 1259 OID 17233)
-- Name: carriage_registration_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX carriage_registration_idx ON carriage USING btree (registration);


--
-- TOC entry 2021 (class 1259 OID 25271)
-- Name: deliveryhead_date_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX deliveryhead_date_idx ON deliveryhead USING btree (date);


--
-- TOC entry 2046 (class 1259 OID 25262)
-- Name: saleheader_date_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX saleheader_date_idx ON saleheader USING btree (date);


--
-- TOC entry 2049 (class 1259 OID 17236)
-- Name: saleheader_registration_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX saleheader_registration_idx ON saleheader USING btree (registration);


--
-- TOC entry 2050 (class 1259 OID 17237)
-- Name: saleheader_tstmp_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX saleheader_tstmp_idx ON saleheader USING btree (tstmp);


--
-- TOC entry 2051 (class 1259 OID 25253)
-- Name: sessions_expires_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sessions_expires_idx ON sessions USING btree (expires);


--
-- TOC entry 2054 (class 1259 OID 17239)
-- Name: user_isterminated_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_isterminated_idx ON "user" USING btree (isterminated);


--
-- TOC entry 2067 (class 2606 OID 17240)
-- Name: billheader_id_creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_id_creator_fkey FOREIGN KEY (id_creator) REFERENCES "user"(id) ON DELETE RESTRICT;


--
-- TOC entry 2068 (class 2606 OID 17245)
-- Name: billheader_id_debtor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_id_debtor_fkey FOREIGN KEY (id_debtor) REFERENCES farm(id) ON DELETE RESTRICT;


--
-- TOC entry 2069 (class 2606 OID 17250)
-- Name: deliverydetail_id_deliveryhead_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliverydetail
    ADD CONSTRAINT deliverydetail_id_deliveryhead_fkey FOREIGN KEY (id_deliveryhead) REFERENCES deliveryhead(id) ON DELETE CASCADE;


--
-- TOC entry 2070 (class 2606 OID 17255)
-- Name: deliverydetail_id_vegetable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliverydetail
    ADD CONSTRAINT deliverydetail_id_vegetable_fkey FOREIGN KEY (id_vegetable) REFERENCES vegetable(id) ON DELETE RESTRICT;


--
-- TOC entry 2071 (class 2606 OID 17265)
-- Name: deliveryhead_id_creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliveryhead
    ADD CONSTRAINT deliveryhead_id_creator_fkey FOREIGN KEY (id_creator) REFERENCES "user"(id);


--
-- TOC entry 2072 (class 2606 OID 17270)
-- Name: deliveryhead_id_farm_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliveryhead
    ADD CONSTRAINT deliveryhead_id_farm_fkey FOREIGN KEY (id_farm) REFERENCES farm(id) ON DELETE RESTRICT;


--
-- TOC entry 2073 (class 2606 OID 17275)
-- Name: deliveryhead_id_salehead_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY deliveryhead
    ADD CONSTRAINT deliveryhead_id_salehead_fkey FOREIGN KEY (id_salehead) REFERENCES saleheader(id) ON DELETE RESTRICT;


--
-- TOC entry 2074 (class 2606 OID 17280)
-- Name: etcitem_id_etc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY etcitem
    ADD CONSTRAINT etcitem_id_etc_fkey FOREIGN KEY (id_etc) REFERENCES etc(id) ON DELETE CASCADE;


--
-- TOC entry 2075 (class 2606 OID 17285)
-- Name: saleheader_id_creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY saleheader
    ADD CONSTRAINT saleheader_id_creator_fkey FOREIGN KEY (id_creator) REFERENCES "user"(id) ON DELETE RESTRICT;


--
-- TOC entry 2076 (class 2606 OID 17290)
-- Name: saleheader_id_customer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY saleheader
    ADD CONSTRAINT saleheader_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES customer(id) ON DELETE RESTRICT;


--
-- TOC entry 2077 (class 2606 OID 17295)
-- Name: saleheader_id_instead_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY saleheader
    ADD CONSTRAINT saleheader_id_instead_fkey FOREIGN KEY (id_instead) REFERENCES saleheader(id) ON DELETE SET NULL;


--
-- TOC entry 2078 (class 2606 OID 17300)
-- Name: sessions_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_id_user_fkey FOREIGN KEY (id_user) REFERENCES "user"(id) ON DELETE SET NULL;


--
-- TOC entry 2079 (class 2606 OID 17305)
-- Name: userrole_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_id_user_fkey FOREIGN KEY (id_user) REFERENCES "user"(id) ON DELETE CASCADE;


-- Completed on 2015-02-26 18:02:57 ICT

--
-- PostgreSQL database dump complete
--

