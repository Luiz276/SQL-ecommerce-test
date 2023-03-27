--
-- PostgreSQL database dump
--

-- Dumped from database version 13.9 (Debian 13.9-0+deb11u1)
-- Dumped by pg_dump version 13.9 (Debian 13.9-0+deb11u1)

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
-- Name: functiondeleteorderprice(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.functiondeleteorderprice() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  id_prod int;
BEGIN
  --update quantidade vendida
  id_prod := OLD.id_produto;
  UPDATE Produtos SET quantidade_vendida= quantidade_vendida-OLD.quantidade
  WHERE id_produto=id_prod;

  return NEW;
END;
$$;


ALTER FUNCTION public.functiondeleteorderprice() OWNER TO postgres;

--
-- Name: functionsetorderprice(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.functionsetorderprice() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  produto_price numeric(10,2);
  order_price numeric(10,2);
  id_prod int;
BEGIN
  -- Getting the particular part's price
  produto_price := (SELECT preco FROM Produtos WHERE Produtos.id_produto=NEW.id_produto);
  -- Multiplying the price with the quantity to get order total price
  order_price := produto_price * NEW.quantidade;
  -- Let's set the Orders.price to the correct value!
  NEW.valor_total = order_price;

  --update quantidade vendida
  id_prod := NEW.id_produto;
  UPDATE Produtos SET quantidade_vendida= quantidade_vendida+NEW.quantidade
  WHERE id_produto=id_prod;

  return NEW;
END;
$$;


ALTER FUNCTION public.functionsetorderprice() OWNER TO postgres;

--
-- Name: functionupdateorderprice(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.functionupdateorderprice() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  produto_price numeric(10,2);
  order_price numeric(10,2);
  id_prod int;
BEGIN
  -- Getting the particular part's price
  produto_price := (SELECT preco FROM Produtos WHERE Produtos.id_produto=NEW.id_produto);
  -- Multiplying the price with the quantity to get order total price
  order_price := produto_price * NEW.quantidade;
  -- Let's set the Orders.price to the correct value!
  NEW.valor_total = order_price;

  --update quantidade vendida
  id_prod := NEW.id_produto;
  UPDATE Produtos SET quantidade_vendida= quantidade_vendida-OLD.quantidade+NEW.quantidade
  WHERE id_produto=id_prod;

  return NEW;
END;
$$;


ALTER FUNCTION public.functionupdateorderprice() OWNER TO postgres;

--
-- Name: random_between(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.random_between(low integer, high integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
   RETURN floor(random()* (high-low + 1) + low);
END;
$$;


ALTER FUNCTION public.random_between(low integer, high integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categorias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categorias (
    id_categoria integer NOT NULL,
    nome_categoria character varying(50) NOT NULL
);


ALTER TABLE public.categorias OWNER TO postgres;

--
-- Name: categorias_id_categoria_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categorias_id_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categorias_id_categoria_seq OWNER TO postgres;

--
-- Name: categorias_id_categoria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categorias_id_categoria_seq OWNED BY public.categorias.id_categoria;


--
-- Name: pedidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedidos (
    id_pedido integer NOT NULL,
    data_pedido date NOT NULL,
    cliente character varying(50) NOT NULL,
    id_produto integer NOT NULL,
    quantidade numeric(10,2) NOT NULL,
    endereco character varying(50) NOT NULL,
    valor_total numeric(10,2)
);


ALTER TABLE public.pedidos OWNER TO postgres;

--
-- Name: pedidos_id_pedido_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedidos_id_pedido_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pedidos_id_pedido_seq OWNER TO postgres;

--
-- Name: pedidos_id_pedido_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedidos_id_pedido_seq OWNED BY public.pedidos.id_pedido;


--
-- Name: produtos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produtos (
    id_produto integer NOT NULL,
    nome_produto character varying(50) NOT NULL,
    id_categoria integer NOT NULL,
    descricao character varying(500),
    quantidade_vendida integer DEFAULT 0,
    preco numeric(10,2) NOT NULL
);


ALTER TABLE public.produtos OWNER TO postgres;

--
-- Name: produtos_id_produto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produtos_id_produto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.produtos_id_produto_seq OWNER TO postgres;

--
-- Name: produtos_id_produto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produtos_id_produto_seq OWNED BY public.produtos.id_produto;


--
-- Name: categorias id_categoria; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias ALTER COLUMN id_categoria SET DEFAULT nextval('public.categorias_id_categoria_seq'::regclass);


--
-- Name: pedidos id_pedido; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos ALTER COLUMN id_pedido SET DEFAULT nextval('public.pedidos_id_pedido_seq'::regclass);


--
-- Name: produtos id_produto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos ALTER COLUMN id_produto SET DEFAULT nextval('public.produtos_id_produto_seq'::regclass);


--
-- Data for Name: categorias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categorias (id_categoria, nome_categoria) FROM stdin;
1	Categoria1
2	Categoria2
3	Categoria3
4	Categoria4
5	Categoria5
6	Categoria6
7	Categoria7
8	Categoria8
9	Categoria9
10	Categoria10
11	Categoria11
12	Categoria12
13	Categoria13
14	Categoria14
15	Categoria15
16	Categoria16
17	Categoria17
18	Categoria18
19	Categoria19
20	Categoria20
21	Categoria21
22	Categoria22
23	Categoria23
24	Categoria24
25	Categoria25
26	Categoria26
27	Categoria27
28	Categoria28
29	Categoria29
30	Categoria30
31	Categoria31
32	Categoria32
33	Categoria33
34	Categoria34
35	Categoria35
36	Categoria36
37	Categoria37
38	Categoria38
39	Categoria39
40	Categoria40
41	Categoria41
42	Categoria42
43	Categoria43
44	Categoria44
45	Categoria45
46	Categoria46
47	Categoria47
48	Categoria48
49	Categoria49
50	Categoria50
\.


--
-- Data for Name: pedidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedidos (id_pedido, data_pedido, cliente, id_produto, quantidade, endereco, valor_total) FROM stdin;
1	2022-01-02	6ba	55	67.00	c2d92fa17632eed7397f	268.00
2	2023-12-27	789	16	50.00	66a1f5cb9e621872e3a6	3400.00
3	2023-11-05	ec6	63	38.00	301883bbe57a754bc694	76.00
4	2020-08-04	746	32	88.00	0def3fff4d0ebf7841e5	1936.00
5	2021-05-01	648	19	30.00	f99990b4d2b47ae90c32	1380.00
6	2020-03-04	7d1	100	83.00	6f164a77a5a3c38ac176	1743.00
7	2020-09-08	345	18	27.00	377016d139b7911403e9	54.00
8	2021-03-15	ee1	65	73.00	98342699f48321ee84ca	5256.00
9	2023-02-25	f29	2	28.00	992d54932fda4f8c7bf1	2464.00
10	2023-11-28	dba	2	26.00	22f146dae8af2a6bf944	2288.00
11	2022-02-05	a3a	87	64.00	c9d673e27d49f06f53c6	1664.00
12	2020-05-02	19d	59	35.00	3f878aeb3a16e806b82a	875.00
13	2021-05-21	7a2	57	39.00	b3920820a3cba0091e59	351.00
14	2023-01-08	bb0	18	81.00	9ac9c17c41cc828780bc	162.00
15	2021-05-04	62d	74	60.00	2a2e1a597d13cc932409	2100.00
16	2022-02-23	b80	67	47.00	67b28427541d4dfedc4a	2209.00
17	2022-12-06	ca3	64	95.00	4fd869fbe7429647734e	8930.00
18	2021-08-30	32c	74	51.00	d8cb62947fe804d266da	1785.00
19	2023-07-24	997	11	7.00	e4e9eb94d99a4a59526a	308.00
20	2021-09-03	e70	25	67.00	6a76c48a4114b8da1518	1943.00
21	2023-10-22	622	94	11.00	4d12b78b1bda2f747c7d	385.00
22	2020-01-20	cf9	61	22.00	2f25469811589dda4f98	1782.00
23	2023-02-08	4d5	84	24.00	3186c5832fcc38aff0cd	336.00
24	2020-07-04	09b	16	23.00	d1e0f2e99f2c89ab32ce	1564.00
25	2023-02-23	369	80	64.00	b520773d7ecc184f137d	5568.00
26	2020-03-20	4f5	37	85.00	15519724c6638fba233d	935.00
27	2023-07-21	1bf	45	37.00	220927f915c1955ac733	185.00
28	2021-06-07	184	10	74.00	c6ab524b45584bf2d8d9	4144.00
29	2020-05-20	5c3	66	22.00	519276fe4681f51f64e3	2002.00
30	2020-12-02	78d	58	25.00	6a93281f4c2ff251e928	1200.00
31	2021-07-30	c53	12	52.00	9654040c12c75375530b	4524.00
32	2021-06-15	2bc	29	96.00	bc736c944d2932073395	8736.00
33	2020-09-22	b43	4	15.00	0dc80b83731e232fe217	495.00
34	2020-12-25	04f	41	75.00	210cac66d838afa17e0b	3375.00
35	2023-03-02	9f9	10	62.00	86eb76e8bab046418d11	3472.00
36	2021-06-15	4f6	69	10.00	4fec6ff2169804a14a56	390.00
37	2020-06-05	f79	41	99.00	469630626f9e09de8a3e	4455.00
38	2021-01-10	8ab	99	17.00	f0402019712a46601009	1377.00
39	2023-08-10	3f5	16	84.00	a5ce9dc359a067d528db	5712.00
40	2020-10-12	023	53	13.00	cc73972051a663cb539b	1300.00
41	2023-02-06	280	94	77.00	5bad28ab06c08b95dd46	2695.00
42	2020-11-02	b55	32	84.00	31dfb6842258010152ce	1848.00
43	2021-10-13	79f	13	82.00	0a6fbd314bba8c860272	7462.00
44	2020-06-23	23d	75	91.00	4c0cbef7568108ff5a2f	7280.00
45	2024-01-18	806	52	86.00	c1a99ca6cb998c6b09bd	8428.00
46	2021-07-31	a85	61	66.00	6f4141ff992f385f0df7	5346.00
47	2020-03-04	1ca	14	23.00	af7eef0e33ba6b484846	1311.00
48	2021-08-24	10c	97	33.00	3217df579d28348e0f0a	1386.00
49	2022-07-09	7b6	86	45.00	ee425723c7cd95ccf86b	1395.00
50	2023-09-01	4f6	27	2.00	aebbadc3fb610594e4c0	194.00
51	2023-07-16	5c8	19	32.00	d1cd99c5d29562ba5eb1	1472.00
52	2021-10-02	824	62	49.00	20a2cdb7cf6c0c0e46ac	1862.00
53	2021-01-24	2a6	57	4.00	9116826a7ecabfbb9191	36.00
54	2023-03-27	1a4	46	53.00	725eae85eab646a4ca52	5088.00
55	2023-03-03	65f	90	63.00	236064c74a54fc9f407b	819.00
56	2022-04-03	c30	93	20.00	305d480a16dcc7e4f434	1600.00
57	2020-10-16	d09	95	92.00	82a6eba19100d04667c7	9108.00
58	2021-01-28	fda	91	40.00	ccc5e82104f5d517d074	1240.00
59	2020-11-28	60b	84	1.00	37d47835765f5e7480e7	14.00
60	2023-03-12	e47	83	43.00	4ef751674fff796f6143	1032.00
61	2021-04-26	4e0	55	83.00	61eaedcf9c812d10f684	332.00
62	2023-03-21	926	81	100.00	1cf62bc4ae08634aa02c	7400.00
63	2022-07-11	2ac	50	25.00	b67e3fbb1764030e8625	925.00
64	2022-12-28	137	76	14.00	737076a393084c8267f8	938.00
65	2021-12-14	019	84	8.00	9c2a5dfeea575540e360	112.00
66	2023-07-28	428	9	47.00	a654e7086ec24c893212	1363.00
67	2021-05-15	7bd	58	22.00	38efc331d1d6304ccf95	1056.00
68	2023-09-01	33b	19	12.00	b9a72ed28afb72bc1603	552.00
69	2023-12-30	cd1	59	70.00	bbbf89271669515b1286	1750.00
70	2022-07-30	f41	29	69.00	806452961b2a277ed969	6279.00
71	2022-07-21	c42	36	84.00	26d5cc44a1c3fce53331	5796.00
72	2020-12-06	591	27	10.00	4d4dd68c32749c1a1a3c	970.00
73	2021-01-29	8ea	28	68.00	d65b2906bc60e93572f7	2176.00
74	2022-04-02	919	67	73.00	239b9183ec1c8facdf54	3431.00
75	2020-11-22	0d4	96	92.00	868ee09431b512795bd5	8188.00
76	2020-06-08	10e	67	22.00	ae8fab04faa5f0d62fa2	1034.00
77	2022-08-09	7f4	20	54.00	f83b56f1d4d4ace71795	2376.00
78	2021-01-22	0c7	73	65.00	f66e609192a7f0f00f58	4225.00
79	2023-06-11	b67	69	41.00	a0cdfee81c20443d5e2d	1599.00
80	2022-05-18	124	92	93.00	980a748c9a5009906434	5766.00
81	2022-05-05	a80	77	83.00	9bfeb60a9f1b067c9377	2656.00
82	2020-08-06	15a	53	51.00	528106bd3f3fd32d4c97	5100.00
83	2021-06-05	6af	24	45.00	9c32e7388e07ec08728f	4185.00
84	2022-05-28	977	95	95.00	8e9969c32d2cd7200532	9405.00
85	2021-10-07	380	41	48.00	8b93ba6ff0858bbdf842	2160.00
86	2020-12-29	b20	12	87.00	b096d5667f367fa19ae4	7569.00
87	2022-02-14	9fb	5	97.00	1ae0f874eadea1f5d553	9700.00
88	2022-09-28	70e	53	71.00	a17c73220562afe93aea	7100.00
89	2022-12-21	5f6	37	31.00	01109d186be719337608	341.00
90	2022-07-02	cd6	16	11.00	48c892712e209cbf9c5e	748.00
91	2023-07-19	d90	96	4.00	0247016b023c81a34b09	356.00
92	2023-11-10	21d	88	61.00	aaab2c581047d94ae6b1	2318.00
93	2023-09-24	145	54	83.00	2e6098fd174138923cea	5976.00
94	2021-05-17	bd8	100	97.00	4176b9a985fa3b8181aa	2037.00
95	2023-06-29	28d	55	72.00	304428e235cce80e0c43	288.00
96	2022-07-26	96f	48	6.00	e41da7104df7f61c0c22	180.00
97	2022-01-30	286	73	14.00	74ba5ec21ed9cca56088	910.00
98	2020-10-15	ee1	70	82.00	e1f2ae24eb3844283bcd	6232.00
99	2020-06-10	11a	26	8.00	46b210d447ca0518329d	624.00
100	2022-09-02	2b7	66	55.00	6f278010fad72194cbed	5005.00
\.


--
-- Data for Name: produtos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produtos (id_produto, nome_produto, id_categoria, descricao, quantidade_vendida, preco) FROM stdin;
1	Produto1	17	0ea73a6b43bd2120eb8ab2698	0	55.00
3	Produto3	24	d7acb62bd09416a6eeb1a510f	0	75.00
6	Produto6	9	00f4bc9e24ed486ce66e9a270	0	74.00
7	Produto7	20	8e1bc6b0f8592678b5c8f72ff	0	29.00
8	Produto8	50	f93893a820cdaee49d169d8da	0	31.00
15	Produto15	21	876aa33145894b05bb3dc9fc2	0	30.00
17	Produto17	29	8f65b6c0bfbb97273c7a28f8d	0	70.00
21	Produto21	26	c76f26befc07c7ececb2ff13a	0	84.00
22	Produto22	43	6915ecaa49dd24c12fbea2787	0	48.00
23	Produto23	40	6bf4f39948ec99e6c1a129704	0	24.00
30	Produto30	30	5294eaddab2110d4dd950ebdf	0	18.00
31	Produto31	41	af5681a19d3455ea963f95c49	0	13.00
33	Produto33	20	ea6d67a0345d58809c0033b62	0	6.00
34	Produto34	38	a928c913d99de92faeb6ab1c3	0	25.00
35	Produto35	41	9cf838fff67b6c1c06ec78564	0	53.00
38	Produto38	39	35f13f08b2cd5ddc504cbca11	0	1.00
39	Produto39	50	54177714600a307300963947f	0	20.00
40	Produto40	50	1cec7b6b1260d74e03d9d320e	0	24.00
42	Produto42	40	03d7ff4105a57cff1fa83846c	0	79.00
43	Produto43	36	65878d70d39557feb6588d30b	0	82.00
44	Produto44	27	6293039d32266b3ff22922b94	0	78.00
47	Produto47	27	77a18322346ff30ce263ddcc8	0	100.00
49	Produto49	6	55748961e9e9fb6a80c86d539	0	47.00
51	Produto51	50	0fb42ea3652021efcf90daba8	0	41.00
56	Produto56	7	3b52cd1bb1a4e32fc2be92fb8	0	49.00
60	Produto60	41	6fb3ca03173f0672adbe00694	0	51.00
68	Produto68	38	481f0cdd97daf76263afd81ba	0	68.00
71	Produto71	32	50c81426053bf54ed7f1f2ad0	0	98.00
72	Produto72	41	a0d8ec5627a5793587ae520a1	0	83.00
78	Produto78	32	1139719813a5011b2ab2ba421	0	91.00
79	Produto79	37	271d091b389941e22f47d5f3c	0	49.00
82	Produto82	13	b2f4e13b7422d7869a15402d0	0	87.00
85	Produto85	33	3b901d4aedffcd5785cd931e1	0	84.00
89	Produto89	6	e955fa80b8461a85e17623e57	0	31.00
98	Produto98	14	c531c7b962d7605040d7b3294	0	9.00
101	ProdutoRepetido	9	5593fe258a8121271df375e81	0	99.00
102	ProdutoRepetido	1	08f2e04b5054ab10f18a76d85	0	85.00
103	ProdutoRepetido	34	70ea506262c198989d87e4e49	0	47.00
104	ProdutoRepetido	29	e112c044584f73f65ded11594	0	81.00
105	ProdutoRepetido	23	6eae4437304108b9208867b11	0	83.00
63	Produto63	4	cb7cfb5171227679c4992d0c0	38	2.00
65	Produto65	1	24d5becc55babc7919d32499c	73	72.00
2	Produto2	12	c64c69ee8ddc816e462a930ab	54	88.00
87	Produto87	14	b18536c21027a1f9f2a5351a6	64	26.00
18	Produto18	40	ff103cca7307cfe6d228e8d75	108	2.00
64	Produto64	46	b63104f520c6276c0afedb8b9	95	94.00
74	Produto74	49	1ae7dd1da662788a540042e55	111	35.00
11	Produto11	38	2360c6fc6f8b2b9b8437d5541	7	44.00
25	Produto25	28	6713df599d952e5d67cae26c9	67	29.00
80	Produto80	32	0eca0e9300392866e52a9aec2	64	87.00
45	Produto45	36	5f355ed0f3a55552c1563892c	37	5.00
4	Produto4	47	1aef4865b61227977c37409a5	15	33.00
10	Produto10	3	240849eba64ef8433d74c7ca0	136	56.00
99	Produto99	44	2cac777a85de12451e8eac7ef	17	81.00
94	Produto94	25	32dfd1dec0621ae1da8f948fc	88	35.00
32	Produto32	37	26a31b86d39e0027a863be853	172	22.00
13	Produto13	27	3fec696176f4eed5f57494ec3	82	91.00
75	Produto75	45	e6e142ba0ff6b3f26d26234f5	91	80.00
52	Produto52	8	30c97ddafca9e90cb205e08c3	86	98.00
61	Produto61	38	e411f25b1480681f0f34d9858	88	81.00
14	Produto14	16	b116b2c35202e6cfbf57f8c68	23	57.00
97	Produto97	13	9677645a1bab6df3d05dd7efa	33	42.00
86	Produto86	47	674ce47f459207c46e78466a2	45	31.00
62	Produto62	48	a4787a708e807439b42192414	49	38.00
57	Produto57	22	64137eea45b584680a5293e19	43	9.00
46	Produto46	19	5ba0f8f8246d554814c457f22	53	96.00
90	Produto90	24	ceb039c722faa739f32e13db2	63	13.00
93	Produto93	12	c94d190da5be77198e94ae6a9	20	80.00
91	Produto91	20	aa32e4efbb4bb645c2aae21f8	40	31.00
83	Produto83	25	5379128a5029e563fea040735	43	24.00
81	Produto81	22	4aeb3f1c1d634fe45b6402f96	100	74.00
50	Produto50	40	38fb924f5ff3f56f9416639f0	25	37.00
76	Produto76	39	95be553fde0540ce2f4b0a264	14	67.00
84	Produto84	31	10d59be6f19acfa258529d19a	33	14.00
9	Produto9	17	895d6883d3ccef6c23d51a986	47	29.00
58	Produto58	24	c2fb7922b9d4c483db6d9a4a8	47	48.00
19	Produto19	26	15637cebf9967008fee87d580	74	46.00
59	Produto59	25	d6ce3f196a842c9a8fcf70434	105	25.00
29	Produto29	21	07d639a1265494d5058d8cdb9	165	91.00
36	Produto36	21	e801673af1bcf487cf569cc33	84	69.00
27	Produto27	34	0d9b6d68811053a5da5c6e028	12	97.00
28	Produto28	22	b9682631a9e1ba8af72066417	68	32.00
67	Produto67	40	1ec78a18b230301b414ed2e41	142	47.00
20	Produto20	35	950982cc6e0d257241e12a205	54	44.00
69	Produto69	23	e2504912d0f7ed8efe6f428d0	51	39.00
92	Produto92	41	9c1b3fd2b86187eac3704edca	93	62.00
77	Produto77	44	9a0ef0fcf1d35bf4a66c8e930	83	32.00
24	Produto24	11	959c10008d6f1c27744a07468	45	93.00
95	Produto95	9	79378e3d18a7d4f864b0f5deb	187	99.00
41	Produto41	17	58c9c9f30197b8954c1e599c9	222	45.00
12	Produto12	41	019f448968516e9a7963bfe38	139	87.00
5	Produto5	2	cf420db952af637c7470c5ba2	97	100.00
53	Produto53	38	bd62ad70f0307f036e83ba286	135	100.00
37	Produto37	36	b650a3b25bf91fa9c6273d16f	116	11.00
16	Produto16	1	50d1017c082f9df57feccee69	168	68.00
96	Produto96	18	5737cf68467144ca99c62c4c6	96	89.00
88	Produto88	49	fbc707259ea9fb90cdd9393ef	61	38.00
54	Produto54	45	6896eedc9a4a4fbf521c50010	83	72.00
100	Produto100	5	f0844e72b037af6f3718004d7	180	21.00
55	Produto55	29	8683a6daa4d5e6c03ca6debfa	222	4.00
48	Produto48	10	682193f48c609953ba0e95037	6	30.00
73	Produto73	12	ccadd479baf863bdc9d28a7dc	79	65.00
70	Produto70	27	44f11d4c28a099ecfdf977774	82	76.00
26	Produto26	19	0adb3c1b49a8b8d35dfb87b82	8	78.00
66	Produto66	9	c7164e08d9bd45e2e046f9ba6	77	91.00
\.


--
-- Name: categorias_id_categoria_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categorias_id_categoria_seq', 50, true);


--
-- Name: pedidos_id_pedido_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedidos_id_pedido_seq', 100, true);


--
-- Name: produtos_id_produto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produtos_id_produto_seq', 105, true);


--
-- Name: categorias categorias_nome_categoria_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_nome_categoria_key UNIQUE (nome_categoria);


--
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id_categoria);


--
-- Name: pedidos pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (id_pedido);


--
-- Name: produtos produtos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_pkey PRIMARY KEY (id_produto);


--
-- Name: pedidos deleteorder; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER deleteorder AFTER DELETE ON public.pedidos FOR EACH ROW EXECUTE FUNCTION public.functiondeleteorderprice();


--
-- Name: pedidos insertorder; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER insertorder BEFORE INSERT ON public.pedidos FOR EACH ROW EXECUTE FUNCTION public.functionsetorderprice();


--
-- Name: pedidos updateorder; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER updateorder BEFORE UPDATE ON public.pedidos FOR EACH ROW EXECUTE FUNCTION public.functionupdateorderprice();


--
-- Name: pedidos pedidos_id_produto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_id_produto_fkey FOREIGN KEY (id_produto) REFERENCES public.produtos(id_produto);


--
-- Name: produtos produtos_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categorias(id_categoria);


--
-- PostgreSQL database dump complete
--

