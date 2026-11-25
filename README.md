JXL Novorius

<p align="center">
  <strong>JPEG XL Integration for CorelDRAW</strong><br>
  An experimental, AI-assisted project bringing JPEG XL conversion and workflow integration to CorelDRAW on Windows and macOS.
</p><p align="center">
  <img src="docs/assets/novorius-banner.png" alt="JXL Novorius Banner" width="850">
</p><p align="center">
  <img src="https://img.shields.io/badge/Platform-Windows%20%7C%20macOS-64748b?style=flat-square">
  <img src="https://img.shields.io/badge/Format-JPEG%20XL-8b5cf6?style=flat-square">
  <img src="https://img.shields.io/badge/Windows-CorelDRAW%202026-2563eb?style=flat-square">
  <img src="https://img.shields.io/badge/macOS-Standalone%20Launcher-64748b?style=flat-square">
  <img src="https://img.shields.io/badge/Status-Experimental-f59e0b?style=flat-square">
</p><p align="center">
  <i>One format. Two platforms. Different integration approaches.</i>
</p>---

Overview

JXL Novorius is an experimental JPEG XL conversion project designed to make ".jxl" files more accessible in graphic design workflows.

The project provides two different implementations:

Windows| macOS
CorelDRAW Add-on| Standalone Launcher
Native Docker interface| Local desktop application
Automatic add-on deployment| Manual CorelDRAW script integration
Multi-version compatibility builds| Homebrew / Python-based decoding

The Windows edition integrates directly into CorelDRAW through a native CPG host and WPF Docker interface.

The macOS edition runs independently as a local desktop application. It provides batch conversion, diagnostics, and an experimental JavaScript bridge for importing converted PNG files into CorelDRAW.

«Important: The macOS application is not a native CorelDRAW add-on. It does not install a Docker, register a CorelDRAW extension, or inject code into the application.»

Application Preview

Windows — CorelDRAW Docker

Novorius Interface| Live Conversion Diagnostics
"Windows Docker Preview" (docs/assets/windows-docker.png)| "Windows Diagnostics Preview" (docs/assets/windows-logs.png)
Native CorelDRAW Docker interface| Real-time conversion events and diagnostics

macOS — Standalone Launcher

Application Interface| Conversion Results
"macOS Launcher Preview" (docs/assets/macos-launcher.png)| "macOS Conversion Preview" (docs/assets/macos-results.png)
Independent local desktop application| Batch processing and conversion logs

Replace the preview images with actual application screenshots. Recommended image format: PNG or WebP.

---

Features

Windows Edition

- Native CorelDRAW Docker integration.
- Batch import of multiple JPEG XL files.
- Drag-and-drop support inside the Novorius panel.
- Automatic PNG conversion and document import.
- Export to PNG, JPG, WebP, TIFF, GIF and BMP.
- Adjustable JPG and WebP quality.
- Persistent conversion logs.
- Live diagnostics, including:
  - Decoder events.
  - Effective output quality.
  - Output file size.
  - Conversion duration.
  - Process exit code.
  - Verified CorelDRAW object counts.
- Separate installation from the original JLX Converter.
- Version-specific CPG and WPF builds.

macOS Edition

- Standalone dark desktop interface.
- Local batch JPEG XL conversion.
- PNG, JPG, WebP, TIFF, GIF and BMP export.
- Adjustable JPG and WebP quality.
- Real subprocess output and conversion diagnostics.
- Persistent local logs.
- Experimental CorelDRAW JavaScript import bridge.
- Apple Silicon and Intel support, subject to dependency availability.

---

Compatibility

Windows — CorelDRAW

The Windows edition uses separate compatibility targets to avoid assuming that different CorelDRAW SDK versions share the same ABI or runtime behavior.

