CREATE TABLE testTable(
    a int,
    b int,
    c int
);

create function upd() RETURNS trigger as $upd$
BEGIN
    NEW.c := NEW.a+NEW.b;
    return NEW;
END;
$upd$ LANGUAGE plpgsql;

create trigger upd before insert or update on testTable
    for each row execute function upd();