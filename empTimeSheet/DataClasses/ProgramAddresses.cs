using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


public class ProgramAddresses
{
    public ProgramAddresses()
    {
    }
    public double _lat, _lng;
   
    public string description { get; set; }
    public double lng { get { return this._lng; } set { this._lng = value; } }
    public double lat { get { return this._lat; } set { this._lat = value; } }
}

