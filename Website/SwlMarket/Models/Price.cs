﻿using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SwlMarket.Models
{
    public class Price
    {
        public int Id { get; set; }
        public int ItemID { get; set; }
        public DateTime Time { get; set; }
        public int? ExpiresIn { get; set; }
        public int Marks { get; set; }
        public int? IPId { get; set; }

        public Item Item { get; set; }

        public IPEntry IP { get; set; }

        [NotMapped]
        public DateTime? ExpiresAt
        {
            get
            {
                var expirationDate = Time.AddSeconds(ExpiresIn ?? 0);
                return expirationDate > DateTime.Now ? (DateTime?)expirationDate : null;
            }
        }
    }

    public class CurrentPrice : Price
    {

    }
    
    public class HistoricalPrice : Price
    {

    }
}
