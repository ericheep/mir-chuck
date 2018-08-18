// SpectralCrest.ck


public class SpectralCrest {

    fun float compute(float X[]){
        float max, sum;
        for (int j; j < X.cap(); j++) {
            if (X[j] >= max) {
                X[j] => max;
            }
            X[j] +=> sum;
        }
        return max / sum;
    }
}
