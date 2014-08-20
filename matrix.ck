// matrix.ck
// Eric Heep

public class matrix {
// basic matrix operations and manipulations

    fun int[] arg_max(float x[], int num) {
        /* Returns the index of the max value in a 1D array
        */
        int out[num];
        for (int i; i < num; i++) {
           float max;
           int idx_max;
           for (int j; j < x.cap(); j++) {
                if (x[j] >= max) {
                    x[j] => max;
                    j => idx_max;
                }
            }
            idx_max => out[i];
            0 => x[idx_max];
        }
        return out;
    }

    fun float[][] cut(float x[][], int low, int high) {
        /* Reduces the number of rows in a 2D array 
        */
        high - low => int rows;
        float out[rows][x[0].cap()];
        float temp[x.cap()];
        for (int i; i < x[0].cap(); i++) {
            for (int j; j < x.cap(); j++) {
                x[j][i] => temp[j];
            }
            cut_win(temp, low, high) @=> float r[];
            for (int j; j < rows; j++) {
                r[j] => out[j][i];    
            }
        }
        return out;
    }

    fun float[] cut_win(float x[], int low, int high) {
        /* Reduces the number of rows in a 1D array
        */
        high - low => int num;
        float out[num];
        for (int i; i < num; i++) {
            x[low + i] => out[i];
        }
        return out;
    }

    fun float[][] dot(float x[][], float y[][]) {
        /* Returns the dot product of two matrices
        */
        x.cap() => int rows_x;
        x[0].cap() => int cols_x;
        y.cap() => int rows_y; 
        y[0].cap() => int cols_y; 

        float out[cols_y][cols_x];
        float temp[rows_x];
        for (int i; i < cols_x; i++) {
            for (int j; j < rows_x; j++) {
                x[j][i] => temp[j];
            }
            dot_win(temp, y) @=> float mx[];
            for (int j; j < cols_y; j++) {
                mx[j] => out[j][i];
            }
        }
        return out;
    }

    fun float[] dot_win(float x[], float y[][]) {
        /* Returns the dot product of an array and matrix
        */
        1 => int rows_x; 
        x.cap() => int cols_x;
        y.cap() => int rows_y; 
        y[0].cap() => int cols_y;
        
        float out[cols_y];

        if (cols_x == rows_y) {
            for (int i; i < cols_y; i++) {
                float prod;
                for (int j; j < rows_y; j++) { 
                    x[j] * y[j][i] +=> prod;
                }
                prod => out[i];
            }
            return out;
        }
        else <<< "Number of x columns must match number of y rows", "" >>>;
    }

    fun float[][] log(float x[][]) {
        /* Returns the log of a 2d array
        */
        float out[x.cap()][x[0].cap()];
        float temp[x.cap()];
        for (int i; i < x[0].cap(); i++) {
            for (int j; j < x.cap(); j++) {
                x[j][i] => temp[j];
            }
            log_win(temp) @=> float lg[];
            for (int j; j < x.cap(); j++) {
                lg[j] => out[j][i];    
            }
        }
        return out;
    }

    fun float[] log_win (float x[]) {
        /* Returns the log of a 1D array
        */
        for (int i; i < x.cap(); i++) {
            Math.log(x[i] + 1.0) => x[i];
        }
        return x;
    }
    
    fun float[] mean(float x[][], int axis) {
        /* Returns mean of a 2D array along a given axis
        */
        int rows, cols;
        if (axis == 0) {
            x.cap() => rows;
            x[0].cap() => cols;
        }
        else if (axis == 1) {
            x[0].cap() => rows;
            x.cap() => cols;
        }
        float out[cols];
        for (int i; i < cols; i++) {
            float sum;
            for (int j; j < rows; j++) {
                if (axis == 0) {
                    x[j][i] +=> sum;
                }
                else {
                    x[i][j] +=> sum;
                }
            }
            sum/rows => out[i];
        }
        return out;
    }

    fun int[] order (int x[]) {
        /* Reoders an array
        */
        int out[x.cap()];
        int sum;
        while (sum != x.cap() - 1) {
            0 => sum;
            for (int i; i < x.cap() - 1; i++) {
                if (x[i] > x[i + 1]) {
                    x[i] => int temp;
                    x[i + 1] => x[i];
                    temp => x[i + 1];
                }
                else {
                    sum++;
                }
            } 
        }
        return x;
    }

    fun float[][] transpose (float x[][]) {
        /* Returns a transpose of a 2D array
        */

        float out[x[0].cap()][x.cap()];
        for (int i; i < x.cap(); i++) {
            for (int j; j < x[0].cap(); j++) {
                x[i][j] => out[j][i];
            }
        }
        return out;
    }
}
