# Raquel_Live.Visuals
A generative visualization in Processing that transforms music into art in real-time
AudioReactive Visualizer
A generative visualization built with Processing that transforms music into dynamic visual art in real-time using spectral analysis (FFT). The artwork responds to bass, midrange, and treble frequencies, featuring six unique visual modes.

Features
Real-time audio analysis using FFT

Six distinct visual modes

Interactive controls for customization

Dynamic color and shape responses to music

Visual Modes
Tripartite Waveform – Three simultaneous waveforms for treble, midrange, and bass

Rainbow Sine Wave – Chromatic background with animated waveform

Reactive Geometry – Rhythm-sensitive rotating shapes

ASCII Particles – Music-responsive moving and changing characters

Split Screen – Random combination of two visual modes

Relative Spectrum – Symmetric bars with dynamic colors

Controls
Key	Action
m / Space	Switch visual mode
+	Increase line thickness
-	Decrease line thickness
Installation & Usage
Requires Processing 3.5+ (Download here)

Place your audio file in the data/ folder of the Processing sketch

Default audio file: The City Never Felt So Good [IKjMt_q-jnU].mp3

Run the sketch and enjoy the visualization!

Pro Tip: For optimal results with different audio files, adjust frequency ranges in the analyzeAudio() function.

Project Structure
text
AudioReactive-Visualizer/
├── AudioReactive_Visualizer.pde
├── data/
│   └── your-audio-file.mp3
└── README.md
Author
Raquel Benavides
MOSDACT – La Salle Campus Barcelona
