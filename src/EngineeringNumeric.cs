namespace PSi.Converters
{
    using System;
    using System.Collections.Generic;
    
    public class EngineeringNumeric
    {
        private Dictionary<int, string> table = new Dictionary<int, string> {
            { -24, "y" },
            { -21, "z" },
            { -18, "p" },
            { -15, "f" },
            { -12, "p" },
            { -9, "n" },
            { -6, "μ" },
            { -3, "m" },
            { 3, "k" },
            { 6, "M" },
            { 9, "G" },
            { 12, "T" },
            { 15, "P" },
            { 18, "E" },
            { 21, "Z" },
            { 24, "Y" }
        };

        private double abs;
        private double exp;
        private int step;

        public readonly double Value;

        public EngineeringNumeric(double d)
        {
            Value = d;
            abs = Math.Abs(d);
            exp = Math.Log10(abs);
            step = (int)(Math.Floor(exp / 3) * 3);
        } 
        public string Symbol
        {
            get { return table[step]; }
        }

        public double BaseValue
        {
            get { return Value * Math.Pow(10.0, -step); }
        }

        public int E
        {
            get { return step; }
        }

        public override string ToString()
        {
            try
            {
                return BaseValue.ToString() + " " + Symbol; 
            }
            catch (System.Exception)
            { 
                return Value.ToString();
            } 
        }
    }
}