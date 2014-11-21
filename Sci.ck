// Sci.ck
// Eric Heep

public class Sci {

    // cepstral mean subtraction
    fun float[][] cms(float X[][]) {
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
    
    // cepstral mean subtraction
    fun float[] cms_win(float x[]) {

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

    // cosine similarity score
    fun float cosine_dist(float x[], float y[]) {
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

    // cosine similarity score
    fun float mat_cosine_compare(float x[][], float y[][]) {
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

    // discrete cosine transform
    fun float[][] dct(float x[][]) {
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

    // discrete cosine transform
    fun float[] dct_win(float x[]){
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
