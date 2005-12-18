# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion toolchain-funcs flag-o-matic

DESCRIPTION="x264 is a free library for encoding H264/AVC video streams"
HOMEPAGE="http://www.videolan.org/x264.html"
ESVN_REPO_URI="svn://svn.videolan.org/${PN}/trunk"
ESVN_PATCHES="*.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="X mp4 sdl threads test"

RDEPEND="mp4? ( media-video/gpac-cvs )
	X? ( virtual/x11 )
	sdl? ( media-libs/libsdl )"
DEPEND="${RDEPEND}
	dev-lang/nasm"

src_compile() {
	use X && DEP_LIBS=" -lX11"
	use threads && DEP_LIBS="${DEP_LIBS} -lpthread"

	./configure\
		`use_enable X visualize` \
		`use_enable threads pthread` \
		`use_enable mp4 mp4-output`\
		--extra-cflags="${CFLAGS}"\
		--extra-ldflags="$LDFLAGS"

	make || die
	`tc-getCC` $CFLAGS $LDFLAGS -o avc2avi tools/avc2avi.c
	use sdl && `tc-getCC` $CFLAGS $LDFLAGS -o xyuv tools/xyuv.c -lSDL
}

src_test() {
	make checkasm || die
	./checkasm || die
}

src_install() {
	dobin x264 avc2avi
	use sdl && dobin xyuv
	dolib.a libx264.a
	insinto /usr/$(get_libdir)/pkgconfig
	doins x264.pc
	insinto /usr/include
	doins x264.h
	dodoc AUTHORS TODO doc/*.txt tools/*.{pl,sh}
}
