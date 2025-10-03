# Inspired by elgeeko1, I looked at his published code and made some changes based on my needs.
#
# Roon Server Docker (Debian 13.1 Slim)

This repository provides a lightweight Docker image for running **Roon Server** based on **Debian 13.1 slim**.  
It is designed to be minimal, stable, and easy to use in a containerized environment.

---

## Features

- Based on **Debian 13.1 slim**
- Includes the latest **FFmpeg** build from [BtbN/FFmpeg-Builds](https://github.com/BtbN/FFmpeg-Builds)
- Supports audio libraries (`libasound2`, `alsa-utils`)
- CIFS support for mounting network shares
- Preconfigured environment variables for Roon data
- Clean image (unnecessary packages removed)
- Multi-stage build to keep final image small

---

## Requirements

- Docker or Podman installed on your host
- A valid **Roon license** or **Roon trial account**
- Sufficient storage for your music library and Roon database

---

## Usage

### Build the image

```bash
git clone https://github.com/DartSteven/roon-server.git
cd roon-server-docker
docker build -t roon-server .
