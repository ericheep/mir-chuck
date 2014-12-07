adc => LiSaCluster lc => dac;

1024 => int N;

lc.centroid(1);
lc.spread(1);
lc.mel(1);

lc.fftSize(N);
lc.clusters(4);
lc.stepLength(100::ms);

Hid hi;
HidMsg msg;

if (!hi.openKeyboard(0)) {
    me.exit();
}
<<< "Keyboard '" + hi.name() + "' connected!", "" >>>;

keyboard();

fun void keyboard() {
    while (true) {
        // event
        hi => now;

        while (hi.recv(msg)) {
            if (msg.isButtonDown()) {
                if (msg.ascii == 49) {
                }
                if (msg.ascii == 50) {
                }
                if (msg.ascii == 96) {
                    lc.record(1);
                }
            }
            if (msg.isButtonUp()) {
                if (msg.ascii == 96) {
                    lc.record(0);
                    lc.play(1);
                }
            }
        }
    }
}
