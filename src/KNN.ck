// KNN.ck


// this is primarily based on a short tutorial for a basic KNN,
// https://machinelearningmastery.com/tutorial-to-implement-k-nearest-neighbors-in-python-from-scratch/
public class KNN {

	float trainingData[][];
	int trainingLabels[];

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
	private int[] getNeighbors(float trainingSet[][], float testInstance[], int K) {
		trainingSet.size() => int N;
		float distances[N];
		int neighbors[K];

		// collect distances from instance and trained data
		for (0 => int i; i < N; i++) {
			euclideanDistance(trainingSet[i], testInstance) => distances[i];
		}

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

		0 => int max;
		for (0 => int i; i < numLabels; i++) {
			if (votes[i] > votes[max]) {
				i => max;
			}
		}

		return max;
	}

	private int[] getNeighborLabels(int neighbors[], int trainingLabels[]) {
		int neighborLabels[neighbors.size()];

		for (0 => int i; i < neighbors.size(); i++) {
			trainingLabels[neighbors[i]] => neighborLabels[i];
		}

		return neighborLabels;
	}

	public void train (float data[], int label) {
		trainingData << data;
		trainingLabels << label;
	}

    // returns highest vote
	public int predict (float testInstance[], int numLabels, int K) {
		if (trainingData.size() > K) {
			getNeighbors(trainingData, testInstance, K) @=> int neighbors[];
			getNeighborLabels(neighbors, trainingLabels) @=> int neighborLabels[];
			getHighestVote(neighborLabels, numLabels) => int vote;
			return vote;
		} else {
			return -1;
		}
	}

    // returns neighbor ratio
	public float score(float testInstance[], int numLabels, int K) {
		if (trainingData.size() > K) {
			getNeighbors(trainingData, testInstance, K) @=> int neighbors[];
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
