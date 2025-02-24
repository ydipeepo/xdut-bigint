class_name BigIntTaiwaneseFormatter extends BigIntFormatter

#-------------------------------------------------------------------------------
#	CONSTANTS
#-------------------------------------------------------------------------------

enum {
	## 123456789 のように、プレーンな文字列を得ます。
	DIGIT_SEPARATOR_NONE,
	## 123,456,789 のように、カンマで 3 桁毎に区切った文字列を得ます。
	DIGIT_SEPARATOR_COMMA,
	## 1,2345,6789 のように、カンマで 4 桁毎に区切った文字列を得ます。
	DIGIT_SEPARATOR_COMMA_MYRIADS,
	## 123'456'789 のように、引用符で 3 桁毎に区切った文字列を得ます。
	DIGIT_SEPARATOR_QUOTE,
	## 1'2345'6789 のように、引用符で 4 桁毎に区切った文字列を得ます。
	DIGIT_SEPARATOR_QUOTE_MYRIADS,
	## 123 456 789 のように、スペースで 3 桁毎に区切った文字列を得ます。
	DIGIT_SEPARATOR_SPACE,
	## 1 2345 6789 のように、スペースで 4 桁毎に区切った文字列を得ます。
	DIGIT_SEPARATOR_SPACE_MYRIADS,
}

enum {
	## 小数点以下を省略した文字列を得ます。
	DECIMAL_PRECISION_NONE,
	## 小数点以下を全て含めた文字列を得ます。
	DECIMAL_PRECISION_FULL,
	## 小数点以下を桁区切りの桁数と同じ桁 (ゼロ詰め) 含めた文字列を得ます。
	DECIMAL_PRECISION_AUTO,
	## 小数点以下を桁区切りの桁数と同じ桁含めた文字列を得ます。
	DECIMAL_PRECISION_AUTO_NO_PAD,
	## 小数点以下を 1 桁 (ゼロ詰め) 含めた文字列を得ます。
	DECIMAL_PRECISION_1,
	## 小数点以下を 1 桁含めた文字列を得ます。
	DECIMAL_PRECISION_1_NO_PAD,
	## 小数点以下を 2 桁 (ゼロ詰め) 含めた文字列を得ます。
	DECIMAL_PRECISION_2,
	## 小数点以下を 2 桁含めた文字列を得ます。
	DECIMAL_PRECISION_2_NO_PAD,
	## 小数点以下を 3 桁 (ゼロ詰め) 含めた文字列を得ます。
	DECIMAL_PRECISION_3,
	## 小数点以下を 3 桁含めた文字列を得ます。
	DECIMAL_PRECISION_3_NO_PAD,
	## 小数点以下を 4 桁 (ゼロ詰め) 含めた文字列を得ます。
	DECIMAL_PRECISION_4,
	## 小数点以下を 4 桁含めた文字列を得ます。
	DECIMAL_PRECISION_4_NO_PAD,
}

#-------------------------------------------------------------------------------
#	PROPERTIES
#-------------------------------------------------------------------------------

## 桁区切りの種類および桁数。
var digit_separator: int = DIGIT_SEPARATOR_NONE

## 単位調整を行うかどうか。
var unit_adjustment: bool

## 単位調整を行う場合の小数点以下の精度。
var unit_adjustment_precision: int = DECIMAL_PRECISION_NONE

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

func format(value: BigInt) -> String:
	assert(value != null)

	var s := value.to_string()
	if unit_adjustment:
		var d := value.digits
		var b := _find_nearest_base(d - 1)
		s = _build_integer_part(s.substr(0, d - b)) + _build_fractional_part(s.substr(d - b))
		if b != 0:
			s += _UNITS[b]
	else:
		s = _build_integer_part(s)
	return s

#-------------------------------------------------------------------------------

const _UNITS := {
	4: "萬",
	8: "億",
	12: "兆",
	16: "京",
	20: "垓",
	24: "秭",
	28: "穰",
	32: "溝",
	36: "澗",
	40: "正",
	44: "載",
	48: "極",
	52: "恒河沙",
	56: "阿僧只",
	60: "那由他",
	64: "不可思議",
	68: "無量大數",
}

func _find_nearest_base(digits: int) -> int:
	assert(0 <= digits)

	var n: int
	for b: int in _UNITS.keys():
		if b <= digits and n < b:
			n = b
	return n

func _get_digit_group_size() -> int:
	var g: int
	match digit_separator:
		DIGIT_SEPARATOR_COMMA, \
		DIGIT_SEPARATOR_QUOTE, \
		DIGIT_SEPARATOR_SPACE:
			g = 3
		DIGIT_SEPARATOR_COMMA_MYRIADS, \
		DIGIT_SEPARATOR_QUOTE_MYRIADS, \
		DIGIT_SEPARATOR_SPACE_MYRIADS:
			g = 4
	return g

func _build_integer_part(s: String) -> String:
	var g := _get_digit_group_size()
	if g != 0:
		var c: String
		match digit_separator:
			DIGIT_SEPARATOR_COMMA, \
			DIGIT_SEPARATOR_COMMA_MYRIADS:
				c = ","
			DIGIT_SEPARATOR_QUOTE, \
			DIGIT_SEPARATOR_QUOTE_MYRIADS:
				c = "'"
			DIGIT_SEPARATOR_SPACE, \
			DIGIT_SEPARATOR_SPACE_MYRIADS:
				c = " "
		var l := s.length()
		var b := (l - 1) / g
		var p := l - b * g
		var o := s.substr(0, p)
		for i: int in b:
			o += c + s.substr(p + i * g, g)
		s = o
	return s

func _build_fractional_part(s: String) -> String:
	var f: String
	match unit_adjustment_precision:
		DECIMAL_PRECISION_NONE:
			pass
		DECIMAL_PRECISION_FULL:
			f = s
		DECIMAL_PRECISION_AUTO, \
		DECIMAL_PRECISION_AUTO_NO_PAD:
			f = s.substr(0, _get_digit_group_size())
		DECIMAL_PRECISION_1, \
		DECIMAL_PRECISION_1_NO_PAD:
			f = s.substr(0, 1)
		DECIMAL_PRECISION_2, \
		DECIMAL_PRECISION_2_NO_PAD:
			f = s.substr(0, 2)
		DECIMAL_PRECISION_3, \
		DECIMAL_PRECISION_3_NO_PAD:
			f = s.substr(0, 3)
		DECIMAL_PRECISION_4, \
		DECIMAL_PRECISION_4_NO_PAD:
			f = s.substr(0, 4)
	match unit_adjustment_precision:
		DECIMAL_PRECISION_AUTO_NO_PAD, \
		DECIMAL_PRECISION_1_NO_PAD, \
		DECIMAL_PRECISION_2_NO_PAD, \
		DECIMAL_PRECISION_3_NO_PAD, \
		DECIMAL_PRECISION_4_NO_PAD:
			f = f.trim_suffix("0")
	return "" if f.is_empty() else "." + f
