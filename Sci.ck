// Sci.ck
// Eric Heep
// drey


public class Sci {
    
    // matrix multiply
    fun float dot(float x[], float y[]){
        float result;
        for(int i; i < x.cap(); i++){
            x[i] * y[i] +=> result;
        }
        return result;
    }
    
    // returns magnitude
    fun float veclen(float x[]){
        float temp;
        for(int i; i < x.cap(); i++){
            x[i] * x[i] +=> temp;
        }
        return Math.sqrt(temp);
    }
    
    // cepstral mean subtraction
    fun float[][] cmsMat(float X[][]) {
        float out[X.cap()][X[0].cap()];
        float temp[X.cap()];
        for (int i; i < X[0].cap(); i++) {
            for (int j; j < X.cap(); j++) {
                X[j][i] => temp[j];
            }
            cms(temp) @=> float c[];
            for (int j; j < X.cap(); j++) {
                c[j] => out[j][i];    
            }
        }
        return out;
        
    }
    
    // cepstral mean subtraction
    fun float[] cms(float x[]) {
        
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
    fun float cosineDistance(float x[], float y[]) {
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
        //<<<num, prod>>>;
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
    fun float cosineDistanceMat(float x[][], float y[][]) {
        0 => float sum;
        float temp_x[x.cap()];
        float temp_y[y.cap()];
        for (int i; i < x[0].cap(); i++) {
            for (int j; j < x.cap(); j++) {
                x[j][i] => temp_x[j];
                y[j][i] => temp_y[j];
            }
            cosineDistance(temp_x, temp_y) => float temp;
            temp +=> sum;
        }
        return sum/y[0].cap();
    }
    // WIP
    // cosine similarity for beat spectrum
    fun float[][] cosineSimMat(float x[][], float y[][]) {
        
        0 => float sum;
        float S[x[0].cap()][x[0].cap()];
        float temp_x[x.cap()];
        float temp_y[x.cap()];
        
        for (int i; i < x[0].cap(); i++) {
            for (int k; k < x[0].cap(); k++) {
                for (int j; j < x.cap(); j++) {
                    x[j][i] => temp_x[j];
                    y[j][k] => temp_y[j];
                }
                dot(temp_x, temp_y) / (veclen(temp_x) * veclen(temp_y)) => S[i][k];
            }
        }
        //<<<S[1][0], S[1][1], S[1][2], S[1][3], S[1][4]>>>;
        //<<<"temp_x: ", temp_x[2], " temp_y: ", temp_y[2], " S: ", S[2][0]>>>;
        //<<<"sim done">>>;
        return S;
    }
    //WIP
    // autocorrelation
    fun float[] autoCorr(float S[][]){
        float B[S.cap()];
        float temp_x[S.cap()];
        float temp_y[S[0].cap()];
        
        for(int i; i < S[0].cap(); i++){
            for(int j; j < S.cap(); j++){
                S[j][i] => temp_x[j];
                S[j][i] => temp_y[j];
            }
        }
        for (1 => int k; k < S.cap(); k++){
            for(int i; i<  S.cap(); i++){
                temp_x[i] * temp_y[k] +=> B[i];
            }
        }
        
        <<<temp_x[0], temp_y[1], B[0]>>>;
        return B;
    }
    
    // discrete cosine transform
    fun float[][] dctMat(float x[][]) {
        float out[x.cap()][x[0].cap()];
        float temp[x.cap()];
        for (int i; i < x[0].cap(); i++) {
            for (int j; j < x.cap(); j++) {
                x[j][i] => temp[j];
            }
            dct(temp) @=> float d[];
            for (int j; j < x.cap(); j++) {
                d[j] => out[j][i];    
            }
        }
        return out;
    }
    
    // discrete cosine transform
    fun float[] dct(float x[]){
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
