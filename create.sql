-- Criando as tabelas ----------
CREATE TABLE Categorias(
    id_categoria serial PRIMARY KEY,
    nome_categoria VARCHAR(50) unique not null,
    n_produtos INTEGER
);

CREATE TABLE Produtos(
    id_produto SERIAL PRIMARY KEY,
    nome_produto VARCHAR(50) unique not null,
    id_categoria INT NOT NULL,
    descricao VARCHAR(500),
    preco FLOAT(10) not null,
    FOREIGN KEY (id_categoria)
      REFERENCES Categorias (id_categoria)
);

CREATE TABLE Pedidos(
    id_pedido SERIAL PRIMARY KEY,
    data_pedido DATE not null,
    cliente VARCHAR(50) not null,
    id_produto INT NOT NULL,
    quantidade INT not null,
    endereco VARCHAR(50) not null,
    valor_total INT not null,
    FOREIGN KEY (id_produto)
      REFERENCES Produtos (id_produto)
);