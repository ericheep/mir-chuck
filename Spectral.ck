// Spectral.ck

public class Spectral {

    // spectral centroid
    fun float centroid(float X[], float sr, int fft_size) {

        // array for our bin frequencies
        float fft_frqs[fft_size/2 + 1];

        // finds center bin frequencies
        for (int i; i < fft_frqs.cap(); i++) {
            sr/fft_size * i => fft_frqs[i];
        }

        float den;
        float power[X.cap()];
        for (int i; i < X.cap(); i++) {
            X[i] * X[i] => power[i]; 
            power[i] +=> den;
        }

        float num;
        for (int i; i < X.cap(); i++) {
            fft_frqs[i] * power[i] +=> num; 
        }

        return num/den;
    }
    
    // spectral spread
    fun float spread(float X[], float sr, int fft_size) {
        float power[X.cap()];
        float square[X.cap()];
        float num;
        float den;
        centroid(X, sr, fft_size) => float cent;
        for(int i; i < X.cap(); i++) {
            X[i] * X[i] => power[i]; 
            Math.pow(i - cent, 2) => square[i];
            power[i] * square[i] +=> num;
            power[i] +=> den;
        }
        
        return Math.sqrt(num/den);
        


    }

    //spectral flatness
    fun float flatness(float X[]) {
        1 => float powerNum;
        float powerDen;
        float num;
        float den;
        
        for (int i; i < X.cap(); i++) {
            if(X[i] == 0){
                .00001 => X[i];
                <<<"fuck">>>;
            }
            (X[i] * X[i]) *=> powerNum; 
            
            (X[i] * X[i]) +=> powerDen;
        }

        powerDen/X.cap() => den;
        Math.pow(powerNum,1.0/X.cap()) => num;
        //<<< den, num, powerNum, powerDen >>>;

        return num/den;

    }
}
