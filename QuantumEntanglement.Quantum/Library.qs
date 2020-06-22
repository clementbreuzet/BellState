namespace Quantum.QuantumEntanglement.Quantum {

    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    // On déclare un tuple de Result Result
    newtype BellStateInitialResult = (q0Init: Result, q1Init: Result);

    // On déclare un tuple de Int, Int, Int, Int
    newtype BellStateOutput = (OnesMatch: Int, ZerosMatch: Int, OnesUnmatch: Int, ZerosUnmatch: Int);

    // On déclare un nested tuple BellStateInitialResult, Int
    newtype BellStateInput = (BellStateInitialResult: BellStateInitialResult, Iteration: Int);
    
    // On déclare une opération pour tester l'état de Bell
    // Elle prend en paramètres le tuple BellStateInput
    // Elle retourne BellStateOutput
    operation TestBellState(bellStateInput: BellStateInput) : BellStateOutput {    
        
        // On initialise un tuple mutable BellStateOutput
        mutable result = BellStateOutput(0, 0, 0, 0);

        // On déclare deux qubits dans un bloc using
        using ((q0, q1) = (Qubit(), Qubit())) {

            //On itère sur l'item iteration du tuple BellStateInput
            for (_ in 1..bellStateInput::Iteration) {

                // On initialise nos deux qubits dans la position initiale désirée
                Set(bellStateInput::BellStateInitialResult::q0Init, q0);
                Set(bellStateInput::BellStateInitialResult::q1Init, q1);

                // On applique la porte de Hadamard au qubitO -> Superposition
                H(q0);

                // On applique la porte CNOT entre le qubit0 et qubit1 -> Intrication
                CNOT(q0, q1);

                // On assigne les résultats de mesures et on remet nos deux qubits dans un état initial
                let q0result = MResetZ(q0);
                let q1result = MResetZ(q1);

                // On définie notre tuple BellStateOutput avec la function GetBellStateResult
                set result = GetBellStateResult(result, q0result, q1result);
            }
        }

        // On retourne le tuple BellStateOutput
        return result;
	}

    // On déclare une function GetBellStateResult qui va construire notre résultat
    // Elle prend en paramètres BellStateOutput, Result et Result
    // Elle retourne un tuple BellStateOutput
    function GetBellStateResult(result: BellStateOutput, q0Result: Result, q1Result: Result): BellStateOutput {

        // On assigne notre tuple à une variable mutable car les paramètres du prototype d'une function ou operation ne sont pas mutable
        mutable mutableResult = result;

        // Si les mesures sont identiques
        if (q0Result == q1Result) {

            // Si la mesure du premier qubit est dans un état exité
            if(q0Result == One){
                // on incrément OnesMatch
                return mutableResult w/ OnesMatch <- mutableResult::OnesMatch + 1;
			} else {
                // on incrément ZerosMatch
                return mutableResult w/ ZerosMatch <- mutableResult::ZerosMatch + 1; 
			}
        } else {

            // Si la mesure du premier qubit est dans un état exité
            if(q0Result == One){
                // on incrément OnesUnmatch
                return mutableResult w/ OnesUnmatch <- mutableResult::OnesUnmatch + 1;
			} else{
                // on incrément ZerosUnmatch
                return mutableResult w/ ZerosUnmatch <- mutableResult::ZerosUnmatch + 1;
			}    
		}
	}

    // On déclare une operation Set qui va nous permettre de position un qubit dans la position désirée
    // Elle prend en paramètres desiredResult qui est un état souhaité et le qubit que l'on souhaite travailler
    // Elle retourne un tuple vide -> Unit
    operation Set(desiredResult : Result, qubit : Qubit) : Unit {

        // Si la mesure du qubit n'est pas la position que l'on désire
        if (desiredResult != M(qubit)) {

            // On bit-flip le qubit
            X(qubit);
        }
    }
}
