// Subband.ck
// Eric Heep    

public class Subband {
    // subband analysis

    fun float[] bank(float X[], float filts[], int N, float sr) {
        /* Subband analysis of an stft window
        */

        float subbands[filts.cap() - 1];
        N/2 + 1 => int bins;

        for (int i; i < bins; i++) {
            sr/N * i => float frq; 
            for (int j; j < filts.cap() - 1; j++) {
                if (filts[j] < frq && filts[j + 1] > frq) {
                    X[i] +=> subbands[j];        
                }
            }
        }

        return subbands;
    }

    fun float[] sub_cent(float X[], float filts[], int N, float sr) {
        /* Subband centroid of an stft window
        */ 
        
        float prod[filts.cap() - 1];
        float sum[filts.cap() - 1];
        float centroid[filts.cap() - 1];

        X.cap() => int bins;

        for (int i; i < bins; i++) {
            sr/N * i => float frq; 
            for (int j; j < filts.cap() - 1; j++) {
                if (filts[j] < frq && filts[j + 1] > frq) {
                    X[i] * frq +=> prod[j];        
                    X[i] +=> sum[j];
                }
            }
        }

        for (int i; i < filts.cap() - 1; i++) {
            if (prod[i] != 0 && sum[i] != 0) {
                prod[i]/sum[i] => centroid[i];
            }
            else {
                0 => centroid[i];
            }
        }

        return centroid;
    }
}
