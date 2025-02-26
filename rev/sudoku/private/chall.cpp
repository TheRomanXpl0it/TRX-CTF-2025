#include <iostream>
#include <vector>
#include <cmath>
#include <string>
using namespace std;

const int SIZE = 25;

vector<vector<int>> board = {
    {0, 0, 0, 21, 0, 11, 0, 0, 3, 24, 9, 20, 23, 0, 7, 22, 0, 5, 18, 0, 15, 2, 16, 13, 0},
    {24, 4, 0, 20, 15, 0, 0, 5, 0, 16, 2, 25, 22, 0, 17, 6, 21, 0, 14, 0, 8, 10, 1, 19, 18},
    {0, 0, 10, 0, 5, 0, 21, 19, 22, 0, 3, 13, 1, 16, 0, 15, 4, 7, 23, 24, 12, 0, 14, 0, 0},
    {0, 0, 13, 6, 12, 14, 4, 1, 0, 0, 24, 18, 19, 5, 0, 0, 17, 0, 0, 0, 7, 22, 0, 9, 21},
    {0, 23, 19, 7, 0, 0, 6, 0, 0, 20, 15, 4, 0, 21, 0, 0, 0, 0, 16, 10, 24, 3, 0, 17, 5},
    {12, 15, 21, 0, 0, 0, 16, 6, 18, 5, 7, 0, 17, 3, 9, 14, 0, 4, 24, 22, 13, 0, 0, 0, 0},
    {14, 10, 11, 2, 24, 1, 25, 22, 20, 0, 0, 23, 6, 19, 0, 13, 5, 8, 12, 0, 17, 0, 7, 15, 9},
    {0, 0, 0, 0, 1, 24, 0, 3, 15, 10, 20, 8, 5, 0, 25, 9, 16, 19, 21, 0, 2, 6, 0, 12, 14},
    {0, 0, 5, 0, 3, 0, 23, 14, 8, 0, 0, 2, 15, 0, 12, 0, 7, 1, 17, 6, 22, 21, 4, 0, 19},
    {13, 0, 0, 4, 20, 0, 0, 0, 17, 0, 11, 16, 0, 0, 22, 0, 10, 18, 15, 23, 0, 25, 8, 1, 3},
    {20, 25, 7, 22, 0, 23, 0, 10, 1, 0, 0, 0, 0, 13, 4, 21, 0, 6, 19, 0, 3, 9, 15, 8, 0},
    {1, 24, 0, 0, 0, 4, 0, 20, 13, 0, 8, 0, 3, 0, 19, 16, 2, 12, 9, 5, 0, 14, 10, 25, 22},
    {0, 0, 0, 0, 0, 0, 0, 9, 24, 0, 25, 6, 0, 2, 16, 4, 8, 10, 0, 17, 18, 7, 21, 0, 1},
    {0, 8, 0, 10, 14, 16, 3, 25, 6, 0, 0, 7, 18, 9, 11, 0, 13, 0, 20, 0, 19, 24, 5, 0, 17},
    {17, 3, 0, 15, 9, 5, 0, 0, 11, 0, 0, 21, 0, 0, 23, 7, 0, 22, 0, 0, 20, 13, 12, 4, 6},
    {15, 0, 20, 11, 21, 10, 0, 0, 5, 22, 16, 0, 0, 8, 3, 24, 0, 13, 2, 19, 0, 0, 0, 0, 0},
    {0, 13, 8, 0, 19, 17, 0, 0, 0, 0, 0, 12, 7, 24, 6, 0, 15, 23, 22, 4, 14, 5, 9, 0, 0},
    {9, 1, 23, 14, 4, 0, 24, 0, 7, 8, 19, 0, 2, 0, 13, 17, 3, 20, 5, 0, 0, 15, 0, 16, 10},
    {10, 0, 2, 12, 0, 13, 18, 15, 0, 0, 17, 5, 0, 20, 21, 8, 1, 16, 0, 7, 0, 19, 0, 11, 0},
    {7, 5, 17, 24, 16, 20, 2, 11, 19, 3, 23, 0, 4, 15, 1, 18, 14, 0, 10, 0, 0, 8, 13, 21, 12},
    {0, 20, 9, 0, 7, 15, 22, 17, 10, 0, 12, 19, 0, 0, 24, 25, 0, 14, 4, 8, 16, 18, 2, 0, 0},
    {19, 2, 24, 8, 0, 0, 20, 7, 4, 0, 0, 0, 9, 0, 15, 5, 0, 21, 11, 16, 1, 0, 0, 14, 25},
    {0, 0, 25, 1, 0, 8, 5, 23, 14, 6, 4, 17, 16, 0, 2, 0, 20, 0, 13, 9, 10, 12, 24, 7, 15},
    {0, 0, 14, 0, 0, 0, 0, 0, 0, 2, 6, 10, 13, 0, 5, 12, 0, 24, 0, 0, 9, 11, 0, 3, 8},
    {6, 0, 15, 0, 13, 0, 0, 24, 0, 9, 1, 0, 8, 25, 0, 10, 18, 17, 0, 2, 0, 4, 19, 0, 23}
};

