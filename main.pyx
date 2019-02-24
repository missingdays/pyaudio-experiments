import pyaudio
import numpy as np
import pylab
import matplotlib.pyplot as plt
from scipy.io import wavfile
import time
import sys
import seaborn as sns

cdef int i = 0
cdef int RATE   = 16000
cdef int CHUNK  = 1024

f,ax = plt.subplots(2)

# Prepare the Plotting Environment with random starting values
x = np.arange(RATE)
y = np.random.randn(RATE)

# Plot 0 is for raw audio data
li, = ax[0].plot(x, y)
ax[0].set_xlim(0,RATE)
ax[0].set_ylim(-5000,5000)
ax[0].set_title("Raw Audio Signal")
# Plot 1 is for the FFT of the audio
li2, = ax[1].plot(x, y)
ax[1].set_xlim(0,5000)
ax[1].set_ylim(-100,100)
ax[1].set_title("Fast Fourier Transform")
# Show the plot, but without blocking updates
plt.pause(0.01)
plt.tight_layout()

def plot_data(audio_data):
    # get and convert the data to float
    # Fast Fourier Transform, 10*log10(abs) is to scale it to dB
    # and make sure it's not imaginary
    dfft = 10.*np.log10(abs(np.fft.rfft(audio_data)))

    #print
    li.set_xdata(np.arange(len(audio_data)))
    li.set_ydata(audio_data)
    li2.set_xdata(np.arange(len(dfft))*10.)
    li2.set_ydata(dfft)

    # Show the updated plot, but without blocking
    plt.pause(0.01)


p               =   pyaudio.PyAudio()

player = p.open(format=pyaudio.paInt16, channels=1, rate=RATE, output=True, frames_per_buffer=CHUNK)
stream = p.open(format=pyaudio.paInt16, channels=1, rate=RATE, input=True, frames_per_buffer=CHUNK)

buffer = np.array([])
last_update = time.time()

for i in range(500): #do this for 10 seconds
    try:
        data = np.fromstring(stream.read(CHUNK), dtype=np.int16)
        buffer.resize(len(buffer) + len(data))
        buffer[-len(data):] = data

        current_time = time.time()

        if current_time >= last_update + 1:
            last_update = current_time
            plot_data(buffer)
            buffer = np.array([])

        player.write(data, CHUNK)
    except KeyboardInterrupt:
        break

stream.stop_stream()
stream.close()
p.terminate()
