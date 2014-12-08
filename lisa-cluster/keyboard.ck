adc => LiSaCluster lc => dac;

1024 => int N;

lc.rms(1);
//lc.centroid(1);
//lc.spread(1);
//lc.mel(1);

lc.fftSize(N);
lc.numClusters(4);
lc.stepLength(50::ms);

Hid key;
HidMsg msg;
int device, inc;
if (me.args())me.arg(0) => Std.atoi => device;

if (!key.openKeyboard(device)) me.exit();
<<< "Keyboard '" + key.name() + "' is activated!","">>>;

while (true) {
    key => now;
    while (key.recv(msg)) {
        if (msg.isButtonDown()) {
            if (msg.ascii == 96) {
                lc.play(0);
                lc.record(1);
            }
            if (msg.ascii == 49) {
                if (inc < lc.num_clusters) {  
                    inc++;
                    lc.cluster((inc * 0.999)/lc.num_clusters);
                }
            }
            if (msg.ascii == 50) {
                lc.cluster;
                if (inc > 0) {
                    inc--;
                    lc.cluster((inc * 0.999)/lc.num_clusters);
                }
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
