# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit font

DESCRIPTION="Google's font family that aims to support all the world's languages"
HOMEPAGE="https://www.google.com/get/noto/ https://github.com/googlei18n/noto-fonts"

COMMIT="49313785484cd4d1f4c0329ee3a8801f158f5ba1"
SRC_URI="https://github.com/googlei18n/noto-fonts/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~mips ppc ppc64 sparc x86"
# Extra allows to optionally reduce disk usage even returning to tofu
# issue as described in https://www.google.com/get/noto/
IUSE="cjk +extra"

SCRIPTS="
    Adlam Ahom AnatolianHieroglyphs Arabic Armenian Avestan Balinese Bamum
    BassaVah Batak Bengali Bhaiksuki Brahmi Buginese Buhid CanadianAboriginal
    Carian CaucasianAlbanian Chakma Cham Cherokee Coptic Cuneiform Cypriot
    Deseret Devanagari Duployan EgyptianHieroglyphs Elbasan Ethiopic Georgian
    Glagolitic Gothic Grantha Gujarati Gurmukhi Hanunoo Hatran Hebrew
    ImperialAramaic InscriptionalPahlavi InscriptionalParthian Javanese
    Kaithi Kannada KayahLi Kharoshthi Khmer Khudawadi Lao Lepcha Limbu
    LinearA LinearB Lisu Lycian Lydian Mahajani Malayalam Mandaic Manichaean
    Marchen MeeteiMayek MendeKikakui Meroitic Miao Modi Mongolian Mro Multani
    Myanmar NKo Nabataean NewTaiLue Newa Ogham OlChiki OldHungarian OldItalic
    OldNorthArabian OldPermic OldPersian OldSouthArabian OldTurkic Oriya Osage
    Osmanya PahawhHmong Palmyrene PauCinHau PhagsPa Phoenician PsalterPahlavi
    Rejang Runic Samaritan Saurashtra Sharada Shavian Sinhala SoraSompeng
    Sundanese SylotiNagri Syriac SyriacEastern SyriacEstrangela SyriacWestern
    Tagalog Tagbanwa TaiLe TaiTham TaiViet Takri Tamil Telugu Thaana Thai
    Tibetan Tifinagh Tirhuta Ugaritic Vai WarangCiti Yi
"
IUSE+="${SCRIPTS}"

RDEPEND="cjk? ( media-fonts/noto-cjk )"
DEPEND=""

RESTRICT="binchecks strip"

S="${WORKDIR}/${PN}-fonts-${COMMIT}"

FONT_SUFFIX="ttf"
FONT_CONF=(
	# From ArchLinux
	"${FILESDIR}/66-noto-serif.conf"
	"${FILESDIR}/66-noto-mono.conf"
	"${FILESDIR}/66-noto-sans.conf"
)

src_install() {
	mkdir install-unhinted install-hinted || die
	mv unhinted/*/* install-unhinted/. ||  die
	mv hinted/*/* install-hinted/. || die

	FONT_S="${S}/install-unhinted/" font_src_install
	FONT_S="${S}/install-hinted/" font_src_install
	FONT_DIR="${D}/usr/share/fonts/noto"
	
	# Allow to drop some fonts optionally for people that want to save
	# disk space. Following ArchLinux options.
	for script in ${SCRIPTS}; do
		if ! use "${script}"; then
		rm -f "${FONT_DIR}"/NotoSans${script}{,UI,Slanted,Unjoined}-*.ttf
		rm -f "${FONT_DIR}"/NotoSerif${script}{,UI,Slanted,Unjoined}-*.ttf
		if test "${script}" = "Arabic"; then
			rm -f "${FONT_DIR}"/NotoKufi*.ttf
			rm -f "${FONT_DIR}"/NotoNaskh*.ttf
			rm -f "${FONT_DIR}"/NotoNastaliqUrdu*.ttf
		fi
	    fi
	done

	use extra || rm -rf "${ED}"/usr/share/fonts/noto/Noto*{Condensed,SemiBold,Extra}*.ttf
}
