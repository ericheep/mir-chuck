// run.ck

// classes
Machine.add(me.dir(-2) + "src/SpectralCentroid.ck");
Machine.add(me.dir(-2) + "src/SpectralSpread.ck");
Machine.add(me.dir(-2) + "src/SpectralKurtosis.ck");
Machine.add(me.dir(-2) + "src/SpectralSkewness.ck");
Machine.add(me.dir(-2) + "src/SubbandCentroids.ck");


// main program
Machine.add(me.dir() + "/features.ck");
