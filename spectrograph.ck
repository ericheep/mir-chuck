// spectrograph.ck
// Eric Heep

public class spectrograph {
    // sends a moving spectrogram to Processing
    OscOut osc;
    osc.dest("127.0.0.1", 12001);

    fun void spectrogram(float x[]) {
        osc.start("/frame");
        for (int i; i < x.cap(); i++) {
            osc.add(Std.rmstodb(x[i]));
        }
        osc.send();
    }

    fun void spectrogram(float x[][], dur win) {
        /* spectrograph that accepts an stft
        */
        for (int i; i < x[0].cap(); i++) {
            win => now;
            osc.start("/frame");
            for (int j; j < x.cap(); j++) {
                osc.add(Std.rmstodb(x[j][i]));
            }
            osc.send();
        }
        osc.send();
    }
} 


