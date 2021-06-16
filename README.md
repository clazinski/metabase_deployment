# metabase_deployment

## build image 
```bash
docker build -t metabase_img -f docker/dockerfile.dockerfile .
```

## run metabase
```bash
docker run -d -p 3000:3000 --name metabase metabase_img
```