// LiSaCluster.ck
// Eric Heep

public class LiSaCluster extends Chubgraph{

    // mir classes
    Mel m;
    Sci sci;
    Matrix mat;
    Subband sub;
    Spectral spec;

    // k-means class
    Kmeans km;

    // sound chain
    inlet => FFT fft =^ RMS r =>  blackhole;
    LiSa mic[10];
    Pan2 pan[mic.cap()];
    for (int i; i < mic.cap(); i++) {
        inlet => mic[i] => pan[i] => outlet;
    }

    UAnaBlob blob;
    UAnaBlob rms_blob;

    // fft variables
    int N;
    float X[0];
    dur hop_time, max_duration; 
    second/samp => float sr;

    // control variables
    int num_clusters, play_clusters, rec_active, play_active, voice_active;

    // length of samples
    dur step_length;

    // array to store cluster indices 
    int idx[0];
    
    // variable for which cluster to playback
    int which;

    // initialize
    fftSize(1024);
    stepLength(100::ms);
    maxDuration(10::second);

    // feature vars
    int hfc_on, rms_on, crest_on, cent_on, subcent_on, spr_on, mel_on, mfcc_on;
    int subcent_feats, mel_feats, mfcc_feats, mfcc_min, mfcc_max;

    // transformation array in case of mel/bark features
    float mx[0][0];
    float mfcc_mx[0][0];
    // placeholder array for subband centroids 
    float subband_filts[0];

    // toggles collection of root-mean square data
    fun void rms(int on) {
        on => rms_on;
    }

    // toggles collection of high-frequency-content 
    fun void hfc(int on) {
        on => hfc_on;
    }
    
    // toggles collection of spectral crest factor
    fun void crest(int on) {
        on => crest_on;
    }

    // toggles collection of spectral centroids
    fun void centroid(int on) {
        on => cent_on;
    }

    // toggles collection of subband spectral centroids
    fun void subbandCentroids(int on) {
        on => subcent_on;
        if (on) {
            [0.0, 100.0, 500.0, 1000.0, 10000.0, 22050.0] @=> subband_filts; 
            subband_filts.cap() - 1 => subcent_feats;
        }
    }

    // optional method to implement a custom set of 
    // frequency ranges for subband centroids
    fun void subbandCentroids(float bnk[]) {
        1 => subcent_on;
        bnk.cap() - 1 => subcent_feats;
        bnk @=> subband_filts;
    }

    // toggles collection of spectral spreads
    fun void spread(int on) {
        on => spr_on;
    }

    // toggles collection of mel-filtered data
    fun void mel(int on) {
        on => mel_on;
        24 => mel_feats;    
        if (on) {
            m.calc(N, sr, 24, 1.0, "mel") @=> mx; 
            mat.transpose(mx) @=> mx;
            mat.cutMat(mx, 0, N/2) @=> mx;
        }
    }

    // optional method for matrix transformation
    // types include 'mel', 'bark', and 'constantQ'
    fun void mel(int filts, float width, string type) {
        1 => mel_on;
        filts => mel_feats;    
        m.calc(N, sr, filts, width, type) @=> mx; 
        mat.transpose(mx) @=> mx;
        mat.cutMat(mx, 0, N/2) @=> mx;
    }

    // toggles collection of mfccs
    fun void mfcc(int on) {
        on => mfcc_on;
        if (on) {
            1 => mfcc_min; 
            12 => mfcc_max;
            mfcc_max - mfcc_min => mfcc_feats;

            m.calc(N, sr, 24, 1.0, "mel") @=> mfcc_mx; 
            mat.transpose(mfcc_mx) @=> mfcc_mx;
            mat.cutMat(mfcc_mx, 0, N/2) @=> mfcc_mx;
        }
    }

    // optional method to specifiy mel filters
    // and min and max of mfcc array
    fun void mfcc(int filts, int min, int max) {
        1 => mel_on;
        min => mfcc_min; 
        max => mfcc_max;
        mfcc_max - mfcc_min => mfcc_feats;

        m.calc(N, sr, filts, 1.0, "mel") @=> mfcc_mx; 
        mat.transpose(mx) @=> mfcc_mx;
        mat.cutMat(mx, 0, N/2) @=> mfcc_mx;
    }

