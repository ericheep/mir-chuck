// visualization.ck
// Eric Heep

public class visualization{
    // sends data to Processing for visualizations
    OscOut osc;
    osc.dest("127.0.0.1", 12001);

    fun void spectrogram(float x[]) {
        /* Real time spectrogram
        */
        osc.start("/frame");
        for (int i; i < x.cap(); i++) {
            osc.add(Std.rmstodb(x[i]));
        }
        osc.send();
    }

    fun void spectrogram(float x[][], dur win) {
        /* Spectrograph that accepts an stft
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


