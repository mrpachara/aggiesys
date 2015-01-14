--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.5
-- Dumped by pg_dump version 9.3.5
-- Started on 2015-01-14 13:43:22 ICT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 190 (class 3079 OID 11789)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2117 (class 0 OID 0)
-- Dependencies: 190
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 170 (class 1259 OID 16408)
-- Name: billheader; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE billheader (
    id bigint NOT NULL,
    code character varying(64) NOT NULL,
    date date NOT NULL,
    id_debtor bigint,
    fullname character varying(128) NOT NULL,
    address text,
    tstmp timestamp with time zone DEFAULT transaction_timestamp() NOT NULL,
    id_creator bigint NOT NULL
);


ALTER TABLE public.billheader OWNER TO ere;

--
-- TOC entry 171 (class 1259 OID 16415)
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
-- TOC entry 2118 (class 0 OID 0)
-- Dependencies: 171
-- Name: billheader_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE billheader_id_seq OWNED BY billheader.id;


--
-- TOC entry 172 (class 1259 OID 16417)
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
-- TOC entry 173 (class 1259 OID 16423)
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
-- TOC entry 2119 (class 0 OID 0)
-- Dependencies: 173
-- Name: customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE customer_id_seq OWNED BY customer.id;


--
-- TOC entry 174 (class 1259 OID 16425)
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
-- TOC entry 175 (class 1259 OID 16431)
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
-- TOC entry 2120 (class 0 OID 0)
-- Dependencies: 175
-- Name: farm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE farm_id_seq OWNED BY farm.id;


--
-- TOC entry 176 (class 1259 OID 16433)
-- Name: product; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE product (
    id bigint NOT NULL,
    code character varying(64),
    name character varying(128)
);


ALTER TABLE public.product OWNER TO ere;

--
-- TOC entry 177 (class 1259 OID 16436)
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
-- TOC entry 2121 (class 0 OID 0)
-- Dependencies: 177
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE product_id_seq OWNED BY product.id;


--
-- TOC entry 178 (class 1259 OID 16438)
-- Name: saledetail; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE saledetail (
    id bigint NOT NULL,
    id_farm bigint NOT NULL,
    id_vegetable bigint NOT NULL,
    qty double precision NOT NULL,
    price money NOT NULL,
    id_saleheader bigint NOT NULL
);


ALTER TABLE public.saledetail OWNER TO ere;

--
-- TOC entry 179 (class 1259 OID 16441)
-- Name: saledetail_id_seq; Type: SEQUENCE; Schema: public; Owner: ere
--

CREATE SEQUENCE saledetail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.saledetail_id_seq OWNER TO ere;

--
-- TOC entry 2122 (class 0 OID 0)
-- Dependencies: 179
-- Name: saledetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE saledetail_id_seq OWNED BY saledetail.id;


--
-- TOC entry 180 (class 1259 OID 16443)
-- Name: saleheader; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE saleheader (
    id bigint NOT NULL,
    code character varying(64) NOT NULL,
    date date NOT NULL,
    tstmp timestamp with time zone DEFAULT transaction_timestamp() NOT NULL,
    id_customer bigint NOT NULL,
    registration character varying(64) NOT NULL,
    id_creator bigint NOT NULL,
    id_instead bigint,
    fullname character varying(128) NOT NULL
);


ALTER TABLE public.saleheader OWNER TO ere;

--
-- TOC entry 181 (class 1259 OID 16447)
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
-- TOC entry 2123 (class 0 OID 0)
-- Dependencies: 181
-- Name: saleheader_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE saleheader_id_seq OWNED BY saleheader.id;


--
-- TOC entry 189 (class 1259 OID 16560)
-- Name: sessions; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE sessions (
    id bigint NOT NULL,
    tstmp timestamp without time zone NOT NULL,
    data text NOT NULL,
    id_user bigint
);


ALTER TABLE public.sessions OWNER TO ere;

--
-- TOC entry 188 (class 1259 OID 16558)
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: ere
--

CREATE SEQUENCE sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sessions_id_seq OWNER TO ere;

--
-- TOC entry 2124 (class 0 OID 0)
-- Dependencies: 188
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE sessions_id_seq OWNED BY sessions.id;