    // internal function that recalls the number of enabled features
    fun int numFeatures() {
        int num;
        rms_on +=> num;
        hfc_on +=> num;
        crest_on +=> num;
        cent_on +=> num;
        spr_on +=> num;
        subcent_feats +=> num;
        mel_feats +=> num;
        mfcc_feats +=> num;
        return num;
    }

    // sets N, hop, optional
    // currently hardcoded to always use a hamming window
    fun void fftSize(int fft_size) {
        fft_size => N => fft.size;
        hop((N/2)::samp);
        Windowing.hamming(N) => fft.window;
    }

    // set hop size other than 50% default, optional
    fun void hop(dur h) {
        h => hop_time;
        (hop_time/samp) $ int => X.size;
    }

    // sets which cluster to playback
    fun void cluster(float c) {
        if (c != 1.0) {
            if ((c * play_clusters) $ int != which) {
                (c * play_clusters) $ int => which;
                <<< which >>>;
            }
        }
    }

    // sets number of k-means clusters to utilize
    fun void numClusters(int c) {
        c => num_clusters;
    }

    // sets maximum duration of the LiSa input buffer
    fun void maxDuration(dur d) {
        d => max_duration;
    }

    // sets durational length of each sample step
    fun void stepLength(dur s) {
        s => step_length;
    }

    // plays back samples in clusters
    fun void play(int p) {
        // ensures model is finished training before playing
        hop_time => now;

        // plays until play(0) is called
        if (p) {
            1 => play_active;
            spork ~ playing();
        }
        if (p == 0) {
            0 => play_active;
        }
    }

    // plays random steps belonging to one selectable cluster
    fun void playing() {
        mic[0].play(1);
        while (play_active) {
            Math.random2(0, idx.cap() - 1) => int rand;
            if (idx[rand] == which) {
                mic[0].playPos(rand * step_length);
                step_length => now;
            }
        }
        mic[0].play(0);
    }
    
    // plays steps belonging to one selectable cluster linearly
    fun void linearPlaying() {
        mic[0].play(1);
        while (play_active) {
            for(int i; i < idx.cap(); i++){
                if(idx[i] == which) {
                    mic[0].playPos(i * step_length);
                    step_length => now;
                }
            }
        }
        mic[0].play(0);
    }
    
    // plays steps belonging to one selectable cluster backwards
    fun void backwardsPlaying() {
        mic[0].play(1);
        while (play_active) {
            for(idx.cap() => int i; i > 0; i--){
                if(idx[i] == which) {
                    mic[0].playPos(i * step_length);
                    step_length => now;
                }
            }
        }
        mic[0].play(0);
    }

    fun void voice(int v) {
        // ensures model is finished training before playing
        hop_time => now;

        // plays until play(0) is called
        if (v) {
            1 => voice_active;
            spork ~ voicing();
        }
        if (v == 0) {
            0 => voice_active;
        }
    }

