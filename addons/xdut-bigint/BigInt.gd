## 巨大な符号なし整数を扱うためのクラスです。
class_name BigInt

#-------------------------------------------------------------------------------
#	CONSTANTS
#-------------------------------------------------------------------------------

## 0 を表す [BigInt]。
static var ZERO: BigInt:
	get:
		return _zero

## 1 を表す [BigInt]。
static var ONE: BigInt:
	get:
		return _one

## 2^63-1 を表す [BigInt]。
static var INT_MAX: BigInt:
	get:
		return _int_max

#-------------------------------------------------------------------------------
#	PROPERTIES
#-------------------------------------------------------------------------------

## この [BigInt] が 0 の場合 [code]true[/code]、それ以外の場合は [code]false[/code] を返します。
var is_zero: bool:
	get:
		return _is_zero(_read_big_int(self))

## この [BigInt] の桁数を返します。
var digits: int:
	get:
		return _array.size()

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

## [BigInt] を作成します。
static func from(value: Variant) -> BigInt:
	return BigInt.new(_read(value))

## この [BigInt] の指定した位置の上ケタを取得します。
func upper(index: int) -> int:
	var n := _array.size()
	if index < 0 or n <= index:
		printerr("Out of range.")
		return -1
	return _array[n - index - 1]

## この [BigInt] の指定した位置の下ケタを取得します。
func lower(index: int) -> int:
	if index < 0 or _array.size() <= index:
		printerr("Out of range.")
		return -1
	return _array[index]

## この [BigInt] が与えられた値と等値か判定します。
func equals(value: Variant) -> bool:
	var array1 := _read_big_int(self)
	var array2 := _read(value)
	return array1 == array2

## この [BigInt] が与えられた値より小さいか判定します。
func less(value: Variant) -> bool:
	var array1 := _read_big_int(self)
	var array2 := _read(value)
	return _less(array1, array2)

## この [BigInt] をインクリメントした新たな [BigInt] を返します。
func increment() -> BigInt:
	var array := _read_big_int(self)
	if _is_zero(array):
		array = _array_1.duplicate()
	else:
		array = _increment(array, true)
	return new(array)

## この [BigInt] をデクリメントできるかを返します。
func can_decrement() -> bool:
	var array := _read_big_int(self)
	return _can_decrement(array)

## この [BigInt] をデクリメントした新たな [BigInt] を返します。
func decrement() -> BigInt:
	var array := _read_big_int(self)
	if _is_one(array):
		array = _array_0.duplicate()
	else:
		array = _decrement(array, true)
	return new(array)

## この [BigInt] と与えられた値の和を求め新たな [BigInt] として返します。
func add(value: Variant) -> BigInt:
	var array1 := _read_big_int(self)
	var array2 := _read(value)
	if _is_one(array2):
		array1 = _increment(array1, true)
	else:
		array1 = _add(array1, array2, true)
	return new(array1)

## この [BigInt] と与えられた値の差を求めることができるかを返します。
func can_subtract(value: Variant) -> bool:
	var array1 := _read_big_int(self)
	var array2 := _read(value)
	return _can_subtract(array1, array2)

## この [BigInt] と与えられた値の差を求め新たな [BigInt] として返します。
func subtract(value: Variant) -> BigInt:
	var array1 := _read_big_int(self)
	var array2 := _read(value)
	if _is_one(array2):
		array1 = _decrement(array1, true)
	else:
		array1 = _subtract(array1, array2, true)
	return new(array1)

## この [BigInt] と与えられた値の積を求め新たな [BigInt] として返します。
func multiply(value: Variant) -> BigInt:
	var array1 := _read_big_int(self)
	var array2 := _read(value)
	if _is_one(array2):
		array1 = array1.duplicate()
	else:
		array1 = _multiply(array1, array2, true)
	return new(array1)

## この [BigInt] と与えられた値の商を求めることができるかを返します。
func can_divide(value: Variant) -> bool:
	var array1 := _read_big_int(self)
	var array2 := _read(value)
	return _can_divide(array1, array2)

## この [BigInt] と与えられた値の商を求め新たな [BigInt] として返します。
func divide(value: Variant) -> BigInt:
	var array1 := _read_big_int(self)
	var array2 := _read(value)
	array1 = _divide(array1, array2, true)
	return new(array1)

