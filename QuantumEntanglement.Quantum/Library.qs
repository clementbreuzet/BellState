namespace Quantum.QuantumEntanglement.Quantum {

    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;

    newtype BellStateInitialResult = (q0Init: Result, q1Init: Result);
    newtype BellStateOutput = (OnesMatch: Int, ZerosMatch: Int, OnesUnmatch: Int, ZerosUnmatch: Int);
    newtype BellStateInput = (BellStateInitialResult: BellStateInitialResult, Iteration: Int);
    
    operation TestBellState(bellStateInput: BellStateInput) : BellStateOutput {     
        mutable result = BellStateOutput(0, 0, 0, 0);
        using ((q0, q1) = (Qubit(), Qubit())) {
            for (test in 1..bellStateInput::Iteration) {
                Set(bellStateInput::BellStateInitialResult::q0Init, q0);
                Set(bellStateInput::BellStateInitialResult::q1Init, q1);
                H(q0);
                CNOT(q0, q1);
                let q0result = MResetZ(q0);
                let q1result = MResetZ(q1);
                set result = GetBellStateResult(result, q0result, q1result);
            }
        }
        return result;
	}

    function GetBellStateResult(result: BellStateOutput, q0Result: Result, q1Result: Result): BellStateOutput {
        mutable mutableResult = result;
        if (q0Result == q1Result) {
            if(q0Result == One){
                return mutableResult w/ OnesMatch <- mutableResult::OnesMatch + 1;
			} else {
                return mutableResult w/ ZerosMatch <- mutableResult::ZerosMatch + 1; 
			}
        } else {
            if(q0Result == One){
                return mutableResult w/ OnesUnmatch <- mutableResult::OnesUnmatch + 1;
			} else{
                return mutableResult w/ ZerosUnmatch <- mutableResult::ZerosUnmatch + 1;
			}    
		}
	}


    operation Set(desiredResult : Result, qubit : Qubit) : Unit {
        if (desiredResult != M(qubit)) {
            X(qubit);
        }
    }
}
