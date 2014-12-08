adc => LiSa mic => Pan2 pan => dac;

mic.duration(2::second);
pan.pan(-1.0);
mic.record(1);
1::second => now;
mic.record(0);

mic.getVoice() => int voice;
mic.rate(voice, 1.0);
mic.play(voice, 1);
//mic.rate(1, 2.0);
//mic.play(1, 2);
//mic.pan(1, 1.0);

while (true) {
    mic.playPos(voice, 0::samp);
    1::second => now;
}
