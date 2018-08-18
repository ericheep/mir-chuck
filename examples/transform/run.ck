// run.ck

// classes
Machine.add(me.dir(-2) + "src/Transform.ck");
Machine.add(me.dir(-2) + "src/MFCCs.ck");
Machine.add(me.dir(-2) + "src/utility/Matrix.ck");

// give time to load
1::ms => now;

// main program
Machine.add(me.dir() + "/transform.ck");