// vector<vector<int>> board = {
//         {25, 14, 1, 21, 17, 11, 10, 8, 3, 24, 9, 20, 23, 6, 7, 22, 19, 5, 18, 12, 15, 2, 16, 13, 4},
//         {24, 4, 3, 20, 15, 7, 9, 5, 23, 16, 2, 25, 22, 12, 17, 6, 21, 11, 14, 13, 8, 10, 1, 19, 18},
//         {2, 18, 10, 9, 5, 25, 21, 19, 22, 17, 3, 13, 1, 16, 8, 15, 4, 7, 23, 24, 12, 20, 14, 6, 11},
//         {16, 11, 13, 6, 12, 14, 4, 1, 2, 15, 24, 18, 19, 5, 10, 3, 17, 25, 8, 20, 7, 22, 23, 9, 21},
//         {8, 23, 19, 7, 22, 18, 6, 13, 12, 20, 15, 4, 11, 21, 14, 1, 9, 2, 16, 10, 24, 3, 25, 17, 5},
//         {12, 15, 21, 19, 8, 2, 16, 6, 18, 5, 7, 1, 17, 3, 9, 14, 25, 4, 24, 22, 13, 23, 11, 10, 20},
//         {14, 10, 11, 2, 24, 1, 25, 22, 20, 4, 21, 23, 6, 19, 18, 13, 5, 8, 12, 3, 17, 16, 7, 15, 9},
//         {23, 7, 22, 17, 1, 24, 13, 3, 15, 10, 20, 8, 5, 4, 25, 9, 16, 19, 21, 11, 2, 6, 18, 12, 14},
//         {18, 16, 5, 25, 3, 9, 23, 14, 8, 11, 13, 2, 15, 10, 12, 20, 7, 1, 17, 6, 22, 21, 4, 24, 19},
//         {13, 9, 6, 4, 20, 19, 12, 21, 17, 7, 11, 16, 24, 14, 22, 2, 10, 18, 15, 23, 5, 25, 8, 1, 3},
//         {20, 25, 7, 22, 2, 23, 17, 10, 1, 18, 5, 24, 12, 13, 4, 21, 11, 6, 19, 14, 3, 9, 15, 8, 16},
//         {1, 24, 18, 23, 6, 4, 7, 20, 13, 21, 8, 15, 3, 17, 19, 16, 2, 12, 9, 5, 11, 14, 10, 25, 22},
//         {5, 19, 12, 13, 11, 22, 15, 9, 24, 14, 25, 6, 20, 2, 16, 4, 8, 10, 3, 17, 18, 7, 21, 23, 1},
//         {21, 8, 4, 10, 14, 16, 3, 25, 6, 12, 22, 7, 18, 9, 11, 23, 13, 15, 20, 1, 19, 24, 5, 2, 17},
//         {17, 3, 16, 15, 9, 5, 8, 2, 11, 19, 14, 21, 10, 1, 23, 7, 24, 22, 25, 18, 20, 13, 12, 4, 6},
//         {15, 6, 20, 11, 21, 10, 14, 4, 5, 22, 16, 9, 25, 8, 3, 24, 12, 13, 2, 19, 23, 1, 17, 18, 7},
//         {3, 13, 8, 18, 19, 17, 1, 16, 21, 25, 10, 12, 7, 24, 6, 11, 15, 23, 22, 4, 14, 5, 9, 20, 2},
//         {9, 1, 23, 14, 4, 6, 24, 12, 7, 8, 19, 11, 2, 18, 13, 17, 3, 20, 5, 21, 25, 15, 22, 16, 10},
//         {10, 22, 2, 12, 25, 13, 18, 15, 9, 23, 17, 5, 14, 20, 21, 8, 1, 16, 6, 7, 4, 19, 3, 11, 24},
//         {7, 5, 17, 24, 16, 20, 2, 11, 19, 3, 23, 22, 4, 15, 1, 18, 14, 9, 10, 25, 6, 8, 13, 21, 12},
//         {11, 20, 9, 3, 7, 15, 22, 17, 10, 1, 12, 19, 21, 23, 24, 25, 6, 14, 4, 8, 16, 18, 2, 5, 13},
//         {19, 2, 24, 8, 10, 12, 20, 7, 4, 13, 18, 3, 9, 22, 15, 5, 23, 21, 11, 16, 1, 17, 6, 14, 25},
//         {22, 21, 25, 1, 18, 8, 5, 23, 14, 6, 4, 17, 16, 11, 2, 19, 20, 3, 13, 9, 10, 12, 24, 7, 15},
//         {4, 17, 14, 16, 23, 21, 19, 18, 25, 2, 6, 10, 13, 7, 5, 12, 22, 24, 1, 15, 9, 11, 20, 3, 8},
//         {6, 12, 15, 5, 13, 3, 11, 24, 16, 9, 1, 14, 8, 25, 20, 10, 18, 17, 7, 2, 21, 4, 19, 22, 23}
// };