CorelDRAW Release| SDK Major| Compatibility
2026| 27| Dedicated build
2025| 26| Compatibility build
2024| 25| Compatibility build
2022–2023| 24| Experimental
2021| 23| Experimental
2020| 22| Experimental
2019| 21| Experimental
2018| 20| Legacy experimental
2017| 19| Legacy experimental
X8| 18| Legacy experimental
X7| 17| Legacy experimental
X6 and earlier| —| Not supported

Choose the correct build

CorelDRAW 2026 — v27

Use the standard 2026 package.

This build targets CorelDRAW 2026 and its SDK major version 27.

Under CorelDRAW 2026 — v26 and earlier

Use the compatibility package.

This package targets CorelDRAW 2025 and earlier releases. The installer builds the CPG and WPF components against the selected installation's SDK and interop assemblies.

Each detected installation is built independently. The installer refuses ambiguous SDK paths rather than silently borrowing a newer SDK.

«Compatibility entries are experimental until individually tested on their respective CorelDRAW versions.»

Platform limitations

- Windows x64 only.
- No ARM64 or x86 builds.
- X6 and earlier are outside the supported scope.
- Older CorelDRAW releases may require a compatible Windows environment and modern MSVC runtime.
- SDK method availability does not guarantee ABI or workspace compatibility.

macOS

Component| Requirement
Operating system| macOS
Architecture| Apple Silicon / Intel
Application| CorelDRAW 2026 for Mac
Python| Python 3.12
Decoder| Pillow JPEG XL binding or Homebrew libjxl
Integration| JavaScript Scripts Inspector
Additional tools| Homebrew, Bash, Perl

The macOS edition is a standalone local launcher, not a native CorelDRAW extension.

---

Installation

Windows — CorelDRAW Integration

Build dependencies

The build machine requires:

- Python 3.12 x64.
- Visual Studio 2022 Build Tools.
- C++ x64 build tools.
- Windows SDK.
- .NET Framework 4.x.
- A supported CorelDRAW x64 installation.

The installer uses the selected CorelDRAW installation's SDK and type library to generate the corresponding components.

Automatic installation

1. Close all running CorelDRAW instances.
2. Extract the downloaded package.
3. Run "INSTALL.bat" as Administrator.
4. Allow the installer to check the build dependencies.
5. Install or configure any missing prerequisites when requested.
6. Allow the installer to build the engine and CorelDRAW components.
7. Select the detected CorelDRAW installation by its list index.

Use "A" to install on all detected eligible versions when supported by the selected compatibility package.

The installer then:

- Detects the CorelDRAW executable architecture and version.
- Locates the appropriate SDK.
- Builds a separate CPG and WPF assembly.
- Tests the decoder.
- Backs up the previous Novorius installation.
- Deploys the generated components into the corresponding CorelDRAW directory.

The standard deployment location is:

"Programs64/Addons/JXLNovorius"

After installation, launch CorelDRAW.

The Novorius Docker should load automatically and should also be accessible through:

"Window → Dockers → Novorius"

Troubleshooting utilities

Script| Purpose
"CHECK.bat"| Check installation and diagnostics
"UNINSTALL.bat"| Remove Novorius components
"INSTALL.bat"| Build and deploy Novorius

The installer only manages Novorius. It does not intentionally modify or replace the original JLX Converter.

«Administrator privileges are required for automatic deployment into protected CorelDRAW installation directories. This is add-on deployment and registration, not runtime process injection.»

macOS — Standalone Launcher

The macOS package operates independently from CorelDRAW.

1. Install Python

Download Python 3.12 with Tk support:

https://www.python.org/downloads/macos/

2. Install dependencies

Install Homebrew if it is not already available:

https://brew.sh/

For the Homebrew decoder fallback:

brew install jpeg-xl

3. Install Novorius

Extract the package, open Terminal, navigate to the extracted directory and execute:

bash INSTALL.command

4. Launch

bash OPEN.command

The installer creates a local Python virtual environment.

No background service, native CorelDRAW Docker, or system-wide extension installation is required.

---

Usage

Windows

1. Open CorelDRAW.
2. Open the Novorius Docker.
3. Drag one or more ".jxl" files into the panel or use Browse.
4. Select the desired conversion mode.
5. Start processing.
6. Inspect the imported object or generated output.

