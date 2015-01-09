--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.5
-- Dumped by pg_dump version 9.3.5
-- Started on 2015-01-09 17:11:11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 188 (class 3079 OID 11750)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2065 (class 0 OID 0)
-- Dependencies: 188
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 185 (class 1259 OID 16686)
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
-- TOC entry 184 (class 1259 OID 16684)
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
-- TOC entry 2066 (class 0 OID 0)
-- Dependencies: 184
-- Name: billheader_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE billheader_id_seq OWNED BY billheader.id;


--
-- TOC entry 177 (class 1259 OID 16557)
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
-- TOC entry 176 (class 1259 OID 16555)
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
-- TOC entry 2067 (class 0 OID 0)
-- Dependencies: 176
-- Name: customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE customer_id_seq OWNED BY customer.id;


--
-- TOC entry 175 (class 1259 OID 16544)
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
-- TOC entry 174 (class 1259 OID 16542)
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
-- TOC entry 2068 (class 0 OID 0)
-- Dependencies: 174
-- Name: farm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE farm_id_seq OWNED BY farm.id;


--
-- TOC entry 187 (class 1259 OID 16720)
-- Name: product; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE product (
    id bigint NOT NULL,
    code character varying(64),
    name character varying(128)
);


ALTER TABLE public.product OWNER TO ere;

--
-- TOC entry 186 (class 1259 OID 16718)
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
-- TOC entry 2069 (class 0 OID 0)
-- Dependencies: 186
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE product_id_seq OWNED BY product.id;


--
-- TOC entry 183 (class 1259 OID 16626)
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
-- TOC entry 182 (class 1259 OID 16624)
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
-- TOC entry 2070 (class 0 OID 0)
-- Dependencies: 182
-- Name: saledetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE saledetail_id_seq OWNED BY saledetail.id;


--
-- TOC entry 181 (class 1259 OID 16607)
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
-- TOC entry 180 (class 1259 OID 16605)
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
-- TOC entry 2071 (class 0 OID 0)
-- Dependencies: 180
-- Name: saleheader_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE saleheader_id_seq OWNED BY saleheader.id;


--
-- TOC entry 171 (class 1259 OID 16514)
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
-- TOC entry 170 (class 1259 OID 16512)
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
-- TOC entry 2072 (class 0 OID 0)
-- Dependencies: 170
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- TOC entry 173 (class 1259 OID 16524)
-- Name: userrole; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE userrole (
    id bigint NOT NULL,
    id_user bigint,
    role character varying(64)
);


ALTER TABLE public.userrole OWNER TO ere;

--
-- TOC entry 172 (class 1259 OID 16522)
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
-- TOC entry 2073 (class 0 OID 0)
-- Dependencies: 172
-- Name: userrole_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE userrole_id_seq OWNED BY userrole.id;


--
-- TOC entry 179 (class 1259 OID 16570)
-- Name: vegetable; Type: TABLE; Schema: public; Owner: ere; Tablespace: 
--

CREATE TABLE vegetable (
    id bigint NOT NULL,
    code character varying(64),
    name character varying(128)
);


ALTER TABLE public.vegetable OWNER TO ere;

--
-- TOC entry 178 (class 1259 OID 16568)
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
-- TOC entry 2074 (class 0 OID 0)
-- Dependencies: 178
-- Name: vegetable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ere
--

ALTER SEQUENCE vegetable_id_seq OWNED BY vegetable.id;


--
-- TOC entry 1882 (class 2604 OID 16689)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY billheader ALTER COLUMN id SET DEFAULT nextval('billheader_id_seq'::regclass);


--
-- TOC entry 1877 (class 2604 OID 16560)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY customer ALTER COLUMN id SET DEFAULT nextval('customer_id_seq'::regclass);


--
-- TOC entry 1876 (class 2604 OID 16547)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY farm ALTER COLUMN id SET DEFAULT nextval('farm_id_seq'::regclass);


--
-- TOC entry 1884 (class 2604 OID 16723)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY product ALTER COLUMN id SET DEFAULT nextval('product_id_seq'::regclass);


--
-- TOC entry 1881 (class 2604 OID 16629)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY saledetail ALTER COLUMN id SET DEFAULT nextval('saledetail_id_seq'::regclass);


--
-- TOC entry 1879 (class 2604 OID 16610)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY saleheader ALTER COLUMN id SET DEFAULT nextval('saleheader_id_seq'::regclass);


--
-- TOC entry 1874 (class 2604 OID 16517)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- TOC entry 1875 (class 2604 OID 16527)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY userrole ALTER COLUMN id SET DEFAULT nextval('userrole_id_seq'::regclass);


