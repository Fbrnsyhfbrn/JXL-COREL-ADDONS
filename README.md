JXL Novorius

JPEG XL Integration for CorelDRAW

<p align="center">
  <img src="https://img.shields.io/badge/Windows-CorelDRAW%20Docker-2563eb?style=flat-square">
  <img src="https://img.shields.io/badge/macOS-Standalone%20Launcher-64748b?style=flat-square">
  <img src="https://img.shields.io/badge/Format-JPEG%20XL-8b5cf6?style=flat-square">
  <img src="https://img.shields.io/badge/Status-Experimental-f59e0b?style=flat-square">
</p><p align="center">
  <i>One format. Two platforms. Different integration approaches.</i>
</p>---

Overview

JXL Novorius is an experimental, AI-assisted project bringing JPEG XL (".jxl") conversion and workflow integration to CorelDRAW on Windows and macOS.

It provides two platform-specific implementations:

Windows| macOS
Native CorelDRAW Docker| Standalone desktop launcher
CPG + WPF integration| Python-based application
Automatic add-on deployment| Local installation
Direct document import| Manual JavaScript import bridge

«Important: The macOS edition is not a native CorelDRAW extension. It does not install a Docker, register an add-on, or inject code into CorelDRAW.»

Architecture

Windows

CorelDRAW
    |
    v
Native CPG Startup Host
    |
    v
Novorius Docker (WPF)
    |
    v
Python Conversion Engine
    |
    v
JPEG XL Decoder
    |
    v
Pillow / Output Encoders
    |
    v
PNG / JPG / WebP / TIFF / GIF / BMP

macOS

macOS
    |
    v
Standalone Tk Application
    |
    v
Python Conversion Engine
    |
    v
Pillow / libjxl / djxl
    |
    v
Converted Image
    |
    v
Generated JavaScript Bridge
    |
    v
CorelDRAW Scripts Inspector

Compatibility

Windows

CorelDRAW| SDK Major| Compatibility
2026| 27| Dedicated build
2025| 26| Experimental
2024| 25| Experimental
2022–2023| 24| Experimental
2021| 23| Experimental
2020| 22| Experimental
2019| 21| Experimental
2018| 20| Legacy experimental
2017| 19| Legacy experimental
X8| 18| Legacy experimental
X7| 17| Legacy experimental
X6 and earlier| —| Not supported

Platform: Windows x64 only.

CorelDRAW 2026 is the currently user-tested target. Older releases require individual runtime validation.

macOS

Component| Requirement
Operating system| macOS
Architecture| Apple Silicon / Intel
Python| 3.12
Decoder| Pillow JPEG XL / Homebrew libjxl
Integration| JavaScript Scripts Inspector

The macOS application is standalone and requires manual CorelDRAW import.

Conversion Features

Format| Alpha Support| Quality Control
PNG| Yes| Lossless
JPG| No, white background| Adjustable
WebP| Where supported| Adjustable
TIFF| Where supported| N/A
GIF| Limited| Palette-based
BMP| No, white background| N/A

Windows Features

- Native CorelDRAW Docker.
- Batch JPEG XL conversion.
- Drag-and-drop support inside the Novorius panel.
- Automatic PNG import into the document.
- Export to multiple image formats.
- Live conversion diagnostics.
- Persistent conversion logs.
- Version-specific CPG and WPF builds.

macOS Features

- Standalone dark desktop interface.
- Batch JPEG XL conversion.
- Multiple output formats.
- Adjustable image quality.
- Local conversion diagnostics.
- Experimental CorelDRAW JavaScript import bridge.

Installation

Windows

Requirements

- Python 3.12 x64.
- Visual Studio 2022 Build Tools.
- C++ x64 build tools.
- Windows SDK.
- .NET Framework 4.x.
- Supported CorelDRAW installation.

Installation

1. Close all CorelDRAW instances.
2. Extract the Windows package.
3. Run "INSTALL.bat" as Administrator.
4. Select the detected CorelDRAW installation.
5. Wait for the components to build and deploy.
6. Launch CorelDRAW.

Open Novorius through:

"Window → Dockers → Novorius"

