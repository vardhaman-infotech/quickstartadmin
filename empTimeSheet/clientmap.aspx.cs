using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Runtime.Serialization.Json;
using GoogleMaps.LocationServices;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.IO;

namespace empTimeSheet
{
    public partial class clientmap : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds1 = new DataSet();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();
            if (!Page.IsPostBack)
            {

                if (!objda.checkUserInroles("3"))
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                ClsAdmin objadmin = new ClsAdmin();
                objadmin.action = "select";
                objadmin.companyId = Session["companyid"].ToString();
                ds = objadmin.ManageSettings();
                var ad_origin = new AddressData
                {
                    Address = ds.Tables[0].Rows[0]["address"].ToString(),
                    City = ds.Tables[0].Rows[0]["cityid"].ToString(),
                    State = ds.Tables[0].Rows[0]["stateid"].ToString(),
                    Country = ds.Tables[0].Rows[0]["countryid"].ToString(),
                    Zip = ds.Tables[0].Rows[0]["zip"].ToString()
                };
                Session["origin"] = ad_origin;
                hidaddress.Value = ad_origin.ToString();


                fillgrid();

            }
        }

        /// <summary>
        /// When Add new button clicked
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>


        /// <summary>
        /// Fill Employee to select as a manager
        /// </summary>


        /// <summary>
        /// Fill list of existing clients
        /// </summary>
        public void fillgrid()
        {
            objuser.clientname = txtsearch.Text;
            objuser.action = "select";
            objuser.companyid = Session["companyid"].ToString();
            objuser.id = "";
            ds = objuser.client();
            if (ds.Tables[0].Rows.Count > 0)
            {
                nodata.Visible = false;
                dgnews.Visible = true;
                dgnews.DataSource = ds;
                dgnews.DataBind();

            }
            else
            {
                dgnews.Visible = false;
                nodata.Visible = true;
            }

        }
        protected void btnexportcsv_Click(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            bindheader();
            fillgrid();
            if (ds.Tables[0].Rows.Count > 0)
            {
                sb.Append("<table cellpadding='4' cellspacing='0' style='font-family:Calibri;font-size:12px;' border='0'>" + bindheader() + "<tr><th style='text-align:center;'>S.No.</th><th  style='text-align:left;'>Client Code</th><th style='text-align:left;'>Client Name</th><th style='text-align:left;'>Contact Name</th><th style='text-align:left;'>Email Id</th><th style='text-align:left;'>Phone</th><th style='text-align:left;'>Cell</th><th style='text-align:left;'>Fax</th><th style='text-align:left;'>Website</th><th style='text-align:left;'>Address</th><th style='text-align:left;'>City</th><th style='text-align:left;'>State</th><th style='text-align:left;'>Country</th><th style='text-align:left;'>ZIP</th><th style='text-align:left;'>Manager</th><th style='text-align:left;'>Active Status</th></tr>");

                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    if (ds.Tables[0].Rows[i]["activestatus"].ToString().ToLower() == "block")
                        sb.Append("<tr style= 'color:red;'><td style='text-align:center;'>" + (i + 1).ToString() + "</td><td>" + ds.Tables[0].Rows[i]["code"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["clientname"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["company"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["email"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["phone"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["mobile"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["fax"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["website"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["street"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["city"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["state"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["country"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["zip"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["managername"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["activestatus"].ToString() + "</td></tr>");
                    else
                        sb.Append("<tr><td style='text-align:center;'>" + (i + 1).ToString() + "</td><td>" + ds.Tables[0].Rows[i]["code"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["clientname"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["company"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["email"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["phone"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["mobile"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["fax"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["website"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["street"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["city"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["state"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["country"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["zip"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["managername"].ToString() + "</td><td>" + ds.Tables[0].Rows[i]["activestatus"].ToString() + "</td></tr>");

                }
                sb.Append("</table>");

            }

            excelexport objexcel = new excelexport();
            objexcel.downloadFile(sb.ToString(), "Client.xls");

        }
        protected string bindheader()
        {
            string str = "";
            string Companyname = Session["companyname"].ToString();

            str += "<tr><td colspan='16' style='background-color:blue;color:#ffffff;font-size:16px;' align='center'>" + Companyname + "</td></tr>";
            str += "<tr><td colspan='16' style='background-color:blue;color:#ffffff;font-size:14px;' align='center'>Client List</td></tr>";

            return str;

        }
        /// <summary>
        /// Save information
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>


        /// <summary>
        /// event fires when clicks to Edit/Delete in List
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        /// 


        private void BindGMap(DataTable datatable)
        {

            try
            {

                List<ProgramAddresses> AddressList = new List<ProgramAddresses>();

                foreach (DataRow dr in datatable.Rows)
                {
                    //Full address to show on description
                    //string FullAddress = dr["name"].ToString() + " " + dr["Address"].ToString() + " " + dr["cityname"].ToString() + ", " + dr["countryname"].ToString() + " " + dr["stateName"].ToString() + " " + dr["zip"].ToString();


                    ProgramAddresses MapAddress = new ProgramAddresses();


                  

                    var ad = new AddressData
                    {
                        Address = dr["street"].ToString(),
                        City = dr["city"].ToString(),
                        State = dr["state"].ToString(),
                        Country = dr["country"].ToString(),
                        Zip = dr["zip"].ToString()
                    };

                  
                    MapAddress.description = dr["clientname"].ToString() + "<br/> " + ad.ToString();
                    hidaddress2.Value = ad.ToString();
                    string straddress = "<b>" + dr["clientname"].ToString() + "</b></br>";
                    straddress += ad.ToString();
                    divaddress.InnerHtml = straddress;
                    var locationService = new GoogleLocationService();




                    var point = locationService.GetLatLongFromAddress(ad);

                    try
                    {
                        //Assign  Map Latitude an Logitude fetched from Map Location Service
                        MapAddress.lat = point.Latitude;

                        MapAddress.lng = point.Longitude;

                        //Add these description, Latitude and Logitude to the Addresses List
                        AddressList.Add(MapAddress);



                    }
                    catch (Exception ex)
                    {
                        try
                        {
                            var ad1 = new AddressData
                            {
                                Address = "",
                                City = dr["city"].ToString(),
                                State = dr["state"].ToString(),
                                Country = dr["country"].ToString(),
                                Zip = dr["zip"].ToString()
                            };



                            var point1 = locationService.GetLatLongFromAddress(ad1);

                            //Assign  Map Latitude an Logitude fetched from Map Location Service
                            MapAddress.lat = point1.Latitude;

                            MapAddress.lng = point1.Longitude;

                            //Add these description, Latitude and Logitude to the Addresses List
                            AddressList.Add(MapAddress);
                        }
                        catch
                        {
                            divmsgmap.Visible = true;
                            divshowmap.Visible = false;

                        }
                    }

                }

                //Convert complete address list to json string
                string jsonString = JsonSerializer<List<ProgramAddresses>>(AddressList);

                //if (jsonString == "")
                //{ 


                //}


                if (jsonString != null && jsonString != "")
                {
                    // divmsgmap.Visible = true;
                    divmsgmap.Visible = false;
                    divshowmap.Visible = true;
                    //Call Client side GoogleMap function to Plot the address on Map
                    ScriptManager.RegisterArrayDeclaration(Page, "markers", jsonString);
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), Guid.NewGuid().ToString(), "GoogleMap();", true);
                }
                else
                {
                    divmsgmap.Visible = true;
                    divshowmap.Visible = false;
                }
            }

            catch (Exception ex)
            {
                divmsgmap.Visible = true;
                divshowmap.Visible = false;

            }

        }
        public static string JsonSerializer<T>(T t)
        {
            DataContractJsonSerializer ser = new DataContractJsonSerializer(typeof(T));
            MemoryStream ms = new MemoryStream();
            ser.WriteObject(ms, t);
            string jsonString = Encoding.UTF8.GetString(ms.ToArray());
            ms.Close();
            return jsonString;
        }
        /// <summary>
        /// Show MAP view
        /// </summary>
        /// <param name="dt"></param>
        protected void activatemap(DataTable dt)
        {
            if (dt != null)
            {
                BindGMap(dt);
            }


        }

        /// <summary>
        /// Check whether what menu is active add the Active class according to that
        /// "hidtype" contains the value for MAP and LIST
        /// </summary>

        protected void dgnews_RowCommand(object sender, RepeaterCommandEventArgs e)
        {

            if (e.CommandName.ToLower() == "detail")
            {




                hidid.Value = e.CommandArgument.ToString();
                objuser.id = e.CommandArgument.ToString();
                objuser.action = "select";
                objuser.name = txtsearch.Text;

                ds = objuser.client();
                activatemap(ds.Tables[0]);


            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgnews_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {

                e.Row.Cells[0].Attributes.Add("onclick", Page.ClientScript.GetPostBackClientHyperlink(dgnews, "RowCommand$" + DataBinder.Eval(e.Row.DataItem, "nid").ToString()));

                e.Row.Attributes["onmouseover"] = "this.style.cursor='pointer'";
            }

        }

        /// <summary>
        /// Reset values
        /// </summary>


        /// <summary>
        /// When search any record
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnsearch_Click(object sender, EventArgs e)
        {
            fillgrid();
        }


    }
}