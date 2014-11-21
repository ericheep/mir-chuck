// master.ck
// Eric heep

me.dir() + "/Chromagram.ck" => string chromagram;
Machine.add(chromagram);

me.dir() + "/Matrix.ck" => string matrix;
Machine.add(matrix);

me.dir() + "/Mel.ck" => string mel;
Machine.add(mel);

me.dir() + "/Sci.ck" => string sci;
Machine.add(sci);

me.dir() + "/Visualization.ck" => string visualization;
Machine.add(visualization);

me.dir() + "/Stft.ck" => string stft;
Machine.add(stft);

me.dir() + "/Subband.ck" => string filter_bank;
Machine.add(filter_bank);

me.dir() + "/example.ck" => string example;
Machine.add(example);
