%define luaver 5.1
%define lualibdir %{_libdir}/lua/%{luaver}
%define luadatadir %{_datadir}/lua/%{luaver}
%define debug_package %{nil}
%define _builddir %{_topdir}/BUILD/lua-crypto

Name:		lua-crypto

Version:	0.3.0
Release:	1%{?dist}
Summary:	Crypto library for Lua

Group:		Development/Libraries
License:	MIT
URL:		http://luacrypto.luaforge.net/
Source0:	https://github.com/luaforge/luacrypto/archive/%{name}-master.zip
BuildRoot:	%(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)

Patch: lcrypto.config.patch

BuildRequires:	lua >= %{luaver}, lua-devel >= %{luaver}, gcc
Requires:	lua >= %{luaver}

%description
LuaCrypto provides a Lua frontend to the OpenSSL cryptographic library.
The OpenSSL features that are currently exposed are digests
 (MD5, SHA-1, HMAC, and more) and crypto-grade random number generators.


%prep
#%setup -q -n luacrypto-master
%patch -p0


%build
make 


%install
rm -rf "$RPM_BUILD_ROOT"
mkdir -p $RPM_BUILD_ROOT%{lualibdir}
install $RPM_BUILD_DIR//src/lcrypto.so.0.3.0 $RPM_BUILD_ROOT%{lualibdir}/
pushd $RPM_BUILD_ROOT%{lualibdir}/
ln -s lcrypto.so.0.3.0 crypto.so
popd


%clean
rm -rf "$RPM_BUILD_ROOT"


%preun


%files
%defattr(-,root,root,-)
#%doc README
%{lualibdir}/*


%changelog
* Thu Aug 24 2006 nezroy
- README, doc/us/index.html: adding README and historical doc links

* Thu Aug 24 2006 nezroy
- src/lcrypto.h: fixing API define

* Thu Aug 24 2006 nezroy
- Makefile, config, doc/luacrypto.html, doc/us/examples.html,
  doc/us/index.html, doc/us/license.html, doc/us/luacrypto-128.png,
  doc/us/manual.html, src/lcrypto.c, tests/rand.lua,
  tests/test.lua: adding new documentation and tweaking build

* Tue Aug 22 2006 nezroy
- Makefile, config, src/crypto.c, src/crypto.h, src/crypto.lua,
  src/evp.c, src/evp.h, src/evp.lua, src/hmac.c, src/hmac.h,
  src/hmac.lua, src/lcrypto.c, src/lcrypto.h, tests/test.lua:
  adding rand support and collapsing into a kepler-ized format

* Mon Aug 21 2006 nezroy
- LICENSE, README: cleaning out files

