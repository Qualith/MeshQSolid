# Software de terceros en MeshQSolid

MeshQSolid se distribuye con las bibliotecas siguientes, cada una bajo su propia
licencia de software libre o de código abierto. Se enlazan de forma dinámica (DLL
separadas), por lo que pueden ser examinadas o sustituidas por otras versiones
compatibles. Los textos de licencia disponibles se encuentran en la carpeta `licenses/`
junto al ejecutable, organizada en una subcarpeta por biblioteca.

Las dependencias cuyo paquete de MSYS2 (UCRT64) no instala el texto de su licencia (ICU y
jxrlib) lo llevan igualmente en `licenses/`: el texto oficial de la versión exacta que usa el
paquete, tomado de su fuente original y guardado en `third-party/licenses/` con un `SOURCE.txt`
que dice de dónde sale. No se inventa ningún texto.

## Componentes principales

| Biblioteca | Uso en MeshQSolid | Licencia | Código fuente | Carpeta de licencia |
|---|---|---|---|---|
| Qt 6 (Core, Widgets, Gui, Test) | Interfaz gráfica y utilidades | GNU LGPL v3 / GPL v3 con excepción comercial | https://download.qt.io/official_releases/qt/ | `licenses/qt6-base/` |
| Open CASCADE Technology 7.9.3 | Geometría B-Rep, sólidos y exportación STEP | GNU LGPL v2.1 con excepción OCCT | https://github.com/Open-Cascade-SAS/OCCT | `licenses/opencascade/` |
| Eigen 3 | Álgebra lineal (solo cabeceras en compilación) | Mozilla Public License 2.0 | https://gitlab.com/libeigen/eigen | Solo compilación (cabeceras) |
| zlib | Compresión de datos | Licencia zlib | https://www.zlib.net/ | `licenses/zlib/` |
| Runtime de GCC (libgcc, libstdc++, libgomp) | Soporte de tiempo de ejecución C/C++ | GPL v3 con Runtime Exception | https://gcc.gnu.org/ | `licenses/libgcc/`, `licenses/libstdc++/` |
| MinGW-w64 winpthreads | Soporte de hilos POSIX en Windows | Licencia MIT / BSD / zlib | https://www.mingw-w64.org/ | `licenses/libwinpthread/` |
| Módulo OCCT TKTopAlgo modificado | Clasificación de caras y curvas locales | GNU LGPL v2.1 con excepción OCCT | https://github.com/Qualith/MeshQSolid/tree/main/third-party/occt | `licenses/occt-classifier/` |
| Módulo OCCT TKService recompilado (OCCT 7.9.3 oficial, parches de MSYS2, sin FFmpeg ni OpenVR) | Servicios gráficos del visor 3D | GNU LGPL v2.1 con excepción OCCT | https://github.com/Qualith/MeshQSolid/tree/main/third-party/occt-tkservice (receta: `scripts/build-occt-tkservice.ps1` y lista de parches) | `licenses/occt-tkservice/` |

## Inventario completo de bibliotecas empaquetadas (DLL)

### Bibliotecas con licencia copiada en `licenses/` (38 paquetes, 82 DLLs)

