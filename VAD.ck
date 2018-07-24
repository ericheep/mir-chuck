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

    fun float numerator(float A, float B, float meanA, float meanB, int lag, int N) {
        0.0 => float numerator;
        for (0 => int i; i < N; i++) {
            (A[i] - meanA) * (B[i - lag] - meanB) +=> numerator;
        }
        return numerator;
    }

    fun float denominator(float A, float B, float meanA, float meanB, int N) {

    }

    fun float crossCorr(float A[], float B[], int lag) {
        A.size() => int N;

        mean(A, N) => float meanA;
        mean(B, N) => float meanB;

        calculateDenominator(A, B, meanA, meanB, N) => float denominator;

    }

}