Script| Purpose
"INSTALL.bat"| Build and deploy
"CHECK.bat"| Installation diagnostics
"UNINSTALL.bat"| Remove Novorius

macOS

Requirements

- macOS.
- Python 3.12 with Tk support.
- Homebrew.

Install the decoder:

brew install jpeg-xl

Install and launch:

bash INSTALL.command
bash OPEN.command

The installer creates a local Python virtual environment.

Usage

Windows

1. Open CorelDRAW.
2. Open the Novorius Docker.
3. Browse or drag and drop ".jxl" files.
4. Select the conversion mode.
5. Start processing.
6. Inspect the imported image or generated output.

macOS

1. Launch JXL Novorius.
2. Select ".jxl" files.
3. Choose the output format and quality.
4. Process the images.
5. Select Prepare Corel Import.
6. Open the generated JavaScript file through CorelDRAW's Scripts Inspector.
7. Execute the script and verify the imported bitmap.

Diagnostics & Storage

Platform| Location
Windows logs| "%LOCALAPPDATA%\JXLNovorius\conversion.log"
macOS logs| "~/Library/Logs/JXLNovorius/conversion.log"
macOS import jobs| "~/Library/Application Support/JXLNovorius/Jobs"

Diagnostics may include:

- Decoder output.
- Conversion events.
- Effective quality settings.
- Output file size.
- Processing duration.
- Exit codes.
- CorelDRAW object counts.

«Privacy: Logs may contain local filenames and filesystem paths. Review them before sharing.»

Command Line

Windows

novorius.exe export input.jxl output.gif --format gif --quality 95

macOS

.venv/bin/python engine/deck.py export \
  input.jxl output.jpg \
  --format jpg \
  --quality 95 \
  --live

Homebrew decoder fallback:

.venv/bin/python engine/deck.py export \
  input.jxl output.jpg \
  --format jpg \
  --quality 95 \
  --live \
  --backend djxl

Project Structure

JXL-Novorius/
├── host/                  # Windows CorelDRAW integration
├── engine/                # Conversion engine
├── corel/                 # JavaScript import bridge
├── docs/                  # Documentation and previews
├── tests/                 # Fixtures and regression tests
├── app.py                 # macOS application
├── INSTALL.bat            # Windows installer
├── INSTALL.command        # macOS installer
├── OPEN.command           # macOS launcher
└── README.md

Validation & Testing

Test| Status
CorelDRAW 2026 integration| User-tested
Windows v0.5.1 JPG quality 100| User-tested
Windows live conversion logging| User-tested
Windows v0.6.0 compatibility installer| Untested
CorelDRAW 2025 and older| Untested
macOS standalone GUI| Requires real Mac testing
macOS JavaScript bridge| Untested
Animated JPEG XL export| Experimental

See ""tests/LOCAL-RESULT.txt"" (tests/LOCAL-RESULT.txt) for local regression results.

Known Limitations

- No native CorelDRAW canvas drag-and-drop.
- No Ctrl+I file-filter integration.
- No reverse conversion.
- Animated JPEG XL support is experimental.
- GIF transparency is limited.
- JPG and BMP flatten transparency onto white.
- ICC profiles and DPI depend on decoder and encoder support.
- Older CorelDRAW compatibility requires individual testing.
- macOS does not provide a native CorelDRAW Docker.

Development

JXL Novorius is developed through vibe coding and AI-assisted development.

The project builds upon the user-tested JLX Converter v0.4.1 host architecture, introducing additional conversion features, diagnostics, and platform-specific implementations.

References

- "CorelDRAW SDK" (https://community.coreldraw.com/sdk/)
- "CorelDRAW JavaScript Integration" (https://community.coreldraw.com/sdk/w/articles/349/using-javascript-with-coreldraw)
- "libjxl" (https://github.com/libjxl/libjxl)
- "Homebrew JPEG XL" (https://formulae.brew.sh/formula/jpeg-xl)

Disclaimer

JXL Novorius is an independent experimental project. It is not affiliated with, endorsed by, or maintained by Corel Corporation.

No project license has been selected yet. Third-party components remain subject to their respective licenses.

---

<p align="center">
  <strong>JXL Novorius</strong><br>
  <sub>Experimental JPEG XL workflow integration.</sub>
</p>