--
-- TOC entry 1878 (class 2604 OID 16573)
-- Name: id; Type: DEFAULT; Schema: public; Owner: ere
--

ALTER TABLE ONLY vegetable ALTER COLUMN id SET DEFAULT nextval('vegetable_id_seq'::regclass);


--
-- TOC entry 2055 (class 0 OID 16686)
-- Dependencies: 185
-- Data for Name: billheader; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY billheader (id, code, date, id_debtor, fullname, address, tstmp, id_creator) FROM stdin;
\.


--
-- TOC entry 2075 (class 0 OID 0)
-- Dependencies: 184
-- Name: billheader_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('billheader_id_seq', 1, false);


--
-- TOC entry 2047 (class 0 OID 16557)
-- Dependencies: 177
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY customer (id, code, name, address) FROM stdin;
\.


--
-- TOC entry 2076 (class 0 OID 0)
-- Dependencies: 176
-- Name: customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('customer_id_seq', 1, false);


--
-- TOC entry 2045 (class 0 OID 16544)
-- Dependencies: 175
-- Data for Name: farm; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY farm (id, code, name, address) FROM stdin;
\.


--
-- TOC entry 2077 (class 0 OID 0)
-- Dependencies: 174
-- Name: farm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('farm_id_seq', 1, false);


--
-- TOC entry 2057 (class 0 OID 16720)
-- Dependencies: 187
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY product (id, code, name) FROM stdin;
\.


--
-- TOC entry 2078 (class 0 OID 0)
-- Dependencies: 186
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('product_id_seq', 1, false);


--
-- TOC entry 2053 (class 0 OID 16626)
-- Dependencies: 183
-- Data for Name: saledetail; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY saledetail (id, id_farm, id_vegetable, qty, price, id_saleheader) FROM stdin;
\.


--
-- TOC entry 2079 (class 0 OID 0)
-- Dependencies: 182
-- Name: saledetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('saledetail_id_seq', 1, false);


--
-- TOC entry 2051 (class 0 OID 16607)
-- Dependencies: 181
-- Data for Name: saleheader; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY saleheader (id, code, date, tstmp, id_customer, registration, id_creator, id_instead, fullname) FROM stdin;
\.


--
-- TOC entry 2080 (class 0 OID 0)
-- Dependencies: 180
-- Name: saleheader_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('saleheader_id_seq', 1, false);


--
-- TOC entry 2041 (class 0 OID 16514)
-- Dependencies: 171
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY "user" (id, username, password, fullname) FROM stdin;
\.


--
-- TOC entry 2081 (class 0 OID 0)
-- Dependencies: 170
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('user_id_seq', 1, false);


--
-- TOC entry 2043 (class 0 OID 16524)
-- Dependencies: 173
-- Data for Name: userrole; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY userrole (id, id_user, role) FROM stdin;
\.


--
-- TOC entry 2082 (class 0 OID 0)
-- Dependencies: 172
-- Name: userrole_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('userrole_id_seq', 1, false);


--
-- TOC entry 2049 (class 0 OID 16570)
-- Dependencies: 179
-- Data for Name: vegetable; Type: TABLE DATA; Schema: public; Owner: ere
--

COPY vegetable (id, code, name) FROM stdin;
\.


--
-- TOC entry 2083 (class 0 OID 0)
-- Dependencies: 178
-- Name: vegetable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ere
--

SELECT pg_catalog.setval('vegetable_id_seq', 1, false);


--
-- TOC entry 1915 (class 2606 OID 16693)
-- Name: billheader_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_code_key UNIQUE (code);


--
-- TOC entry 1918 (class 2606 OID 16691)
-- Name: billheader_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_pkey PRIMARY KEY (id);


--
-- TOC entry 1898 (class 2606 OID 16579)
-- Name: customer_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_code_key UNIQUE (code);


--
-- TOC entry 1900 (class 2606 OID 16562)
-- Name: customer_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- TOC entry 1894 (class 2606 OID 16589)
-- Name: farm_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY farm
    ADD CONSTRAINT farm_code_key UNIQUE (code);


--
-- TOC entry 1896 (class 2606 OID 16552)
-- Name: farm_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY farm
    ADD CONSTRAINT farm_pkey PRIMARY KEY (id);


--
-- TOC entry 1921 (class 2606 OID 16727)
-- Name: product_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_code_key UNIQUE (code);


--
-- TOC entry 1923 (class 2606 OID 16725)
-- Name: product_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- TOC entry 1913 (class 2606 OID 16631)
-- Name: saledetail_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY saledetail
    ADD CONSTRAINT saledetail_pkey PRIMARY KEY (id);


--
-- TOC entry 1906 (class 2606 OID 16614)
-- Name: saleheader_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY saleheader
    ADD CONSTRAINT saleheader_code_key UNIQUE (code);