void displayBoard(const vector<vector<int>>& board) {
    for (const auto& row : board) {
        for (int cell : row) {
            if (cell == 0)
                cout << ". ";
            else
                cout << cell << " ";
        }
        cout << endl;
    }
}


bool isValid(const vector<vector<int>>& board) {
    // Check rows and columns
    for (int i = 0; i < SIZE; i++) {
        vector<bool> rowCheck(SIZE + 1, false);
        vector<bool> colCheck(SIZE + 1, false);
        for (int j = 0; j < SIZE; j++) {
            if (board[i][j] > 0 && rowCheck[board[i][j]])
                return false;
            if (board[j][i] > 0 && colCheck[board[j][i]])
                return false;
            rowCheck[board[i][j]] = true;
            colCheck[board[j][i]] = true;
        }
    }

    // Check sub-grids
    int subGridSize = 5; // sqrt(SIZE)
    for (int startRow = 0; startRow < SIZE; startRow += subGridSize) {
        for (int startCol = 0; startCol < SIZE; startCol += subGridSize) {
            vector<bool> subGridCheck(SIZE + 1, false);
            for (int i = 0; i < subGridSize; i++) {
                for (int j = 0; j < subGridSize; j++) {
                    int cell = board[startRow + i][startCol + j];
                    if (cell > 0 && subGridCheck[cell])
                        return false;
                    subGridCheck[cell] = true;
                }
            }
        }
    }

    return true;
}

bool checkWin(const vector<vector<int>>& board) {
    for (const auto& row : board) {
        for (int cell : row) {
            if (cell == 0)
                return false;
        }
    }
    return isValid(board);
}

