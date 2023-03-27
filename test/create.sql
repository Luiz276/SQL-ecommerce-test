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