<!-- TOC -->

- [🚀 Quick start](#-quick-start)
- [✨ Features](#-features)
- [🖥️ Setup Instructions](#-setup-instructions)
	- [Install Lua](#1-install-lua)
	- [Install Visual Studio Code and Lua Debug](#2-install-visual-studio-code-and-lua-debug)
- [🐞 Debugging in VS Code](#-debugging-in-vs-code)
- [📁 Project Structure Example](#-project-structure-example)
- [🧪 Simple Example](#-simple-example)
- [🛠️ Plans / Ideas](#-ideas)

<!-- /TOC -->

# mw-mock

Minimal implementation of the `mw` object for testing and debugging Wikipedia Lua modules **outside of MediaWiki**.

> ⚠️ This is a lightweight mock. It is not complete or production-safe — intended for **development and debugging only**.

<a id="-quick-start" name="-quick-start"></a>
## 🚀 Quick start

First add a module to your repo:
```bash
# add to your repo
git submodule add https://github.com/Eccenux/wiki-lua-mw-mock.git mw
# commit the change
git commit -am "Add 'mw' submodule"
```
There are many other ways. Like e.g.: download zip of this repo an unzip to "mw" subdirectory, download once and create a symlink (Unix) or junction (Windows).

Quick example:
```lua
-- include this library
local mw = require("mw/mw")

-- replace require to support namespace removal
local originalRequire = require
function require(moduleName)
	moduleName = moduleName:gsub("Modu[^:]+:", "")
	return originalRequire(moduleName)
end

-- Load a copy of a module
-- Note that this loads "Piechart.lua" file (a local file).
local p = require('Module:Piechart')
local json_data = '[{"label": "k: $v", "value": 33.1}, {"label": "m: $v", "value": -1}]'
local html = p.renderPie(json_data)
mw.logObject(html)
```

<a id="-features" name="-features"></a>
## ✨ Features

- Implements a minimal `mw` table with placeholders for:
	- `mw.log`, `mw.logObject`
	- `mw.text`
	- `mw.ustring` (proxy to `string`)
- Useful for writing and testing Lua modules locally before deploying to Wikipedia or Wikidata.
- Pure Lua — no dependencies.

<a id="-setup-instructions" name="-setup-instructions"></a>
## 🖥️ Setup Instructions

### 1. Install Lua

After this `lua` and `luac` should be available in your terminal.

### 1a) Lua on Windows
Install Lua on Windows using [Scoop](https://scoop.sh).

If you don’t have Scoop yet:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

Then install Lua:
```powershell
scoop install lua
```

### 1b) Lua on MacOS

Install [Homebrew](https://brew.sh/).

Then install Lua:
```bash
brew update
brew install lua
```

### 2. Install Visual Studio Code and Lua Debug

Install [Visual Studio Code](https://code.visualstudio.com/).

Install the Lua Debug extension by **actboy168**:
```text
Extension ID: actboy168.lua-debug
```

<a id="-debugging-in-vs-code" name="-debugging-in-vs-code"></a>
## 🐞 Debugging in VS Code

1. Create a `.vscode/launch.json`:

	```json
	{
		"version": "0.2.0",
		"configurations": [
			{
				"type": "lua",
				"request": "launch",
				"name": "Launch Lua script",
				"program": "${workspaceFolder}/_test.lua"
			}
		]
	}
	```

2. Create a test file, e.g. `_test.lua`:

	```lua
	mw = require("mw") -- your mock

	mw.log("Hello from mock mw!")
	mw.logObject({ foo = "bar", nested = { a = 1 } })
	```

3. Set breakpoints, hit F5 to debug.

<a id="-project-structure-example" name="-project-structure-example"></a>
## 📁 Project Structure Example

```
lua-wiki/
│
├── mw/
│   ├── mw.lua             -- mw entry point
│   ├── text.lua           -- mw.text mock
│   ├── ustring.lua        -- mw.ustring proxy
|   ...
├── _test.lua              -- your dev entry point
```

<a id="-simple-example" name="-simple-example"></a>
## 🧪 Simple Example

```lua
-- _test.lua
require("mw")

local data = {
	title = "Example",
	ns = 0,
	isTalk = false,
}

mw.logObject(data)
```

<a id="-ideas" name="-ideas"></a>
## 🛠️ Plans / Ideas

- Add more realistic implementations (e.g. Unicode support in `mw.ustring`).
- Other mocks/implementations?
- Optional strict mode to catch unexpected fields.

