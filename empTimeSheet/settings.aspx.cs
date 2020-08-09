using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;
using System.Web.UI.HtmlControls;
using uploadimage;


namespace empTimeSheet
{
    public partial class settings : System.Web.UI.Page
    {
        DataAccess objda = new DataAccess();
        ClsUser objuser = new ClsUser();
        GeneralMethod objgen = new GeneralMethod();
        DataSet ds1 = new DataSet();
        DataSet ds = new DataSet();
        imageupload objimg = new imageupload();
        protected void Page_Load(object sender, EventArgs e)
        {
            objgen.validatelogin();

            Page.Form.Attributes.Add("enctype", "multipart/form-data");
            if (!IsPostBack)
            {
                ViewState["profileimg"] = "nophoto.png";
                hidid.Value = Session["userid"].ToString();
                //Go to fill user deatils

                binddetail();
                //  fillcountry();
                bind();


     
            }

        }

        protected void btnChangeEmail_OnClick(object sender, EventArgs e)
        {
              objuser.id = hidid.Value;
            
                objuser.action = "editemail";
                objuser.usertype = Session["usertype"].ToString();
                objuser.email = txtemail.Text;
                ds = objuser.ManageEmployee();
      
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Your Email ID changed successfully!');hidediv();</script>", false);
                bindEmail();
        }

           protected void btnChangeCell_OnClick(object sender, EventArgs e)
          {
            objuser.id = hidaddress.Value;
            objuser.action = "editcell";            
            objuser.phone = txtCell.Text;
            ds = objuser.address();
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Your Cell changed successfully!');hidediv();</script>", false);
            bindCell();
        }

           protected void btnChangeSkype_OnClick(object sender, EventArgs e)
           {
               objuser.id = hidaddress.Value;
               objuser.action = "editskype";
               objuser.fax = txtSkype.Text;
               ds = objuser.address();
               ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Your Skype ID changed successfully!');hidediv();</script>", false);
               bindSkype();

           }



        protected void bindEmail()
        {
            objuser.id = hidid.Value;
            objuser.usertype = Session["usertype"].ToString();
            objuser.action = "selectfulldetail";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {

                ltrEmail.Text = ds.Tables[0].Rows[0]["email"].ToString();
            }
 
        }

        protected void bindCell()
        {
            objuser.id = hidid.Value;
            objuser.usertype = Session["usertype"].ToString();
            objuser.action = "selectfulldetail";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {

                ltrPhone.Text = ds.Tables[0].Rows[0]["phone"].ToString();
            }

        }

        protected void bindSkype()
        {
            objuser.id = hidid.Value;
            objuser.usertype = Session["usertype"].ToString();
            objuser.action = "selectfulldetail";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                ltrSkype.Text = ds.Tables[0].Rows[0]["skypeid"].ToString();
 
            }
        }

        public void bind()
        {
            objuser.id = hidid.Value;
            objuser.usertype = Session["usertype"].ToString();
            objuser.action = "selectfulldetail";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {
                txtemail.Text=ds.Tables[0].Rows[0]["email"].ToString();
                txtCell.Text= ds.Tables[0].Rows[0]["phone"].ToString();
                txtSkype.Text = ds.Tables[0].Rows[0]["skypeid"].ToString();
 
 
            }
        }


        //Change password
        protected void btnChangePass_OnClick(object sender, EventArgs e)
        {
            objuser.id = Session["userid"].ToString();

            objuser.password = txtOldPass.Text.Trim();

            objuser.action = "checkpassword";
            ds = objuser.ManageEmployee();

            if (ds.Tables[0].Rows.Count > 0)
            {
                lblError1.Text = "";
                objuser.password = txtNew.Text.Trim();
                objuser.action = "updatepass";
                ds = objuser.ManageEmployee();
               
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Your password changed successfully!');hidediv();</script>", false);
            }
            else
            {
                txtOldPass.Text = ""; 
                lblError1.Text = "Your password does not match with our record.";
            }
        }

        protected void btnReset_OnClick(object sender, EventArgs e)
        {
            txtNew.Text = "";
            txtOldPass.Text = "";
            txtConfirm.Text = "";
        }