Conversion modes

Import into document

Converts the JXL input to PNG and imports it into the current CorelDRAW document.

Save converted files beside originals

Exports the converted file alongside its source.

Supported formats:

Format| Alpha Support| Quality Control
PNG| Yes| Lossless
JPG| No, white background| Adjustable
WebP| Yes, where supported| Adjustable
TIFF| Yes, where supported| N/A
GIF| Limited| Palette-based
BMP| No, white background| N/A

Existing filenames are not overwritten.

macOS

1. Launch JXL Novorius.
2. Browse for ".jxl" files.
3. Select the desired processing mode.
4. Choose an output format.
5. Adjust quality when applicable.
6. Process the files.
7. Inspect the conversion log and generated files.

CorelDRAW import bridge

To import a converted image:

1. Select Prepare Corel Import.
2. Process the selected JXL files.
3. Open the generated Corel script folder.
4. Open a blank CorelDRAW document.
5. Open the Scripts Inspector.
6. Load and execute the generated "Import-1.js".
7. Verify the imported bitmap visually.

The bridge uses CorelDRAW's JavaScript scripting interface and "Layer.ImportEx".

This workflow is intentionally manual. The application does not automatically invoke an external decoder from inside CorelDRAW.

---

Live Diagnostics

The Windows debug edition includes a collapsible live conversion log.

Diagnostics include:

- Actual decoder output.
- Conversion events.
- Effective quality settings.
- Output file size.
- Elapsed processing time.
- Exit codes.
- Verified CorelDRAW object counts.

The log is persisted locally:

%LOCALAPPDATA%\JXLNovorius\conversion.log

The macOS edition stores logs at:

~/Library/Logs/JXLNovorius/conversion.log

Generated Corel import jobs are stored at:

~/Library/Application Support/JXLNovorius/Jobs

Clearing the visible log does not erase the persistent disk log.

Privacy note: Logs may contain local filenames and filesystem paths. Review them before sharing.

---

Technical Architecture

Windows

CorelDRAW
    |
    v
Native CPG Startup Host
    |
    v
Novorius Docker
    |
    v
WPF User Interface
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

Key project files:

File| Responsibility
"host/startup.cpp"| Native Docker startup
"host/DockerUI.cs"| WPF interface
"host/*.xslt"| Menu registration
"engine/tools/export.py"| Output encoding
"INSTALL.bat"| Build and deployment

macOS

macOS
  |
  v
Standalone Tk Application
  |
  v
Local Python Engine
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
  |
  v
Document Import

Key project files:

File| Responsibility
"app.py"| Desktop application
"engine/"| Conversion engine
"corel/import-template.js"| Experimental import bridge
"INSTALL.command"| Local environment setup
"OPEN.command"| Application launcher

---

Known Limitations

Windows

- No native CorelDRAW canvas drop.
- No Ctrl+I file-filter integration.
- No reverse conversion.
- No arbitrary input formats.
- Animated JXL export is experimental.
- Animated import is rejected when the decoder exposes multiple frames.
- GIF transparency is limited.
- JPG and BMP flatten transparency onto white.
- ICC profiles and DPI depend on decoder and encoder support.
- Color output is not guaranteed to be identical inside CorelDRAW.
- Multi-version compatibility requires individual runtime testing.

macOS

- Not a native CorelDRAW add-on.
- No automatic Docker startup.
- No custom Scripts Inspector.
- No direct canvas drag-and-drop.
- No automatic decoder invocation from CorelDRAW JavaScript.
- Animated JXL support is unverified.
- FFmpeg fallback processes static images only and may select the first frame.
- ICC, physical DPI, orientation and CorelDRAW alpha handling remain unverified.

---

Validation & Testing

The project distinguishes between locally validated functionality and features requiring real target-system testing.

