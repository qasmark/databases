using System;
using System.Collections;
using System.Collections.Generic;

namespace lw9
{
    public class Rental
    {
        public int RentalId { get; set; }
        public DateTime RentalDate { get; set; }
        public DateTime RentalDaysTime { get; set; }
        public bool IsReturned { get; set; }
        public virtual Client Client { get; set; }
    }
}
