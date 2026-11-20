# OCCT-BUILD-001: recompila solo libTKService.dll de OCCT 7.9.3 sin FFmpeg ni OpenVR,
# con la receta del paquete de MSYS2 (mingw-w64-opencascade 7.9.3-3: mismas fuentes,
# mismos parches y mismas opciones salvo USE_FFMPEG/USE_OPENVR).
# No toca MSYS2, el proyecto ni ningún paquete: todo queda en -Work.
# Toma el mutex Global\Mesh2SolidFullBuild (espera su turno si hay otro trabajo pesado).
# Uso: pwsh -NoProfile -ExecutionPolicy Bypass -File scripts\build-occt-tkservice.ps1
param(
  [string]$Work = 'F:\Mesh2Solid\occt-build',
  [string]$Msys = 'D:\ChatGPT\Mesh2solid\.tools\msys64',
  [int]$Jobs = 4
)
$ErrorActionPreference = 'Stop'
$ucrt = Join-Path $Msys 'ucrt64'
$env:PATH = "$ucrt\bin;$env:PATH"
New-Item -ItemType Directory -Force $Work | Out-Null
$log = Join-Path $Work 'build.log'
$result = Join-Path $Work 'RESULTADO.txt'
function Log([string]$m){ $l = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  $m"; Write-Host $l; Add-Content -Path $log -Value $l -Encoding utf8 }
function Fail([string]$m){ Log "ERROR: $m"; Set-Content -Path $result -Value "FALLO: $m`r`nMira $log" -Encoding utf8; exit 1 }
function Run([string]$exe, [string[]]$a){ Log ("> $exe " + ($a -join ' ')); & $exe @a *>> $log; if($LASTEXITCODE -ne 0){ Fail "$exe salió con código $LASTEXITCODE" } }

$mutex = New-Object System.Threading.Mutex($false, 'Global\Mesh2SolidFullBuild')
$owned = $false
try {
  try { $owned = $mutex.WaitOne(0) } catch [System.Threading.AbandonedMutexException] { $owned = $true }
  if (-not $owned) { Log 'Esperando turno: hay otro trabajo pesado en marcha (mutex)...'; try { $mutex.WaitOne() | Out-Null } catch [System.Threading.AbandonedMutexException] { }; $owned = $true }
  Log "Inicio. Carpeta de trabajo: $Work"

  # 0. Comprobaciones
  foreach($t in 'cmake.exe','ninja.exe','g++.exe','objdump.exe'){ if(-not (Test-Path "$ucrt\bin\$t")){ Fail "falta $ucrt\bin\$t" } }
  foreach($f in 'lib\libtbb12.dll.a','lib\libtbbmalloc.dll.a','lib\libfreetype.dll.a','lib\libfreeimage.dll.a','bin\libTKService.dll'){ if(-not (Test-Path "$ucrt\$f")){ Fail "falta $ucrt\$f" } }
  $git = (Get-Command git -ErrorAction SilentlyContinue).Source; if(-not $git){ Fail 'no encuentro git (se usa para aplicar los parches)' }

  # 1. Fuentes oficiales de OCCT 7.9.3 (mismo archivo y suma que el PKGBUILD)
  $tgz = Join-Path $Work 'opencascade-7.9.3.tar.gz'
  if(-not (Test-Path $tgz)){ Run 'curl.exe' @('-L','--fail','-o',$tgz,'https://github.com/Open-Cascade-SAS/OCCT/archive/refs/tags/V7_9_3/opencascade-7.9.3.tar.gz') }
  $sha = (Get-FileHash $tgz -Algorithm SHA256).Hash.ToLower()
  if($sha -ne '5ecf094ec6b12d5413dfb851d8c3590c354058aee556e32e408bdfbf8c357d57'){ Fail "SHA-256 de las fuentes no coincide: $sha" }
  $src = Join-Path $Work 'OCCT-7_9_3'
  if(Test-Path $src){ Remove-Item -Recurse -Force $src }
  Run 'tar.exe' @('-xzf',$tgz,'-C',$Work)
  if(-not (Test-Path $src)){ Fail "no se ha creado $src al descomprimir" }

  # 2. Parches del paquete de MSYS2, en el mismo orden
  $patches = @('0001-do-not-redefine-WIN32_WINNT.patch','0002-fix-build-with-ffmpeg.patch',
    '0003-BRepFill_Filling-WireFromList-We-can-t-assume-that-a.patch','0004-BRepFill_Filling-Curve-constraints-confused-by-impli.patch',
    '0006-BRepOffset_Tool-TryProject-Check-return-of-BRepLib-B.patch','0007-static-build.patch','0009-SSE2-detection-gcc.patch',
    # 0013-ExpToCasExe-Fix-building-static.patch se omite: solo afecta a la build estática de ExpToCasExe y no aplica con git apply en 7.9.3
    '0010-Fix-TBB-detection.patch','0014-aarch64-mm_alloc.patch')
  $pdir = Join-Path $Work 'patches'; New-Item -ItemType Directory -Force $pdir | Out-Null
  foreach($p in $patches){
    $pf = Join-Path $pdir $p
    if(-not (Test-Path $pf)){ Run 'curl.exe' @('-L','--fail','-o',$pf,"https://raw.githubusercontent.com/msys2/MINGW-packages/master/mingw-w64-opencascade/$p") }
    Log "Aplicando $p"
    & $git -C $src apply -p1 --whitespace=nowarn $pf *>> $log
    if($LASTEXITCODE -ne 0){ Fail "no se pudo aplicar $p" }
  }

  # 3. Configurar con las opciones del PKGBUILD, salvo FFmpeg, OpenVR, VTK, D3D y Draw (Tcl/Tk)
  $env:CFLAGS = '-march=nocona -msahf -mtune=generic -O2 -pipe'
  $env:CXXFLAGS = $env:CFLAGS
  $bld = Join-Path $Work 'build'
  if(Test-Path $bld){ Remove-Item -Recurse -Force $bld }
  $u = $ucrt -replace '\\','/'
  Run "$ucrt\bin\cmake.exe" @('-Wno-dev','-GNinja','-S',$src,'-B',$bld,
    '-DCMAKE_BUILD_TYPE=Release','-DBUILD_LIBRARY_TYPE=Shared','-DINSTALL_DIR_LAYOUT=Unix',
    "-DCMAKE_INSTALL_PREFIX=$Work/install",
    "-D3RDPARTY_DIR=$u",
    '-DUSE_FFMPEG=OFF','-DUSE_OPENVR=OFF','-DUSE_VTK=OFF','-DUSE_D3D=OFF','-DUSE_RAPIDJSON=OFF','-DUSE_TK=OFF',
    '-DBUILD_MODULE_Draw=OFF',
    '-DUSE_FREETYPE=ON',"-D3RDPARTY_FREETYPE_DIR=$u","-D3RDPARTY_FREETYPE_DLL_DIR=$u/bin/","-D3RDPARTY_FREETYPE_DLL=$u/bin/libfreetype-6.dll","-D3RDPARTY_FREETYPE_LIBRARY_DIR=$u/lib/","-D3RDPARTY_FREETYPE_LIBRARY=$u/lib/libfreetype.dll.a",
    '-DUSE_FREEIMAGE=ON',"-D3RDPARTY_FREEIMAGE_DIR=$u","-D3RDPARTY_FREEIMAGE_DLL_DIR_freeimage=$u/bin/","-D3RDPARTY_FREEIMAGE_DLL_freeimage=$u/bin/libfreeimage-3.dll","-D3RDPARTY_FREEIMAGE_LIBRARY_DIR_freeimage=$u/lib/","-D3RDPARTY_FREEIMAGE_LIBRARY=$u/lib/libfreeimage.dll.a",
    '-DUSE_TBB=ON',"-D3RDPARTY_TBB_DLL_DIR=$u/bin/","-D3RDPARTY_TBB_LIBRARY_DIR=$u/lib/","-D3RDPARTY_TBB_LIBRARY=$u/lib/libtbb12.dll.a","-D3RDPARTY_TBBMALLOC_LIBRARY_DIR=$u/lib/","-D3RDPARTY_TBBMALLOC_LIBRARY=$u/lib/libtbbmalloc.dll.a")

  # 4. Compilar solo TKService (arrastra TKernel y TKMath)
  Run "$ucrt\bin\ninja.exe" @('-C',$bld,"-j$Jobs",'TKService')
  $dll = Get-ChildItem $bld -Recurse -Filter 'libTKService.dll' | Select-Object -First 1
  if(-not $dll){ Fail 'no aparece libTKService.dll tras compilar' }
  $out = Join-Path $Work 'out'; New-Item -ItemType Directory -Force $out | Out-Null
  Copy-Item $dll.FullName (Join-Path $out 'libTKService.dll') -Force

  # 5. Comprobaciones: dependencias y exportaciones frente a la DLL de MSYS2
  $od = "$ucrt\bin\objdump.exe"
  $imports = & $od -p (Join-Path $out 'libTKService.dll') | Select-String 'DLL Name' | ForEach-Object { ($_.Line -split ':')[1].Trim() }
  $bad = $imports | Where-Object { $_ -match '^(avcodec|avformat|avutil|swscale|swresample)|openvr' }
  function Exports($f){ $in=$false; & $od -p $f | ForEach-Object { if($_ -match '^\[Ordinal/Name Pointer\] Table'){ $in=$true; return }; if($in){ if($_.Trim() -eq ''){ $in=$false } else { ($_.Trim() -split '\s+')[-1] } } } | Sort-Object -Unique }
  $newExp = Exports (Join-Path $out 'libTKService.dll')
  $oldExp = Exports "$ucrt\bin\libTKService.dll"
  $missing = $oldExp | Where-Object { $newExp -notcontains $_ }
  $extra = $newExp | Where-Object { $oldExp -notcontains $_ }
  $r = @("OCCT-BUILD-001 — libTKService.dll sin FFmpeg ni OpenVR",
    "Fecha: $(Get-Date -Format 'yyyy-MM-dd HH:mm')",
    "DLL nueva: $(Join-Path $out 'libTKService.dll')",
    "Dependencias: $($imports -join ', ')",
    "FFmpeg u OpenVR entre las dependencias: $(if($bad){'SÍ: ' + ($bad -join ', ')}else{'no'})",
    "Exportaciones: nueva $($newExp.Count), MSYS2 $($oldExp.Count); faltan $(@($missing).Count), sobran $(@($extra).Count)")
  if($missing){ $r += 'Exportaciones que faltan (primeras 40):'; $r += ($missing | Select-Object -First 40) }
  $r += $(if(-not $bad -and -not $missing){'VEREDICTO: OK, lista para probarla en el paquete (la prueba la hace la coordinación).'}else{'VEREDICTO: REVISAR antes de usarla.'})
  Set-Content -Path $result -Value $r -Encoding utf8
  Log 'Terminado. Resultado en RESULTADO.txt'
  $r | ForEach-Object { Write-Host $_ }
} finally {
  if($owned){ $mutex.ReleaseMutex() }
  $mutex.Dispose()
}