--
-- TOC entry 182 (class 1259 OID 16449)
-- Name: user; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE "user" (
    id bigint NOT NULL,
    username character varying(64),
    password character varying(128),
    fullname character varying(256)
);


ALTER TABLE public."user" OWNER TO ere;

--
-- TOC entry 183 (class 1259 OID 16452)
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
-- TOC entry 2125 (class 0 OID 0)
-- Dependencies: 183
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- TOC entry 184 (class 1259 OID 16454)
-- Name: userrole; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE userrole (
    id bigint NOT NULL,
    id_user bigint,
    role character varying(64)
);


ALTER TABLE public.userrole OWNER TO ere;

--
-- TOC entry 185 (class 1259 OID 16457)
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
-- TOC entry 2126 (class 0 OID 0)
-- Dependencies: 185
-- Name: userrole_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE userrole_id_seq OWNED BY userrole.id;


--
-- TOC entry 186 (class 1259 OID 16459)
-- Name: vegetable; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE vegetable (
    id bigint NOT NULL,
    code character varying(64),
    name character varying(128)
);


ALTER TABLE public.vegetable OWNER TO ere;

--
-- TOC entry 187 (class 1259 OID 16462)
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
-- TOC entry 2127 (class 0 OID 0)
-- Dependencies: 187
-- Name: vegetable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE vegetable_id_seq OWNED BY vegetable.id;


--
-- TOC entry 1920 (class 2604 OID 16464)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY billheader ALTER COLUMN id SET DEFAULT nextval('billheader_id_seq'::regclass);


--
-- TOC entry 1921 (class 2604 OID 16465)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY customer ALTER COLUMN id SET DEFAULT nextval('customer_id_seq'::regclass);


--
-- TOC entry 1922 (class 2604 OID 16466)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY farm ALTER COLUMN id SET DEFAULT nextval('farm_id_seq'::regclass);


--
-- TOC entry 1923 (class 2604 OID 16467)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY product ALTER COLUMN id SET DEFAULT nextval('product_id_seq'::regclass);


--
-- TOC entry 1924 (class 2604 OID 16468)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY saledetail ALTER COLUMN id SET DEFAULT nextval('saledetail_id_seq'::regclass);


--
-- TOC entry 1926 (class 2604 OID 16469)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY saleheader ALTER COLUMN id SET DEFAULT nextval('saleheader_id_seq'::regclass);


--
-- TOC entry 1930 (class 2604 OID 16563)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY sessions ALTER COLUMN id SET DEFAULT nextval('sessions_id_seq'::regclass);


--
-- TOC entry 1927 (class 2604 OID 16470)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- TOC entry 1928 (class 2604 OID 16471)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY userrole ALTER COLUMN id SET DEFAULT nextval('userrole_id_seq'::regclass);


--
-- TOC entry 1929 (class 2604 OID 16472)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY vegetable ALTER COLUMN id SET DEFAULT nextval('vegetable_id_seq'::regclass);


--
-- TOC entry 2090 (class 0 OID 16408)
-- Dependencies: 170
-- Data for Name: billheader; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY billheader (id, code, date, id_debtor, fullname, address, tstmp, id_creator) FROM stdin;
\.


--
-- TOC entry 2128 (class 0 OID 0)
-- Dependencies: 171
-- Name: billheader_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('billheader_id_seq', 1, false);


--
-- TOC entry 2092 (class 0 OID 16417)
-- Dependencies: 172
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY customer (id, code, name, address) FROM stdin;
\.


--
-- TOC entry 2129 (class 0 OID 0)
-- Dependencies: 173
-- Name: customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('customer_id_seq', 1, false);


--
-- TOC entry 2094 (class 0 OID 16425)
-- Dependencies: 174
-- Data for Name: farm; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY farm (id, code, name, address) FROM stdin;
\.


--
-- TOC entry 2130 (class 0 OID 0)
-- Dependencies: 175
-- Name: farm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('farm_id_seq', 1, false);


--
-- TOC entry 2096 (class 0 OID 16433)
-- Dependencies: 176
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY product (id, code, name) FROM stdin;
\.


--
-- TOC entry 2131 (class 0 OID 0)
-- Dependencies: 177
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('product_id_seq', 1, false);


