-- Criando as tabelas ----------
CREATE TABLE Categorias(
    id_categoria serial PRIMARY KEY,
    nome_categoria VARCHAR(50) unique not null,
    n_produtos INTEGER DEFAULT 0
);

CREATE TABLE Produtos(
    id_produto SERIAL PRIMARY KEY,
    nome_produto VARCHAR(50) unique not null,
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
  produto_price integer;
  order_price integer;
  id_prod int;
BEGIN
  -- Getting the particular part's price
  produto_price := (SELECT preco FROM Produtos WHERE Produtos.id_produto=NEW.id_produto);
  -- Multiplying the price with the quantity to get order total price
  order_price := produto_price * NEW.quantidade;
  -- Let's set the Orders.price to the correct value!
  NEW.valor_total = order_price;

  id_prod := NEW.id_produto;
  UPDATE Produtos SET quantidade_vendida= quantidade_vendida+NEW.quantidade
  WHERE id_produto=id_prod;

  return NEW;
END;
$$ LANGUAGE plpgsql;


-- Update o numero de produtos em cada categoria
CREATE OR REPLACE FUNCTION categoriaQuantidade()
RETURNS trigger AS
$$
DECLARE
    id_cat INT;
BEGIN
    -- descobrir a qual categoria o novo produto pertence
    id_cat := NEW.id_categoria;
    -- aumentar o contador na categoria
    UPDATE Categorias SET n_produtos= n_produtos+1
    WHERE id_categoria=id_cat;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para valor total e update em quantidade vendida em produtos
CREATE TRIGGER insertOrder
BEFORE INSERT OR UPDATE ON Pedidos
FOR EACH ROW
EXECUTE FUNCTION functionSetOrderPrice();

-- Trigger para n_produtos em categoria
CREATE TRIGGER novoProduto
AFTER INSERT ON Produtos
FOR EACH ROW
EXECUTE FUNCTION categoriaQuantidade();

-- Inserindo dados nas tabelas ----------

INSERT INTO
    Categorias(nome_categoria)
VALUES
    ('comida'),
    ('casa'),
    ('banho');

INSERT INTO
    Produtos(nome_produto, id_categoria, descricao,preco)
VALUES
    ('agua', 1, 'H2O', 1.5),
    ('suco', 1, 'Suco de sabores sortidos', 3),
    ('cafe', 1, 'Po de cafe', 5);

INSERT INTO
    Pedidos(data_pedido, cliente, id_produto, quantidade, endereco)
VALUES
    ('2023-03-25', 'Luiz', 1, 1, 'UFSC');

-- Queries nas tabelas ----------

-- Listar todos os produtos em ordem alfabetica crescente
SELECT nome_produto,
    descricao,
    preco
  FROM Produtos ORDER BY nome_produto ASC;

-- listar todas as categorias com nome e número de produtos associados
-- em ordem alfabetica crescente
SELECT nome_categoria,
    n_produtos
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


-- Listar todos os pedidos feitos por um determinado cliente, filtrando-os
-- por um determinado período, em ordem alfabética crescente do nome do
-- cliente e ordem crescente da data do pedido;


-- Listar possíveis produtos com nome replicado e a quantidade de
-- replicações, em ordem decrescente de quantidade de replicações;