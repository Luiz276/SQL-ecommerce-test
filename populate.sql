-- Script responsável por popular as tabelas com dados aleatórios

CREATE OR REPLACE FUNCTION random_between(low INT ,high INT) 
   RETURNS INT AS
$$
BEGIN
   RETURN floor(random()* (high-low + 1) + low);
END;
$$ LANGUAGE plpgsql;

do $$ 
declare
    rows_categorias int := 50;
    rows_produtos int := 100;
    rows_pedidos int := 100;
begin

    -- for r in 1..rows_categorias loop
    -- insert into Categorias(nome_categoria)
    -- values(
    --     'Categoria'||r
    -- );
    -- end loop;

    for r in 1..rows_produtos loop
    insert into Produtos(nome_produto, id_categoria, descricao,preco)
    values(
        'Produto'||r,
        random_between(1, rows_categorias),
        substr(md5(random()::text), 1, 25),
        random_between(1, 100)
    );
    end loop;

    for r in 1..rows_pedidos loop
    insert into Pedidos(data_pedido, cliente, id_produto, quantidade, endereco)
    values(
        DATE '2020-01-01' + (random() * 1500)::integer,
        substr(md5(random()::text), 1, 3),
        random_between(1, rows_produtos),
        random_between(1, 100),
        substr(md5(random()::text), 1, 20)
    );
    end loop;

    -- -- Criando categorias
    -- INSERT INTO Categorias (nome_categoria)
    -- SELECT 'categoria'||substr(md5(random()::text), 0, 15)
    -- FROM generate_series(1, rows_categorias);

    -- -- Criando Produtos
    -- INSERT INTO Produtos (nome_produto, id_categoria, descricao,preco)
    -- SELECT 'produto'||substr(md5(random()::text), 1, 10),
    --     random_between(1, rows_categorias),
    --     substr(md5(random()::text), 1, 25),
    --     random_between(1, 100)
    -- FROM generate_series(1, rows_produtos);

    -- -- Criando Pedidos
    -- INSERT INTO Pedidos(data_pedido, cliente, id_produto, quantidade, endereco)
    -- SELECT DATE '2018-01-01' + (random() * 700)::integer,
    --     substr(md5(random()::text), 1, 3),
    --     random_between(1, rows_produtos),
    --     random_between(1, 100),
    --     substr(md5(random()::text), 1, 20)
    -- FROM generate_series(1, rows_pedidos);
    

end $$;
SELECT * from categorias;