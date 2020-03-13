include("synthesize.jl")
include("wavgen.jl")

using .Synthesize, .WavGen

## Examples

music1 = Music("C C G G A A G-2 F F E E D D C-2", 100)

music2 = Music("E' E' F' G' G' F' E' D' C' C' D' E' E'-1.5 D'-0.5 D' 0 E' E' F' G' G' F' E' D' C' C' D' E' D'-1.5 C'-0.5 C' 0 D' D' E' C' D' E'-0.5 F'-0.5 E' C' D' E'-0.5 F'-0.5 E' D' C' D' G E'-2 E' F' G' G' F' E' D' C' C' D' E' D'-1.5 C'-0.5 C'", 140)

music3 = Music("E'-0.75 F'-0.25 G' E'-0.5 C'-0.5 F#'-0.5 G'-0.5 E'-0.5 C'-0.5 H-0.5 C'-0.5 C#'-0.5 D'-0.5 G C'-0.75 H-0.25 A-0.5 H-0.25 C'-0.25 D'-0.25 E'-0.25 F'-0.25 G'-0.25 G#'-0.25 A'-0.25 G'-0.25 F'-0.25 E'-0.25 D'-0.25 E'-0.25 F'-0.25 C'-1.5 D'-0.25 C'-0.25 H-0.5", 86)


writeToWav("beethoven.wav", musicFromNotes(music2, organ), 44100)
writeToWav("mozart.wav", musicFromNotes(music3, flute), 44100)
