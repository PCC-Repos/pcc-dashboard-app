class_name L
#Used for printing text to the stdout fast

# Debug print
static func debug(a, b="", c="", d="", e="", f=""):
	var arr = PoolStringArray([str(a)])
	if b: arr.append(str(b))
	if c: arr.append(str(c))
	if d: arr.append(str(d))
	if e: arr.append(str(e))
	if f: arr.append(str(f))

	printerr("DEBUG::", arr.join("::"))

# Normal print
static func print(a, b="", c="", d="", e="", f=""):
	var arr = PoolStringArray([str(a)])
	if b: arr.append(str(b))
	if c: arr.append(str(c))
	if d: arr.append(str(d))
	if e: arr.append(str(e))
	if f: arr.append(str(f))

	print(arr.join("::"))
