# Node and Chrome headless Docker image

This docker image is based on Debian and includes Node and Chrome. It is intended to be used to test Angular applications using Karma in a CI that uses Docker Compose.

# Build

Define what Debian version and Node version to use and then build the image. Check available combinations in DockerHub. For example, to look for combinations for Debian Bullseye go to https://hub.docker.com/_/node/tags?page=&page_size=&ordering=&name=bullseye.

Example using Debian Bullseye and Node 22.


```
export NODE_VERSION=22.7
export OS_VERSION=bullseye

docker build . --build-arg NODE_VERSION=$NODE_VERSION --build-arg OS_VERSION=$OS_VERSION --tag node:node$NODE_VERSION-$OS_VERSION
```

Node releases can be checked here: https://nodejs.org/en/about/previous-releases.


# Testing Angular applications

The following instructions asumes that you are using Docker Compose to run your tests.

First, integrate the image using `docker compose`. Add something like this in your `compose.yml` file (this usally is in the root folder of your project):

```
services:
  node:
    image: metadrop/node-chrome:bullseye-node.22.7
    container_name: "node"
    entrypoint: []
    command: tail -f /dev/null
    user: node
    working_dir: /usr/src/app
    volumes:
      - .:/usr/src/app
```


Then, add a custom browser for Karma using the `karma.conf.js file`. This is required to run Chrome with the `--no-sandbox` flag.

If the file does not exist Angular is generating it on the fly when running tests. Run the following command to force Angular to generate a configuration file in the root folder:

```
npx ng generate config karma
```

Once you have located or generated the Karma configuration file make sure the following lines are present:

```
browsers: ['Chrome'],
customLaunchers: {
  ChromeHeadlessCI: {
    base: 'ChromeHeadless',
    flags: ['--no-sandbox']
  }
},
```

The `browser` section is probably already present in the Karma configuration file.

Also, install the Junit reporter so CI can read the tests results easily:

```
npm install karma-junit-reporter
```

And add `junit` as a reproter. For exampñe:

```
reporters: ['progress', 'kjhtml', 'junit'],
```

Finally, add a new script in the `package.json` to launch tests using the Headless Chrome:

```
"scripts": {
  "test-headless": "ng test --watch=false --browsers=ChromeHeadlessCI",
}
```



## Runnig the tests

Bring the containers up and run tests:

```
docker compose up -d


