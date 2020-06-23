using System;
using System.Collections.Generic;
using System.Text;

namespace QuantumEntanglement
{
    public static class Helper
    {
        public static void WriteResult(long zerosMatch, long onesMatch, long zerosUnmatch, long onesUnmatch, int iteration)
        {
            (string matchesString, string unmatchesString) = GetStrings(zerosMatch, onesMatch, iteration);
            double matchRatio = GetMatchRatio(zerosMatch, onesMatch, iteration);
            Console.Write("[ ");
            Console.BackgroundColor = ConsoleColor.Green;
            Console.Write($"{matchesString}");
            Console.BackgroundColor = ConsoleColor.Red;
            Console.Write($"{unmatchesString}");
            Console.ResetColor();
            Console.Write($" ] Ratio: {matchRatio}% /");
            Console.Write($" Match -> Zero: {zerosMatch} One: {onesMatch} / Unmatch -> Zero: {zerosUnmatch} One: {onesUnmatch}");
            Console.WriteLine(Environment.NewLine);
        }

        private static (string matchesString, string unmatchesString) GetStrings(long zerosMatch, long onesMatch, int iteration)
        {
            string matchesString = string.Empty;
            string unmatchesString = string.Empty;
            int matchRatio = Convert.ToInt32(Math.Round((zerosMatch + onesMatch) * 10.0) / iteration);
            matchesString = matchesString.PadLeft(matchRatio);
            unmatchesString = unmatchesString.PadLeft(10 - matchRatio);
            return (matchesString, unmatchesString);
        }

        private static double GetMatchRatio(long zerosMatch, long onesMatch, int iteration)
        {
            return Math.Round((Convert.ToDouble(zerosMatch) + Convert.ToDouble(onesMatch)) / Convert.ToDouble(iteration) * 100.00, 4);
        }
    }
}
