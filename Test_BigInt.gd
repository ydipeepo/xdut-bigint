extends MarginContainer

#-------------------------------------------------------------------------------
#	METHODS
#-------------------------------------------------------------------------------

func test_from() -> void:
	for i: int in 500:
		var n := randi()
		var b := BigInt.from(n)
		assert(b.equals(n))
	for i: int in 500:
		var n := randi()
		var b := BigInt.from(str(n))
		assert(b.equals(n))
	for i: int in 500:
		var n := randi()
		var a := Array(str(n).split("")).map(func (c: String) -> int: return int(c))
		var b := BigInt.from(a)
		assert(b.equals(n))
	for i: int in 500:
		var n := randi()
		var a := PackedByteArray(Array(str(n).split("")).map(func (c: String) -> int: return int(c)))
		var b := BigInt.from(a)
		assert(b.equals(n))
	for i: int in 500:
		var n := randi()
		var a := PackedInt32Array(Array(str(n).split("")).map(func (c: String) -> int: return int(c)))
		var b := BigInt.from(a)
		assert(b.equals(n))
	for i: int in 500:
		var n := randi()
		var a := PackedInt64Array(Array(str(n).split("")).map(func (c: String) -> int: return int(c)))
		var b := BigInt.from(a)
		assert(b.equals(n))

	%From.button_pressed = true

func test_upper() -> void:
	for i: int in 1000:
		var n := randi()
		var b := BigInt.from(n)
		var d := int(log(n) / log(10.0)) + 1
		for j: int in b.digits:
			assert(b.upper(j) == n / int(pow(10.0, b.digits - j - 1)) % 10)

	%Upper.button_pressed = true

func test_lower() -> void:
	for i: int in 1000:
		var n := randi()
		var b := BigInt.from(n)
		for j: int in int(log(i) / log(10.0)) + 2:
			assert(b.lower(j) == n / int(pow(10.0, j)) % 10)

	%Lower.button_pressed = true

func test_equals() -> void:
	for i: int in 1000:
		var n := randi()
		var b := BigInt.from(n)
		assert(b.equals(n))
	for i: int in 1000:
		var n := randi()
		var m := randi()
		var b := BigInt.from(n)
		assert(n == m or not b.equals(m))
	for i: int in 1000:
		var n := randi()
		var m := randi()
		var b := BigInt.from(n)
		assert(n == m or not b.equals(m)) 
	
	%Equals.button_pressed = true

func test_less() -> void:
	for i: int in 2000:
		var n := randi()
		var m := randi()
		var b := BigInt.from(n)
		assert(n >= m or b.less(m))

	%Less.button_pressed = true

func test_increment() -> void:
	for i: int in 2000:
		var n := i
		var m := i + 1
		var b := BigInt.from(n)
		assert(b.increment().equals(m))

	%Increment.button_pressed = true

func test_decrement() -> void:
	for i: int in 2000:
		var n := i
		var m := i - 1
		var b := BigInt.from(n)
		if b.can_decrement():
			assert(b.decrement().equals(m))

	%Decrement.button_pressed = true

func test_add() -> void:
	for i: int in 2000:
		var n := randi_range(0, 0xFFFF)
		var m := randi_range(0, 0xFFFF)
		var a := BigInt.from(n)
		var b := BigInt.from(m)
		assert(a.add(b).equals(n + m))

	%Add.button_pressed = true

func test_subtract() -> void:
	for i: int in 2000:
		var n := randi_range(0, 0xFFFF)
		var m := randi_range(0, 0xFFFF)
		var a := BigInt.from(n)
		var b := BigInt.from(m)
		if a.can_subtract(b):
			assert(a.subtract(b).equals(n - m))

	%Subtract.button_pressed = true

func test_multiply() -> void:
	for i: int in 2000:
		var n := randi_range(0, 0xFFFF)
		var m := randi_range(0, 0xFFFF)
		var a := BigInt.from(n)
		var b := BigInt.from(m)
		assert(a.multiply(b).equals(n * m))

	%Multiply.button_pressed = true

func test_divide() -> void:
	for i: int in 1000:
		var n := randi_range(0, 0xFFFF)
		var m := randi_range(0, 0xFFFF)
		var a := BigInt.from(n)
		var b := BigInt.from(m)
		if a.can_divide(b):
			assert(a.divide(b).equals(n / m))

	%Divide.button_pressed = true