bool askInput(vector<vector<int>>& board) {
    int row, col, value;
    cout << "Caesar, the legions await your command. Specify the sector where our forces should deploy." << endl;
    cout << "Row [1-25] (-1 to check win): ";
    cin >> row;
    if (row == -1)
        return false;
    
    cout << "Column [1-25]: ";
    cin >> col;
    cout << "Troups [1-25]: ";
    cin >> value;

    if (row < 1 || row > SIZE || col < 1 || col > SIZE) {
        cout << "You attempted to reinforce Saturn, but its fragile alliance with Mars has shattered. Their combined fury annihilated our forces. This misstep will be recorded as a dark chapter in Roman history." << endl;
        return true;
    }

    if (value < 1 || value > SIZE) {
        cout << "Your decision to deploy all our troops into what appeared to be a strategic stronghold was a trap. The aliens detonated a bomb, and our legions were obliterated. The stars grow dimmer with our loss." << endl;
        return true;
    }

    if (board[row - 1][col - 1] != 0) {
        cout << "The battlefield is overrun with alien forces, Dominus. There's no room for additional troops, and your efforts have led to chaos within the ranks." << endl;
        return false;
    }
    board[row - 1][col - 1] = value;

    return true;
}

vector<double> matrixVectorMultiply(const vector<vector<int>>& matrix, const vector<double>& vec) {
    vector<double> result(matrix.size(), 0.0);
    for (size_t i = 0; i < matrix.size(); i++) {
        for (size_t j = 0; j < vec.size(); j++) {
            result[i] += matrix[i][j] * vec[j];
        }
    }
    return result;
}

vector<double> A = {
    2.40730024, 3.52795552, -1.77118277, -3.21942618, -2.81138137, -3.60802597, 1.86051666,
    3.86948988, 1.27937421, -0.96357686, 3.21355026, -1.57705018, 2.3197017, 0.15847021, -4.27518901,
    -0.70971959, -2.77817208, 5.16719809, 4.02597733, 4.75077767, 0.81294202, -5.56832771, -2.33760069,
    0.50749877, 2.52197679, 0.66154349, 1.45858961, 0.57051573, 0.31238932, -1.58938559, -0.7010957,
    0.70390144, -0.83454445, 4.56571847, -0.33819606, 2.081262, -0.12496723, 5.21202568, 0.84758812,
    -4.51370257, -2.81155389, -6.26384178, 3.09152486, 4.90150442, 0.46263767, 2.59381792, -6.05432952,
    -0.7670083, -3.40705352, 6.12419834
};

string getFlag(const vector<vector<int>>& board) {
    size_t N2 = A.size() / 2;

    // Split A into two parts
    vector<double> A1(A.begin(), A.begin() + N2);
    vector<double> A2(A.begin() + N2, A.end());

    // Perform matrix-vector multiplications
    vector<double> F1 = matrixVectorMultiply(board, A1);
    vector<double> F2 = matrixVectorMultiply(board, A2);

    // Concatenate F1 and F2
    vector<double> F(F1);
    F.insert(F.end(), F2.begin(), F2.end());

    // Convert to characters and output the result
    string result;
    for (double c : F) {
        result += static_cast<char>(round(c));
    }
    
    return result;
}

void play() {
    do {
        if (!isValid(board)) {
            cout << "A miscalculation, Darius. The aliens exploit our weaknesses." << endl;
            return;
        }
        // displayBoard(board);
    } while (askInput(board));

    if (checkWin(board)) {
        cout << "\nVictory is ours, Darius! \nThe alien forces have been routed, and their stronghold burns under the New Roman banner. \nThe Senate declares you 'Imperator Invictus'!" << endl;
        string flag = "TRX{" + getFlag(board) + "}";
        cout << flag << endl;
    } else
        cout << "\nThe legions have fallen, and the Senate lies in ruins. The alien horde swarms across the galaxy, extinguishing the light of the New Roman Empire. Your name, once shouted in triumph, is now whispered in despair. The dream of eternal Rome ends here, Dominus. But remember—history is not kind to the vanquished. The stars, once ours, now belong to the void. Hail, fallen Caesar." << endl;
}


int main() {
    cout << "Welcome, Darius Caesar. \nThe Senate has entrusted you with the fate of the New Roman Empire. \nOur legions await your orders, and the alien menace encroaches upon our borders.\n" << endl;
    play();
    return 0;
}
