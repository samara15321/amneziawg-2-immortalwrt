#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# Настройки сборки
# -----------------------------
TAG="23.05.6"
TARGET="rockchip"
SUBTARGET="armv8"
PKGARCH="aarch64_generic"
VERMAGIC="1165e14f95a921713988260b06d8b0ab"
GO_VERSION="1.24.6"
AWGRELEASE_DIR="awgrelease"
LOCAL_TAG="LOCALBUILD"

# -----------------------------
# 1. Установка Go (локально)
# -----------------------------
if ! command -v go >/dev/null 2>&1 || [[ $(go version) != *"${GO_VERSION}"* ]]; then
    echo "[*] Установка Go ${GO_VERSION}..."
    wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -O /tmp/go${GO_VERSION}.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf /tmp/go${GO_VERSION}.linux-amd64.tar.gz
fi
export PATH=/usr/local/go/bin:$PATH
go version

# -----------------------------
# 2. Установка зависимостей
# -----------------------------
echo "[*] Установка системных зависимостей..."
sudo apt-get update
sudo apt-get install -y wget curl git build-essential unzip xz-utils coreutils python3-dev python3-setuptools swig python3-pyelftools gettext

# -----------------------------
# 3. Подготовка исходников
# -----------------------------
IMMORTAL_DIR="//home/root1/projects/immortalwrt"
cd "$IMMORTAL_DIR"


echo "[*] Настройка feeds..."
wget https://raw.githubusercontent.com/immortalwrt/immortalwrt/v${TAG}/feeds.conf.default -O feeds.conf
echo "src-git awgopenwrt https://github.com/samara15321/amneziawg-2-immortalwrt.git" >> feeds.conf
./scripts/feeds update -a
./scripts/feeds install -a

# -----------------------------
# 4. Конфигурация сборки
# -----------------------------
echo "[*] Настройка конфигурации..."
wget https://downloads.immortalwrt.org/releases/${TAG}/targets/${TARGET}/${SUBTARGET}/config.buildinfo -O .config
cat <<EOF >> .config
CONFIG_PACKAGE_amneziawg-go=y
CONFIG_PACKAGE_amneziawg-tools=y
CONFIG_PACKAGE_luci-proto-amneziawg=y
CONFIG_PACKAGE_kmod-amneziawg=m
CONFIG_PACKAGE_kmod-crypto-lib-chacha20=m
CONFIG_PACKAGE_kmod-crypto-lib-chacha20poly1305=m
CONFIG_PACKAGE_kmod-crypto-chacha20poly1305=m
EOF
make defconfig

# -----------------------------
# 5. Сборка инструментов и ядра
# -----------------------------
echo "[*] Сборка инструментов и ядра..."
make tools/install -j$(nproc)
make toolchain/install -j$(nproc)
make target/linux/compile -j$(nproc) V=s

# -----------------------------
# 6. Проверка vermagic
# -----------------------------
VERMAGIC_ACTUAL=$(cat ./build_dir/target-*/linux-*/linux-*/.vermagic)
echo "[*] Vermagic: $VERMAGIC_ACTUAL"
if [[ "$VERMAGIC_ACTUAL" != "$VERMAGIC" ]]; then
    echo "[!] Vermagic mismatch: $VERMAGIC_ACTUAL, expected $VERMAGIC"
    exit 1
fi

# -----------------------------
# 7. Сборка пакетов AmneziaWG
# -----------------------------
echo "[*] Сборка пакетов AmneziaWG..."
export PATH=/usr/local/go/bin:$PATH
make package/amneziawg-go/{clean,download,prepare,compile} V=s
make package/kmod-amneziawg/{clean,download,prepare,compile} V=s
make package/amneziawg-tools/{clean,download,prepare,compile} V=s
make package/luci-proto-amneziawg/{clean,download,prepare,compile} V=s

# -----------------------------
# 8. Подготовка артефактов
# -----------------------------
echo "[*] Подготовка артефактов..."
mkdir -p $AWGRELEASE_DIR
POSTFIX="${LOCAL_TAG}_v${TAG}_${PKGARCH}_${TARGET}_${SUBTARGET}"
cp bin/packages/${PKGARCH}/awgopenwrt/amneziawg-tools_*.ipk $AWGRELEASE_DIR/amneziawg-tools_${POSTFIX}.ipk
cp bin/packages/${PKGARCH}/awgopenwrt/luci-proto-amneziawg_*.ipk $AWGRELEASE_DIR/luci-proto-amneziawg_${POSTFIX}.ipk
cp bin/packages/${PKGARCH}/awgopenwrt/amneziawg-go_*.ipk $AWGRELEASE_DIR/amneziawg-go_${POSTFIX}.ipk
cp bin/targets/${TARGET}/${SUBTARGET}/packages/kmod-amneziawg_*.ipk $AWGRELEASE_DIR/kmod-amneziawg_${POSTFIX}.ipk

echo "[*] Сборка завершена. Пакеты находятся в $AWGRELEASE_DIR/"