        //Bind User profile details
        protected void binddetail()
        {

            objuser.id = hidid.Value;
            objuser.usertype = Session["usertype"].ToString();
            objuser.action = "selectfulldetail";
            ds = objuser.ManageEmployee();
            if (ds.Tables[0].Rows.Count > 0)
            {

                //bind form view to show details
                //fromBasicDetail.DataSource = ds;
                //fromBasicDetail.DataBind();

                if (ds.Tables[0].Rows[0]["imgurl"].ToString() != "")
                {
                    //divuserphoto.Style.Add("background-image", "url(webfile/profile/" + ds.Tables[0].Rows[0]["imgurl"].ToString() + ")");
                    divuserphoto.Src = "webfile/profile/" + ds.Tables[0].Rows[0]["imgurl"].ToString();
                    ViewState["filename"] = ds.Tables[0].Rows[0]["imgurl"].ToString();

                }
                else
                {
                    divuserphoto.Src = "webfile/profile/" + ds.Tables[0].Rows[0]["imgurl"].ToString();
                 
                }

                hidaddress.Value = ds.Tables[0].Rows[0]["addressid"].ToString();
                litusername1.Text = ds.Tables[0].Rows[0]["username"].ToString()+", ";
                litdsignation1.Text = ds.Tables[0].Rows[0]["designation"].ToString();
                litdepartment1.Text = ds.Tables[0].Rows[0]["department"].ToString();
                ltrAddress1.Text = ds.Tables[0].Rows[0]["street"].ToString();
                ltrAddress2.Text = ds.Tables[0].Rows[0]["city"].ToString();
                ltrAddress3.Text = ds.Tables[0].Rows[0]["state"].ToString();
                ltrEmail.Text = ds.Tables[0].Rows[0]["email"].ToString();
                ltrPhone.Text = ds.Tables[0].Rows[0]["phone"].ToString();
                ltrSkype.Text = ds.Tables[0].Rows[0]["skypeid"].ToString();
               

                
            }
        }


        //When user clicks to edit profile
        protected void lbtneditprofile_Click(object sender, EventArgs e)
        {
            //Change the form view from "VIEW" to "EDIT", where it will show the textboxes
            //fromBasicDetail.ChangeMode(FormViewMode.Edit);
            binddetail();
        }



        protected void btnupload_Click(object sender, EventArgs e)
        {
            if (FileUpload1.HasFile)
            {
                string filename = "";
                string path2 = "";
                string datetime = DateTime.Now.ToFileTimeUtc().ToString();
                try
                {
                    objuser.id = Session["userid"].ToString();
                    String extension = Path.GetExtension(FileUpload1.PostedFile.FileName);
                    if (extension.ToUpper() != ".JPG" && extension.ToUpper() != ".JPEG" && extension.ToUpper() != ".PNG" && extension.ToUpper() != ".GIF")
                    {

                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Selected file  has invalid format');</script>", false);
                        return;
                    }
                    filename = "Profile_" + datetime + extension;
                    ViewState["filename"] = filename;
                    //string path = Server.MapPath(FileUpload1.PostedFile.FileName);
                    string path = AppDomain.CurrentDomain.BaseDirectory + "\\webfile\\profile\\" + filename;
                    ViewState["path"] = @"webfile/profile/" + filename;
                    FileUpload1.SaveAs(path);
                    path = Server.MapPath("webfile/profile/" + filename);
                    path2 = Server.MapPath("webfile/profile/thumb/" + filename);


                    objimg.CreateThumbnail(100, 100, path, path2);

                    //Find image control shown on top from Master page and change url
                     HtmlImage homethumbimage = (HtmlImage)this.Master.FindControl("imgphoto");

                     if (homethumbimage != null)
                     {
                            homethumbimage.Src = "webfile/profile/thumb/" + filename;
                     }

                }
                catch (Exception ex)
                {

                    ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('" + ex.ToString() + "'Server error please try again later.');</script>", false);
                    return;

                }
                objuser.imgurl = ViewState["filename"].ToString();
                objuser.action = "changephoto";
                ds = objuser.ManageEmployee();
                Response.Cookies["user"]["profilephoto"] = filename;
                Session["profilephoto"] = filename;
                binddetail();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "temp", "<script type='text/javascript'>alert('Please select a file');</script>", false);
                return;
            }



        }

     
    }
}