using System;
using System.Security.Policy;

namespace lw9
{
    public class Sale
    {
        public int SaleId { get; set; }
        public DateTime SaleDate { get; set; }
        public double SaleAmount { get; set; }
        public bool IsPaid { get; set; }
        public virtual Employee Employee { get; set; }
        public virtual Rental Rental { get; set; }
    }

}
