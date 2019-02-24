import pyaudio
import numpy as np

cdef int RATE   = 16000
cdef int CHUNK  = 1024
cdef int i      
p               =   pyaudio.PyAudio()

player = p.open(format=pyaudio.paInt16, channels=1, rate=RATE, output=True, frames_per_buffer=CHUNK)
stream = p.open(format=pyaudio.paInt16, channels=1, rate=RATE, input=True, frames_per_buffer=CHUNK)

for i in range(500): #do this for 10 seconds
    player.write(np.fromstring(stream.read(CHUNK),dtype=np.int16), CHUNK)
stream.stop_stream()
stream.close()
p.terminate()
