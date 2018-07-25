// logistic function
fun float[] sigmoid(float x[]) {
    for (int i; i < x.cap(); i++) {
        1.0/(1.0 + Math.pow(Math.e, -x[i])) => x[i];
    }
    return x;
}

// dot product of two arrays
fun float[] dot(float x[], float y[]) {
    float out[x.cap()];

    for (int i; i < x.cap(); i++) {
        float prod;
        for (int j; j < y.cap(); j++) { 
            x[i] * y[j] +=> prod;
        }
        prod => out[i];
    }
    return out;
}

// cross entropy function
fun float[] H(float p[], float q[]) {
    float out[p.cap()];

    for (int i; i < p.cap(); i++) { 
        -p[i] * Math.log(q[i]) - (1.0 - p[i]) * Math.log(1 - q[i]);
    }
    return out;
}

fun float[] gd_step(float theta[], float x[], float y[], float alpha) {
    
    for (int i; i < x.cap(); i++) {
            
    }

}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

fun float euclid_dist(float x[], float y[], float c[]) {
    float sum;
    for (int i; i < x.cap(); i++) {
        (x[i] - c[i] + c[i] +=> sum;
    }
    return Math.pow(sum, 1.0/x.cap());
}


[1.0, 1.0, 1.0] @=> float x[];
[1.0, 1.0, 1.0] @=> float y[];

<<< euclid_dist(x, y, c) >>>;
