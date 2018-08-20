// run.ck

// classes
Machine.add(me.dir(-2) + "src/Transform.ck");
Machine.add(me.dir(-2) + "src/MFCCs.ck");
Machine.add(me.dir(-2) + "src/Deltas.ck");
Machine.add(me.dir(-2) + "src/KNN.ck");

// main program
Machine.add(me.dir() + "/knn.ck");
