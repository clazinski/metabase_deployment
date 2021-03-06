# Metabase

## Build Image 
```bash
docker build -t metabase_img -f docker/dockerfile.dockerfile .
```

## Run Metabase
```bash
docker run -d -p 3000:3000 --name metabase metabase_img
```

## Docker Compose
```bash
docker-compose -f docker/docker-compose.yml up
```

- **Issues:** the directory of the volume binding has already been initialized after the first start, so the user (postgres) and the database creation only happen on the first start. The `/var/lib /postgresql/data` shouldn't contain any database files of data. 
- **Resolution:** add `PGDATA=/var/lib/postgresql/data` to the postgres environment and finally set the volumes (`'postgres:/var/lib/postgresql/data'`).

## Migrating H2 Docs To Postgres

Since the purpose of my project is to develop a new architecture for an existing server in Metabase, one of the steps in the process was to migrating data from H2 to Postgres (new architecture), so I will describe it below:

1. The first step was to move the H2 files (metabase.db) to a Metabase container folder.
(ps: to perform this procedure, all parts of the "environment" of the metabase - inside the docker compose - were removed, but after following these steps, update the docker-compose.yml file with the "environtments" passed again.)

2. Inside the Metabase container, run the following commands:

`export MB_DB_TYPE=postgres`<br>
`export MB_DB_DBNAME=<database_name>`<br>
`export MB_DB_PORT=5432`<br>
`export MB_DB_USER=<my_user>`<br>
`export MB_DB_PASS=<my_password>`<br>
`export MB_DB_HOST=postgres`<br>

right after, we go into the "app" folder (cd /app) and run this command:

`java -jar metabase.jar load-from-h2 /path/to/my/metabase.db/docs`

3. When running this last line, I got an error (something like "ERROR: duplicate key value"). If you had the same error, to be able to do the migration, try entering the postgres container (docker exec -it container-name-postgres sh) and log into the database:

`psql -U <my_user> -W <database_name>` #enter and pass the postgres password

after logging in, run this code:

`ALTER TABLE table_name DROP CONSTRAINT index_name;
DROP INDEX index_name;`

4. Finally, step 2 is repeated and the data was successfully migrated.

## From One Postgres To Another

Transferring data from postgres_1 database to another postgres (postgres_2), on different servers:
```bash
pg_dump -h host -p port -U user_postgres_1 -W password -d database_name_postgres_1 | psql -h host -p port -U user_postgres_2 database_name_postgres_2
```
- To create a new database on the transferring, just pass the -C flag after "pg_dump".
