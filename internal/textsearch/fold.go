// Package textsearch normalises text so a search matches what people type.
package textsearch

import (
	"strings"
	"unicode"

	"golang.org/x/text/runes"
	"golang.org/x/text/transform"
	"golang.org/x/text/unicode/norm"
)

// Fold lowercases text and strips Vietnamese diacritics.
//
// Typing without tone marks is how Vietnamese is normally entered on a phone,
// and a plain substring match meant "Huu Co" found nothing while "Hữu Cơ" sat
// in the list. Both the stored text and the query go through this, so either
// spelling finds the other.
func Fold(text string) string {
	text = strings.TrimSpace(text)
	if text == "" {
		return ""
	}

	// Decomposing separates a letter from its tone mark so the mark can be
	// dropped; đ and Đ are letters in their own right and never decompose, so
	// they are mapped first.
	text = strings.NewReplacer("đ", "d", "Đ", "D").Replace(text)

	folded, _, err := transform.String(
		transform.Chain(
			norm.NFD,
			runes.Remove(runes.In(unicode.Mn)),
			norm.NFC,
		),
		text,
	)
	if err != nil {
		// Nothing here can realistically fail, but a search should degrade to
		// exact matching rather than to no matching at all.
		return strings.ToLower(text)
	}
	return strings.ToLower(folded)
}

// Contains reports whether haystack contains needle, both folded.
func Contains(haystack, needle string) bool {
	return strings.Contains(Fold(haystack), Fold(needle))
}