Test Area| Status
Windows v0.5.1 JPG quality 100 export| User-tested
Windows v0.5.1 live conversion logging| User-tested
CorelDRAW 2026 v0.5.1 host| User-tested
Windows v0.6.0 compatibility installer| Untested
CorelDRAW 2025 and older runtime| Untested
macOS standalone GUI| Requires real Mac testing
macOS CorelDRAW JavaScript bridge| Untested
Animated JXL export| Experimental

Local regression tests use FFmpeg/libjxl static fixtures and Pillow output encoding.

These tests do not establish that the bundled Windows decoder, CPG integration, or macOS CorelDRAW scripting bridge works on every target system.

See "tests/LOCAL-RESULT.txt" for the actual local test results.

Windows compatibility test procedure

For each CorelDRAW version:

1. Close all CorelDRAW instances.
2. Install only the desired target.
3. Open CorelDRAW with a blank document.
4. Verify Docker auto-load.
5. Import "tests/fixtures/alpha_lossless.jxl".
6. Verify 40 × 24 px dimensions and transparency.
7. Export JPG at quality 20 and 95.
8. Test PNG, WebP, TIFF, GIF and BMP.
9. Test "invalid.jxl" and verify error handling.
10. Restart CorelDRAW and verify startup again.
11. Run "CHECK.bat".

When reporting issues, include:

- CorelDRAW version.
- "build-info.json".
- Conversion logs.
- Compiler errors, if any.
- Relevant screenshots.

---

Command Line

Windows:

novorius.exe export input.jxl output.gif --format gif --quality 95

macOS:

.venv/bin/python engine/deck.py export \
  input.jxl output.jpg \
  --format jpg \
  --quality 95 \
  --live

For the Homebrew decoder fallback:

.venv/bin/python engine/deck.py export \
  input.jxl output.jpg \
  --format jpg \
  --quality 95 \
  --live \
  --backend djxl

---

Development

JXL Novorius is developed through vibe coding and AI-assisted development.

The project builds upon the user-tested JLX Converter v0.4.1 host architecture while introducing additional conversion features, diagnostics, and platform-specific implementations.

Development guidelines:

- Keep the original JLX Converter unchanged.
- Use separate development branches for experimental editions.
- Keep Windows SDK builds isolated by CorelDRAW version.
- Do not reuse CPG GUIDs or engines across independent installations.
- Preserve third-party attribution.
- Validate functionality on actual target systems before declaring compatibility.

Suggested branches:

main
windows-2026
windows-compat
macos-experimental

Suggested release tags:

v0.5.1
v0.6.0-compat
v0.5.1-macos-alpha

---

References

- "CorelDRAW X7 AddDocker API" (https://community.coreldraw.com/sdk/api/draw/17/m/framework.adddocker)
- "CorelDRAW X7 IVGAppPlugin" (https://community.coreldraw.com/sdk/api/draw/17/i/ivgappplugin)
- "CorelDRAW 2025 AddDocker API" (https://community.coreldraw.com/sdk/api/draw/26/m/framework.adddocker)
- "CorelDRAW JavaScript Integration" (https://community.coreldraw.com/sdk/w/articles/349/using-javascript-with-coreldraw)
- "CorelDRAW Layer.ImportEx" (https://community.coreldraw.com/sdk/api/draw/26/m/layer.importex?lang=js)
- "libjxl" (https://github.com/libjxl/libjxl)
- "Homebrew JPEG XL" (https://formulae.brew.sh/formula/jpeg-xl)

---

Disclaimer

JXL Novorius is an experimental, independently developed project.

It is not an official CorelDRAW product and is not affiliated with, endorsed by, or maintained by Corel Corporation.

The software is provided for experimentation and evaluation. Compatibility, stability, and behavior may vary depending on the operating system, CorelDRAW version, SDK, decoder and installed dependencies.

No project license has been selected yet. All third-party components remain subject to their respective licenses and notices.

<p align="center">
  <strong>JXL Novorius</strong><br>
  <sub>Experimental JPEG XL workflow integration.</sub>
</p>