| Paquete MSYS2 | DLLs incluidas | Licencia | URL upstream | Carpeta en `licenses/` |
|---|---|---|---|---|
| `brotli` | `libbrotlicommon.dll`<br>`libbrotlidec.dll` | MIT | https://github.com/google/brotli | `licenses/brotli/` |
| `bzip2` | `libbz2-1.dll` | custom | https://sourceware.org/bzip2/ | `licenses/bzip2/` |
| `double-conversion` | `libdouble-conversion.dll` | BSD-3-Clause | https://github.com/google/double-conversion | `licenses/double-conversion/` |
| `freeimage` | `libfreeimage-3.dll` | FreeImage OR GPL-2.0-or-later | https://freeimage.sourceforge.io/ | `licenses/FreeImage/` |
| `freetype` | `libfreetype-6.dll` | GPL-2.0-or-later OR FTL | https://www.freetype.org/ | `licenses/freetype/` |
| `gettext-runtime` | `libintl-8.dll` | GPL-3.0-or-later AND LGPL-2.1-or-later | https://www.gnu.org/software/gettext/ | `licenses/gettext-runtime/` |
| `glib2` | `libglib-2.0-0.dll` | LGPL-2.1-or-later | https://gitlab.gnome.org/GNOME/glib | `licenses/glib2/` |
| `graphite2` | `libgraphite2.dll` | LGPL-2.1-or-later | https://github.com/silnrsi/graphite | `licenses/graphite2/` |
| `harfbuzz` | `libharfbuzz-0.dll` | MIT | https://harfbuzz.github.io/ | `licenses/harfbuzz/` |
| `icu` | `libicudt78.dll`<br>`libicuin78.dll`<br>`libicuuc78.dll` | Unicode License V3 (ICU 78.3, texto de icu4c-78.3-sources.tgz) | https://icu.unicode.org/home/ | `licenses/icu/` |
| `imath` | `libImath-3_2.dll` | BSD-3-Clause | https://www.openexr.com/ | `licenses/imath/` |
| `jbigkit` | `libjbig-0.dll` | GPL-2.0 | https://www.cl.cam.ac.uk/~mgk25/jbigkit/ | `licenses/jbigkit/` |
| `jxrlib` | `libjpegxr.dll`<br>`libjxrglue.dll` | BSD-2-Clause (jxrlib 1.1, nota de sus fuentes) | https://jxrlib.codeplex.com/ | `licenses/jxrlib/` |
| `lcms2` | `liblcms2-2.dll` | MIT AND GPL-3.0-or-later | https://www.littlecms.com/color-engine/ | `licenses/lcms2/` |
| `lerc` | `libLerc.dll` | Apache-2.0 | https://github.com/Esri/lerc | `licenses/lerc/` |
| `libb2` | `libb2-1.dll` | custom:CC0 | https://blake2.net/ | `licenses/libb2/` |
| `libdeflate` | `libdeflate.dll` | MIT | https://github.com/ebiggers/libdeflate | `licenses/libdeflate/` |
| `libgcc` | `libgcc_s_seh-1.dll` | GPL-3.0-or-later WITH GCC-exception-3.1 AND GFDL-1.3-or-later | https://gcc.gnu.org | `licenses/libgcc/` |
| `libgomp` | `libgomp-1.dll` | GPL-3.0-or-later WITH GCC-exception-3.1 AND GFDL-1.3-or-later | https://gcc.gnu.org | `licenses/libgomp/` |
| `libiconv` | `libiconv-2.dll` | LGPL-2.1-or-later  documentation:spdx:GPL-3.0-or-later | https://www.gnu.org/software/libiconv/ | `licenses/libiconv/` |
| `libjpeg-turbo` | `libjpeg-8.dll` | custom:BSD-like | https://libjpeg-turbo.virtualgl.org/ | `licenses/libjpeg-turbo/` |
| `libpng` | `libpng16-16.dll` | custom | http://www.libpng.org/pub/png/libpng.html | `licenses/libpng/` |
| `libraw` | `libraw-25.dll` | LGPL-2.1 OR CDDL-1.0 | https://www.libraw.org/ | `licenses/libraw/` |
| `libstdc++` | `libstdc++-6.dll` | GPL-3.0-or-later WITH GCC-exception-3.1 AND GFDL-1.3-or-later | https://gcc.gnu.org | `licenses/libstdc++/` |
| `libtiff` | `libtiff-6.dll` | MIT | https://libtiff.gitlab.io/libtiff/ | `licenses/libtiff/` |
| `libwebp` | `libsharpyuv-0.dll`<br>`libwebp-7.dll`<br>`libwebpmux-3.dll` | BSD-3-Clause | https://developers.google.com/speed/webp/ | `licenses/libwebp/` |
| `libwinpthread` | `libwinpthread-1.dll` | MIT AND BSD-3-Clause-Clear | https://www.mingw-w64.org/ | `licenses/libwinpthread/` |
| `md4c` | `libmd4c.dll` | MIT | https://github.com/mity/md4c | `licenses/md4c/` |
| `opencascade` | `libTKBO.dll`<br>`libTKBool.dll`<br>`libTKBRep.dll`<br>`libTKCAF.dll`<br>`libTKCDF.dll`<br>`libTKDE.dll`<br>`libTKDESTEP.dll`<br>`libTKernel.dll`<br>`libTKFeat.dll`<br>`libTKFillet.dll`<br>`libTKG2d.dll`<br>`libTKG3d.dll`<br>`libTKGeomAlgo.dll`<br>`libTKGeomBase.dll`<br>`libTKHLR.dll`<br>`libTKLCAF.dll`<br>`libTKMath.dll`<br>`libTKMesh.dll`<br>`libTKOffset.dll`<br>`libTKOpenGl.dll`<br>`libTKPrim.dll`<br>`libTKService.dll` (recompilada, ver `licenses/occt-tkservice/`)<br>`libTKShHealing.dll`<br>`libTKTopAlgo.dll` (modificada, ver `licenses/occt-classifier/`)<br>`libTKV3d.dll`<br>`libTKVCAF.dll`<br>`libTKXCAF.dll`<br>`libTKXSBase.dll` | LGPL-2.1-or-later WITH OCCT-exception-1.0 | https://dev.opencascade.org | `licenses/opencascade/` |
| `openexr` | `libIex-3_4.dll`<br>`libIlmThread-3_4.dll`<br>`libOpenEXR-3_4.dll`<br>`libOpenEXRCore-3_4.dll` | BSD-3-Clause | https://www.openexr.com/ | `licenses/openexr/` |
| `openjpeg2` | `libopenjp2-7.dll` | BSD-2-Clause | https://www.openjpeg.org/ | `licenses/openjpeg/` |
| `openjph` | `libopenjph-0.32.dll` | BSD-2-Clause | https://openjph.org/ | `licenses/openjph/` |
| `pcre2` | `libpcre2-16-0.dll`<br>`libpcre2-8-0.dll` | BSD-3-Clause | https://pcre.org/ | `licenses/pcre2/` |
| `qt6-base` | `qgif.dll`<br>`qico.dll`<br>`qjpeg.dll`<br>`Qt6Core.dll`<br>`Qt6Gui.dll`<br>`Qt6Test.dll`<br>`Qt6Widgets.dll`<br>`qwindows.dll` | LGPL-3.0-only WITH Qt-GPL-exception-1.0 AND AFL-2.1 AND Apache-2.0 AND BSL-1.0 AND CC0-1.0 AND BSD-3-Clause AND CC-BY-4.0 AND GFDL-1.3-no-invariants-only AND GPL-2.0-only AND GPL-2.0-or-later AND GPL-3.0-only AND custom | https://www.qt.io | `licenses/qt6-base/` |
| `tbb` | `libtbb12.dll` | Apache-2.0 | https://software.intel.com/en-us/oneapi/onetbb | `licenses/oneTBB/` |
| `xz` | `liblzma-5.dll` | 0BSD AND LGPL-2.1-or-later AND GPL-2.0-or-later | https://tukaani.org/xz | `licenses/xz/` |
| `zlib` | `zlib1.dll` | Zlib | https://www.zlib.net/ | `licenses/zlib/` |
| `zstd` | `libzstd.dll` | BSD-3-Clause OR GPL-2.0-or-later | https://facebook.github.io/zstd/ | `licenses/zstd/` |

Todas las bibliotecas empaquetadas tienen su licencia copiada en `licenses/`; no queda ninguna pendiente.
