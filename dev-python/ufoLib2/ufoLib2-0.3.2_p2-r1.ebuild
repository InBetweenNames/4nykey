# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fonttools/${PN}.git"
else
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="e685526"
	fi
	MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/fonttools/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A UFO font library"
HOMEPAGE="https://github.com/fonttools/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/fonttools-3.34[ufo,${PYTHON_USEDEP}]
	>=dev-python/attrs-18.2[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	virtual/python-typing[${PYTHON_USEDEP}]
	virtual/python-enum34[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && \
		export SETUPTOOLS_SCM_PRETEND_VERSION="${PV/_p/.post}"
}

python_test() {
	pytest -v || die "Tests failed with ${EPYTHON}"
}
