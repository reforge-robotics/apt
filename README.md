# Reforge Robotics APT Repository

This repository publishes Reforge Robotics Debian packages for
supported Ubuntu machines.

## Supported Platform

```text
Ubuntu 24.04 noble, amd64
```

The setup script exits with an error on unsupported operating
systems before it writes an APT source.

## Install The Shaper C++ SDK

Install the basic tools needed to add the repository:

```bash
sudo apt update
sudo apt install -y ca-certificates curl gnupg
```

Add the signed Reforge APT repository:

```bash
curl -fsSL https://reforge-robotics.github.io/reforge-core-cpp/setup.sh | sudo bash
```

Install only the Shaper C++ SDK package:

```bash
sudo apt update
sudo apt install -y reforge-core-shaper
```

Or install the default Reforge Core package set:

```bash
sudo apt update
sudo apt install -y reforge-core
```

## Validate The Installed SDK

Check the installed package version:

```bash
dpkg-query -W -f='${Package} ${Version} ${Architecture}\n' reforge-core-shaper
```

Build and run the demo shipped with the SDK:

```bash
sudo apt install -y cmake build-essential
cmake -S /usr/share/reforge-core-shaper/examples -B /tmp/reforge-shaper-demo
cmake --build /tmp/reforge-shaper-demo --parallel
/tmp/reforge-shaper-demo/reforge_shaper_demo
```

Expected demo output:

```text
Reforge Shaper C++ demo complete.
```

## Use The SDK In Your CMake Project

After installation, use the exported CMake package:

```cmake
cmake_minimum_required(VERSION 3.22)
project(reforge_shaper_app LANGUAGES CXX)

find_package(ReforgeShaper CONFIG REQUIRED)

add_executable(reforge_shaper_app main.cpp)
target_link_libraries(reforge_shaper_app PRIVATE ReforgeShaper::runtime)
```

The package installs SDK files under:

```text
/usr/include/reforge_core
/usr/lib/x86_64-linux-gnu
/usr/lib/x86_64-linux-gnu/cmake/ReforgeShaper
/usr/share/reforge-core-shaper/examples
```

## Upgrade

Upgrade the Shaper C++ SDK:

```bash
sudo apt update
sudo apt upgrade -y reforge-core-shaper
```

Upgrade the default Reforge Core package set:

```bash
sudo apt update
sudo apt upgrade -y reforge-core
```

Run the installed demo again after upgrading to confirm the SDK
still builds and links correctly.

## Repository Contents

This repository is generated release output. The source code,
packaging scripts, and release workflow live in the private
`reforge-robotics/reforge-core` repository.
