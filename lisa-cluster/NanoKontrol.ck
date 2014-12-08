public class NanoKontrol {

    int top[9];
    int bot[9];

    int knob[9];
    int slider[9];


    int port;
    MidiIn min[10];
    MidiMsg msg;

    spork ~ receive();

    for (int i; i < min.cap(); i++) {
        min[i].printerr(0);

        // opens devices, seraches for NanoKontrol
        if (min[i].open(i)) {
            if (min[i].name() == "nanoKONTROL SLIDER/KNOB") {
                i => port;
                <<< "Connected to", min[port].name(), "" >>>;
            }
        }
        else break;
    }
   
    fun void receive() {
        while (true) {
            // waits on midi events
            min[port] => now;
            while (min[port].recv(msg)) {
                convert(msg.data1, msg.data2, msg.data3);
            }
        }
    }

    //176 2 vel
    fun void convert (int data1, int data2, int data3) {
        if (data1 == 176) {
            for (int i ;i < 9; i++) {
                if (data2 == 2 + i) {
                    data3 => slider[i];
                }
                if (data2 == 11 + i) {
                    data3 => knob[i];
                }
                if (data2 == 20 + i) {
                    data3 => top[i];
                }
                if (data2 == 29 + i) {
                    data3 => bot[i];
                }
            }
        }
    }
}
