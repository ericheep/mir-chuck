// LiSaCluster.ck
// Eric Heep

public class LiSaCluster extends Chubgraph{

    // mir classes
    Mel mel;
    Matrix mat;
    Subband bnk;
    Spectral spec;

    // k-means class
    Kmeans km;

    // sound chain
    inlet => FFT fft => blackhole;
    inlet => LiSa mic => outlet;

    // fft array
    float X[0];

    // fft vars
    UAnaBlob blob;
    int N;
    dur hop_time, max_duration; 
    second / samp => float sr;

    // control variables
    int num_clusters, rec_active, play_active;

    // length of samples
    dur step_length;

    // array to store cluster indices 
    int idx[0];

    // initialize
    fftSize(1024);
    stepLength(100::ms);
    maxDuration(10::second);

    // feature arrays
    float cent[0];
    float spr[0];

    // sets N, hop, and window using fft size
    fun void fftSize(int fft_size) {
        fft_size => N => fft.size;
        hop((N/2)::samp);
        Windowing.hamming(N) => fft.window;
    }

    // option to change default 50% hop
    fun void hop(dur h) {
        h => hop_time;
        (hop_time/samp) $ int => X.size;
    }

    fun void clusters(int c) {
        c => num_clusters;
    }

    fun void maxDuration(dur d) {
        d => max_duration;
    }

    fun void stepLength(dur s) {
        s => step_length;
    }

    // plays back samples in clusters
    fun void play(int p) {
        // ensures model is finished training before playing
        hop_time => now;
        if (p) {
            1 => play_active;
            spork ~ playing();
        }
        if (p == 0) {
            0 => play_active;
        }
    }

    fun void playing() {
        mic.play(1);
        while (play_active) {
            Math.random2(0, idx.cap() - 1) => int rand;
            if (idx[rand] == 0) {
                mic.playPos(rand * step_length);
                step_length => now;
            }
        }
        mic.play(0);
    }

    // records and then trains
    fun void record(int r) {
        if (r) {
            1 => rec_active;
            spork ~ recording();
        }
        if (r == 0) {
            0 => rec_active;
        }
    }

    fun void recording() {
        // allocating buffer memory
        mic.duration(max_duration);

        // starts recording
        mic.record(1);
        now => time past;
        while (rec_active) {
            // 50% hop size
            hop_time => now;
            
            // fft array
            fft.upchuck() @=> blob;

            // low level features
            cent << spec.centroid(blob.fvals(), sr, N);
            spr << spec.spread(blob.fvals(), sr, N);
        }
        now - past => dur rec_time;
        mic.record(0);

        // segmenting variables
        ((rec_time/step_length) $ int) + 1 => int num_steps;
        (rec_time/hop_time) $ int => int num_frames;
        train(num_steps, num_frames);
    }

    fun void train(int steps, int frames) {
        // feature variables
        float cent_sum;
        float spr_sum;

        // feature arrays
        float cent_mean[steps];
        float spr_mean[frames];

        0 => int div;
        1 => int inc;

        // finds means of all frames per segment
        for (int i; i < frames; i++) {
            if (i * hop_time > inc * step_length) {
                // finds the means of a number of frames per segment
                cent_sum/div => cent_mean[inc];
                spr_sum/div => spr_mean[inc]; 

                inc++; 
                
                // resetting vars for mean calculation per segment
                0 => cent_sum;
                0 => spr_sum;
                0 => div;
            }
            cent[i] +=> cent_sum;
            spr[i] +=> spr_sum;
            div++;
        }

        // packing data into a matrix for training and predicting
        float training[steps][2];
        for (int i; i < steps; i++) {
            cent_mean[i] => training[i][0];
            spr_mean[i] => training[i][1];
        }

        // kmeans centroids
        km.clusters(num_clusters);

        // trains, then predicts using the training data to return index array
        km.train(training) @=> float model[][];
        km.predict(training, model) @=> idx;

        // feature arrays
        cent.clear();
        spr.clear();
    }
}
