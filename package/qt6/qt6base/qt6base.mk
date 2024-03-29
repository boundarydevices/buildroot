################################################################################
#
# qt6base
#
################################################################################

QT6BASE_VERSION = $(QT6_VERSION)
QT6BASE_SITE = $(QT6_SITE)
QT6BASE_SOURCE = qtbase-$(QT6_SOURCE_TARBALL_PREFIX)-$(QT6BASE_VERSION).tar.xz
QT6BASE_LICENSE = GPL-2.0+ or LGPL-3.0, GPL-3.0 with exception (tools), GFDL-1.3 (docs)
QT6BASE_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPL3 LICENSE.GPL3-EXCEPT LICENSE.LGPL3 LICENSE.FDL
QT6BASE_DEPENDENCIES = \
	host-ninja \
	host-qt6base \
	double-conversion \
	libb2 \
	pcre2 \
	zlib
QT6BASE_INSTALL_STAGING = YES

QT6BASE_CONF_OPTS = \
	-GNinja \
	-DQT_HOST_PATH=$(HOST_DIR) \
	-DFEATURE_gui=OFF \
	-DFEATURE_concurrent=OFF \
	-DFEATURE_xml=OFF \
	-DFEATURE_sql=OFF \
	-DFEATURE_testlib=OFF \
	-DFEATURE_network=OFF \
	-DFEATURE_dbus=OFF \
	-DFEATURE_icu=OFF \
	-DFEATURE_glib=OFF \
	-DFEATURE_system_doubleconversion=ON \
	-DFEATURE_system_pcre2=ON \
	-DFEATURE_system_zlib=ON \
	-DFEATURE_system_libb2=ON

define QT6BASE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(BR2_CMAKE) --build $(QT6BASE_BUILDDIR)
endef

define QT6BASE_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(BR2_CMAKE) --install $(QT6BASE_BUILDDIR) --prefix $(STAGING_DIR)/usr
endef

define QT6BASE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(BR2_CMAKE) --install $(QT6BASE_BUILDDIR) --prefix $(TARGET_DIR)/usr
endef

HOST_QT6BASE_DEPENDENCIES = \
	host-ninja \
	host-double-conversion \
	host-libb2 \
	host-pcre2 \
	host-zlib
HOST_QT6BASE_CONF_OPTS = \
	-GNinja \
	-DFEATURE_gui=OFF \
	-DFEATURE_concurrent=OFF \
	-DFEATURE_xml=ON \
	-DFEATURE_sql=OFF \
	-DFEATURE_testlib=OFF \
	-DFEATURE_network=OFF \
	-DFEATURE_dbus=OFF \
	-DFEATURE_icu=OFF \
	-DFEATURE_glib=OFF \
	-DFEATURE_system_doubleconversion=ON \
	-DFEATURE_system_libb2=ON \
	-DFEATURE_system_pcre2=ON \
	-DFEATURE_system_zlib=ON

define HOST_QT6BASE_BUILD_CMDS
	$(HOST_MAKE_ENV) $(BR2_CMAKE) --build $(HOST_QT6BASE_BUILDDIR)
endef

define HOST_QT6BASE_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(BR2_CMAKE) --install $(HOST_QT6BASE_BUILDDIR)
endef

# We need host-qt6base with D-Bus support, otherwise: "the tool
# "Qt6::qdbuscpp2xml" was not found in the Qt6DBusTools package."
ifeq ($(BR2_PACKAGE_QT6BASE_DBUS),y)
QT6BASE_CONF_OPTS += -DFEATURE_dbus=ON -DINPUT_dbus=linked
QT6BASE_DEPENDENCIES += dbus
HOST_QT6BASE_CONF_OPTS += -DFEATURE_dbus=ON
HOST_QT6BASE_DEPENDENCIES += host-dbus
else
QT6BASE_CONF_OPTS += -DFEATURE_dbus=OFF
HOST_QT6BASE_CONF_OPTS += -DFEATURE_dbus=OFF
endif

ifeq ($(BR2_PACKAGE_QT6BASE_NETWORK),y)
QT6BASE_CONF_OPTS += -DFEATURE_network=ON
else
QT6BASE_CONF_OPTS += -DFEATURE_network=OFF
endif

ifeq ($(BR2_PACKAGE_QT6BASE_CONCURRENT),y)
QT6BASE_CONF_OPTS += -DFEATURE_concurrent=ON
else
QT6BASE_CONF_OPTS += -DFEATURE_concurrent=OFF
endif

ifeq ($(BR2_PACKAGE_QT6BASE_TEST),y)
QT6BASE_CONF_OPTS += -DFEATURE_testlib=ON
else
QT6BASE_CONF_OPTS += -DFEATURE_testlib=OFF
endif

ifeq ($(BR2_PACKAGE_QT6BASE_XML),y)
QT6BASE_CONF_OPTS += -DFEATURE_xml=ON
else
QT6BASE_CONF_OPTS += -DFEATURE_xml=OFF
endif

ifeq ($(BR2_PACKAGE_QT6BASE_SYSLOG),y)
QT6BASE_CONF_OPTS += -DFEATURE_syslog=ON
else
QT6BASE_CONF_OPTS += -DFEATURE_syslog=OFF
endif

$(eval $(cmake-package))
$(eval $(host-cmake-package))
