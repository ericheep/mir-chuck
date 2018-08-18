// HighFrequencyContent.ck


public class HighFrequencyContent {

    fun float compute(float X[]) {
        float out;
        for(int k; k < X.cap(); k++){
            X[k] * k +=> out;
        }
        return out;
    }
}
