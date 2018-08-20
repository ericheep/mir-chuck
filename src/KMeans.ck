// KMeans.ck


public class KMeans {

    // number of clusters/centroids
    2 => int k;
    25 => int maxIterations;

    float trainingData[0][0];
    float model[0][0];

    // recalculates centroid each iteration
    fun float[][] centroid(float x[][], int indices[], int k) {
        x.size() => int instances;
        x[0].size() => int features;

        // centroid update array
        float c[k][features];
        float sum[k][features];
        int div[k][features];
        for (0 => int i; i < instances; i++) {
            for (0 => int j; j < features; j++) {
                x[i][j] +=> sum[indices[i]][j];
                div[indices[i]][j]++;
            }
        }
        for (0 => int i; i < k; i++) {
            for (0 => int j; j < features; j++) {
                sum[i][j]/div[i][j] => c[i][j];
            }
        }

        return c;
    }

    // euclidean distance function for a matrix of N-features
    fun float[][] euclideanDistances(float x[][], float c[][]) {
        x.size() => int instances;
        x[0].size() => int features;
        c.size() => int centroids;

        // distance matrix
        float d[instances][centroids];
        for (int k; k < centroids; k++) {
            for (0 => int i; i < instances; i++) {
                float sum;
                for (0 => int j; j < features; j++) {
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
        for (0 => int k; k < centroids; k++) {
            float sum;
            for (0 => int j; j < features; j++) {
                Math.pow(x[j] - c[k][j], 2) +=> sum;
            }
            Math.sqrt(sum) => d[k];
        }
        return d;
    }

    // finds the minimum index of an array
    fun int argMin(float d[]) {
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
    fun int[] argMins(float d[][]) {
        d.size() => int instances;
        d[0].size() => int clusters;

        // index array
        int indices[instances];
        for (0 => int i; i < instances; i++) {
            d[i][0] => float min;
            for (0 => int j; j < clusters; j++) {
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
    fun void setMaxIterations(int m) {
        m => maxIterations;
    }

    // returns an array of predicted scores
    fun int predict(float x[]) {
        if (model.size() > 0) {
            euclideanDistance(x, model) @=> float d[];
            return argMin(d);
        } else {
            return -1;
        }
    }

    fun void addFeatures(float data[]) {
        trainingData.size() => int N;
        trainingData.size(N + 1);
        data @=> trainingData[N];
    }

    fun void clearModel() {
        model.clear();
    }

    fun float computeModel() {
        trainingData[0].size() => int numFeatures;

        // centroids
        float c[k][numFeatures];

        // indices
        int indices[numFeatures];

        // centroid assignment
        for (0 => int i; i < k; i++) {
            for (int j; j < numFeatures; j++) {
                trainingData[i][j] => c[i][j];
            }
        }

        // main loop, breaks at convergence or at max iterations
        for (0 => int i; i < maxIterations; i++) {
            // returns a distance matrix of clusters by instances
            euclideanDistances(trainingData, c) @=> float d[][];

            // checks for convergence
            c @=> float check[][];

            // returns an array with the labels
            argMins(d) @=> indices;

            // recalculate centroids
            centroid(trainingData, indices, k) @=> c;

            // checks for convergence
            int check_sum;
            for (0 => int i; i < c.size(); i++) {
                for (0 => int j; j < c[0].size(); j++) {
                    if (c[i][j] == check[i][j]) {
                        check_sum++;
                    }
                }
            }

            if (check_sum == (c.size() * c[0].size())) {
                break;
            }
        }

        c @=> model;
    }
}
