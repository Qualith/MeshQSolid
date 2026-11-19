# MeshQSolid

**Español** | [English](README.en.md)

*(antes Mesh2Solid)*

Conversión de mallas 3D poligonales (STL, OBJ, 3MF) a sólidos CAD en formato STEP (B-Rep).

Está pensado para la impresión 3D: permite tomar una malla descargada de un repositorio o exportada de otro software, convertirla en sólido y modificarla en un editor de sólidos (cambiar una medida, añadir un taladro, adaptar un encaje) para volver a imprimirla. Funciona mejor con mallas que proceden de un diseño CAD exportado (las habituales con caras planas, cilindros y redondeos), ya que reconstruye esas superficies analíticas exactas. No es una herramienta de ingeniería inversa para escaneos 3D: las mallas de escáner (ruidosas, densas u orgánicas) no son su objetivo, y en esos casos el resultado será como mucho aproximado o facetado.

MeshQSolid reconstruye superficies analíticas (planos, cilindros, conos, revoluciones, solevados reglados y determinadas roscas normalizadas) a partir de mallas triangulares para su uso en editores de sólidos CAD.

**La beta v0.2.0 de MeshQSolid está en preparación.** Mientras tanto, puedes descargar la última versión publicada con el nombre anterior, [Mesh2Solid 0.1.17](https://github.com/Qualith/MeshQSolid/releases/tag/v0.1.17) (paquete portable para Windows x64), con la interfaz antigua.

---

> [!IMPORTANT]
> **Aviso de versión beta y revisión antes de fabricar:**
> - Esta versión es una **beta** y puede fallar.
> - Las piezas complejas (formas orgánicas, redondeos encadenados o superficies libres) saldrán como sólidos aproximados o facetados.
> - **Conviene revisar siempre la geometría y las dimensiones del resultado en tu editor de sólidos antes de fabricar**, como establece la licencia.
> - Si una pieza no sale bien, el reporte más útil es abrir una incidencia adjuntando el archivo de la malla.

---

## Qué piezas admite

| Tipo de pieza | Comportamiento | Resultado esperado |
|---|---|---|
| **Piezas mecánicas** | Soportes, carcasas, perfiles, ejes, bridas y taladros. Roscas normalizadas probadas en el banco (métricas ISO, paso unificado UNC y una trapecial) cuando la malla las define con claridad. | Sólido validado o aproximado. |
| **Piezas planas por capas (2,5D)** | Piezas planas hechas de capas extruidas, como fichas, insignias, llaveros, placas, posavasos o plantillas. Contornos de cada capa a escala 1:1 en SVG, para corte láser o vinilo. | Sólido validado o aproximado. |
| **Solevados (lofts)** | Transiciones entre secciones transversales regladas con tapas planas y taladros. | Sólido validado o aproximado según la malla. |
| **Archivos multicuerpo (3MF / STL)** | Varios cuerpos independientes en el mismo archivo. | Reconstrucción independiente por cuerpo en un único archivo STEP. |
| **Piezas orgánicas o escaneos libres** | Esculturas, figuras o modelos sin geometría analítica regular. | Sólido facetado (sólido de triángulos). |

---

## Niveles de reconstrucción

Al procesar una pieza, MeshQSolid indica el nivel alcanzado:

- **✓ Sólido validado (`solido_validado`)**: Todas las caras son superficies exactas y pasa nuestras comprobaciones a 0,05 mm.
- **≈ Sólido aproximado (`solido_aproximado`)**: La mayor parte con caras limpias y el resto facetado, con el porcentaje declarado.
- **▦ Sólido facetado (`solido_facetado`)**: Sólido de triángulos.

---

## Flujo de trabajo

El flujo general de la aplicación se organiza en cuatro pasos:

1. **Añadir piezas**: Carga archivos STL, OBJ o 3MF individuales, carpetas o lotes.
2. **Ajustes**: Selecciona el perfil y la tolerancia deseada para la reconstrucción (0,05 mm por defecto en el motor).
3. **Convertir**: Procesa las piezas pendientes en la cola.
4. **Ver el resultado**: Inspecciona el sólido obtenido y expórtalo a formato STEP.


---

## Revisión asistida

Cuando una pieza contiene detalles que admiten interpretación normalizada (como roscas métricas ISO o redondeos reconocibles sobre mallas bien definidas), el programa permite revisar cada zona detectada o aplicar en bloque las sugerencias que no superen la desviación geométrica de 0,05 mm.

---

## Piezas planas por capas (2,5D)

Para piezas planas hechas de capas extruidas, como fichas, insignias, llaveros, placas, posavasos o plantillas:
- Reconstrucción por capas a partir de caras opuestas.
- Exportación en SVG de los contornos de cada capa a escala 1:1, para corte láser o vinilo.
- Generación de cuerpos complementarios de relleno para impresión multicolor.

---

## Línea de comandos (`meshqsolid-cli.exe`)

Para automatización, pruebas y uso con scripts:

```powershell
meshqsolid-cli.exe pieza.stl --step pieza.step --summary resumen.json
```

- `--step <archivo.step>`: Exporta el sólido reconstruido en formato STEP.
- `--summary <resumen.json>`: Genera un resumen compacto en JSON (~2 KB, esquema `m2s-summary/1`) con el nivel obtenido, número de caras y desviación.
- `--tolerance <mm>`: Tolerancia superficial en milímetros (por defecto `0.05`).
- Códigos de salida: `0` (sólido validado), `5` (sólido aproximado o facetado declarado), `3` (rechazado).

---

## Requisitos e instalación

- **Sistema operativo**: Windows 10 o Windows 11 de 64 bits (x64).
- **Instalación**: Cuando se publique la beta, descarga el ZIP portable de la sección Releases, descomprímelo en una carpeta y ejecuta `MeshQSolid.exe`. Conserva la carpeta `licenses/` y las DLLs junto al ejecutable. No requiere instalación adicional.

---

## Cómo informar de fallos

Los informes de los probadores son fundamentales para corregir problemas del motor geométrico:

1. Entra en la sección de [Issues](https://github.com/Qualith/MeshQSolid/issues).
2. Selecciona la plantilla correspondiente:
   - **Pieza no sale bien**: Si el modelo se rechaza, sale facetado o con errores. **Adjuntar el archivo de la malla (STL, OBJ o 3MF) es imprescindible para que podamos reproducir el fallo.** Incluye también el nivel obtenido y el archivo de resumen o registro.
   - **Fallo del programa**: Para bloqueos o cierres inesperados.
   - **Sugerencia**: Para propuestas sobre opciones o perfiles.

---

## Licencia y componentes de terceros

- **Licencia**: MeshQSolid es de uso gratuito tanto personal como comercial bajo los términos de [LICENSE.md](LICENSE.md). Los archivos generados (STEP, SVG) pertenecen al usuario.
- **Componentes de terceros**: El paquete incluye la carpeta `licenses/` con los avisos y licencias de las bibliotecas utilizadas (Open CASCADE Technology, Qt 6, entre otras).
