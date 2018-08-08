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
        float p[0];
        for (0 => int i; i < peakIndices.size(); i++) {
            p << x[peakIndices[i]];
        }
        return p;
    }

    fun int[] highestPeaks(float x[], int amount) {
        peaks(x) @=> int peakIndices[];
        peakValues(x, peakIndices) @=> float peakValues[];
        argBubbleSort(peakValues, peakIndices, peakValues.size());

        peakIndices.size(amount);
        return peakIndices;
    }

    fun void argBubbleSort(float values[], int indices[], int n)
    {
        int i, j;
        for (0 => int i; i < n - 1; i++) {

            // Last i elements are already in place
            for (0 => int j; j < n - i - 1; j++)  {
                if (values[j] > values[j + 1]) {
                    values[i] => float temp;
                    values[j] => values[i];
                    temp => values[j];

                    indices[i] => int tempIndex;
                    indices[j] => indices[i];
                    tempIndex => indices[j];
                }
            }
        }
    }


    fun void quickSort(int arr[], int low, int high)
    {
        if (low < high)
        {
            /* pi is partitioning index, arr[p] is now
               at right place */
            partition(arr, low, high) => int partitionIndex;

            // Separately sort elements before
            // partition and after partition
            quickSort(arr, low, partitionIndex - 1);
            quickSort(arr, partitionIndex + 1, high);
        }
    }

    fun int partition (int arr[], int low, int high)
    {
        arr[high] => int pivot;   // pivot
        (low - 1) => int i;   // Index of smaller element

        for (low => int j; j <=  high - 1; j++) {
            // equal to pivot
            if (arr[j] <= pivot) {
                i++;    // increment index of smaller element

                // swap
                arr[i] => int temp;
                arr[j] => arr[i];
                temp => arr[j];
            }
        }
        // swap
        arr[i + 1] => int temp;
        arr[high] => arr[i + 1];
        temp => arr[high];

        return (i + 1);
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

/* [0.1, 0.2, 0.1, 0.4, 0.5, 0.1, 0.0, 0.8, 0.7, 0.5] @=> float x[]; */

/* p.highestPeaks(x, 2) @=> int indices[]; */

/* <<< indices[0], indices[1] >>>; */

