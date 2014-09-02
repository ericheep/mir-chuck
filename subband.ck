// subband.ck
// Eric Heep    

public class subband{
    // subband analysis

    fun float[] subband(float X[], float filts[], int N, float sr) {
        /* Subband analysis of an stft window
        */

        float subfilts[filts.cap() - 1];
        N/2 + 1 => int bins;

        for (int i; i < bins; i++) {
            sr/N * i => float frq; 
            for (int j; j < filts.cap() - 1; j++) {
                if (filts[j] < frq && filts[j + 1] > frq) {
                    X[i] +=> subfilts[j];        
                }
            }
        }

        return subfilts;
    }
}
