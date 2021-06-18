# Metabase

## build image 
```bash
docker build -t metabase_img -f docker/dockerfile.dockerfile .
```

## run metabase
```bash
docker run -d -p 3000:3000 --name metabase metabase_img
```

## docker compose

```docker-compose -f docker/docker-compose.yml up```

- **Issues:** the directory of the volume binding has already been initialized after the first start, so the user (postgres) and the database creation only happen on the first start. The `/var/lib /postgresql/data` shouldn't contain any database files of data. 
