# libTKService.dll de OCCT 7.9.3 sin FFmpeg ni OpenVR

MeshQSolid usa Open CASCADE Technology (OCCT) 7.9.3, con licencia GNU LGPL v2.1 y la excepción adicional de OCCT. La `libTKService.dll` del paquete se ha recompilado a partir de las fuentes oficiales, con la receta del paquete `mingw-w64-opencascade` 7.9.3-3 de MSYS2. Se usan los mismos parches que en ese paquete, salvo 0013, que solo afecta a la compilación estática de ExpToCasExe. Las opciones también son las mismas, salvo estas, que se han desactivado: `USE_FFMPEG`, `USE_OPENVR`, `USE_VTK`, `USE_D3D`, `USE_RAPIDJSON`, `USE_TK` y `BUILD_MODULE_Draw`.

El código de OCCT no se ha modificado más allá de esos parches.

- Fuentes oficiales: https://github.com/Open-Cascade-SAS/OCCT/archive/refs/tags/V7_9_3/opencascade-7.9.3.tar.gz (SHA-256 `5ecf094ec6b12d5413dfb851d8c3590c354058aee556e32e408bdfbf8c357d57`)
- Parches: carpeta `patches/` (copiados de https://github.com/msys2/MINGW-packages/tree/master/mingw-w64-opencascade)
- Script de compilación: `build-occt-tkservice.ps1` (Windows, MSYS2 UCRT64)

Para sustituir la DLL por otra compilada por ti, basta con reemplazar `libTKService.dll` en la carpeta del programa.

---

MeshQSolid uses Open CASCADE Technology (OCCT) 7.9.3, licensed under the GNU LGPL v2.1 with the additional OCCT exception. The `libTKService.dll` shipped in the package was rebuilt from the official sources using the recipe of the MSYS2 `mingw-w64-opencascade` 7.9.3-3 package. It uses the same patches as that package, except 0013, which only affects the static build of ExpToCasExe. The options are also the same, except for these, which were turned off: `USE_FFMPEG`, `USE_OPENVR`, `USE_VTK`, `USE_D3D`, `USE_RAPIDJSON`, `USE_TK` and `BUILD_MODULE_Draw`. The OCCT code was not modified beyond those patches. To use a DLL you built yourself, replace `libTKService.dll` in the program folder.