namespace Psi 
{
    using System;
    using System.Collections.Generic;
    using System.Linq;

    public static class Euclid 
    {
        public static bool IsOdd(this int n)
        {
            return (n & 0x01) == 0x01;
        }
    }

    /// <summary>
    /// Not o(n). Use Mathnet.Numerics for that.
    /// </summary>
    public static class Statistics
    {
        public static double Median(IEnumerable<double> numbers)
        {
            var a = numbers
                .OrderBy(n => n)
                .ToArray(); 
            var mid = a.Length / 2; 
            var x = a[mid];
            var y = a[mid - 1];

            return a.Length.IsOdd()
                ? x
                : (x + y) / 2.0;
        }
    }
}

