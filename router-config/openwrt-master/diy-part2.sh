#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic s9xxx tv box
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/openwrt/openwrt / Branch: master
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
#sed -i 's/luci-theme-bootstrap/luci-theme-material/g' feeds/luci/collections/luci/Makefile

# Add the default password for the 'root' user（Change the empty password to 'password'）
sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' package/base-files/files/etc/shadow

# Set etc/openwrt_release
#sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
#echo "DISTRIB_SOURCECODE='openwrt.master'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
sed -i 's/192.168.1.1/192.168.2.10/g' package/base-files/files/bin/config_generate

#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic

#使用源码自带ShadowSocksR Plus+出国软件
#sed -i 's/#src-git helloworld/src-git helloworld/g' ./feeds.conf.default
#sed -i '$a src-git helloworld https://github.com/fw876/helloworld' feeds.conf.default
#git clone https://github.com/0118Add/helloworld.git package/helloworld
#git clone https://github.com/0118Add/pass-ssrp.git package/luci-app-ssr-plus
svn co https://github.com/0118Add/OpenWrt-CI/trunk/x86/diy/x86_lede/pass-ssrp package/helloworld

git clone https://github.com/xiaorouji/openwrt-passwall.git package/openwrt-passwall
git clone https://github.com/messense/aliyundrive-webdav.git package/aliyundrive-webdav
git clone https://github.com/sirpdboy/luci-theme-opentopd.git package/luci-theme-opentopd
rm -rf feeds/luci/themes/luci-theme-argon
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
git clone https://github.com/jerrykuku/luci-app-vssr.git package/luci-app-vssr
git clone https://github.com/jerrykuku/lua-maxminddb.git package/lua-maxminddb
svn co https://github.com/vernesong/OpenClash/branches/dev/luci-app-openclash package/luci-app-openclash
# 编译 po2lmo (如果有po2lmo可跳过)
pushd package/luci-app-openclash/tools/po2lmo
make && sudo make install
popd
git clone https://github.com/immortalwrt/luci-app-unblockneteasemusic.git package/luci-app-unblockneteasemusic
sed -i 's/解除网易云音乐播放限制/解锁网易音乐播放限制/g' package/luci-app-unblockneteasemusic/luasrc/controller/unblockneteasemusic.lua

./scripts/feeds update -a
./scripts/feeds install -a
