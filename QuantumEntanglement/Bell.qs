namespace Quantum.QuantumEntanglement {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    
    operation TestBellState((q0Init: Result, q1Init: Result), iteration: Int, entangled: Bool) : (Int, Int) {
        mutable onesMatch = 0;
        mutable zerosMatch = 0;
        using ((q0, q1) = (Qubit(), Qubit())) {
            for (test in 1..iteration) {
                Set(q0Init, q0);
                Set(q1Init, q1);

                H(q0);
                if(entangled) {
                    CNOT(q0, q1);
				}
                let q0result = M(q0);
                let q1result = M(q1);
                if (q0result == q1result) {
                    if(q0result == One){
                        set onesMatch += 1;           
					} else{
                        set zerosMatch += 1; 
					}
                }
            }
            
            Set(Zero, q0);
            Set(Zero, q1);
        }
        return (zerosMatch, onesMatch);
	}

    operation Set(desiredResult : Result, qubit : Qubit) : Unit {
        if (desiredResult != M(qubit)) {
            X(qubit);
        }
    }
}
