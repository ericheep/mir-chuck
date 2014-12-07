// LiSaCluster.ck
// Eric Heep

public class LiSaCluster extends Chubgraph{

    // mir classes
    Mel m;
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
    second/samp => float sr;

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

    // feature vars
    int cent_on, spr_on, hfc_on, mel_on, mfcc_on;
    int mel_feats, mfcc_feats;

    // transformation array in case of mel/bark features
    float mx[0][0];

    fun void centroid(int on) {
        on => cent_on;
    }

    fun void spread(int on) {
        on => spr_on;
    }

    fun void hfc(int on) {
        on => hfc_on;
    }

    fun void mel(int on) {
        on => mel_on;
        24 => mel_feats;    
        if (on) {
            m.calc(N, sr, 24, 1.0, "mel") @=> mx; 
            mat.transpose(mx) @=> mx;
            mat.cutMat(mx, 0, N/2) @=> mx;
        }
    }

    fun void mel(int filts, float width, string type) {
        1 => mel_on;
        filts => mel_feats;    
        m.calc(N, sr, filts, width, type) @=> mx; 
        mat.transpose(mx) @=> mx;
        mat.cutMat(mx, 0, N/2) @=> mx;
    }

    fun int numFeatures() {
        int num;
        cent_on +=> num;
        spr_on +=> num;
        hfc_on +=> num;
        mel_feats +=> num;
        mfcc_feats +=> num;
        <<< num >>>;
        return num;
    }

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

        // max frame size corresponding to max duration
        (max_duration/hop_time) $ int => int max_frames;

        // retreives number of features 
        numFeatures() => int num_features;

        // will store our raw features
        float features[max_frames][num_features];
        int frame_idx, feature_idx;

        // starts recording while gathering features
        mic.record(1);
        now => time past;
        while (rec_active) {
            // 50% hop size
            hop_time => now;
            
            // fft array
            fft.upchuck() @=> blob;

            // low level features
            if (cent_on) {
                spec.centroid(blob.fvals(), sr, N) => features[frame_idx][feature_idx];
                feature_idx++;
            }

            if (spr_on) {
                spec.spread(blob.fvals(), sr, N) => features[frame_idx][feature_idx];
                feature_idx++;
                //<<< features[frame_idx][0], features[frame_idx][1] >>>;
            }

            if (mel_on) {
                mat.dot(blob.fvals(), mx) @=> float mel_filts[];
                for (int i; i < mel_filts.cap(); i++) {
                    mel_filts[i] => features[frame_idx][feature_idx];
                    feature_idx++;
                }
            }

            frame_idx++;
            0 => feature_idx;
        }

        now - past => dur rec_time;
        mic.record(0);

        // segmenting variables
        ((rec_time/step_length) $ int) + 1 => int num_steps;
        (rec_time/hop_time) $ int => int num_frames;
        num_frames => features.size;

        train(features, num_steps, num_frames);
    }

    fun void train(float data[][], int steps, int frames) {
        
        0 => int div;
        0 => int inc;
       
        float sum[data[0].cap()];
        float training[steps][data[0].cap()];

        // finds means of all frames per segment
        for (int i; i < frames; i++) {
            // calculates mean after surpassing a step size in frames
            if (i * hop_time > (inc + 1) * step_length || i == frames - 1) {
                // mean calcuation finally given to training array
                for (int j; j < sum.cap(); j++) {
                    sum[j]/div => training[inc][j];
                    0.0 => sum[j];
                }
                // resetting mean division var and sum array
                0 => div;
                // keeps track of steps
                inc++; 
            }
            for (int j; j < sum.cap(); j++) {
                data[i][j] +=> sum[j];
            }
            div++;
        }
        
        // in the case that the last step is too short to collect data
        // otherwise, there'd be a cluster dedicated to no data
        if (training[steps - 1][0] == 0) {
            steps - 1 => training.size;
        }

        // kmeans centroids
        km.clusters(num_clusters);

        // trains, then predicts using the training data to return index array
        km.train(training) @=> float model[][];
        km.predict(training, model) @=> idx;
        for (int i; i < idx.cap(); i++) {
           <<< idx[i] >>>;
        }
    }
}
