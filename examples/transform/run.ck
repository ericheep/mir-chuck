// run.ck

// classes
Machine.add(me.dir(-2) + "src/features/Features.ck");

// give time to load
1::ms => now;

// main program
Machine.add(me.dir() + "/features.ck");
