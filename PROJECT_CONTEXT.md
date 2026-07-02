# BnBrooklyn — Project Context
_Ported from Claude.ai for use in Claude Code_

## Overview

**COMMAND SPACE** is Brian's personal fabrication and design practice. **BnBrooklyn** is the sub-project focused on 3D-printable home goods and furniture — modular, scalable designs that print cleanly with minimal or no supports, made on a Bambu printer.

**Current focus:** building a pre-visualization layer (parametric shader/renderer) for shelving designs before they're modeled in Blender and printed.

**Pipeline:** Figma (inspiration + specs) → Blender (modeling via MCP) → STL export → Bambu Studio (slicing) → Bambu printer.

---

## New: Shelf Pre-Vis Tool (starting point)

Goal: a parametric visualizer to preview shelf geometry before committing to full Blender modeling.

- **Inputs (v1):** length, width, height — exposed as adjustable sliders
- **Output (v1):** a simple box representing the shelf volume
- **Planned evolution:** add more specs incrementally (shelf count, connector type, dowel diameter, clearances, etc.) as the tool develops — start simple, validate, then scale (consistent with the project's general "incremental complexity" approach)

This is a fresh build — no prior pre-vis code exists yet. Reasonable next parameters to anticipate, based on the physical designs already built (see below): rod/dowel diameter, shelf clearance/spacing, wall thickness, number of tiers, corner/connector type.

---

## Existing Designs

### 1. Modular Rod-and-Connector Shelving (connectors_v1)

Inspired by a reference image of dowel-and-connector shelving (not a flat panel system — an earlier flat 100×100×5mm dovetail panel system is in the backlog, not current focus).

Designed for **1-inch (25.4mm) diameter dowels**, off-the-shelf hardware-store closet rod.

Full connector family (v1, all exported):
- 2-way elbow
- 3-way corner
- 3-way T (flat, all arms in plane)
- 4-way intermediate (pass-through)
- X-brace center (4 diagonal arms at 45°)
- Corner-plus-45°

**Socket specs:**
- Inner diameter: 26mm (0.3mm clearance per side for 25.4mm dowels)
- Outer diameter: 36mm
- Depth: 25mm
- Hub sphere: 20mm

**File locations:**
- Staging: `~/Desktop/connectors_v1/`
- Canonical: `🟡/Projects/COMMAND SPACE/BnBrooklyn/modular-panels/connectors_v1/` (Google Drive)

**Open items:**
- Print the elbow connector first to validate socket tolerance before printing the full set
- Consider lead-in chamfers on socket mouths in a future version
- Add dowels into the Blender scene for full-assembly visualization

### 2. Spice Rack (v8, current)

Single-piece design, reached v8 through iteration.

**Specs:**
- Height: 7.46"
- Shelf clearance: 5" (127mm)
- Depth: 62mm
- Four corner feet, open column structure
- Triangular gussets under shelves (resolved a Bambu cantilever-geometry flag)
- Exports **upside-down** for flat-bed printing — eliminates the need for supports entirely

**File location:** `/Users/2b/Library/CloudStorage/GoogleDrive-brian.rio11@gmail.com/My Drive/🟡/Projects/COMMAND SPACE/BnBrooklyn/spice-rack`

**Convention:** versioned suffixes (e.g. `-v8`), never overwrite prior versions.

---

## Key Technical Learnings

- **Blender MCP export paths with emoji characters can time out.** Reliable workaround: export to `~/Desktop` first, then `cp` to the Google Drive path via Terminal.
- **Print orientation matters** — flipping a model upside-down to land flat on the print bed can eliminate support needs entirely (used in spice rack v8).
- **Always version files**, never overwrite (e.g. `-v1`, `-v8`).
- **Test one piece before printing a full set** (e.g. print one elbow connector to validate tolerance before committing to the whole connector family).
- **Boolean modifiers:** use `solver = 'EXACT'` for complex multi-arm geometry in Blender.
- **Bambu flags cantilever geometry** — triangular gussets are the fix pattern for shelving.
- `import bpy` must be explicit in every Blender MCP code block (not auto-imported).
- Blender geometry built procedurally with `bmesh`, `remove_doubles`, and `recalc_face_normals` before export.
- STL export operator: `bpy.ops.wm.stl_export(filepath=path, export_selected_objects=True)` (Blender 5.1.2).
- Figma MCP: call `whoami` first to confirm team access; need file-level URLs with `fileKey`; node IDs use `-` in URLs but must be passed as `:` (e.g. `0-1` → `0:1`); `get_metadata` on root reveals child IDs for multi-frame pages.
- Viewport screenshots via Blender's `get_screenshot_of_area_as_image` consistently fail — don't rely on this.

---

## Tools & Environment

- **Blender 5.1.2** with MCP via `mcp-proxy` bridging to Blender's socket server (port 9876); Claude Desktop config uses full Homebrew path `/opt/homebrew/bin/uvx` (Desktop doesn't inherit shell PATH)
- **Bambu printer** — Apple Silicon Mac, WiFi-connected, AI monitoring
- **Bambu Studio** for slicing
- **Figma** for inspiration boards and specs
- **Google Drive** synced at `~/Library/CloudStorage/GoogleDrive-brian.rio11@gmail.com/My Drive/` — canonical project archive
- Desktop (`~/Desktop`) — staging area for exports before copying to Drive
- Active project root: `🟡/Projects/COMMAND SPACE/BnBrooklyn/`

---

## Working Style / Patterns

- Communication is conceptual and idea-forward — Brian describes intent, implementation gets translated from there
- Design-driven by reference images (e.g. the rod-and-connector shelving pivot came from a found reference photo)
- Start with the simplest piece, validate physically, then scale up complexity
- Google Drive = canonical archive; Desktop = scratch/staging
