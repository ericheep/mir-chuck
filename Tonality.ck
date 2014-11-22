// Tonality.ck
// Eric Heep

public class Tonality {
    

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

}
