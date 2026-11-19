# MeshQSolid

[Español](README.md) | **English**

*(formerly Mesh2Solid)*

Converts 3D polygonal meshes (STL, OBJ, 3MF) into CAD solids in STEP format (B-Rep).

It is designed for 3D printing workflows: convert a downloaded or exported mesh into a solid, modify it in a solid CAD modeler (change a dimension, add a hole, adapt a fit), and print it again. It works best with meshes originating from exported CAD designs (the usual models with planar faces, cylinders, and fillets), reconstructing those exact analytical surfaces. It is not a reverse-engineering tool for 3D scans: scan meshes (noisy, dense, or organic) are outside its scope, and will yield at most an approximate or faceted solid.

MeshQSolid reconstructs analytical surfaces (planes, cylinders, cones, revolutions, ruled lofts, and tested standard thread profiles) from triangular meshes for use in solid CAD editors.

**The MeshQSolid v0.2.0 beta is being prepared.** In the meantime, you can download the latest release published under the previous name, [Mesh2Solid 0.1.17](https://github.com/Qualith/MeshQSolid/releases/tag/v0.1.17) (portable package for Windows x64), with the old interface.

---

> [!IMPORTANT]
> **Beta release notice and pre-manufacturing review:**
> - This software is in **beta** and may fail.
> - Complex parts (organic shapes, chained fillets, or freeform surfaces) will output as approximate or faceted solids.
> - **Geometry and dimensions should always be inspected in your CAD software before manufacturing any part**, as stated in the license.
> - If a part does not convert as expected, the most helpful report is an issue with the mesh file attached.

---

## Supported part types

| Part type | Behavior | Expected outcome |
|---|---|---|
| **Mechanical parts** | Brackets, enclosures, structural profiles, shafts, flanges, and bores. Tested standard thread profiles (ISO metric, UNC, and trapezoidal) when clearly defined in the mesh. | Validated or approximate solid. |
| **Layered flat parts (2.5D)** | Flat parts made of extruded layers, such as badges, keychains, plates, coasters, templates, or tokens. Layer outlines at 1:1 scale in SVG, for laser cutting or vinyl cutting. | Validated or approximate solid. |
| **Lofted shapes (lofts)** | Transitions between ruled cross-sections with planar end caps and parallel bores. | Validated or approximate solid depending on mesh quality. |
| **Multi-body files (3MF / STL)** | Multiple independent bodies within a single file. | Per-body independent reconstruction into a single combined STEP file. |
| **Organic or freeform shapes** | Sculptures, figurines, or models without regular analytical geometry. | Faceted solid (solid shell of triangles). |

---

## Reconstruction levels

When processing a part, MeshQSolid indicates the status achieved:

- **✓ Validated solid (`solido_validado`)**: All faces are exact surfaces and pass our checks at 0.05 mm.
- **≈ Approximate solid (`solido_aproximado`)**: Most of the part with clean analytical faces and the rest faceted, with the declared percentage.
- **▦ Faceted solid (`solido_facetado`)**: Solid shell of triangles.

---

## Workflow

The general application workflow consists of four steps:

1. **Add parts**: Load individual STL, OBJ, or 3MF files, folders, or batches.
2. **Settings**: Select conversion profile and required tolerance (0.05 mm engine default).
3. **Convert**: Process pending parts in the queue.
4. **View result**: Inspect the reconstructed solid and export to STEP format.


---

## Assisted review

When a part contains features that match standard definitions (such as identifiable ISO metric threads or fillets on well-defined meshes), the software allows inspecting detected areas or applying suggestions that fall within the 0.05 mm geometric tolerance.

---

## Layered flat parts (2.5D)

For flat parts made of extruded layers, such as badges, keychains, plates, coasters, templates, or tokens:
- Layer reconstruction from opposite faces.
- Export of layer outlines at 1:1 scale in SVG, for laser cutting or vinyl cutting.
- Generation of complementary fill solid bodies for multi-colour 3D printing.

---

## Command-line interface (`meshqsolid-cli.exe`)

For automation, testing, and batch scripting:

```powershell
meshqsolid-cli.exe part.stl --step part.step --summary summary.json
```

- `--step <file.step>`: Exports the reconstructed solid in STEP format.
- `--summary <summary.json>`: Generates a compact JSON summary (~2 KB, schema `m2s-summary/1`) with status, face counts, and deviation.
- `--tolerance <mm>`: Surface tolerance in millimetres (default `0.05`).
- Exit codes: `0` (validated solid), `5` (declared approximate or faceted solid), `3` (rejected).

---

## System requirements and installation

- **Operating System**: 64-bit Windows 10 or Windows 11 (x64).
- **Installation**: Once the beta is released, download the portable ZIP from the Releases section, extract it to a folder, and run `MeshQSolid.exe`. Keep the `licenses/` folder and DLL files alongside the executable. No additional installer required.

---

## Reporting issues

Feedback from testers is essential to improve the geometric engine:

1. Visit the [Issues](https://github.com/Qualith/MeshQSolid/issues) section.
2. Select the appropriate template:
   - **Part conversion issue / Pieza no sale bien**: If a model is rejected, comes out faceted, or shows errors. **Attaching the mesh file (STL, OBJ, or 3MF) is required to reproduce and resolve the problem.** Include the status level and summary or log output.
   - **Bug report / Fallo del programa**: For crashes or unexpected freezes.
   - **Feature request / Sugerencia**: For proposed options or improvements.

---

## License and third-party notices

- **License**: MeshQSolid is free for personal and commercial use under [LICENSE.md](LICENSE.md). Generated CAD files (STEP, SVG) belong to the user.
- **Third-party software**: The package includes the `licenses/` folder with the notices and licenses of the third-party libraries (Open CASCADE Technology, Qt 6, among others).