## この [BigInt] と与えられた値の剰余を求め新たな [BigInt] として返します。
func modulo(value: Variant) -> BigInt:
	var array1 := _read_big_int(self)
	var array2 := _read(value)
	array1 = _modulo(array1, array2, true)
	return new(array1)

## この [BigInt] を [BigIntFormatter] により [code]String[/code] 型として表現される文字列に変換します。
func format(formatter: BigIntFormatter) -> String:
	return formatter.format(self)

## この [BigInt] を [code]int[/code] 型として表現される整数に変換します。
func to_int() -> int:
	var array := _read_big_int(self)
	if _less(_array_int_max, array):
		printerr("Overflow.")
		return -1
	return int(to_string())

#-------------------------------------------------------------------------------

const _INT_MAX := 9223372036854775807

static var _array_0 := PackedByteArray([0])
static var _array_1 := PackedByteArray([1])
static var _array_10 := PackedByteArray([0, 1])
static var _array_int_max := PackedByteArray([7, 0, 8, 5, 7, 7, 4, 5, 8, 6, 3, 0, 2, 7, 3, 3, 2, 2, 9])
static var _zero := new(_array_0)
static var _one := new(_array_1)
static var _int_max := new(_array_int_max)

var _array: PackedByteArray

static func _set_zero(value: PackedByteArray) -> void:
	value.resize(1)
	value[0] = 0

static func _set_one(value: PackedByteArray) -> void:
	value.resize(1)
	value[0] = 1

static func _read_int(
	value: int,
	allocate := false) -> PackedByteArray:

	if not allocate:
		match value:
			0:
				return _array_0
			1:
				return _array_1
			10:
				return _array_10
			_INT_MAX:
				return _array_int_max
	var array := PackedByteArray()
	if value <= 0:
		if value < 0:
			push_error("Negative value: ", value)
		_set_zero(array)
		return array
	while 0 < value:
		array.push_back(value % 10)
		value /= 10
	return array

static func _read_string(
	value: String,
	allocate := false) -> PackedByteArray:

	const CP_0 := 0x0030 # "0".unicode_at(0)
	const CP_1 := 0x0031 # "1".unicode_at(1)
	const CP_9 := 0x0039 # "9".unicode_at(9)

	value = value.lstrip("0")
	if not allocate:
		match value.length():
			0:
				return _array_0
			1:
				match value.unicode_at(0):
					CP_0: return _array_0
					CP_1: return _array_1
	var array := PackedByteArray()
	var i := value.length()
	if i == 0:
		_set_zero(array)
		return array
	var cp: int
	while 0 < i:
		i -= 1
		cp = value.unicode_at(i)
		if cp < CP_0 or CP_9 < cp:
			push_error("Invalid numeric string: ", value)
			_set_zero(array)
			break
		array.push_back(cp - CP_0)
	return array

static func _read_array(
	value: Array,
	allocate := false) -> PackedByteArray:

	if not allocate:
		match value.size():
			0:
				return _array_0
			1:
				match value[0]:
					0:
						return _array_0
					1:
						return _array_1
	var array := PackedByteArray()
	var i := value.size()
	if i == 0:
		_set_zero(array)
		return array
	var v: Variant
	while 0 < i:
		i -= 1
		v = value[i]
		if v is not int or v < 0 or 9 < v:
			push_error("Invalid numeric array: ", value)
			_set_zero(array)
			break
		array.push_back(v)
	_trim_zero(array)
	return array

static func _read_byte_array(
	value: PackedByteArray,
	allocate := false) -> PackedByteArray:

	if not allocate:
		match value.size():
			0:
				return _array_0
			1:
				match value[0]:
					0:
						return _array_0
					1:
						return _array_1
	var array := PackedByteArray()
	var i := value.size()
	if i == 0:
		_set_zero(array)
		return array
	var v: int
	while 0 < i:
		i -= 1
		v = value[i]
		if 9 < v:
			push_error("Invalid numeric array: ", value)
			_set_zero(array)
			break
		array.push_back(v)
	_trim_zero(array)
	return array

static func _read_int32_array(
	value: PackedInt32Array,
	allocate := false) -> PackedByteArray:

	if not allocate and value.size() == 1:
		match value.size():
			0:
				return _array_0
			1:
				match value[0]:
					0:
						return _array_0
					1:
						return _array_1
	var array := PackedByteArray()
	var i := value.size()
	if i == 0:
		_set_zero(array)
		return array
	var v: int
	while 0 < i:
		i -= 1
		v = value[i]
		if v < 0 or 9 < v:
			push_error("Invalid numeric array: ", value)
			_set_zero(array)
			break
		array.push_back(v)
	_trim_zero(array)
	return array