func test_modulo() -> void:
	for i: int in 1000:
		var n := randi_range(0, 0xFFFF)
		var m := randi_range(0, 0xFFFF)
		var a := BigInt.from(n)
		var b := BigInt.from(m)
		if a.can_divide(b):
			assert(a.modulo(b).equals(n % m))

	%Modulo.button_pressed = true

func test_to_string() -> void:
	for i: int in 1000:
		var n := randi()
		var b := BigInt.from(n)
		assert(str(b) == str(n))

	%ToString.button_pressed = true

func test_to_int() -> void:
	for i: int in 1000:
		var n := randi()
		var b := BigInt.from(n)
		assert(b.to_int() == n)

	%ToInt.button_pressed = true

func test_si_formatter() -> void:
	var f := BigIntSIFormatter.new()
	
	assert(BigInt.from("123").format(f) == "123")
	assert(BigInt.from("1234").format(f) == "1234")
	assert(BigInt.from("123456").format(f) == "123456")
	assert(BigInt.from("1234567").format(f) == "1234567")

	f.unit_adjustment = true
	f.unit_adjustment_precision = BigIntSIFormatter.DECIMAL_PRECISION_AUTO
	f.use_kilo_unit = true

	assert(BigInt.from("123").format(f) == "123")
	assert(BigInt.from("1234").format(f) == "1k")
	assert(BigInt.from("123456").format(f) == "123k")
	assert(BigInt.from("1234567").format(f) == "1M")

	f.digit_separator = BigIntSIFormatter.DIGIT_SEPARATOR_COMMA

	assert(BigInt.from("123").format(f) == "123")
	assert(BigInt.from("1234").format(f) == "1.234k")
	assert(BigInt.from("123456").format(f) == "123.456k")
	assert(BigInt.from("1234567").format(f) == "1.234M")

	%BigIntSIFormatter.button_pressed = true

func test_short_form_formatter() -> void:
	var f := BigIntShortFormFormatter.new()
	
	assert(BigInt.from("123").format(f) == "123")
	assert(BigInt.from("1234").format(f) == "1234")
	assert(BigInt.from("123456").format(f) == "123456")
	assert(BigInt.from("1234567").format(f) == "1234567")

	f.unit_adjustment = true
	f.unit_adjustment_precision = BigIntShortFormFormatter.DECIMAL_PRECISION_AUTO

	assert(BigInt.from("123").format(f) == "123")
	assert(BigInt.from("1234").format(f) == "1Thousand")
	assert(BigInt.from("123456").format(f) == "123Thousand")
	assert(BigInt.from("1234567").format(f) == "1Million")

	f.digit_separator = BigIntShortFormFormatter.DIGIT_SEPARATOR_COMMA

	assert(BigInt.from("123").format(f) == "123")
	assert(BigInt.from("1234").format(f) == "1.234Thousand")
	assert(BigInt.from("123456").format(f) == "123.456Thousand")
	assert(BigInt.from("1234567").format(f) == "1.234Million")

	%BigIntShortFormFormatter.button_pressed = true

func test_long_form_formatter() -> void:
	var f := BigIntLongFormFormatter.new()
	
	assert(BigInt.from("123").format(f) == "123")
	assert(BigInt.from("1234").format(f) == "1234")
	assert(BigInt.from("123456").format(f) == "123456")
	assert(BigInt.from("1234567").format(f) == "1234567")

	f.unit_adjustment = true
	f.unit_adjustment_precision = BigIntLongFormFormatter.DECIMAL_PRECISION_AUTO

	assert(BigInt.from("123").format(f) == "123")
	assert(BigInt.from("1234").format(f) == "1Thousand")
	assert(BigInt.from("123456").format(f) == "123Thousand")
	assert(BigInt.from("1234567").format(f) == "1Million")

	f.digit_separator = BigIntLongFormFormatter.DIGIT_SEPARATOR_COMMA

	assert(BigInt.from("123").format(f) == "123")
	assert(BigInt.from("1234").format(f) == "1.234Thousand")
	assert(BigInt.from("123456").format(f) == "123.456Thousand")
	assert(BigInt.from("1234567").format(f) == "1.234Million")

	%BigIntLongFormFormatter.button_pressed = true

