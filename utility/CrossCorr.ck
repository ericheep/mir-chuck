// CrossCorr.ck
// Eric Heep

public class CrossCorr {

    fun float mean(float X[], int N) {
        0.0 => float sum;
        for (0 => int i; i < N; i++) {
            X[i] +=> sum;
        }
        return sum/(N * 1.0);
    }

    fun float denominator(float A[], float B[], float meanA, float meanB, int N) {
        0.0 => float sumA;
        0.0 => float sumB;

        for (0 => int i; i < N; i++) {
            (A[i] - meanA) * (A[i] - meanA) +=> sumA;
            (B[i] - meanB) * (B[i] - meanB) +=> sumB;
        }

        return Math.sqrt(sumA * sumB);
    }

    fun float[] crossCorr(float A[], float B[], int lag) {
        A.size() => int N;

        /* mean(A, N) => float meanA; */
        /* mean(B, N) => float meanB; */
        0 => float meanA;
        0 => float meanB;

        denominator(A, B, meanA, meanB, N) => float denom;

        float series[0];

        for (-lag => int i; i < lag; i++) {
            0.0 => float sumAB;
            for (0 => int j; j < N; j++) {
                j + i => int k;
                if (k < 0 || k >= N) {
                    continue;
                } else {
                    (A[j] - meanA) * (B[k] - meanB) +=> sumAB;
                }
            }
            series << sumAB / denom;
        }

        return series;
    }
}
