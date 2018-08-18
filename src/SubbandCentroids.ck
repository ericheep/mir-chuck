// SubbandCentroids.ck


public class SubbandCentroids {

    // subband collection without centroids
    fun float[] bank(float X[], float filters[], float sr, int N) {

        float subbands[filters.size() - 1];
        N/2 + 1 => int bins;

        for (int i; i < bins; i++) {
            sr/N * i => float frq;
            for (int j; j < filters.size() - 1; j++) {
                if (filters[j] < frq && filters[j + 1] > frq) {
                    X[i] +=> subbands[j];
                }
            }
        }

        return subbands;
    }

    // subband centroids
    fun float[] compute(float X[], float filters[], float sr, int N) {

        float products[filters.size() - 1];
        float sums[filters.size() - 1];
        float centroids[filters.size() - 1];

        X.size() => int bins;

        for (int i; i < bins; i++) {
            sr/N * i => float frq;
            for (int j; j < filters.size() - 1; j++) {
                if (filters[j] < frq && filters[j + 1] > frq) {
                    X[i] * frq +=> products[j];
                    X[i] +=> sums[j];
                }
            }
        }

        for (int i; i < filters.size() - 1; i++) {
            if (products[i] != 0 && sums[i] != 0) {
                products[i]/sums[i] => centroids[i];
            }
            else {
                0 => centroids[i];
            }
        }

        return centroids;
    }
}
