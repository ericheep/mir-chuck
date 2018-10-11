// mel-midi.ck

// classes
Transform transform;

// sound chain
adc => FFT fft => blackhole;

// fft parameters
second / samp => float sr;
1024 => int N => int win => fft.size;
Windowing.hamming(N) => fft.window;

UAnaBlob blob;
MidiOut out;
MidiMsg msg;

// set midi parameters, can input string here
out.open(0);

// set mel coefficients
transform.mel(sr, N);

// main program
while (true) {
    win::samp => now;

    // creates our array of fft bins
    fft.upchuck() @=> blob;
    blob.fvals() @=> float X[];

    // mel bands
    transform.compute(X) @=> float melArray[];

    normalize(melArray);
    midiSendArray(melArray);
}

// subtract min and divide by max
fun void normalize(float arr[]) {
    0.0 => float max;
    arr[0] => float min;
    for (0 => int i; i < arr.size(); i++) {
        if (arr[i] > max) {
            arr[i] => max;
        }
        if (arr[i] < min) {
            arr[i] => min;
        }
    }

    for (0 => int i; i < arr.size(); i++) {
        (arr[i] - min)/max => arr[i];
    }
}

fun int floatToMidiValue(float f) {
    return (f * 255) $ int;
}

// basic sender, sending out MIDI CC messages
fun void midiSendArray(float midiArray[]) {
    for (0 => int i; i < midiArray.size(); i++) {
        120 => msg.data1;
        i => msg.data2;
        floatToMidiValue(midiArray[i]) => msg.data3;
        out.send(msg);
    }
}
