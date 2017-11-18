# Dockerized Homebridge with Alexa support

[![Docker Build Status](https://img.shields.io/docker/build/lumoc/homebridge-docker-alexa.svg)](https://hub.docker.com/r/lumoc/homebridge-docker-alexa/)
[![Docker Pulls](https://img.shields.io/docker/pulls/lumoc/homebridge-docker-alexa.svg)](https://hub.docker.com/r/lumoc/homebridge-docker-alexa/)

[This Docker image](https://hub.docker.com/r/lumoc/homebridge-docker-alexa/) helps you to easily setup [Homebridge](https://github.com/nfarina/homebridge) on your Synology or other Docker Systems

## Installation (via Synology DSM)

### 1. Download Image

First of all, login to your Synology DSM, open Docker and download `lumoc/homebridge-docker-alexa` from within the registry.

![Registry Overview.](https://raw.githubusercontent.com/marcoraddatz/homebridge-docker/master/doc/docker-1.png)

### 2. Prepare your scripts

Create a folder via DSM File Station at `/volume1/docker/homebridge` and `/volume1/docker/homebridge-hue` and put your `config.json` and **either** your `package.json` or `install.sh` (recommended) in the `/volume1/docker/homebridge` folder. If you'd like to develop an own plugin or debug Homebridge, also copy the `.env` file. In the second `/volume1/docker/homebridge-hue` folder put the `config.json` without support for Alexa. So it is possible to have native Hue equipment, third party equipment on Hue Bridge and third party plattforms in one container and on HomeKit and Alexa

![File Station.](https://raw.githubusercontent.com/lumoc/homebridge-docker/master/doc/file-station-1.png)

Here are two examples of how your setup files may look like:

#### [package.json](samples/package.json)

```json
{
  "name": "DiskStationHomeBridge",
  "description": "HomeKit support for the impatient.",
  "version": "0.1.1",
  "license": "ISC",
  "dependencies": {
  }
}
```

#### [install.sh](samples/install.sh)

*Note that you can also use this file to install server dependencies!*

```shell
#!/bin/bash

npm install -gs homebridge-harmonyhub
npm install -gs homebridge-netatmo
npm install -gs homebridge-nukiio
npm install -gs homebridge-synology
```

Since version 2.1 all commands get executed as root, so this is a good place to install missing dependencies.

### 3. Start Container

Once the plugins have been set up, the Docker container is ready to launch.

![Launch container.](https://raw.githubusercontent.com/lumoc/homebridge-docker/master/doc/docker-2.png)

![Click 'Advanced Settings'.](https://raw.githubusercontent.com/lumoc/homebridge-docker/master/doc/docker-3.png)

![Link local configs.](https://raw.githubusercontent.com/lumoc/homebridge-docker/master/doc/docker-4.png)

Link the `/volume1/docker/homebridge` to `/root/.homebridge` and `/volume1/docker/homebridge-hue` to `/root/.homebridge-hue`, otherwise, the configuration files won’t be loaded (within DSM the path is only shown as `/docker/homebridge`.

![Use the same network as Docker host.](https://raw.githubusercontent.com/lumoc/homebridge-docker/master/doc/docker-5.png)

![Apply settings.](https://raw.githubusercontent.com/lumoc/homebridge-docker/master/doc/docker-6.png)

Once you launch (or restart) the container, Homebridge and all its dependencies will get installed. To verify that Homebridge is running or if an error occurs, you can use the container's log (Container → Details → Log) to receive further information on the process.

## Command line

There are many Docker commands that can be run via the `homebridge.sh` script. Please have a look [at the file](homebridge.sh), it should be self-explaining.

## Plugin development

If you intend to develop a plugin or Homebridge is not running as it's supposed to, you might want to start Homebridge with debugging options. To do so, copy the sample `.env` file to `/volume1/docker/homebridge` and set the desired environment. Don't forget to place your plugins manually under `/volume1/docker/homebridge/plugins` and (re-) start the container. See the [Homebridge docs](https://github.com/nfarina/homebridge#plugin-development) for details.

### .env options

All `.env` variables are optional.

#### HOMEBRIDGE_ENV

- **production** _(default)_  
Starts Homebridge without any options.
- **development**  
Starts Homebridge with plugin support.
- **debug**  
Starts Homebridge with plugin support and maximum debugging info.
- **production-insecure**  
Starts Homebridge with HTTP support.
- **development-insecure**  
Starts Homebridge with plugin support and HTTP support.
- **debug-insecure**  
Starts Homebridge with plugin support, HTTP support and maximum debugging info.

#### HOMEBRIDGE_VERSION

To avoid breaks with either new Homebridge releases or iOS updates, you can force the installation of a specific Homebridge version. `HOMEBRIDGE_VERSION` accepts any release tag (f.e "0.4.17") or valid NPM version range.

## Troubleshooting

In case, that Homebridge doesn't run as expected, please follow these steps for debugging:

### 1. Avoid multiple Homebridge instances

A lot of issues come through multiple Homebridge instances. Conflicts might require you to completely re-setup Homekit on your iOS devices! **Always make sure, there's only one Homebridge instance running on your network at once!** 

### 2. Verify your `config.json`

Many issues appear because of invalid JSON. Before you open a ticket, please make sure that the syntax is ok. A good way to verify your config is to use the [jsonlint.com](http://jsonlint.com) validator.

### 3. Disable Plugins

Most issues aren't related to this package, nor to Homebridge --  they are created by outdated plugins or wrong configuration. This package focuses on making Homebridge run as easy as possible. So if Homebridge runs without any plugins, enable them step by step until you find out, which plugin creates the error. You should then contact the plugin's creator.

### 4. Open ports

Make sure that ports 5353 and 51826 (both TCP) aren't blocked by your firewall.

### 5. Disable IPv6 and Bonjour

Sometimes IPv6 or Synology's Bonjour service are the reason devices cannot be found.

### 6. Adjust paths

If you're using a non-Synology device, you might need to adjust the paths to your config (`/volume1/docker/homebridge`).

### 7. Search the GitHub issues

Before opening a new [issue on GitHub](https://github.com/lumoc/homebridge-docker/issues), please use the search function to avoid duplicates.

## License

This project is licensed under Apache License V2 (see [LICENSE](LICENSE)).

## Changelog

Changes can be found in the [CHANGELOG.md](CHANGELOG.md).

## Thanks
- [Chris Brandlehner](https://github.com/cbrandlehner/homebridge-docker)
- [Parker Smith](https://github.com/psmith3/synology-docker-homebridge)
- Christian Haugen
