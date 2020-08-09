using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace empTimeSheet
{
    public partial class Default : System.Web.UI.Page
    {
        clsLogin objda = new clsLogin();
        DataSet ds = new DataSet();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["type"] != null)
            {

                if (Request.QueryString["type"].ToString() == "livedemo")
                {

                    objda.loginid = "admin";
                    objda.password = "admin!123";
                    objda.company = "demo";
                    objda.action = "checklogin";
                    ds = objda.login();
                    Response.Write(ds.Tables[0].Rows.Count.ToString());
                    if (ds.Tables[0].Rows.Count > 0 && Convert.ToBoolean(ds.Tables[0].Rows[0]["isdemoversion"]))
                    {

                        Response.Cookies["quickstart"]["livedemo"] ="1";
                        Response.Cookies["quickstart"]["userid"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["nid"].ToString());
                        Response.Cookies["quickstart"]["username"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["fname"].ToString() + " " + ds.Tables[0].Rows[0]["lname"].ToString());
                        Response.Cookies["quickstart"]["companyname"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["companyname"].ToString());
                        Response.Cookies["quickstart"]["companyaddress"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["companyfulladdress"].ToString());
                        Response.Cookies["quickstart"]["companyid"] = ds.Tables[0].Rows[0]["companyid"].ToString();
                        Response.Cookies["quickstart"]["usertype"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["usertype"].ToString());
                        Response.Cookies["quickstart"]["deptid"] = ds.Tables[0].Rows[0]["deptid"].ToString();
                        Response.Cookies["quickstart"]["chatstatus"] = ds.Tables[0].Rows[0]["chatstatus"].ToString();
                        Response.Cookies["quickstart"]["designation"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["designation"].ToString());
                        Response.Cookies["quickstart"]["profilephoto"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["imgurl"].ToString());
                        Response.Cookies["quickstart"]["branch"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["branchtype"].ToString());

                        Response.Cookies["quickstart"]["timeid"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["companytimezone"].ToString());
                        Response.Cookies["quickstart"]["timediff"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["timediff"].ToString());
                        Response.Cookies["quickstart"]["emptimediff"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["emptimediff"].ToString());



                        Response.Cookies["quickstart"].Expires = DateTime.Now.AddDays(2);

                        Session["livedemo"] = "1";
                        Session["userid"] = ds.Tables[0].Rows[0]["nid"].ToString();
                        Session["username"] = ds.Tables[0].Rows[0]["fname"].ToString() + " " + ds.Tables[0].Rows[0]["lname"].ToString();
                        Session["companyaddress"] = ds.Tables[0].Rows[0]["companyfulladdress"].ToString();
                        Session["companyname"] = ds.Tables[0].Rows[0]["companyname"].ToString();
                        Session["companyid"] = ds.Tables[0].Rows[0]["companyid"].ToString();
                        Session["usertype"] = ds.Tables[0].Rows[0]["usertype"].ToString();
                        Session["deptid"] = ds.Tables[0].Rows[0]["deptid"].ToString();
                        Session["chatstatus"] = ds.Tables[0].Rows[0]["chatstatus"].ToString();
                        Session["designation"] = ds.Tables[0].Rows[0]["designation"].ToString();
                        Session["profilephoto"] = ds.Tables[0].Rows[0]["imgurl"].ToString();
                        Session["branch"] = ds.Tables[0].Rows[0]["branchtype"].ToString();

                        Session["timeid"] = ds.Tables[0].Rows[0]["companytimezone"].ToString();
                        Session["timediff"] = ds.Tables[0].Rows[0]["timediff"].ToString();
                        Session["emptimediff"] = ds.Tables[0].Rows[0]["emptimediff"].ToString();

                        if (Request.QueryString["requestid"] != null)
                            Response.Redirect("LeaveRequest.aspx?requestid=" + Request.QueryString["requestid"].ToString());

                        else
                        {
                            if(ds.Tables[0].Rows[0]["usertype"].ToString()=="Admin")
                            {
                                Response.Redirect("AdminDashboard.aspx");
                            }
                            else
                            {
                                Response.Redirect("UserDashboard.aspx");

                            }
                        }
                            

                    }
                    else
                    {
                        GeneralMethod.alert(this, "Invalid Username or Password!");

                    }
                }
            }



            if (Request.QueryString["action"] ==null)
            {
                if (Request.Cookies["quickstart"] != null)
                {
                    Response.Redirect("UserDashboard.aspx");
                }
                else
                {
                    if (Session["companyid"] == null)
                    {
                       string strcompanyid= objda.getsubdomain(Request.Url);
                       ds = objda.ExecuteString("select compcode from tblcompany where bstatus=1 and compcode='"+strcompanyid+"'");
                       if (ds.Tables[0].Rows.Count > 0)
                       {
                           hidcompanycode.Value = ds.Tables[0].Rows[0]["compcode"].ToString();

                       }
                       
                    }

                }
            }
        }
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            objda.loginid = txtloginid.Text;
            objda.password = txtpassword.Text;
            objda.company = hidcompanycode.Value;
            objda.action = "checklogin";
            ds = objda.login();

            if (ds.Tables[0].Rows.Count > 0)
            {

                Response.Cookies["quickstart"]["userid"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["nid"].ToString());
                Response.Cookies["quickstart"]["username"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["fname"].ToString() + " " + ds.Tables[0].Rows[0]["lname"].ToString());
                Response.Cookies["quickstart"]["companyname"] =HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["companyname"].ToString());
                Response.Cookies["quickstart"]["companyaddress"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["companyfulladdress"].ToString());
                Response.Cookies["quickstart"]["companyid"] = ds.Tables[0].Rows[0]["companyid"].ToString();
                Response.Cookies["quickstart"]["usertype"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["usertype"].ToString());
                Response.Cookies["quickstart"]["deptid"] = ds.Tables[0].Rows[0]["deptid"].ToString();
                Response.Cookies["quickstart"]["chatstatus"] = ds.Tables[0].Rows[0]["chatstatus"].ToString();
                Response.Cookies["quickstart"]["designation"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["designation"].ToString());
                Response.Cookies["quickstart"]["profilephoto"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["imgurl"].ToString());
                Response.Cookies["quickstart"]["branch"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["branchtype"].ToString());

                Response.Cookies["quickstart"]["timeid"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["companytimezone"].ToString());
                Response.Cookies["quickstart"]["timediff"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["timediff"].ToString());
                Response.Cookies["quickstart"]["emptimediff"] = HttpUtility.UrlEncode(ds.Tables[0].Rows[0]["emptimediff"].ToString());
             
               
                
                Response.Cookies["quickstart"].Expires = DateTime.Now.AddHours(9);

                Session["userid"] = ds.Tables[0].Rows[0]["nid"].ToString();
                Session["username"] = ds.Tables[0].Rows[0]["fname"].ToString() + " " + ds.Tables[0].Rows[0]["lname"].ToString();
                Session["companyaddress"] = ds.Tables[0].Rows[0]["companyfulladdress"].ToString();
                Session["companyname"] = ds.Tables[0].Rows[0]["companyname"].ToString();
                Session["companyid"] = ds.Tables[0].Rows[0]["companyid"].ToString();
                Session["usertype"] = ds.Tables[0].Rows[0]["usertype"].ToString();
                Session["deptid"] = ds.Tables[0].Rows[0]["deptid"].ToString();
                Session["chatstatus"] = ds.Tables[0].Rows[0]["chatstatus"].ToString();
                Session["designation"] = ds.Tables[0].Rows[0]["designation"].ToString();
                Session["profilephoto"] = ds.Tables[0].Rows[0]["imgurl"].ToString();
                Session["branch"] = ds.Tables[0].Rows[0]["branchtype"].ToString();

                Session["timeid"] = ds.Tables[0].Rows[0]["companytimezone"].ToString();
                Session["timediff"] = ds.Tables[0].Rows[0]["timediff"].ToString();
                Session["emptimediff"] = ds.Tables[0].Rows[0]["emptimediff"].ToString();

                if (Request.QueryString["requestid"]!=null)
                    Response.Redirect("LeaveRequest.aspx?requestid=" + Request.QueryString["requestid"].ToString());
                else if (Request.QueryString["appointmentid"] != null)
                    Response.Redirect("Appoint_ViewAppointments.aspx?appointmentid=" + Request.QueryString["appointmentid"].ToString());


                else
                {
                    if (ds.Tables[0].Rows[0]["usertype"].ToString() == "Admin")
                    {
                        Response.Redirect("AdminDashboard.aspx");
                    }
                    else
                    {
                        Response.Redirect("UserDashboard.aspx");

                    }
                }

            }
            else
            {
                GeneralMethod.alert(this, "Invalid Username or Password!");

            }
        }
        //protected void btnforgot_Click(object sender,EventArgs e)
        //{
        //    objda.action = "checkidexist";
        //    objda.loginid = txtforgotemail.Text;
        //    DataSet ds = new DataSet();
        //    ds = objda.addviewuser();
        //    if (ds.Tables[0].Rows.Count > 0)
        //    {
        //        if (ds.Tables[0].Rows[0]["email"] != null && ds.Tables[0].Rows[0]["email"].ToString() != "")
        //        {
        //            Random rand = new Random((int)DateTime.Now.Ticks);
        //            int numIterations = 0;
        //            numIterations = rand.Next(1, 999999);


        //            string message = "A request was made at Wings of America to reset your password.<br/><br/> Your Password is: " + numIterations.ToString()
        //            + "<br/>Please visit following link to Sign In: <a href='http://woa.saratechnologies.com'>Wings of America</a><br/><br/> Thank You <br/>Wings of America Team";
        //            string msg = objda.SendEmail("saratechnologiesinc@gmail.com", ds.Tables[0].Rows[0]["email"].ToString(), "Abhi8589-", message, "Wings of America Password", "smtp.gmail.com");
        //            if (msg == "Sent")
        //            {
        //                objda.passowrd = numIterations.ToString();
        //                objda.loginid = txtforgotemail.Text;
        //                objda.action = "updatepass";
        //                objda.addviewuser();
        //                ScriptManager.RegisterStartupScript(this, GetType(), "ok", "<script>alert('Your password reset successfully, please check your email," + ds.Tables[0].Rows[0]["email"].ToString().Substring(0,4) + "....')closediv();</script>", false);
        //                txtforgotemail.Text = "";
        //            }
        //            else
        //            {
        //                txtforgotemail.Text = "";
        //                divforgoterror.InnerText = "Server error, please try again later.";
        //                ScriptManager.RegisterStartupScript(this, GetType(), "ok", "<script>opendiv();</script>", false);
        //            }
        //        }
        //    }
        //    else
        //    {
        //        txtforgotemail.Text = "";
        //        divforgoterror.InnerText = "Login Id does not exists.";
        //        ScriptManager.RegisterStartupScript(this, GetType(), "ok", "<script>opendiv();</script>", false);
        //    }
        //}
    }
}