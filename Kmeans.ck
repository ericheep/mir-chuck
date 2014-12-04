// Kmeans.ck
// Eric Heep

public class Kmeans {

    // number of clusters/centroids
    2 => int k;
    25 => int max_iterations;

    // recalculates centroid each iteration
    fun float[][] centroid(float x[][], int idx[], int k) {
        x.cap() => int instances;
        x[0].cap() => int features;
        
        // centroid update array
        float c[k][features];
        float sum[k][features];
        int div[k][features];
        for (int i; i < instances; i++) {
            for (int j; j < features; j++) {
                x[i][j] +=> sum[idx[i]][j];    
                div[idx[i]][j]++;
            }
        }
        for (int i; i < k; i++) {
            for (int j; j < features; j++) {
                sum[i][j]/div[i][j] => c[i][j];
            }
        }

        return c;
    }

    // euclidean distance function for N-features
    fun float[][] euclid_dist(float x[][], float c[][]) {
        x.cap() => int instances;
        x[0].cap() => int features;
        c.cap() => int centroids; 

        // distance arrays
        float d[instances][centroids];
        for (int k; k < centroids; k++) {
            for (int i; i < instances; i++) {
                float sum;
                for (int j; j < features; j++) {
                    Math.pow((x[i][j] - c[k][j]), 2) +=> sum;
                }
                Math.sqrt(sum) => d[i][k];
            }
        }
        return d;
    }

    // finds the minimum value indices across thes rows of a matrix
    fun int[] argMin(float d[][]) {
        d.cap() => int instances;
        d[0].cap() => int clusters;

        // index array
        int idx[instances];
        for (int i; i < instances; i++) {
            d[i][0] => float min;
            for (int j; j < clusters; j++) {
                if (d[i][j] < min) {
                    d[i][j] => min;
                    j => idx[i];
                }
            }
        }
        return idx;
    }

    // number of clusters to return
    fun void clusters(int c) {
        c => k;
    }
    
    // max iterations in case of non-convergence
    fun void maxIterations(int m) {
        m => maxIterations;
    }

    // main function to train a model
    fun int[] train(float x[][]) {

        // features
        x[0].cap() => int num_features;

        // centroids
        float c[k][num_features];

        // indices
        int idx[num_features];

        // centroid assignment
        for (int i; i < k; i++) {
            for (int j; j < num_features; j++) {
                x[i][j] => c[i][j];
            }
        }

        for (int i; i < max_iterations; i++) {
            // returns a distance matrix of clusters by instances 
            euclid_dist(x, c) @=> float d[][];
            
            // checks for convergence
            c @=> float check[][];

            // returns an array with the labels
            argMin(d) @=> idx;
            
            // recalculate centroids
            centroid(x, idx, k) @=> c;
            
            int check_sum;
            for (int i; i < c.cap(); i++) {
                for (int j; j < c[0].cap(); j++) {
                    if (c[i][j] == check[i][j]) {
                        check_sum++;
                    }
                } 
            }

            if (check_sum == (c.cap() * c[0].cap())) {
                break;
            }
        }
        return idx;
    }
}

Kmeans km;

// data
//float x[num_instances][num_features];
[[1.0, 3.0, 1.0, 4.0, 2.0], [1.2, 3.1, 1.3, 4.1, 2.0], [1.3, 3.5, 1.2, 4.5, 2.1],
 [4.0, 2.1, 4.4, 1.1, 0.1], [3.9, 2.0, 4.3, 1.0, 0.0], [4.1, 1.9, 5.9, 1.2, 0.5],
 [1.0, 3.0, 1.0, 4.0, 2.0], [1.2, 3.1, 1.3, 4.1, 2.0], [1.3, 3.5, 1.2, 4.5, 2.1],
 [4.0, 2.1, 4.4, 1.1, 0.1], [3.9, 2.0, 4.3, 1.0, 0.0], [4.1, 1.9, 5.9, 1.2, 0.5]]
 @=> float x[][];

km.train(x) @=> int idx[];

for (int i; i < idx.cap(); i++) {
    <<< idx[i] >>>;
}

