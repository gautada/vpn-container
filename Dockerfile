FROM ubuntu:20.04

COPY vpnsetup.sh /vpnsetup.sh

# RUN /vpnsetup.sh

RUN mkdir -p  /opt/cluster-data/home \
 && rm -rf /home \
 && ln -sf /opt/cluster-data/home /home \
 && export TZ=US/Eastern \
 && DEBIAN_FRONTEND=noninteractive \
 && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
 && echo $TZ > /etc/timezone \
 && apt-get update -y \
 && apt-get install -y --no-install-recommends apt-utils bash nano screen sudo 
 
RUN apt-get install -y wget dnsutils openssl iptables iproute2 gawk grep sed net-tools

RUN apt-get -yq install libnss3-dev libnspr4-dev pkg-config \
  libpam0g-dev libcap-ng-dev libcap-ng-utils libselinux1-dev \
  libcurl4-nss-dev flex bison gcc make libnss3-tools \
  libevent-dev ppp xl2tpd

RUN apt-get -yq install fail2ban

RUN export SWAN_VER=3.32 \
 && export SWAN_FILE="libreswan-$SWAN_VER.tar.gz" \
 && export SWAN_URL="https://github.com/libreswan/libreswan/archive/v$SWAN_VER.tar.gz" \
 && wget -t 3 -T 30 -nv -O "$SWAN_FILE" "$SWAN_URL" \
 && tar xzf "$SWAN_FILE" && /bin/rm -f "$SWAN_FILE" \
 && cd "libreswan-$SWAN_VER"

# SWAN_VER=3.32
# swan_file="libreswan-$SWAN_VER.tar.gz"
# 
# swan_url1="https://github.com/libreswan/libreswan/archive/v$SWAN_VER.tar.gz"
# swan_url1="https://github.com/libreswaswan_file="libreswan-$SWAN_VER.tar.gz"n/libreswan/archive/v$SWAN_VER.tar.gz"
# swan_url2="https://download.libreswan.org/$swan_file"
# if ! { wget -t 3 -T 30 -nv -O "$swan_file" "$swan_url1" || wget -t 3 -T 30 -nv -O "$swan_file" "$swan_url2"; }; then
#   exit 1
# fi
# /bin/rm -rf "/opt/src/libreswan-$SWAN_VER"
# tar xzf "$swan_file" && /bin/rm -f "$swan_file"
# cd "libreswan-$SWAN_VER" || exit 1



# cat > Makefile.inc.local <<'EOF'
# WERROR_CFLAGS = -w
# USE_DNSSEC = false
# USE_DH2 = true
# USE_DH31 = false
# USE_NSS_AVA_COPY = true
# USE_NSS_IPSEC_PROFILE = false
# USE_GLIBC_KERN_FLIP_HEADERS = true
# EOF
# if ! grep -qs IFLA_XFRM_LINK /usr/include/linux/if_link.h; then
#   echo "USE_XFRM_INTERFACE_IFLA_HEADER = true" >> Makefile.inc.local
# fi
# if [ "$(packaging/utils/lswan_detect.sh init)" = "systemd" ]; then
#   apt-get -yq install libsystemd-dev || exiterr2
# fi
# NPROCS=$(grep -c ^processor /proc/cpuinfo)
# [ -z "$NPROCS" ] && NPROCS=1
# make "-j$((NPROCS+1))" -s base && make -s install-base
# 
#  cd /opt/src || exit 1
# /bin/rm -rf "/opt/src/libreswan-$SWAN_VER"
# if ! /usr/local/sbin/ipsec --version 2>/dev/null | grep -qF "$SWAN_VER"; then
#   exiterr "Libreswan $SWAN_VER failed to build."
# fi

