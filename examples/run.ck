// master.ck
// Eric heep

// classes
Machine.add(me.dir(-1) + "/spectral/Chromagram.ck");
Machine.add(me.dir(-1) + "/spectral/Mel.ck");
Machine.add(me.dir(-1) + "/spectral/Spectral.ck");
Machine.add(me.dir(-1) + "/spectral/Subband.ck");

Machine.add(me.dir(-1) + "/utility/Matrix.ck");
Machine.add(me.dir(-1) + "/utility/Visualization.ck");
Machine.add(me.dir(-1) + "/utility/CrossCorr.ck");

// main program
//Machine.add(me.dir() + "/kmeans_example.ck");
//Machine.add(me.dir() + "/cossim_example.ck");
//Machine.add(me.dir() + "/mfcc_example.ck");
Machine.add(me.dir() + "/vad_example.ck");