--
-- TOC entry 2098 (class 0 OID 16438)
-- Dependencies: 178
-- Data for Name: saledetail; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY saledetail (id, id_farm, id_vegetable, qty, price, id_saleheader) FROM stdin;
\.


--
-- TOC entry 2132 (class 0 OID 0)
-- Dependencies: 179
-- Name: saledetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('saledetail_id_seq', 1, false);


--
-- TOC entry 2100 (class 0 OID 16443)
-- Dependencies: 180
-- Data for Name: saleheader; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY saleheader (id, code, date, tstmp, id_customer, registration, id_creator, id_instead, fullname) FROM stdin;
\.


--
-- TOC entry 2133 (class 0 OID 0)
-- Dependencies: 181
-- Name: saleheader_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('saleheader_id_seq', 1, false);


--
-- TOC entry 2109 (class 0 OID 16560)
-- Dependencies: 189
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY sessions (id, tstmp, data, id_user) FROM stdin;
\.


--
-- TOC entry 2134 (class 0 OID 0)
-- Dependencies: 188
-- Name: sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('sessions_id_seq', 1, false);


--
-- TOC entry 2102 (class 0 OID 16449)
-- Dependencies: 182
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY "user" (id, username, password, fullname) FROM stdin;
1	root	1234	Root
2	admin	1234	Administrator
\.


--
-- TOC entry 2135 (class 0 OID 0)
-- Dependencies: 183
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('user_id_seq', 2, true);


--
-- TOC entry 2104 (class 0 OID 16454)
-- Dependencies: 184
-- Data for Name: userrole; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY userrole (id, id_user, role) FROM stdin;
1	1	ADMIN
2	1	USER
\.


--
-- TOC entry 2136 (class 0 OID 0)
-- Dependencies: 185
-- Name: userrole_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('userrole_id_seq', 2, true);


--
-- TOC entry 2106 (class 0 OID 16459)
-- Dependencies: 186
-- Data for Name: vegetable; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY vegetable (id, code, name) FROM stdin;
\.


--
-- TOC entry 2137 (class 0 OID 0)
-- Dependencies: 187
-- Name: vegetable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('vegetable_id_seq', 1, false);


--
-- TOC entry 1932 (class 2606 OID 16474)
-- Name: billheader_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_code_key UNIQUE (code);


--
-- TOC entry 1935 (class 2606 OID 16476)
-- Name: billheader_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_pkey PRIMARY KEY (id);


--
-- TOC entry 1938 (class 2606 OID 16478)
-- Name: customer_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_code_key UNIQUE (code);


--
-- TOC entry 1940 (class 2606 OID 16480)
-- Name: customer_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- TOC entry 1942 (class 2606 OID 16482)
-- Name: farm_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY farm
    ADD CONSTRAINT farm_code_key UNIQUE (code);


--
-- TOC entry 1944 (class 2606 OID 16484)
-- Name: farm_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY farm
    ADD CONSTRAINT farm_pkey PRIMARY KEY (id);


--
-- TOC entry 1946 (class 2606 OID 16486)
-- Name: product_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_code_key UNIQUE (code);


--
-- TOC entry 1948 (class 2606 OID 16488)
-- Name: product_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- TOC entry 1950 (class 2606 OID 16490)
-- Name: saledetail_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY saledetail
    ADD CONSTRAINT saledetail_pkey PRIMARY KEY (id);


--
-- TOC entry 1952 (class 2606 OID 16492)
-- Name: saleheader_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY saleheader
    ADD CONSTRAINT saleheader_code_key UNIQUE (code);


--
-- TOC entry 1955 (class 2606 OID 16494)
-- Name: saleheader_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY saleheader
    ADD CONSTRAINT saleheader_pkey PRIMARY KEY (id);


--
-- TOC entry 1971 (class 2606 OID 16568)
-- Name: session_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT session_pkey PRIMARY KEY (id);


--
-- TOC entry 1959 (class 2606 OID 16496)
-- Name: user_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 1961 (class 2606 OID 16498)
-- Name: user_username_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- TOC entry 1963 (class 2606 OID 16500)
-- Name: userrole_id_user_role_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_id_user_role_key UNIQUE (id_user, role);


