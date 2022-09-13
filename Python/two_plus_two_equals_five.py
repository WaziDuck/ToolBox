import ctypes


class IntObject(ctypes.Structure):
    _fields_ = [
        ("ob_refcnt", ctypes.c_int64),
        ("ob_type", ctypes.py_object),
        ("ob_size", ctypes.c_int64),
        ("ob_digit", ctypes.c_uint32)
    ]


ctypes.cast(id(5), ctypes.POINTER(IntObject))[0].ob_digit = 4
print(2 + 2 == 5)
