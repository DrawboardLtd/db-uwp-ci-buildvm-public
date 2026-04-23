#!/bin/bash
set -ex

# utils
info() { echo -e "\033[1;32m$1\033[0m"; }

info "# set up dependencies"
apt-get autoremove -y
apt-get update && apt-get install git curl zip unzip tar pkg-config software-properties-common -y
apt-get update -y # once software-properties-common are installed, update again

info "# install dejavu font"
apt-get install fonts-dejavu-core -y

info "# gcc 14"
apt-get update -y
apt-get install gcc-14 g++-14 -y
gcc-14 --version
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 20
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-14 20
update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 30
update-alternatives --set cc /usr/bin/gcc
update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30
update-alternatives --set c++ /usr/bin/g++
update-alternatives --config gcc
update-alternatives --config g++
gcc --version

info "# cmake"
cmake_version=4.3.2
cmake_installer="cmake-${cmake_version}-linux-x86_64.sh"
curl -fsSLO "https://github.com/Kitware/CMake/releases/download/v${cmake_version}/${cmake_installer}"
mkdir /opt/cmake
sh "${cmake_installer}" --prefix=/opt/cmake --skip-license
ln -s "/opt/cmake/bin/cmake" /usr/local/bin/cmake
rm "./${cmake_installer}"
cmake --version

info "# ninja & make"
apt-get update && apt-get install -y ninja-build make
ninja --version
make --version

info "# dotnet"
curl -fsSL https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -o packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
apt-get update && apt-get install -y dotnet-sdk-6.0

info "# setup complete"