--
-- TOC entry 1965 (class 2606 OID 16502)
-- Name: userrole_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_pkey PRIMARY KEY (id);


--
-- TOC entry 1967 (class 2606 OID 16504)
-- Name: vegetable_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY vegetable
    ADD CONSTRAINT vegetable_code_key UNIQUE (code);


--
-- TOC entry 1969 (class 2606 OID 16506)
-- Name: vegetable_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY vegetable
    ADD CONSTRAINT vegetable_pkey PRIMARY KEY (id);


--
-- TOC entry 1933 (class 1259 OID 16507)
-- Name: billheader_date_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX billheader_date_idx ON billheader USING btree (date);


--
-- TOC entry 1936 (class 1259 OID 16508)
-- Name: billheader_tstmp_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX billheader_tstmp_idx ON billheader USING btree (tstmp);


--
-- TOC entry 1953 (class 1259 OID 16509)
-- Name: saleheader_date_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX saleheader_date_idx ON saleheader USING btree (date);


--
-- TOC entry 1956 (class 1259 OID 16510)
-- Name: saleheader_registration_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX saleheader_registration_idx ON saleheader USING btree (registration);


--
-- TOC entry 1957 (class 1259 OID 16511)
-- Name: saleheader_tstmp_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX saleheader_tstmp_idx ON saleheader USING btree (tstmp);


--
-- TOC entry 1972 (class 1259 OID 16574)
-- Name: sessions_tstmp_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX sessions_tstmp_idx ON sessions USING btree (tstmp);


--
-- TOC entry 1973 (class 2606 OID 16512)
-- Name: billheader_id_creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_id_creator_fkey FOREIGN KEY (id_creator) REFERENCES "user"(id) ON DELETE RESTRICT;


--
-- TOC entry 1974 (class 2606 OID 16517)
-- Name: billheader_id_debtor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_id_debtor_fkey FOREIGN KEY (id_debtor) REFERENCES farm(id) ON DELETE RESTRICT;


--
-- TOC entry 1975 (class 2606 OID 16522)
-- Name: saledetail_id_farm_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY saledetail
    ADD CONSTRAINT saledetail_id_farm_fkey FOREIGN KEY (id_farm) REFERENCES farm(id) ON DELETE RESTRICT;


--
-- TOC entry 1976 (class 2606 OID 16527)
-- Name: saledetail_id_saleheader_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY saledetail
    ADD CONSTRAINT saledetail_id_saleheader_fkey FOREIGN KEY (id_saleheader) REFERENCES saleheader(id) ON DELETE CASCADE;


--
-- TOC entry 1977 (class 2606 OID 16532)
-- Name: saledetail_id_vegetable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY saledetail
    ADD CONSTRAINT saledetail_id_vegetable_fkey FOREIGN KEY (id_vegetable) REFERENCES vegetable(id) ON DELETE RESTRICT;


--
-- TOC entry 1978 (class 2606 OID 16537)
-- Name: saleheader_id_creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY saleheader
    ADD CONSTRAINT saleheader_id_creator_fkey FOREIGN KEY (id_creator) REFERENCES "user"(id) ON DELETE RESTRICT;


--
-- TOC entry 1979 (class 2606 OID 16542)
-- Name: saleheader_id_customer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY saleheader
    ADD CONSTRAINT saleheader_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES customer(id) ON DELETE RESTRICT;


--
-- TOC entry 1980 (class 2606 OID 16547)
-- Name: saleheader_id_instead_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY saleheader
    ADD CONSTRAINT saleheader_id_instead_fkey FOREIGN KEY (id_instead) REFERENCES saleheader(id) ON DELETE SET NULL;


--
-- TOC entry 1982 (class 2606 OID 16575)
-- Name: session_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT session_id_user_fkey FOREIGN KEY (id_user) REFERENCES "user"(id) ON DELETE SET NULL;


--
-- TOC entry 1981 (class 2606 OID 16552)
-- Name: userrole_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_id_user_fkey FOREIGN KEY (id_user) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 2116 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-01-14 13:43:23 ICT

--
-- PostgreSQL database dump complete
--

