module WavGen

export writeToWav

# writes sound data to WAV file
# - fname : name of output file
# - data : array of sound signal
# - samplerate : number of samples per second
function writeToWav(fname :: String, data :: Array{<:Number, 1}, samplerate :: Integer)
    out =  open(fname, "w")
    outputType = Int16
    bytenum = sizeof(outputType)
    subchunk2size = length(data) * bytenum
    chunksize = 36 + subchunk2size

    write(out, "RIFF")
    write(out, Int32(chunksize))
    write(out, "WAVE")

    write(out, "fmt ")
    write(out, Int32(16)) # PCM
    write(out, Int16(1)) # linear quantization
    write(out, Int16(1)) # mono
    write(out, Int32(samplerate))
    write(out, Int32(samplerate*bytenum))
    write(out, Int16(bytenum))
    write(out, Int16(8*bytenum))

    write(out, "data")
    write(out, Int32(subchunk2size))
    write(out, Array{Int16,1}(map(floor, data)))

    close(out)
end

end
