# Sample Golang project using private repo

This project uses a `helloworld` library hosted as private repo.

Note: If you are trying this out you will have to change the dependency to your own private repo.

# Goals
    * Have a development environment using docker
    * Build image which download dependency from a private github repo

Docker's buildkit provides `--mount=type=ssh` to mount host's ssh settings onto the intermediary
containers created while building the image. This allows downloading go dependencies from private
repos.

Also I have made use of other buildkit features to improve caching and speed of the build process.

# How to run

## Development environment
Building development environment image
`TAG=<tag> ENV=dev make build`

Edit `image` field in docker-compose.yaml
`image: helloworld:<tag>`
    
Spin up the dev container:
`docker-compose up -d`

Now you can `docker exec --user <your user> app bash` and run/build your app, etc.

Note: You have to edit `Dockerfile.dev` and add your user instead of `shinto`. I create
user `shinto` in the image so that there are no file permission conflicts 
in host and the container.

## Building image for deployment
Run
```
TAG=<tag> ENV=build make build

docker run -it --rm --name sample helloworld:<TAG>
```

# Demo
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/MZ0cwjbuhAA/0.jpg)](https://www.youtube.com/watch?v=MZ0cwjbuhAA)
