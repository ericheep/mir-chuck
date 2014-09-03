// visualization.ck
// Eric Heep

public class visualization{
    // sends data to Processing for visualizations
    OscOut osc;
    osc.dest("127.0.0.1", 12001);

    fun void data(float x[], string addr) {
        /* General function for sending real time data to Processing
        */
        osc.start(addr);
        for (int i; i < x.cap(); i++) {
            osc.add(x[i]);
        }
        osc.send();
    }

    fun void matrix(float x[][], string addr, dur win) {
        /* General function for sending a matrix of data to Processing
        */
        for (int i; i < x[0].cap(); i++) {
            osc.start(addr);
            for (int j; j < x.cap(); j++) {
                osc.add(x[j][i]);
            }
            osc.send();
            win => now;
        }
        osc.send();
    }
} 