    fun void voicing() {
        // ensures model is finished training before playing
        hop_time => now;
        int check; 

        1.0/(play_clusters + 1) => float p;
        p => float add;
        
        for (int i; i < play_clusters + 1; i++) {
            int newVoice;
            pan[i].pan(p * 2 - 1.0);
            p + add => p;
            mic[i].play(i, 1);
        }
        while (voice_active) {
            for (int i; i < play_clusters; i++) {
                0 => check;
                while (check == 0) {
                    Math.random2(0, idx.cap() - 1) => int rand;
                    if (idx[rand] == i) {
                        mic[i].playPos(i, rand * step_length);
                        1 => check;
                    }
                }
            }
            step_length => now;
        }
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

    // records data and features while active, sends raw_features to train
    fun void recording() {
        // allocates buffer memory and sets corresponding maximium frame size
        (max_duration/hop_time) $ int => int max_frames;

        // retreives number of features 
        numFeatures() => int num_features;

        // will store our raw features
        float raw_features[max_frames][num_features];
        int frame_idx, feature_idx;

        // clears out buffers
        for (int i; i < mic.cap(); i++) {
            mic[i].duration(max_duration);
        }

        // begins recording for number of clusters
        for (int i; i < mic.cap(); i++) {
            mic[i].record(1);
        }

        now => time past;
        while (rec_active) {
            // 50% hop size
            hop_time => now;
            
            // fft array
            fft.upchuck() @=> blob;
            r.upchuck() @=> rms_blob;

            // low level features
            if (rms_on) {
                rms_blob.fval(0) => raw_features[frame_idx][feature_idx];
                feature_idx++;
            }

            if (hfc_on) {
                spec.hfc(blob.fvals()) => raw_features[frame_idx][feature_idx];
                feature_idx++;
            }
 
            if (crest_on) {
                spec.spectralCrest(blob.fvals()) => raw_features[frame_idx][feature_idx];
                feature_idx++;
            }


            if (cent_on) {
                spec.centroid(blob.fvals(), sr, N) => raw_features[frame_idx][feature_idx];
                feature_idx++;
            }

            if (subcent_on) {
                sub.subbandCentroid(blob.fvals(), subband_filts, N, sr) @=> float sub_cents[];
                for (int i; i < sub_cents.cap(); i++) {
                    sub_cents[i] => raw_features[frame_idx][feature_idx];
                    feature_idx++;
                }
            }

            if (spr_on) {
                spec.spread(blob.fvals(), sr, N) => raw_features[frame_idx][feature_idx];
                feature_idx++;
            }

            if (mel_on) {
                mat.dot(blob.fvals(), mx) @=> float mel_filts[];
                for (int i; i < mel_filts.cap(); i++) {
                    mel_filts[i] => raw_features[frame_idx][feature_idx];
                    feature_idx++;
                }
            }

            if (mfcc_on) {
                mat.dot(blob.fvals(), mfcc_mx) @=> float mfccs[];

                // mfcc steps
                mat.log10(mfccs) @=> mfccs;
                sci.dct(mfccs) @=> mfccs;

                // discarding upper half of mfcc
                mat.cut(mfccs, mfcc_min, mfcc_max) @=> mfccs;
                for (int i; i < mfccs.cap(); i++) {
                    mfccs[i] => raw_features[frame_idx][feature_idx];
                    feature_idx++;
                }
            }

            frame_idx++;
            0 => feature_idx;
        }

        // ends recording
        for (int i; i < num_clusters; i++) {
            mic[i].record(0);
        }

        // segmenting variables
        now - past => dur rec_time;
        ((rec_time/step_length) $ int) + 1 => int num_steps;
        (rec_time/hop_time) $ int => int num_frames;

        // discards empty frames
        num_frames => raw_features.size;

        // sends raw data to k-means function
        train(raw_features, num_steps, num_frames);
    }

    // trains the k-means model using means of raw features over the audio steps
    fun void train(float raw[][], int steps, int frames) {
        // incrementers for mean calcuation  
        int div, inc;
      
        // array for storing sums of all features
        float sum[raw[0].cap()];
        float training[steps][raw[0].cap()];

        // finds means of all frames per segment
        for (int i; i < frames; i++) {
            // calculates mean after surpassing a step size in frames
            if (i * hop_time > (inc + 1) * step_length || i == frames - 1) {
                // mean calcuation finally given to training array
                for (int j; j < sum.cap(); j++) {
                    sum[j]/div => training[inc][j];
                    0.0 => sum[j];
                }

                // increments steps and resets div 
                inc++; 
                0 => div;
            }
            for (int j; j < sum.cap(); j++) {
                raw[i][j] +=> sum[j];
            }
            div++;
        }
        
        // in the case that the last step is too short to collect data
        // the last frame is discarded
        // otherwise, there'd be a cluster dedicated to no data
        if (training[steps - 1][0] == 0) {
            steps - 1 => training.size;
        }

        // kmeans centroids
        km.clusters(num_clusters);

        // trains, then predicts using the training data to return index array
        km.train(training) @=> float model[][];
        km.predict(training, model) @=> idx;

        // finds the returned number of clusters
        idx[0] => int max; 
        for (int i; i < idx.cap(); i++) {
            if (idx[i] > max) {
                idx[i] => max; 
            }
        }

        // checks for number of returned clusters
        if (max != num_clusters - 1) {
            max + 1 => play_clusters; 
        }
        else {
            num_clusters => play_clusters;
        }

        for (int i; i < idx.cap(); i++) {
            <<< idx[i] >>>;
        }
    }
}
