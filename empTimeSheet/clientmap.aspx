<%@ Page Title="" Language="C#" MasterPageFile="~/userMaster.Master" AutoEventWireup="true" CodeBehind="clientmap.aspx.cs" Inherits="empTimeSheet.clientmap" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<%@ Register Src="progressbar.ascx" TagName="progress" TagPrefix="pg" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyD4IuRFVcMjWo1qWvBrS3v4uvDXcCiq_c4&sensor=false"></script>

    <script type="text/javascript">
        function searchKeyPress(e) {
            // look for window.event in case event isn't passed in
            e = e || window.event;
            if (e.keyCode == 13) {
                document.getElementById('ctl00_ContentPlaceHolder1_btnsearch').click();
            }
        }
    </script>
    <script type="text/javascript">
        function GoogleMap() {
            var id = document.getElementById("ctl00_ContentPlaceHolder1_hidid").value;

            var zoomlevel = 2;
            if (id != "") {
                zoomlevel = 17;
            }
            var mapOptions = {
                center: new google.maps.LatLng(markers[0][0].lat, markers[0][0].lng),
                zoom: zoomlevel,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };
            var infoWindow = new google.maps.InfoWindow();
            var map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
            for (i = 0; i < markers[0].length; i++) {
                var data = markers[0][i];
                var marker = new google.maps.Marker({
                    position: new google.maps.LatLng(data.lat, data.lng),
                    map: map
                });
                (function (marker, data) {
                    google.maps.event.addListener(marker, "click", function (e) {
                        infoWindow.setContent(data.description);
                        infoWindow.open(map, marker);
                    });
                })(marker, data);
            }
        }




        function GoogleMap1() {
            var directionsService = new google.maps.DirectionsService;
            var directionsDisplay = new google.maps.DirectionsRenderer({
                polylineOptions: {
                    strokeColor: "blue",
                    strokeWeight: 3
                }
            });
            var map = new google.maps.Map(document.getElementById('map_canvas'), {
                zoom: 7,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                center: new google.maps.LatLng(markers[0][0].lat, markers[0][0].lng)
            });
            directionsDisplay.setMap(map);

            var onChangeHandler = function () {
                calculateAndDisplayRoute(directionsService, directionsDisplay);
            };

        }

        function calculateAndDisplayRoute(directionsService, directionsDisplay) {
            directionsService.route({
                origin: document.getElementById('ctl00_ContentPlaceHolder1_hidaddress').value,
                destination: document.getElementById('ctl00_ContentPlaceHolder1_hidaddress2').value,
                travelMode: google.maps.TravelMode.DRIVING
            }, function (response, status) {
                if (status === google.maps.DirectionsStatus.OK) {
                    directionsDisplay.setDirections(response);
                } else {
                    window.alert('Directions request failed due to ' + status);
                }
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <input type="hidden" id="hidid" runat="server" />
    <input type="hidden" id="hidaddress" runat="server" value="266 17th Street, Suite 200, Oakland, CA 94612" />
    <input type="hidden" id="hidaddress2" runat="server" />
    <input type="hidden" id="hidrate" runat="server" />
    <pg:progress ID="progress1" runat="server" />
    <div class="pageheader">
        <h2>
            <i class="fa fa-user"></i>Client Address Map
        </h2>
        <div class="breadcrumb-wrapper">
            <asp:LinkButton ID="btnexportcsv" runat="server" OnClick="btnexportcsv_Click" CssClass="right_link">
            <i class="fa fa-fw fa-file-excel-o topicon"></i>Export to Excel</asp:LinkButton>

        </div>
        <div class="clear">
        </div>
    </div>
    <div class="contentpanel">
        <div class="row">
            <div class="col-sm-4 col-md-3">
                <div class="panel panel-default">
                    <div class="panel-body">
                        <h5 class="subtitle mb5">Client</h5>
                        <asp:TextBox ID="txtsearch" runat="server" CssClass="search_btn" placeholder="Search..."
                            onkeypress="searchKeyPress(event);"></asp:TextBox>
                        <asp:Button ID="btnsearch" runat="server" Text="Search" CssClass="button" OnClick="btnsearch_Click"
                            Style="display: none" />
                        <h5 class="color">Clients
                        </h5>
                        <div class="nodatafound" id="nodata" runat="server">
                            No data found
                        </div>
                        <asp:Repeater ID="dgnews" runat="server" OnItemCommand="dgnews_RowCommand">
                            <HeaderTemplate>
                                <ul class="search_list">
                            </HeaderTemplate>
                            <ItemTemplate>
                                <li class="odd">
                                    <asp:LinkButton ID="lbtndetails" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                        CommandName="detail">
                                        <%# DataBinder.Eval(Container.DataItem, "fullname")%>&nbsp;
                                        <br />
                                        <span>(<%# DataBinder.Eval(Container.DataItem, "code")%>
                                            -
                                            <%# DataBinder.Eval(Container.DataItem, "company")%>)</span>
                                    </asp:LinkButton>
                                </li>
                            </ItemTemplate>
                            <AlternatingItemTemplate>
                                <li class="even">
                                    <asp:LinkButton ID="lbtndetails" runat="server" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "nid")%>'
                                        CommandName="detail">
                                        <%# DataBinder.Eval(Container.DataItem, "fullname")%>&nbsp;
                                        <br />
                                        <span>(<%# DataBinder.Eval(Container.DataItem, "code")%>
                                            -
                                            <%# DataBinder.Eval(Container.DataItem, "company")%>)</span>
                                    </asp:LinkButton>
                                </li>
                            </AlternatingItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>
            <!-- col-sm-9 -->
            <div class="col-sm-8 col-md-9">
                <div class="panel panel-default">
                    <div class="panel-body3">
                        <div class="row">


                            <div class="col-sm-12 col-md-12 mar3">
                                <div id="divshowmap" runat="server" visible="false">
                                   
                                    <div id="map_canvas" style="border-top: none; width: 100%; height: auto; min-height: 407px; overflow: auto; background-color: #FAFAFA; margin-top: 0px;">
                                    </div>


                                    <div class="clear">
                                    </div>
                                    <div id="divaddress" runat="server" style="background: #0da08b; padding: 10px; color: #ffffff;"></div>
                                </div>

                                  <div id="divmsgmap" runat="server" style="min-height:453px;" >
                                      <div style="text-align:center;padding-top:50px;">
                                          <img src="images/blankmap.png" />
                                      </div>
                                   <div style="padding-left:150px;">
                                         Show your client's address on google map
                                   </div>
                                      </div>
                            </div>
                        </div>
                        <!-- row -->
                    </div>
                    <!--panel-body3-->
                </div>
            </div>
        </div>
    </div>


</asp:Content>
