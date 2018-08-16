// Peaks.ck
// Eric Heep

public class Peaks {
    fun int[] peaks(float x[]) {
        x.size() => int N;

        int p[0];

        for (1 => int i; i < N - 1; i++) {
            if (x[i] > x[i - 1] && x[i] > x[i + 1]) {
                p << i;
            }
        }

        return p;
    }

    fun float[] peakValues(float x[], int peakIndices[]) {
        peakIndices.size() => int N;

        float p[N];
        for (0 => int i; i < N; i++) {
            x[peakIndices[i]] => p[i];
        }
        return p;
    }

    fun int[] highestPeaks(float x[], int amount) {
        peaks(x) @=> int peakIndices[];
        peakValues(x, peakIndices) @=> float peakValues[];
        argSort(peakValues) @=> int indices[];

        int finalIndices[peakIndices.size()];
        for (0 => int i; i < indices.size(); i++) {
            peakIndices[indices[i]] => finalIndices[i];
        }

        // reduce size
        finalIndices.size(amount);

        return finalIndices;
    }

    fun void reverse(int arr[]) {
        int reverseArr[arr.size()];
        for (0 => int i; i < arr.size(); i++) {
            arr[i] => reverseArr[arr.size() - 1 - i];
        }
        for (0 => int i; i < arr.size(); i++) {
            reverseArr[i] => arr[i];
        }
    }

    // index sorting
    fun int[] argSort(float x[]) {
        float xCopy[x.size()];
        for (0 => int i; i < x.size(); i++) {
            x[i] => xCopy[i];
        }

        int idx[x.cap()];
        for (0 => int i; i < xCopy.cap(); i++) {
            float max;
            int idx_max;
            for (int j; j < xCopy.cap(); j++) {
                if (xCopy[j] >= max) {
                    xCopy[j] => max;
                    j => idx_max;
                }
            }
            idx_max => idx[i];
            0 => xCopy[idx_max];
        }
        return idx;
    }

    fun float[] filter(float x[], int m) {
        x.size() => int N;

        for (0 => int i; i < N; i++) {
            0.0 => float sum;
            for (0 => int j; j < m; j++) {
                if (i + j < N) {
                    x[i + j] +=> sum;
                }
            }
            sum/m => x[i];
        }

        return x;
    }
}

/* Peaks p; */

/* float arr[20]; */
/* for (0 => int i; i < arr.size(); i++) { */
/*     Math.random2f(0.0, 1.0) => arr[i]; */
/* } */

/* p.highestPeaks(arr, 3) @=> int indices[]; */

/* <<< "---", "" >>>; */
/* <<< indices[0], indices[1], indices[2] >>>; */
/* <<< arr[indices[0]], arr[indices[1]], arr[indices[2]] >>>; */

