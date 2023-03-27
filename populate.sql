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
    -- Parametros que controlam numero de rows a serem inseridas nas tabelas
    rows_categorias int := 50;
    rows_produtos int := 100;
    rows_produtos_repetidos int := 5;
    rows_pedidos int := 100;
begin
    -- Inserindo categorias
    for r in 1..rows_categorias loop
    insert into Categorias(nome_categoria)
    values(
        'Categoria'||r
    );
    end loop;

    -- Inserindo produtos
    for r in 1..rows_produtos loop
    insert into Produtos(nome_produto, id_categoria, descricao,preco)
    values(
        'Produto'||r,
        random_between(1, rows_categorias),
        substr(md5(random()::text), 1, 25),
        random_between(1, 100)
    );
    end loop;

    -- Inserindo produtos repetidos
    for r in 1..rows_produtos_repetidos loop
    insert into Produtos(nome_produto, id_categoria, descricao,preco)
    values(
        'ProdutoRepetido',
        random_between(1, rows_categorias),
        substr(md5(random()::text), 1, 25),
        random_between(1, 100)
    );
    end loop;

    -- Inserindo pedidos
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
end $$;