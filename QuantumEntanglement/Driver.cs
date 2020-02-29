using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using QuantumEntanglement;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Quantum.QuantumEntanglement
{
	internal class Driver
	{
		static void Main(string[] args)
		{
			using (var qsim = new QuantumSimulator())
			{
				var initialResults = new (Result q0, Result q1)[]
				{
					(Result.Zero, Result.Zero),
					(Result.Zero, Result.One),
					(Result.One, Result.Zero),
					(Result.One, Result.One)
				};

				Console.WriteLine("... Bell State ...");
				Console.WriteLine("Please enter an iteration value to perform the bell state test...");
				int iteration = int.TryParse(Console.ReadLine(), out int result) ? result : 1000;
				Console.Clear();
				foreach ((Result q0, Result q1) initialResult in initialResults)
				{
					Console.WriteLine($"Init Q0: {initialResult.q0} - Q1: {initialResult.q1}");
					(long zerosMatch, long onesMatch, long zerosUnmatch, long onesUnmatch) = TestBellState.Run(qsim, initialResult.q0, initialResult.q1, iteration).Result;
					DriverHelper.WriteResult(zerosMatch, onesMatch, zerosUnmatch, onesUnmatch, iteration);
				}
			}
			Console.ReadKey();
		}
	}
}