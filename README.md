# AudioReactive Visualizer

Visualización generativa en Processing que transforma la música en arte en tiempo real mediante análisis espectral (FFT). La obra responde dinámicamente a los graves, medios y agudos del audio, ofreciendo seis modos visuales únicos.


## Modos visuales
- **Waveform tripartito**: Tres ondas simultáneas para agudos, medios y graves.
- **Arcoíris con onda sinusoidal**: Fondo cromático con onda animada.
- **Geometría reactiva**: Figuras rotativas sensibles al ritmo.
- **Partículas ASCII**: Caracteres que se mueven y cambian con la música.
- **Pantalla partida**: Combinación aleatoria de dos modos.
- **Espectro relativo**: Barras simétricas con colores dinámicos.

## Controles
| Tecla | Acción |
|------|--------|
| `m` o `Espacio` | Cambiar modo visual |
| `+` | Aumentar grosor de líneas |
| `-` | Disminuir grosor de líneas |

## Requisitos
- **Processing 3.5+** ([processing.org](https://processing.org))
- Archivo de audio:  
  `The City Never Felt So Good [IKjMt_q-jnU].mp3`  
  → Debe estar en la carpeta **`data/`** del sketch de Processing.

> **Consejo**: Si usas otro audio, ajusta los rangos en `analyzeAudio()` para una mejor respuesta.

## 🎬 Demo del proyecto
<video src="Raquel_Live_Visuals_Demo.MP4" controls width="640"></video>

## 👤 Autor
**Raquel Benavides**  
MOSDACT – La Salle Campus Barcelona  

