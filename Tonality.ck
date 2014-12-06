// Tonality.ck
// Eric Heep

public class Tonality {

    // keystrength template, (E. Gomez, 2006)
    fun float[][] gomezProfs() {
        // array for our correlation matrix
        float gomez_profs[12][12];
        // reads form txt file
        FileIO file;
        file.open("gomezprofs.txt", FileIO.READ);
        for (int i; i < 12; i++) {
            for (int j; j < 12; j++) {
                file => gomez_profs[i][j]; 
            }
        }
        return gomez_profs;
    }

    // major and minor chord templates
    fun float[][] chord(string m) {
        float c[12][12];
        int third, fifth;

        if (m == "maj") {
            4 => third;
            7 => fifth;
        }
        if (m == "min") {
            3 => third;
            7 => fifth;
        }
        if (m == "dim") {
            3 => third;
            6 => fifth;
        }
        if (m == "aug") {
            4 => third;
            8 => fifth;
        }

        int pos;
        for (int i; i < 12; i++) {
            for (int j; j < 12; j++) {
                if (j == (0 + pos) % 12 || j == (third + pos) % 12 || j == (fifth + pos) % 12) {
                    // arithmetic mean of chord entries
                    0.333 => c[j][i];
                }
            }
            pos++;
        }
        return c;
    }

    // 6D tonal centroid, (Harte et al., 2006)
    fun float[][] tonalCentroid() {
        float tc[6][12];

        // r1, r2, and r3 (1.0, 1.0, 0.5)
        [1.0, 1.0, 0.5] @=> float r[];
        [7.0, 3.0, 2.0] @=> float num[];
        [6.0, 2.0, 3.0] @=> float den[];

        for (int l; l < 12; l++) {
            for (int i; i < 3; i++) {
                for (int j; j < 2; j++) {
                    if (j % 2 == 0) {
                        r[i] * Math.sin(l * (num[i] * pi)/den[i]) @=> tc[i + j][l];
                    }
                    else {
                        r[i] * Math.cos(l * (num[i] * pi)/den[i]) @=> tc[i + j][l];
                    }
                }
            }
        }

        return tc;
    }

}
