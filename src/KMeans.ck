// KMeans.ck


public class KMeans {

    // number of clusters/centroids
    2 => int k;
    25 => int maxIterations;

    // recalculates centroid each iteration
    fun float[][] centroid(float x[][], int indices[], int k) {
        x.size() => int instances;
        x[0].size() => int features;

        // centroid update array
        float c[k][features];
        float sum[k][features];
        int div[k][features];
        for (0 => int i; i < instances; i++) {
            for (int j; j < features; j++) {
                x[i][j] +=> sum[indices[i]][j];
                div[indices[i]][j]++;
            }
        }
        for (0 => int i; i < k; i++) {
            for (int j; j < features; j++) {
                sum[i][j]/div[i][j] => c[i][j];
            }
        }

        return c;
    }

    // euclidean distance function for a matrix of N-features
    fun float[][] euclidDistances(float x[][], float c[][]) {
        x.size() => int instances;
        x[0].size() => int features;
        c.size() => int centroids;

        // distance matrix
        float d[instances][centroids];
        for (int k; k < centroids; k++) {
            for (0 => int i; i < instances; i++) {
                float sum;
                for (int j; j < features; j++) {
                    Math.pow((x[i][j] - c[k][j]), 2) +=> sum;
                }
                Math.sqrt(sum) => d[i][k];
            }
        }
        return d;
    }

    // euclidean distance function for an array of N-features
    fun float[] euclideanDistance(float x[], float c[][]) {
        x.size() => int features;
        c.size() => int centroids;

        // distance array
        float d[centroids];
        for (int k; k < centroids; k++) {
            float sum;
            for (int j; j < features; j++) {
                Math.pow(x[j] - c[k][j], 2) +=> sum;
            }
            Math.sqrt(sum) => d[k];
        }
        return d;
    }

    // finds the minimum index of an array
    fun int singleArgMin(float d[]) {
        d.size() => int clusters;

        // low index
        int index;
        d[0] => float min;
        for (0 => int i; i < clusters; i++) {
            if (d[i] < min) {
                d[i] => min;
                i => index;;
            }
        }
        return index;
    }

    // finds the minimum indices across the rows of a matrix
    fun int[] argMin(float d[][]) {
        d.size() => int instances;
        d[0].size() => int clusters;

        // index array
        int indices[instances];
        for (0 => int i; i < instances; i++) {
            d[i][0] => float min;
            for (int j; j < clusters; j++) {
                if (d[i][j] < min) {
                    d[i][j] => min;
                    j => indices[i];
                }
            }
        }
        return indices;
    }

    // number of clusters to return
    fun void clusters(int c) {
        c => k;
    }

    // max iterations in case of non-convergence
    fun void maxIterations(int m) {
        m => maxIterations;
    }

    fun int singlePredict(float x[], float m[][]) {
        singleEuclidDist(x, m) @=> float d[];
        return singleArgMin(d);
    }

    // returns an array of predicted scores
    fun int[] predict(float t[][], float m[][]) {
        euclidDist(t, m) @=> float d[][];
        return argMin(d);
    }

    // main function to train a model
    fun float[][] train(float x[][]) {

        // features
        x[0].size() => int numFeatures;

        // centroids
        float c[k][numFeatures];

        // indices
        int indices[numFeatures];

        // centroid assignment
        for (0 => int i; i < k; i++) {
            for (int j; j < numFeatures; j++) {
                x[i][j] => c[i][j];
            }
        }

        // main loop, breaks at convergence or at max iterations
        for (0 => int i; i < maxIterations; i++) {
            // returns a distance matrix of clusters by instances
            euclidDist(x, c) @=> float d[][];

            // checks for convergence
            c @=> float check[][];

            // returns an array with the labels
            argMin(d) @=> indices;

            // recalculate centroids
            centroid(x, indices, k) @=> c;

            // checks for convergence
            int check_sum;
            for (0 => int i; i < c.size(); i++) {
                for (int j; j < c[0].size(); j++) {
                    if (c[i][j] == check[i][j]) {
                        check_sum++;
                    }
                }
            }

            if (check_sum == (c.size() * c[0].size())) {
                break;
            }
        }
        return c;
    }
}

/*
KMeans km;

// data
//float x[num_instances][numFeatures];
[[1.0, 3.0, 1.0, 4.0, 2.0], [1.2, 3.1, 1.3, 4.1, 2.0], [1.3, 3.5, 1.2, 4.5, 2.1],
 [4.0, 2.1, 4.4, 1.1, 0.1], [3.9, 2.0, 4.3, 1.0, 0.0], [4.1, 1.9, 5.9, 1.2, 0.5],
 [1.0, 3.0, 1.0, 4.0, 2.0], [1.2, 3.1, 1.3, 4.1, 2.0], [1.3, 3.5, 1.2, 4.5, 2.1],
 [4.0, 2.1, 4.4, 1.1, 0.1], [3.9, 2.0, 4.3, 1.0, 0.0], [4.1, 1.9, 5.9, 1.2, 0.5]]
 @=> float x[][];

// training the model
km.train(x) @=> float model[][];

// test data
//[[4.0, 2.1, 4.4, 1.1, 0.1], [4.0, 2.1, 4.4, 1.1, 0.1], [1.2, 3.1, 1.3, 4.1, 2.0]] @=> float test[][];

// predict using the model
//km.predict(test, model) @=> int score[];
<<< km.singlePredict([1.0, 3.0, 1.0, 4.0, 2.0], model) >>>;
//for (0 => int i; i < score.size(); i++) {
//    <<< score[i] >>>;
//}
*/
