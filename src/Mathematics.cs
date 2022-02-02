namespace Psi
{
    using System;
    using System.Linq;

    public class Mathematics
    {
        public static double Gcd(double a, double b)
        {
            while (b != 0.0)
            { 
                b = a % (a = b);
            }

            return Math.Abs(a);
        } 

        public static double Lcm(double a, double b)
        {
            return Math.Abs(a * b) / Mathematics.Gcd(a, b);
        } 
    }
}
