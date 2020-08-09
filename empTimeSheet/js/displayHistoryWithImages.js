var json;
var jsontasks;

function displayHistoryThroughImages(assetId) {
    var params = { assetId: assetId };
    $.ajax(
        {
            type: "POST",
            url: "asset_AssetMaster.aspx/getImagesPath",
            data: JSON.stringify(params),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: true,
            cache: false,
            success: function (data) {
                json = $.parseJSON(data.d);
                if (data.d != "failure")
                {
                    var widthOfBigerDiv = document.getElementById("imageDiv").offsetWidth;
                    var widthIndividual = 0;
                    var downArrowCounter = 1;
                    var evenOddFlag = 0;

                    var count = 1;
                    $(json).each(function (i, val)
                    {
                        var counter = 0;
                        var imageFlowStatus;
                        var arrowdirection;
                        var savePreviousDate;
                        $.each(val, function (key, val)
                        {
                            var splitted = val.split('@');
                            var stringbuilder = [];
                            if (widthIndividual + 200 > 2 * widthOfBigerDiv)
                            {
                                widthIndividual = 0;
                            }
                            if (widthIndividual + 200 > widthOfBigerDiv) //Here i change the image orientation(ltr or rtl) and arrow image (arrowLeft.png or arrowRight.png)
                            {
                                if (counter % 2 == 0)// I use this counter variable because we have images on all even postion and arrowimages at odd position, like this I->I->I->... and so on 
                                {
                                    imageFlowStatus = "rtl";
                                }
                                else
                                {
                                    arrowdirection = "arrowsleft.png";
                                }
                            }
                            else
                            {
                                if (counter % 2 == 0)
                                {
                                    imageFlowStatus = "ltr";
                                }
                                else
                                {
                                    arrowdirection = "arrowsright.png";
                                }
                            }
                            //Now in  previous code the orientation of image and leftArrow.png and RightArror.png have been decided, now display them

                            // At even position we have images
                            if (counter % 2 == 0)
                            {
                                if (downArrowCounter == 8)//At  downArrowCounter position 8 we place the arrow else place the image
                                {
                                    if (evenOddFlag % 2 == 0)// At even position display downArrow.png in right with text on it. Else display in left.
                                    {
                                        stringbuilder.push('<div style="width:700px;height:80px;" class="inline aligntRight ' + "\"" + '><img style="height:80px;" src="' + "images//" + "arrowsDown.png" + '" name="Arrowimage2"></div>');
                                    }
                                    else
                                    {
                                        stringbuilder.push('<div style="width:700px;height:80px;" class="inline aligntLeft ' + "\"" + '><img style="height:80px;" src="' + "images//" + "arrowsDown.png" + '" name="Arrowimage2"></div>');
                                    }
                                    downArrowCounter = 0;
                                    evenOddFlag++;
                                }
                                else
                                {
                                    stringbuilder.push('<div style="width:100px; height:140px;" class="inline ' + imageFlowStatus + "\"" + '><div style="display:inline-block;"><table width="100%  height="140px"><tr><img class="roundedcorners" align="middle" style="width:100px;height:112px;" src="' + splitted[0] + '" name="productimage2"></tr><tr><td  style="text-align: center;"><span style="color:#1caf9a;"> "' + splitted[2] + '"</span></td></tr></table></div></div>');
                                    widthIndividual += 100;
                                }
                            }
                                //at odd position we have  arrow images
                            else
                            {
                                if (downArrowCounter == 8)
                                {
                                    if (evenOddFlag % 2 == 0)
                                    {
                                        stringbuilder.push('<div class="inline" style="width:700px;height:80px;"><img name="Arrowimage2" src="images//arrowsDown.png" style="height: 80px; float: right; margin-right: 23px;"><span  style="color: black; font-weight: bold; float: right; margin-top: 30px; margin-right: -1px;">"' + splitted[1] + '"</span></div>');
                                    }
                                    else
                                    {
                                        stringbuilder.push('<div class="inline" style="width:700px;height:80px;"><img name="Arrowimage2" src="images//arrowsDown.png" style="height:80px;margin-left: 50px;"><span  style="color:black; font-weight: bold; transform: rotate(90.0deg); position: relative; margin-top:30px;">"' + splitted[1] + '"</span></div>');
                                    }
                                    downArrowCounter = 0;
                                    evenOddFlag++;
                                }
                                else
                                {
                                    stringbuilder.push('<div style="width:100px;height:140px;" class="inline ' + imageFlowStatus + "\"" + '><table  width="100%" height="140px"><tr><td style="text-align: center;vertical-align:bottom;"><span style="color:black;font-weight: bold;">"' + splitted[1] + '"</span></td></tr><tr><td style="vertical-align: top;horizontal-align: center;"><img style="height:10px;" src="' + "images//" + arrowdirection + '" name="Arrowimage2"></td></tr> </table></div>');
                                    widthIndividual += 100;
                                }
                            }
                            $('#imageDivs').append(stringbuilder.join(''));
                            downArrowCounter++;
                            counter++;
                        });
                    });

                }
                else { alert("failure"); }
            }
        });

}










