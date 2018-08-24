// KNN.ck
// this is primarily based on a short tutorial for a basic KNN,
// https://machinelearningmastery.com/tutorial-to-implement-k-nearest-neighbors-in-python-from-scratch/


public class KNN {

	float trainingData[0][0];
	int trainingLabels[0];
    int K, L;

    public void numNeighbors(int k) {
        k => K;
    }
    numNeighbors(15);

    public void numLabels(int l) {
        l => L;
    }
    numLabels(2);

	// standard distance metric
	private float euclideanDistance (float x[], float y[]) {
		0.0 => float distanceSquared;
        for (0 => int i; i < x.size(); i++) {
            Math.pow(x[i] - y[i], 2) +=> distanceSquared;
        }
        return Math.sqrt(distanceSquared);
	}

	// returns array with arguments that would sort the array
	private int[] argSort (float arr[]) {
		arr.size() => int N;
		int arguments[N];

		// prefill with ordered values
		for (0 => int i; i < N; i++) {
			i => arguments[i];
		}

		// will only ever be 12-24 values to sort, bubble sort is fine here
		for (0 => int i; i < N - 1; i++) {
			for (0 => int j; j < N -1; j++) {
				if (arr[i] > arr[j + 1]) {
					// sort array
					arr[j] => float temp;
					arr[j + 1] => arr[j];
					temp => arr[j + 1];

					// sort arguments
					arguments[j] => int tempArgument;
					arguments[j + 1] => arguments[j];
					tempArgument => arguments[j + 1];
				}
			}
		}

		return arguments;
	}

	// returns a sorted list of the closest neighbors
	private float[] getDistances(float trainingSet[][], float testInstance[], int K) {
		trainingSet.size() => int N;
		float distances[N];

		// collect distances from instance and trained data
		for (0 => int i; i < N; i++) {
			euclideanDistance(trainingSet[i], testInstance) => distances[i];
		}

        return distances;
    }

    private int[] getNeighbors(float distances[], int K) {
		int neighbors[K];

        // get indices of closest rows (neighbors)
		argSort(distances) @=> int arguments[];

		// reduce list, I wish there was a .Slice method for this
		for (0 => int i; i < K; i++) {
			arguments[i] => neighbors[i];
		}

		return neighbors;
    }

	private int getHighestVote(int neighbors[], int numLabels) {
		int votes[numLabels];

		for (0 => int i; i < neighbors.size(); i++) {
			votes[neighbors[i]]++;
		}

		0 => int highestVote;
		for (0 => int i; i < numLabels; i++) {
			if (votes[i] > votes[highestVote]) {
				i => highestVote;
			}
		}

		return highestVote;
	}

    private void normalize(float x[]) {
        // normalize distances
        x[0] => float min;
        x[0] => float max;

        for (0 => int i; i < x.size(); i++) {
            if (x[i] > max) {
                x[i] => max;
            }
            if (x[i] < min) {
                x[i] => min;
            }
        }

        for (0 => int i; i < x.size(); i++) {
            (x[i] - min)/max => x[i];
        }
    }

    private void invert(float x[]) {
        for (0 => int i; i < x.size(); i++) {
            1.0 - x[i] => x[i];
        }
    }

    private int getHighestWeightedVote(int neighbors[], int neighborLabels[], float distances[], int numLabels) {
		float weightedVotes[numLabels];

        normalize(distances);
        invert(distances);

		for (0 => int i; i < neighborLabels.size(); i++) {
			distances[neighbors[i]] +=> weightedVotes[neighborLabels[i]];
		}

		0 => int highestVote;
		for (0 => int i; i < numLabels; i++) {
			if (weightedVotes[i] > weightedVotes[highestVote]) {
				i => highestVote;
			}
		}

		return highestVote;
	}

	private int[] getNeighborLabels(int neighbors[], int trainingLabels[]) {
		int neighborLabels[neighbors.size()];

		for (0 => int i; i < neighbors.size(); i++) {
			trainingLabels[neighbors[i]] => neighborLabels[i];
		}

		return neighborLabels;
	}

	public void addFeatures(float data[], int label) {
		trainingData << data;
		trainingLabels << label;
	}

    public void clear() {
        trainingData.clear();
    }

    // returns highest vote
	public int predict(float testInstance[], int distanceWeights) {
		if (trainingData.size() > K) {
			getDistances(trainingData, testInstance, K) @=> float distances[];
			getNeighbors(distances, K) @=> int neighbors[];
			getNeighborLabels(neighbors, trainingLabels) @=> int neighborLabels[];

            if (distanceWeights) {
                return getHighestWeightedVote(neighbors, neighborLabels, distances, L);
            } else {
                return getHighestVote(neighborLabels, L);
            }
		} else {
			return -1;
		}
	}

    // returns neighbor ratio
	public float score(float testInstance[], int numLabels) {
		if (trainingData.size() > K) {
			getDistances(trainingData, testInstance, K) @=> float distances[];
			getNeighbors(distances, K) @=> int neighbors[];
			getNeighborLabels(neighbors, trainingLabels) @=> int neighborLabels[];

			0 => int sum;
			for (0 => int i; i < K; i++) {
				neighborLabels[i] +=> sum;
			}
			return sum/(K$float);
		} else {
			return -1.0;
		}
	}
}
