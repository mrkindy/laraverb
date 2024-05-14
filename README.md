## Laraverb
This repository provides a Dockerfile for creating a Docker image that runs a Laravel Reverb server. Reverb is a real-time communication framework built on Laravel Echo and Socket.IO.


## Prerequisites
- Docker installed and running on your system (https://docs.docker.com/engine/install/)

## Building the Docker Image

1. Clone this repository to your local machine:

 ```
git clone https://github.com/mrkindy/laraverb.git
```
2. Navigate to the project directory:

```
cd laraverb
```
3. Build the Docker image using the following command:

```
docker build -t laraverb .
```

This command creates an image named `laraverb` based on the Dockerfile in the current directory.

## Running the Laraverb Server

1. Start a container from the built image:
```
docker run -d --name laraverb-server laraverb
```
This command runs the image in detached mode (`-d`) and assigns the container the name `laraverb-server`.

2. (Optional) Access the container's logs:
```
docker logs laraverb-server
```
This will display the container's output, including any startup messages or errors.

## Environment Variables

The Dockerfile includes placeholder environment variables for common Laravel configurations. You can override these defaults when running the container add a path to your .env file in `compose.yml` like:
```
services:
  webapp:
    image: laraverb-server
    env_file:
      - .env
```

Or You can set default values for environment variables, in an environment file and then pass the file as an argument in the CLI like:

```
docker run --env-file ./env -d --name laraverb-server laraverb
```

You can find [.env.example](.env.example) for the default environment variables.

## Contributing

We welcome contributions to this project. Feel free to submit pull requests with improvements or bug fixes.

## Credits

- [Ibrahim Abotaleb](https://github.com/mrkindy)

## License

The MIT License (MIT). Please see [License File](LICENSE) for more information.
