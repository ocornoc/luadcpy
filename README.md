# Overview
The dcpy Lua (5.1) library is a library containing functions for customizable deep copying of tables. A table of 3 functions is returned when requiring this file.

---

* **`basic( t )`**

This function is a basic deep copy. The original metatables are applied to values and keys remain their originals whilst values are recursively deep copied. This function is defined as

```Lua
basic = create{
	["recursive"] = true,
	["copymts"] = true,
	["inckeys"] = false,
	["incmts"] = false
}
```

---

* **`shallow( t )`**

This function is a basic shallow copy. The original metatable is not applied to values and keys remain their originals whilst values are non-recursively copied. This function is defined as

```Lua
shallow = create{
	["recursive"] = false,
	["copymts"] = false,
	["inckeys"] = false,
	["incmts"] = false
}
```
---

* **`create( t )`**

This function creates and returns copying functions. The input table **`t`** determines what copy function is returned. All fields are treated as booleans. The format for the input table is as follows:

|Key|Description|
|-|-|
|`"recursive"`|Determines whether the function is recursive or not.|
|`"copymts"`|Determines if table values, when copied, have their metatables copied to them, too. Without `"incmts"` being true, this "copy" is actually just the original metatable.|
|`"inckeys"`|Determines whether keys are included in the copying process. If they are, keys are treated just as values are and are copied in the same way.|
|`"incmts"`|Determines whether metatables, when copied, use the original (when `== false`) or a copy (when `== true`). Copied metatables are copied in the same way as  values.|