static func _read_int64_array(
	value: PackedInt64Array,
	allocate := false) -> PackedByteArray:

	if not allocate and value.size() == 1:
		match value.size():
			0:
				return _array_0
			1:
				match value[0]:
					0:
						return _array_0
					1:
						return _array_1
	var array := PackedByteArray()
	var i := value.size()
	if i == 0:
		_set_zero(array)
		return array
	var v: int
	while 0 < i:
		i -= 1
		v = value[i]
		if v < 0 or 9 < v:
			push_error("Invalid numeric array: ", value)
			_set_zero(array)
			break
		array.push_back(v)
	_trim_zero(array)
	return array

static func _read_big_int(value: BigInt, allocate := false) -> PackedByteArray:
	assert(value != null)
	var array := value._array
	return array.duplicate() if allocate else array

static func _read(value: Variant, allocate := false) -> PackedByteArray:
	match typeof(value):
		TYPE_INT:
			return _read_int(value, allocate)
		TYPE_STRING:
			return _read_string(value, allocate)
		TYPE_ARRAY:
			return _read_array(value, allocate)
		TYPE_PACKED_BYTE_ARRAY:
			return _read_byte_array(value, allocate)
		TYPE_PACKED_INT32_ARRAY:
			return _read_int32_array(value, allocate)
		TYPE_PACKED_INT64_ARRAY:
			return _read_int64_array(value, allocate)
		TYPE_OBJECT:
			if value is BigInt:
				return _read_big_int(value, allocate)
	assert(false)
	return PackedByteArray()

static func _is_zero(array: PackedByteArray) -> bool:
	return array.size() == 1 and array[0] == 0

static func _is_one(array: PackedByteArray) -> bool:
	return array.size() == 1 and array[0] == 1

static func _trim_zero(array: PackedByteArray, start := -1) -> void:
	var n := start if start != -1 else array.size()
	while 1 < n and array[n - 1] == 0:
		n -= 1
	array.resize(n)

static func _less(array1: PackedByteArray, array2: PackedByteArray) -> bool:
	var n := array1.size()
	var m := array2.size()
	if n != m:
		return n < m
	while 0 < n:
		n -= 1
		if array1[n] != array2[n]:
			return array1[n] < array2[n]
	return false

static func _increment(
	array: PackedByteArray,
	allocate := false) -> PackedByteArray:

	if allocate:
		array = array.duplicate()
	var n := array.size()
	var i := 0
	while i < n and array[i] == 9:
		array[i] = 0
		i += 1
	if i == n:
		array.push_back(1)
	else:
		array[i] += 1
	return array

static func _can_decrement(array: PackedByteArray) -> bool:
	return not _is_zero(array)

static func _decrement(
	array: PackedByteArray,
	allocate := false) -> PackedByteArray:

	if allocate:
		array = array.duplicate()
	if not _can_decrement(array):
		push_error("Underflow.")
		_set_zero(array)
		return array
	var n := array.size()
	var i := 0
	while array[i] == 0 and i < n:
		array[i] = 9
		i += 1
	array[i] -= 1
	if 1 < n and array[n - 1] == 0:
		array.resize(n - 1)
	return array

static func _add(
	array1: PackedByteArray,
	array2: PackedByteArray,
	allocate := false) -> PackedByteArray:

	if allocate:
		array1 = array1.duplicate()
	var n := array1.size()
	var m := array2.size()
	var t := 0
	var i := 0
	var s: int
	if n < m:
		array1.resize(m)
		n = m
	while i < m:
		s = t + array1[i] + array2[i]
		t = s / 10
		array1[i] = s % 10
		i += 1
	while i < n:
		s = t + array1[i]
		t = s / 10
		array1[i] = s % 10
		i += 1
	if 0 < t:
		array1.push_back(t)
	return array1

static func _can_subtract(
	array1: PackedByteArray,
	array2: PackedByteArray) -> bool:

	return not _less(array1, array2)