func test_japanese_formatter() -> void:
	var f := BigIntJapaneseFormatter.new()
	
	assert(BigInt.from("123").format(f) == "123")
	assert(BigInt.from("1234").format(f) == "1234")
	assert(BigInt.from("123456").format(f) == "123456")
	assert(BigInt.from("1234567").format(f) == "1234567")

	f.unit_adjustment = true
	f.unit_adjustment_precision = BigIntJapaneseFormatter.DECIMAL_PRECISION_AUTO

	assert(BigInt.from("123").format(f) == "123")
	assert(BigInt.from("1234").format(f) == "1234")
	assert(BigInt.from("123456").format(f) == "12万")
	assert(BigInt.from("1234567").format(f) == "123万")

	f.digit_separator = BigIntJapaneseFormatter.DIGIT_SEPARATOR_COMMA_MYRIADS

	assert(BigInt.from("123").format(f) == "123")
	assert(BigInt.from("1234").format(f) == "1234")
	assert(BigInt.from("123456").format(f) == "12.3456万")
	assert(BigInt.from("1234567").format(f) == "123.4567万")

	%BigIntJapaneseFormatter.button_pressed = true

func test_taiwanese_formatter() -> void:
	var f := BigIntTaiwaneseFormatter.new()
	
	assert(BigInt.from("123").format(f) == "123")
	assert(BigInt.from("1234").format(f) == "1234")
	assert(BigInt.from("123456").format(f) == "123456")
	assert(BigInt.from("1234567").format(f) == "1234567")

	f.unit_adjustment = true
	f.unit_adjustment_precision = BigIntTaiwaneseFormatter.DECIMAL_PRECISION_AUTO

	assert(BigInt.from("123").format(f) == "123")
	assert(BigInt.from("1234").format(f) == "1234")
	assert(BigInt.from("123456").format(f) == "12萬")
	assert(BigInt.from("1234567").format(f) == "123萬")

	f.digit_separator = BigIntTaiwaneseFormatter.DIGIT_SEPARATOR_COMMA_MYRIADS

	assert(BigInt.from("123").format(f) == "123")
	assert(BigInt.from("1234").format(f) == "1234")
	assert(BigInt.from("123456").format(f) == "12.3456萬")
	assert(BigInt.from("1234567").format(f) == "123.4567萬")

	%BigIntTaiwaneseFormatter.button_pressed = true

func test_chinese_formatter() -> void:
	var f := BigIntChineseFormatter.new()
	
	assert(BigInt.from("123").format(f) == "123")
	assert(BigInt.from("1234").format(f) == "1234")
	assert(BigInt.from("123456").format(f) == "123456")
	assert(BigInt.from("1234567").format(f) == "1234567")

	f.unit_adjustment = true
	f.unit_adjustment_precision = BigIntChineseFormatter.DECIMAL_PRECISION_AUTO

	assert(BigInt.from("123").format(f) == "123")
	assert(BigInt.from("1234").format(f) == "1234")
	assert(BigInt.from("123456").format(f) == "12万")
	assert(BigInt.from("1234567").format(f) == "123万")

	f.digit_separator = BigIntChineseFormatter.DIGIT_SEPARATOR_COMMA_MYRIADS

	assert(BigInt.from("123").format(f) == "123")
	assert(BigInt.from("1234").format(f) == "1234")
	assert(BigInt.from("123456").format(f) == "12.3456万")
	assert(BigInt.from("1234567").format(f) == "123.4567万")

	%BigIntChineseFormatter.button_pressed = true

#-------------------------------------------------------------------------------

var _test_array: Array[Callable] = [
	# 1.0.0
	test_from,
	test_upper,
	test_lower,
	test_equals,
	test_less,
	test_increment,
	test_decrement,
	test_add,
	test_subtract,
	test_multiply,
	test_divide,
	test_modulo,
	test_to_string,
	test_to_int,
	
	# 1.1.0
	test_si_formatter,
	test_short_form_formatter,
	test_long_form_formatter,
	test_japanese_formatter,
	test_taiwanese_formatter,
	test_chinese_formatter,
]

func _ready() -> void:
	for i: int in _test_array.size():
		%Status.text = "テストを実行中... (%d/%d)" % [i + 1, _test_array.size()]
		await _test_array[i].call()
	%Status.text = "全てのテストを通過。"