--
-- TOC entry 1909 (class 2606 OID 16612)
-- Name: saleheader_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY saleheader
    ADD CONSTRAINT saleheader_pkey PRIMARY KEY (id);


--
-- TOC entry 1886 (class 2606 OID 16519)
-- Name: user_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 1888 (class 2606 OID 16521)
-- Name: user_username_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- TOC entry 1890 (class 2606 OID 16531)
-- Name: userrole_id_user_role_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_id_user_role_key UNIQUE (id_user, role);


--
-- TOC entry 1892 (class 2606 OID 16529)
-- Name: userrole_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_pkey PRIMARY KEY (id);


--
-- TOC entry 1902 (class 2606 OID 16599)
-- Name: vegetable_code_key; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY vegetable
    ADD CONSTRAINT vegetable_code_key UNIQUE (code);


--
-- TOC entry 1904 (class 2606 OID 16575)
-- Name: vegetable_pkey; Type: CONSTRAINT; Schema: public; Owner: ere; Tablespace: 
--

ALTER TABLE ONLY vegetable
    ADD CONSTRAINT vegetable_pkey PRIMARY KEY (id);


--
-- TOC entry 1916 (class 1259 OID 16716)
-- Name: billheader_date_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX billheader_date_idx ON billheader USING btree (date);


--
-- TOC entry 1919 (class 1259 OID 16717)
-- Name: billheader_tstmp_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX billheader_tstmp_idx ON billheader USING btree (tstmp);


--
-- TOC entry 1907 (class 1259 OID 16620)
-- Name: saleheader_date_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX saleheader_date_idx ON saleheader USING btree (date);


--
-- TOC entry 1910 (class 1259 OID 16623)
-- Name: saleheader_registration_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX saleheader_registration_idx ON saleheader USING btree (registration);


--
-- TOC entry 1911 (class 1259 OID 16622)
-- Name: saleheader_tstmp_idx; Type: INDEX; Schema: public; Owner: ere; Tablespace: 
--

CREATE INDEX saleheader_tstmp_idx ON saleheader USING btree (tstmp);


--
-- TOC entry 1932 (class 2606 OID 16711)
-- Name: billheader_id_creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_id_creator_fkey FOREIGN KEY (id_creator) REFERENCES "user"(id) ON DELETE RESTRICT;


--
-- TOC entry 1931 (class 2606 OID 16706)
-- Name: billheader_id_debtor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY billheader
    ADD CONSTRAINT billheader_id_debtor_fkey FOREIGN KEY (id_debtor) REFERENCES farm(id) ON DELETE RESTRICT;


--
-- TOC entry 1929 (class 2606 OID 16642)
-- Name: saledetail_id_farm_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY saledetail
    ADD CONSTRAINT saledetail_id_farm_fkey FOREIGN KEY (id_farm) REFERENCES farm(id) ON DELETE RESTRICT;


--
-- TOC entry 1930 (class 2606 OID 16647)
-- Name: saledetail_id_saleheader_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY saledetail
    ADD CONSTRAINT saledetail_id_saleheader_fkey FOREIGN KEY (id_saleheader) REFERENCES saleheader(id) ON DELETE CASCADE;


--
-- TOC entry 1928 (class 2606 OID 16637)
-- Name: saledetail_id_vegetable_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY saledetail
    ADD CONSTRAINT saledetail_id_vegetable_fkey FOREIGN KEY (id_vegetable) REFERENCES vegetable(id) ON DELETE RESTRICT;


--
-- TOC entry 1925 (class 2606 OID 16659)
-- Name: saleheader_id_creator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY saleheader
    ADD CONSTRAINT saleheader_id_creator_fkey FOREIGN KEY (id_creator) REFERENCES "user"(id) ON DELETE RESTRICT;


--
-- TOC entry 1926 (class 2606 OID 16664)
-- Name: saleheader_id_customer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY saleheader
    ADD CONSTRAINT saleheader_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES customer(id) ON DELETE RESTRICT;


--
-- TOC entry 1927 (class 2606 OID 16679)
-- Name: saleheader_id_instead_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY saleheader
    ADD CONSTRAINT saleheader_id_instead_fkey FOREIGN KEY (id_instead) REFERENCES saleheader(id) ON DELETE SET NULL;


--
-- TOC entry 1924 (class 2606 OID 16537)
-- Name: userrole_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ere
--

ALTER TABLE ONLY userrole
    ADD CONSTRAINT userrole_id_user_fkey FOREIGN KEY (id_user) REFERENCES "user"(id) ON DELETE CASCADE;


--
-- TOC entry 2064 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-01-09 17:11:12

--
-- PostgreSQL database dump complete
--

