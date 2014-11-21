// Sci.ck
// Eric Heep

public class Sci {
    // scientific tools 

    fun float[][] cms(float X[][]) {
        /* Cepstral mean subtraction of a 2D array
        */
        float out[X.cap()][X[0].cap()];
        float temp[X.cap()];
        for (int i; i < X[0].cap(); i++) {
            for (int j; j < X.cap(); j++) {
                X[j][i] => temp[j];
            }
            cms_win(temp) @=> float c[];
            for (int j; j < X.cap(); j++) {
                c[j] => out[j][i];    
            }
        }
        return out;

    }
   
    fun float[] cms_win(float x[]) {
        /* Cepstral mean subtraction of a 1D array
        */
        float sum;
        for (int i; i < x.cap(); i++) {
            x[i] +=> sum; 
        }
        sum/x.cap() => float mean;
        for (int i; i < x.cap(); i++) {
            x[i] -=> mean;
            if (x[i] < 0) {
                0 => x[i];
            }
        }
        return x;
    }

    fun float cosine_dist(float x[], float y[]) {
        /* Returns a cosine simlilarity score for two arrays
        */
        float sum_x, sum_y, num;

        for (int i; i < x.cap(); i++) {
            x[i] * x[i] +=> sum_x;
            y[i] * y[i] +=> sum_y;
        }

        Math.sqrt(sum_x) => sum_x;
        Math.sqrt(sum_y) => sum_y;

        sum_x * sum_y => float prod;

        for (int i; i < y.cap(); i++) {
            x[i] * y[i] +=> num;
        }
        
        if (num != 0 && prod == 0) {
            return num/(prod + 0.000001);
        }
        if (num != 0 && prod != 0) {
            return num/prod;
        }
        if (num == 0 && prod != 0) {
            return num/prod;
        }
        if (num == 0 && prod == 0) {
            return 1.0;
        }
    }

    fun float mat_cosine_compare(float x[][], float y[][]) {
        /* Returns a cosine similarity score for two matrices
        */
        0 => float sum;
        float temp_x[x.cap()];
        float temp_y[y.cap()];
        for (int i; i < x[0].cap(); i++) {
            for (int j; j < x.cap(); j++) {
                x[j][i] => temp_x[j];
                y[j][i] => temp_y[j];
            }
            cosine_dist(temp_x, temp_y) => float temp;
            temp +=> sum;
        }
        return sum/y[0].cap();
    }

    fun float[][] dct(float x[][]) {
        /* Returns the direct cosine transform of a 2D array
        */
        float out[x.cap()][x[0].cap()];
        float temp[x.cap()];
        for (int i; i < x[0].cap(); i++) {
            for (int j; j < x.cap(); j++) {
                x[j][i] => temp[j];
            }
            dct_win(temp) @=> float d[];
            for (int j; j < x.cap(); j++) {
                d[j] => out[j][i];    
            }
        }
        return out;
    }

    fun float[] dct_win(float x[]){
        /* Returns the direct cosine transform of a 1D array
        */
        x.cap() => int N;
        float out[N];
        for (int k; k < N; k++) {
            float sum;
            for (int n; n < N; n++) {
                x[n] * Math.cos(pi/N * (n + 0.5) * k) +=> sum;
            }
            sum => out[k];
        }
        return out;
    }
}