static func _subtract(
	array1: PackedByteArray,
	array2: PackedByteArray,
	allocate := false) -> PackedByteArray:

	if allocate:
		array1 = array1.duplicate()
	if not _can_subtract(array1, array2):
		push_error("Underflow.")
		_set_zero(array1)
		return array1
	var n := array1.size()
	var m := array2.size()
	var t := 0
	var i := 0
	var s: int
	while i < m:
		s = t + array1[i] - array2[i]
		if s < 0:
			s += 10
			t = -1
		else:
			t = 0
		array1[i] = s
		i += 1
	while i < n:
		s = t + array1[i]
		if s < 0:
			s += 10
			t = -1
		else:
			t = 0
		array1[i] = s
		i += 1
	_trim_zero(array1, n)
	return array1

static func _multiply(
	array1: PackedByteArray,
	array2: PackedByteArray,
	allocate := false) -> PackedByteArray:

	if allocate:
		array1 = array1.duplicate()
	if _is_zero(array1) or _is_zero(array2):
		_set_zero(array1)
		return array1
	var n := array1.size()
	var m := array2.size()
	var i := 0
	var j: int
	var t := 0
	var s: int
	var v: Array[int] = []
	v.resize(n + m)
	while i < n:
		j = 0
		while j < m:
			v[i + j] += array1[i] * array2[j]
			j += 1
		i += 1
	n += m
	array1.resize(v.size())
	i = 0
	while i < n:
		s = t + v[i]
		v[i] = s % 10
		t = s / 10
		array1[i] = v[i]
		i += 1
	_trim_zero(array1, n)
	return array1

static func _can_divide(
	array1: PackedByteArray,
	array2: PackedByteArray) -> bool:

	return not _is_zero(array2)

static func _divide(
	array1: PackedByteArray,
	array2: PackedByteArray,
	allocate := false) -> PackedByteArray:

	if allocate:
		array1 = array1.duplicate()
	if not _can_divide(array1, array2):
		push_error("Division by 0.")
		_set_zero(array1)
		return array1
	if _less(array1, array2) or array1 == array2:
		_set_zero(array1)
		return array1
	var n := array1.size()
	var m := array2.size()
	var i := n - 1
	var j := 0
	var k: int
	var t := _array_0.duplicate()
	var u: PackedByteArray
	var v := PackedByteArray()
	v.resize(n)
	while true:
		u = _multiply(t, _array_10, true)
		u = _add(u, _read_int(array1[i]))
		if not _less(u, array2):
			break
		t = u
		i -= 1
	while 0 <= i:
		t = _multiply(t, _array_10)
		t = _add(t, _read_int(array1[i]))
		k = 9
		while true:
			u = _multiply(array2, _read_int(k), true)
			if not _less(t, u):
				break
			k -= 1
		t = _subtract(t, u)
		v[j] = k
		i -= 1
		j += 1
	i = 0
	while i < j:
		array1[i] = v[j - i - 1]
		i += 1
	array1.resize(j)
	return array1

static func _modulo(
	array1: PackedByteArray,
	array2: PackedByteArray, allocate := false) -> PackedByteArray:

	if not _can_divide(array1, array2):
		push_error("Division by 0.")
		if allocate:
			array1 = _array_0.duplicate()
		else:
			_set_zero(array1)
		return array1
	if _less(array1, array2):
		if allocate:
			array1 = array1.duplicate()
		return array1
	if array1 == array2:
		if allocate:
			array1 = _array_0.duplicate()
		else:
			_set_zero(array1)
		_set_zero(array1)
		return array1
	var n := array1.size()
	var m := array2.size()
	var i := n - 1
	var j := 0
	var k: int
	var t := _array_0.duplicate()
	var u: PackedByteArray
	var v := PackedByteArray()
	v.resize(n)
	while true:
		u = _multiply(t, _array_10, true)
		u = _add(u, _read_int(array1[i]))
		if not _less(u, array2):
			break
		t = u
		i -= 1
	while 0 <= i:
		t = _multiply(t, _array_10)
		t = _add(t, _read_int(array1[i]))
		k = 9
		while true:
			u = _multiply(array2, _read_int(k), true)
			if not _less(t, u):
				break
			k -= 1
		t = _subtract(t, u)
		v[j] = k
		i -= 1
		j += 1
	return t

func _init(array: PackedByteArray) -> void:
	assert(not array.is_empty())
	_array = array

func _to_string() -> String:
	var s := ""
	var i := _array.size()
	while 0 < i:
		i -= 1
		s += str(_array[i])
	return s
