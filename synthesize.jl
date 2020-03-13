module Synthesize

using Random, Distributions

export musicFromNotes
export Music
export default, flute, flute2, organ

# instrument profiles (just a bunch of random numbers, needs revising)
default = Dict{Rational, Float64}(1 => 1)
flute = Dict{Rational, Float64}(1//2 => 1, 1 => 10^0.7, 2 => 10^0.6, 3 => 10^0.6, 4 => 10^-0.1, 5 => 1, 6 => 10^-0.3, 7 => 10^-0.7, 8 => 10^-0.7)
flute2 = Dict{Rational, Float64}(1//2 => 2^-8, 1 => 2^-7, 2 => 2^-1.4, 3 => 2^-6, 4 => 2^-1.8, 5 => 2^-6.7, 6 => 2^-3.3, 7 => 2^-6.6, 8 => 2^-3.4, 10 => 2^-4.6, 12 => 2^-5.1, 14 => 2^-5.9, 16 => 2^-5.8, 18 => 2^-6.4, 26 => 2^-7)
organ = Dict{Rational, Float64}(1//16 => 0.5, 1//4 => 2, 1//2 => 0.2, 1 => 6, 2 => 0.2, 3 => 0.1, 4 => 4, 5 => 0.1, 6 => 0.1, 8 => 2, 12 => 1, 16 => 0.5, 20 => 0.2)

# generate sound with given frequency (Hz), duration (s), and instrument profile
function genSound(freq :: Real, duration :: Real, harmonics :: Dict{<:Rational, <:Real}) :: Array{Float64,1}
    data = Array{Float64, 1}(undef, Int64(floor(duration * 44100)))
    Random.seed!(123)
    d = Normal()
    multiplier = repeat([1.0], length(data))
    # first and last n signals are decaying to avoid sudden bumps in signal
    decayLength = 500
    multiplier[1:decayLength] = (1:decayLength) / decayLength
    multiplier[end+1-decayLength:end] = (decayLength:-1:1) / decayLength
    t = (1:length(data)) / 44100
    data = 1000 * sum(h -> h[2] * sin.(h[1] * freq * 2 * π * t), harmonics)
    noise = (freq != 0 ? 20 : 0) * rand(d, length(data))
    return (data + noise) .* multiplier
end

# generate given duration of silence
silence(duration :: Real) = repeat([0], Int64(floor(duration * 44100)))

# list of common note frequencies
freqlist = Dict("0" => 0, "C" => 440.0 * 2^(-9/12), "C#" => 440.0 * 2^(-8/12), "D" => 440.0 * 2^(-7/12),
            "D#" => 440.0 * 2^(-6/12), "E" => 440.0 * 2^(-5/12), "F" => 440.0 * 2^(-4/12),
            "F#" => 440.0 * 2^(-3/12), "G" => 440.0 * 2^(-2/12), "G#" => 440.0 * 2^(-1/12),
            "A" => 440.0, "A#" => 440.0 * 2^(1/12), "H" => 440.0 * 2^(2/12))

struct Music
    notes :: String
    speed :: Number
end

# generate a music from list of notes in a string, with given instrument profile
function musicFromNotes(music :: Music, harmonics :: Dict{<:Rational, <:Real}) :: Array{Float64,1}
    notelist = split(music.notes)
    sound = []
    for note in notelist
        duration = 1
        notedata = split(note, "-")
        if length(notedata) > 1
            duration = parse(Float64, notedata[2])
        end
        octave = count(isequal('\''), notedata[1])
        notedata[1] = split(notedata[1], "'")[1]
        # append sound to current signal
        sound = vcat(sound, genSound(freqlist[notedata[1]] * 2^octave, duration*60/music.speed, harmonics))
        # append a short silence after note
        sound = vcat(sound, silence(0.05*duration*60/music.speed))
    end
    return sound
end


end
