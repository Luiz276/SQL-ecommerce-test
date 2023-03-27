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