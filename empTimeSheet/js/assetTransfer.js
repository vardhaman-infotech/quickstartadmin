var json;
var jsontasks;
$(document).ready(function ()
{

    //---------
    var companyid = document.getElementById("hidcompanyid").value;
    //---------------------Get projects from script methos and put values to an array for autocompleter
    var args = { prefixText: "", companyid: companyid, isapprove: document.getElementById("AsssetTransfer_isapprove").value, empid: document.getElementById("TransferAsset_hiduserid").value };
    $.ajax(
        {
        type: "POST",
        url: "assetTransferMaster.aspx/getAllAsset",
        data: JSON.stringify(args),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        cache: false,
        success: function (data)
        {
            //Check length of returned data, if it is less than 0 it means there is some status available
            if (data.d != "failure")
            {
                json = $.parseJSON(data.d);
                //Call project autocompleter
                bindassetauto("ddlasset", "hidasset",companyid);
            }
        }
    });
});

//---BIND projects autocompleter using json---
function comparedate(from, to) {
    
    var result=true;
   


    if (from != "" && to != "") {

        var d1 = new Date(from);
        var d2 = new Date(to);
        if (d1 > d2) {
            result = false;

        }
    }
    return result;

}
function bindassetauto(inputid, hiddenid, companyid)
{
    $("#" + inputid + "").autocomplete(
        {
            selectFirst: true,
            delay: 0,
            mustMatch: true,
            autoFocus: true,
            source: json,
            select: function (event, ui)
            {
                $("#" + hiddenid + "").val(ui.item.value);
                $("#" + inputid + "").val(ui.item.label1);
                return false;
            },
            change: function (event, ui)
            {
                $(this).val((ui.item ? ui.item.label1 : ""));
                $("#" + hiddenid + "").val((ui.item ? ui.item.value : ""));
                showdetail();
            },
            focus: function (event, ui) { event.preventDefault(); }
        });
}

//This function get the data corresponding to the id we pass 
function showdetail()
{
    var id = document.getElementById("hidasset").value;  
    var arg = { nid: id};
    $.ajax(
       {
           type: "POST",
           url: "assetTransferMaster.aspx/getAssetDetail",
           data: JSON.stringify(arg),
           contentType: "application/json; charset=utf-8",
           dataType: "json",
           async: true,
           cache: false,
           success: function (data)
           {
               //Check length of returned data, if it is less than 0 it means there is some status available
               if (data.d != "failure")
               {
                   var assetDataDiv = document.getElementById("Asset_div");
                   var str = String(data.d);
                   var array = str.split("###");

                   if (array[0] != "") //check if any asset is selected, if not then hide the div of asset information
                   {
                       assetDataDiv.style.display = "block";
                       document.getElementById('ctl00_ContentPlaceHolder1_lbl_assetName').innerHTML = array[0];
                       document.getElementById('ctl00_ContentPlaceHolder1_lbl_assetCode').innerHTML = array[1];
                       document.getElementById('hidtransfer_date').innerHTML = array[6];
                       document.getElementById('ctl00_ContentPlaceHolder1_label_itemCategory').innerHTML = array[2];
                       document.getElementById('ctl00_ContentPlaceHolder1_label_currentLoc').innerHTML = array[3];
                       document.getElementById('ctl00_ContentPlaceHolder1_label_trnsferDate').innerHTML = array[6];
                       document.getElementById('hidlocationid').value = array[5];
                       document.getElementById('ctl00_ContentPlaceHolder1_label_lbladded_on').innerHTML = array[4];
                   }
                   else { assetDataDiv.style.display = "none"; } //hide the div if no data selected
                
               }
           }
       });
  
}






