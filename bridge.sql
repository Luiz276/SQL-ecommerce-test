-- Criando as tabelas ----------
CREATE TABLE Categorias(
    id_categoria serial PRIMARY KEY,
    nome_categoria VARCHAR(50) unique not null
    -- n_produtos INTEGER DEFAULT 0
);

CREATE TABLE Produtos(
    id_produto SERIAL PRIMARY KEY,
    nome_produto VARCHAR(50) not null,
    id_categoria INT NOT NULL,
    descricao VARCHAR(500),
    quantidade_vendida INT DEFAULT 0,
    preco NUMERIC(10,2) not null,
    FOREIGN KEY (id_categoria)
      REFERENCES Categorias (id_categoria)
);

CREATE TABLE Pedidos(
    id_pedido SERIAL PRIMARY KEY,
    data_pedido DATE not null,
    cliente VARCHAR(50) not null,
    id_produto INT NOT NULL,
    quantidade NUMERIC(10,2) not null,
    endereco VARCHAR(50) not null,
    valor_total NUMERIC(10,2),
    FOREIGN KEY (id_produto)
      REFERENCES Produtos (id_produto)
);

-- Funcoes e triggers ----------

-- Calcula valor total e update em quantidade vendida em produtos
CREATE OR REPLACE FUNCTION functionSetOrderPrice()
RETURNS trigger AS 
$$
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
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION functionUpdateOrderPrice()
RETURNS trigger AS 
$$
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
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION functionDeleteOrderPrice()
RETURNS trigger AS 
$$
DECLARE
  id_prod int;
BEGIN
  --update quantidade vendida
  id_prod := OLD.id_produto;
  UPDATE Produtos SET quantidade_vendida= quantidade_vendida-OLD.quantidade
  WHERE id_produto=id_prod;

  return NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para valor total e update em quantidade vendida em produtos
CREATE TRIGGER insertOrder
BEFORE INSERT ON Pedidos
FOR EACH ROW
EXECUTE FUNCTION functionSetOrderPrice();

CREATE TRIGGER updateOrder
BEFORE UPDATE ON Pedidos
FOR EACH ROW
EXECUTE FUNCTION functionUpdateOrderPrice();

CREATE TRIGGER deleteOrder
AFTER DELETE ON Pedidos
FOR EACH ROW
EXECUTE FUNCTION functionDeleteOrderPrice();

-- Inserindo dados nas tabelas ----------

INSERT INTO
    Categorias(nome_categoria)
VALUES
    ('comida'),
    ('casa'),
    ('banho'),
    ('carro');

INSERT INTO
    Produtos(nome_produto, id_categoria, descricao,preco)
VALUES
    ('agua', 1, 'H2O', 1.5),
    ('suco', 1, 'Suco de sabores sortidos', 3),
    ('cafe', 1, 'Po de cafe', 5),
    ('sabonete', 3, 'Sabonete para banho', 10),
    ('cafe', 1, 'Cafe em po', 7),
    ('prato', 2, 'Prato de cerâmica', 25);

INSERT INTO
    Pedidos(data_pedido, cliente, id_produto, quantidade, endereco)
VALUES
    ('2023-03-25', 'Luiz', 1, 3, 'UFSC'),
    ('2021-03-25', 'Luiz', 3, 10, 'UFSC-HU'),
    ('2022-03-25', 'Joao', 2, 5, 'São Paulo'),
    ('2021-04-01', 'Joao', 2, 5, 'São Paulo'),
    ('2021-03-20', 'Joao', 2, 5, 'São Paulo'),
    ('2020-01-01', 'Alberto', 4, 1, 'Rio de Janeiro');

UPDATE pedidos set quantidade=2 where id_pedido=6;
DELETE FROM pedidos where id_pedido=6;

-- Queries nas tabelas ----------

-- Listar todos os produtos em ordem alfabetica crescente
SELECT nome_produto,
    descricao,
    preco
  FROM Produtos ORDER BY nome_produto ASC;

-- listar todas as categorias com nome e número de produtos associados
-- em ordem alfabetica crescente
SELECT nome_categoria,
    (SELECT COUNT(*) FROM Produtos WHERE Categorias.id_categoria = Produtos.id_categoria) as "produtos na categoria"
  FROM Categorias ORDER BY nome_categoria ASC;

-- listar todos os pedidos com data, endereco de entrega e valor total
-- em ordem decrescente de data
SELECT data_pedido,
    endereco,
    valor_total
  FROM Pedidos ORDER BY data_pedido DESC;

-- Listar todos os produtos que já foram vendidos em pelo menos um pedido,
-- com nome, descrição, preço e quantidade total vendida, em ordem
-- decrescente de quantidade total vendida;
SELECT nome_produto,
    descricao,
    preco,
    quantidade_vendida
  FROM Produtos WHERE quantidade_vendida>0 ORDER BY quantidade_vendida DESC;

-- Listar todos os pedidos feitos por um determinado cliente, filtrando-os
-- por um determinado período, em ordem alfabética crescente do nome do
-- cliente e ordem crescente da data do pedido;
SELECT cliente,
    data_pedido,
    nome_produto AS produto,
    quantidade,
    endereco,
    valor_total
  FROM Pedidos INNER JOIN Produtos ON Pedidos.id_produto=Produtos.id_produto
  WHERE data_pedido>='2020-01-01' and data_pedido<='2021-12-31'
  ORDER BY cliente ASC,
    data_pedido ASC;

-- Listar possíveis produtos com nome replicado e a quantidade de
-- replicações, em ordem decrescente de quantidade de replicações;
SELECT 
    nome_produto,
    COUNT(*) AS "Replicações"
  FROM Produtos
  GROUP BY
    nome_produto
  HAVING COUNT(*) > 1
  ORDER BY Count(*) DESC;

-- APAGAR=-------------------------------------------------

drop trigger insertOrder on pedidos;

drop function functionSetOrderPrice();

drop table pedidos;
drop table produtos;
drop table categorias;