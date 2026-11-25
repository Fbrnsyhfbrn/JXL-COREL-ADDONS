<div align="center">

# JXL Novorius
**Multi-Format JPEG XL (`.jxl`) Extension & Converter for CorelDRAW**

[![Platform](https://img.shields.io/badge/Platform-Windows%20x64%20%7C%20macOS-blue?style=for-the-badge)](#architecture-by-operating-system)
[![CorelDRAW](https://img.shields.io/badge/CorelDRAW-X7%20to%202026%20(v17–v27)-00A859?style=for-the-badge)](#coreldraw-compatibility-windows-x64)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-red?style=for-the-badge)](https://www.gnu.org/licenses/agpl-3.0)
[![Status](https://img.shields.io/badge/Build-Experimental%20%2F%20Vibe%20Coded-orange?style=for-the-badge)](#testing--validation-status)
[![Engine](https://img.shields.io/badge/Engine-Python%203.12%20%2B%20C%2B%2B%2FWPF-blueviolet?style=for-the-badge)](#project-structure--development)

*Bring modern **JPEG XL (`.jxl`)** image support directly into your CorelDRAW workflow—without modifying or breaking your existing installation.*

</div>

---

> [!IMPORTANT]
> **Format Support Disclaimer:**
> **GIF and TTF formats are not supported yet.** They may be considered for a future update if time permits, so please stick to the supported raster formats for now.

---

## Why JXL Novorius?

**JPEG XL (`.jxl`)** delivers dramatically smaller file sizes while preserving sharp image fidelity and alpha transparency compared to legacy formats. However, native support across older and current CorelDRAW releases remains limited.

**JXL Novorius** bridges that gap, allowing you to import and convert `.jxl` files seamlessly in your design projects. Built through *vibe coding* and AI-assisted development, it expands upon the user-tested **JLX Converter v0.4.1** host architecture.

---

## Architecture by Operating System

Because Windows and macOS expose completely different extensibility APIs in CorelDRAW, JXL Novorius adapts its architecture to each platform:

| Feature | Windows (x64) | macOS (Apple Silicon & Intel) |
| :--- | :--- | :--- |
| **Application Type** | **Native CorelDRAW Docker Add-on** (C++ / WPF) | **Standalone Local Desktop Launcher** (Python / Tk) |
| **CorelDRAW Integration** | Embedded natively inside CorelDRAW as a Docker panel (`Programs64\Addons`) | **Not** a native add-on or inspector; runs as an independent local desktop app |
| **Canvas Import Workflow** | Drag-and-drop directly into the Novorius panel to place into the active document | Generates ready-to-import images + an `Import-1.js` bridge for the *Scripts Inspector* |
| **Testing Status** | v0.5.1 baseline user-tested on CorelDRAW 2026; `v0.6.0-compat` multi-version installer is experimental | Experimental (`v0.5.1-macos-alpha`); untested on physical Mac hardware |

---

## CorelDRAW Compatibility (Windows x64)

The `v0.6.0-compat` installer inspects executable PE headers and CorelDRAW SDK versions on your machine before compiling. If an SDK path is ambiguous, the installer refuses to borrow a newer SDK to prevent memory or ABI mismatches.

| CorelDRAW Release | SDK Major | Installer Target Group | Readiness Status |
| :--- | :---: | :--- | :--- |
| **CorelDRAW 2026** | `27` | **Standard Build (Non-Legacy)** — Selected via its specific list index | User-Tested (v0.5.1 Baseline) |
| **CorelDRAW 2025** | `26` | **Under Corel 2026** — Included in the 2025-and-older batch option | Candidate |
| **CorelDRAW 2024** | `25` | **Under Corel 2026** — Included in the 2025-and-older batch option | Candidate |
| **CorelDRAW 2022–2023** | `24` | **Under Corel 2026** — Included in the 2025-and-older batch option | Candidate |
| **CorelDRAW 2021** | `23` | **Under Corel 2026** — Included in the 2025-and-older batch option | Candidate |
| **CorelDRAW 2020** | `22` | **Under Corel 2026** — Included in the 2025-and-older batch option | Candidate |
| **CorelDRAW 2019** | `21` | **Under Corel 2026** — Included in the 2025-and-older batch option | Candidate |
| **CorelDRAW 2018** | `20` | **Under Corel 2026 (Legacy)** — Experimental legacy support | Experimental Legacy |
| **CorelDRAW 2017** | `19` | **Under Corel 2026 (Legacy)** — Experimental legacy support | Experimental Legacy |
| **CorelDRAW X8** | `18` | **Under Corel 2026 (Legacy)** — Experimental legacy support | Experimental Legacy |
| **CorelDRAW X7** | `17` | **Under Corel 2026 (Legacy)** — Experimental legacy support | Experimental Legacy |
| **CorelDRAW X6 / x86 / ARM64** | `—` | Unsupported | Out of Scope |

> **Note on Batch Option (`A`):**
> Inside the installer prompt, pressing **`A` (All detected eligible versions older than 2026)** targets **CorelDRAW 2025 (v26) and below** exclusively. To install on **CorelDRAW 2026 (v27)**, select its specific index number from the detected list.

---

## Windows Installation ( Manual installation )

Rather than copying pre-built binaries, the Novorius installer **compiles the engine and C++/WPF assemblies locally** against your exact CorelDRAW SDK, verifies the decoder, and automatically injects the add-on into your CorelDRAW installation directory.

### 1. Required Build Dependencies
Ensure the following tools are installed on your PC before running the installer:
* **Python 3.12 (x64)**
* **Visual Studio 2022 Build Tools** — make sure both **Desktop development with C++ (x64)** and **Windows SDK** workloads are selected.
* **.NET Framework 4.x**
* **CorelDRAW x64** (the target version you wish to inject)

### 2. Installation Steps
1. **Close all running CorelDRAW windows.**
2. Extract the JXL Novorius ZIP archive to a permanent local folder.
3. Right-click **`INSTALL.bat`** and choose **Run as administrator**.
   > *Administrator privileges are required so the script can build the components and automatically inject them into `Programs64\Addons\JXLNovorius`.*
4. When prompted with the list of detected CorelDRAW installations:
   * Enter a **list index number** to install on a single target version (e.g., CorelDRAW 2026).
   * Enter **`A`** to batch-install across all detected versions **older than CorelDRAW 2026 (v25 and below)**.
5. Launch CorelDRAW. The **Novorius Docker** panel is requested automatically on startup, or can be opened manually via **`Window > Dockers`**.

**Custom Directory Installation (64-bit PowerShell as Administrator):**
```powershell
.\install.ps1 -CorelPrograms 'D:\CorelDRAW\Programs64'
```

**Helper Utilities:**
* **`CHECK.bat`** — Run this diagnostic script if the Docker panel fails to load to inspect build logs, paths, and version bindings.
* **`UNINSTALL.bat`** — Cleanly removes only JXL Novorius without affecting *JLX Converter* if installed side-by-side.

---
## Windows Installation (Automatic installation)
JXL Novorius – Installation Guide

Installation instructions for JXL Novorius v0.6.1 on CorelDRAW 2026 (Windows).

Please follow each step in the correct order to ensure a successful installation.

1. Install Dependencies (Required)

Before installing JXL Novorius, you must install the required dependencies.

Steps:

1. Download the dependency package:
   
   "Download JXL Dependency Requirements" (https://release-assets.githubusercontent.com/github-production-release-asset/1471908119/3f6a71ef-caa2-4aa7-8805-b48fc6264ee1?sp=r&sv=2018-11-09&sr=b&spr=https&se=2026-11-25T17%3A15%3A28Z&rscd=attachment%3B+filename%3DJXL-Dependency-Requirements-fix.zip&rsct=application%2Foctet-stream&skt=2025-11-25T16%3A14%3A59Z&ske=2025-11-25T17%3A15%3A28Z&sig=DqJGXHCN6gHZjmUJsA31l%2Fg4BUaPKQfHKagdyZSd%2F%2FY%3D)

2. Extract the downloaded ZIP file.

3. Open the extracted folder.

4. Run the Install file.

5. When the installation menu appears, select Option 2.

6. Wait for the dependency installation process to complete.

Make sure the dependency installation finishes successfully before proceeding.

2. Install JXL Novorius

Once all dependencies have been installed, proceed with the main plugin installation.

Steps:

1. Download JXL Novorius v0.6.1:
   
   "Download JXL Novorius v0.6.1" (https://release-assets.githubusercontent.com/github-production-release-asset/1471908119/e7be5472-e8c8-482b-ba12-345d5f0d3438?sp=r&sv=2018-11-09&sr=b&spr=https&se=2026-11-25T17%3A15%3A28Z&rscd=attachment%3B+filename%3DJXL-Novorius-v0.6.1-buildfix.For.Under.Corel.2026.zip&rsct=application%2Foctet-stream&skt=2025-11-25T16%3A14%3A59Z&ske=2026-11-25T17%3A15%3A28Z&sig=cwwaIcprddaAXXOMSeMJG6%2BvvsyJxmaI1YccW6O7eAc%3D)

2. Extract the downloaded ZIP file.

3. Open the extracted folder.

4. Locate the Install file.

5. Right-click the file and select Run as administrator.

6. If Windows displays a User Account Control (UAC) prompt, click Yes to grant administrator permissions.

7. Follow the installation process and wait until it is complete.

3. Finish & Launch CorelDRAW

After completing both installation stages:

1. Launch or restart CorelDRAW 2026.
2. Check whether JXL Novorius is available under Extensions or its designated plugin location.
3. If the plugin appears, the installation is complete and JXL Novorius is ready to use.

---

Installation Checklist

- [ ] Download JXL Dependency Requirements.
- [ ] Extract the dependency ZIP file.
- [ ] Run Install and select Option 2.
- [ ] Wait for the dependency installation to complete.
- [ ] Download JXL Novorius v0.6.1.
- [ ] Extract the plugin ZIP file.
- [ ] Run Install as administrator.
- [ ] Launch CorelDRAW 2026 and verify that the plugin is available.

Important: Do not skip the dependency installation stage. All required dependencies must be installed before installing JXL Novorius.

JXL Novorius v0.6.1 | CorelDRAW 2026 | Windows x64

## macOS Installation & Usage (Local Launcher)

On macOS, JXL Novorius runs as a **standalone local desktop application**, completely separate from CorelDRAW's internal plugin host.

### 1. Setup & Launch
1. Install **Python 3.12** (with Tk GUI support included) from [python.org](https://www.python.org/downloads/macos/).
2. *(Optional but recommended)* If the Python Pillow JXL binding is unavailable for your Mac architecture, install the official decoder via Homebrew:
   ```bash
   brew install jpeg-xl
   ```
   *(You can then select `djxl` as the backend inside the app).*
3. Open **Terminal**, navigate to the extracted project directory, and run:
   ```bash
   bash INSTALL.command
   bash OPEN.command
   ```

### 2. Importing into CorelDRAW Mac
1. In the local Novorius desktop app, select **Prepare Corel import**, add your `.jxl` files, and click process.
2. Click **Open generated Corel script folder** to view the staged job files (stored in `~/Library/Application Support/JXLNovorius/Jobs`).
3. Open your document in **CorelDRAW Mac**, then open **`Window > Inspectors > Scripts`** (or `File > Scripts > Scripts`).
4. Load and run **`Import-1.js`** from the generated job folder. The script calls `Layer.ImportEx` and verifies that the bitmap shape count increases on the active layer.
   > *Do not delete the temporary job folder until the import completes inside CorelDRAW.*

---

## Key Features & Format Support

| Feature / Format | Behavior & Technical Details |
| :--- | :--- |
| **Canvas Import (Windows)** | Drag-and-drop one or more `.jxl` files into the dark Novorius panel to import static lossless PNG bitmaps directly into the active document. *(Direct canvas drop and `Ctrl+I` filter are not supported).* |
| **PNG & TIFF** | Preserves full alpha transparency, ICC color profiles, and physical DPI metadata where supported by the encoder. |
| **WebP** | Supports alpha transparency and adjustable quality. Setting quality to **`100`** automatically enables **lossless** encoding. |
| **JPG & BMP** | Alpha transparency is flattened onto a solid white background. JPG compression quality is adjustable via slider. |
| **GIF & TTF** | **Not Supported Yet.** Currently unimplemented; may be added in a future update if time permits. |
| **Animated JXL** | **Experimental** for export (depends on the Python decoder exposing all frames and timing). Canvas import rejects multi-frame inputs. |
| **Non-Destructive Saving** | *Save converted files beside originals* automatically generates unique filenames and never overwrites existing files. |

---

## Live Diagnostics & CLI Usage

### Live Conversion Log
The Novorius UI features a collapsible live log with copy and clear-view controls (*Clear view* only clears the UI display and does not erase the disk log).
* **Windows Log Path:** `%LOCALAPPDATA%\JXLNovorius\conversion.log`
* **macOS Log Path:** `~/Library/Logs/JXLNovorius/conversion.log`
* *Note: Logs record local filenames and directory paths. Please review and redact sensitive paths before sharing logs publicly.*

### Command Line Interface (CLI)
You can also run batch conversions directly from the command line without launching the GUI:

```bash
# Windows (Command Prompt / PowerShell)
novorius.exe export input.jxl output.webp --format webp --quality 95

# macOS (Terminal)
.venv/bin/python engine/deck.py export input.jxl output.jpg --format jpg --quality 95 --live

# macOS using Homebrew djxl fallback backend
.venv/bin/python engine/deck.py export input.jxl output.png --format png --backend djxl
```

---

## Testing & Validation Status

This project is released transparently as experimental software:
* **Windows:** The `v0.5.1` runtime baseline has been user-tested on **CorelDRAW 2026** (specifically JPG quality 100 export and live diagnostics). However, the `v0.6.0-compat` multi-version installer and target versions older than 2026 require live testing on target machines.
* **macOS:** Automated regression tests were executed in Linux using a substitute FFmpeg/libjxl adapter and a mocked CorelDRAW JS host. Testing on physical Apple Silicon / Intel Macs with CorelDRAW 2026 Mac is still pending.

---

## Project Structure & Development

For contributors working on separate branches:

| Path | Description |
| :--- | :--- |
| `host/DockerUI.cs` | WPF user interface layout for the Windows Docker panel. |
| `host/startup.cpp` | Native CPG startup host that loads the Docker inside CorelDRAW (Windows). |
| `host/*.xslt` | UI menu registration transforms for CorelDRAW (Windows). |
| `engine/tools/export.py` | Multi-format image encoder implementation. |
| `app.py` | Standalone Tk desktop launcher interface (macOS). |
| `corel/import-template.js` | JavaScript bridge template for CorelDRAW Mac *Scripts Inspector* imports. |

---

## License & Attribution

* **License:** This project is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**. See the `LICENSE` file or visit [gnu.org/licenses/agpl-3.0](https://www.gnu.org/licenses/agpl-3.0) for full terms regarding usage, modification, and distribution.
* **Third-Party Notices:** See `NOTICE` for third-party library attributions.