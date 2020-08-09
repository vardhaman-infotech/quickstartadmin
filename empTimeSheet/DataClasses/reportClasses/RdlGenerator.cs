using DynamicTable;
//using SaraFund.DataClasses.clsModule;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace Dinkum.Reports.budgetReport
{
    class RdlGenerator
    {
        #region Global variables
        public static List<string> allColumns;
        public static List<string> AllColumns
        {
            get { return allColumns; }
            set { allColumns = value; }
        }
        #endregion

        #region Report Creation
        public static Rdl.Report CreateReport(string groupBy, string fromDate, string toDate, string billStatus, string reportName)
        {
            Rdl.Report report = new Rdl.Report();
            try
            {
                report.Items = new object[] 
                {
                    CreateDataSources(), //Creates Data source
                    CreateHeader(groupBy,fromDate,toDate,billStatus,reportName),  //create the header and pass the groupby, which we selected in the combobox so that it will be printed in header of report in order to exlain that this table is grouped by which column.
                    CreateBody(groupBy), //Create Body of the report which will contain the table and the data it contains with the groupby display.
                    CreateDataSets(), //Create Dataset corresponding to Datasource
                     "8.5in", //set the size of reporti inches
                    "8.5in", //set the size of reporti inches
                      "11in", //set the size of reporti inches
                    "0.5in",
                    "0.5in",
                    "0.5in",
                    "0.5in",
                };
                report.ItemsElementName = new Rdl.ItemsChoiceType37[]
                { 
                    Rdl.ItemsChoiceType37.DataSources, 
                    Rdl.ItemsChoiceType37.PageHeader,
                    Rdl.ItemsChoiceType37.Body,
                    Rdl.ItemsChoiceType37.DataSets,
                     Rdl.ItemsChoiceType37.Width,
                    Rdl.ItemsChoiceType37.PageWidth,
                     Rdl.ItemsChoiceType37.PageHeight,
                    Rdl.ItemsChoiceType37.TopMargin,
                     Rdl.ItemsChoiceType37.BottomMargin,
                      Rdl.ItemsChoiceType37.LeftMargin,
                       Rdl.ItemsChoiceType37.RightMargin,
                     
                };
            }
            catch (Exception ex) { }
            return report;
        }
        #endregion

        #region create the header
        private static Rdl.PageHeaderFooterType CreateHeader(string groupBy, string fromDate, string toDate, string billStatus, string reportName)
        {
            Rdl.PageHeaderFooterType header = new Rdl.PageHeaderFooterType();
            header.Items = new object[]
            {
                2 + "in",
                 CreateItems(groupBy,fromDate,toDate,billStatus,reportName),
                true,
             //   true,

            };
            header.ItemsElementName = new Rdl.ItemsChoiceType34[]
            {

                Rdl.ItemsChoiceType34.Height,
                Rdl.ItemsChoiceType34.ReportItems,
                Rdl.ItemsChoiceType34.PrintOnFirstPage, //prints on last and first page of header, will not print if we dont set or set to false.
              //  Rdl.ItemsChoiceType34.PrintOnLastPage,
                         
            };
            return header;
        }
        #endregion

        #region Create Items in the header of report
        public static Rdl.ReportItemsType CreateItems(string groupBy, string fromDate, string toDate, string billStatus, string reportName)
        {
            ClsTimeSheet objts = new ClsTimeSheet();
           // ClsConfiguration objconfi = new ClsConfiguration();
            Rdl.ReportItemsType items = new Rdl.ReportItemsType();
            items.Items = new Rdl.TextboxType[6]; //4 because we just need 4 textboxes. Name, Address and Date from Database.
            DataSet ds = new DataSet();
            objts.id = "";
            objts.taskType = "Task";
            objts.action = "getalltasks";
            ds = objts.timesheetrdlcreport();
            if (ds.Tables[0].Rows.Count > 0)
            {
                items.Items[0] = CreateTableCellTextbox(ds.Tables[0].Rows[0]["companyname"].ToString() , true, 1); //passing 1,2,3 and 4 in order to set their corresponding left,right,top,bottom and width property
                items.Items[1] = CreateTableCellTextbox(ds.Tables[0].Rows[0]["address"].ToString()
                     + "\n" + "Tel: " + ds.Tables[0].Rows[0]["phone"].ToString()
                    + "\n" + "Fax: " + ds.Tables[0].Rows[0]["fax"].ToString()
                    + "\n" + ds.Tables[0].Rows[0]["email"].ToString()
                   + "\n" + ds.Tables[0].Rows[0]["website"].ToString()                  
                    , false, 2);
                var dateOfToday = DateTime.Now;
                string strDate = dateOfToday.ToString("MM/dd/yyyy");
                items.Items[2] = CreateTableCellTextbox("Printed on: " + strDate, false, 3);
                items.Items[3] = CreateTableCellTextbox(reportName + "( Billable : " + billStatus + ")", true, 4); //passing 1,2,3 and 4 in order to set their 
                items.Items[4] = CreateTableCellTextbox("From : "+fromDate +" To : "+toDate, true, 5); //passing 1,2,3 and 4 in order to set their 
            }
            return items;
        }
        #endregion

        #region CreateTableCell Textbox
        private static Rdl.TextboxType CreateTableCellTextbox(string fieldName, bool flag, int num)
        {
            Rdl.TextboxType textbox = new Rdl.TextboxType();
            try
            {
                textbox.Name = "txt" + num;
                if (num == 1)
                {
                    textbox.Items = new object[] 
                {
                    fieldName , //val
                    "145pt",  //width
                    "23pt",   //height
                    "0pt",    //left
                    "0pt",    //top
                    CreateTextboxStyle(num),
                     false,
                };
                }
                else if (num == 2)
                {
                    textbox.Items = new object[] 
                {
                    fieldName ,
                    "230pt",
                    "100pt",
                    "0pt",
                    "33pt",
                    CreateTextboxStyle(num),
                     true,
                };
                }
                else if (num == 3)
                {
                    textbox.Items = new object[] 
                {
                    fieldName ,
                  "125pt",
                    "15pt",
                    "380pt",
                    "33pt",
                    CreateTextboxStyle(num),
                     true,
                };
                }
                else if (num == 4)
                {
                    textbox.Items = new object[] 
                {
                    fieldName ,
                    "325pt",    //width
                    "15pt",   //height
                    "380pt",  //left
                     "5pt", //top
                    CreateTextboxStyle(num),
                     true,
                };
                }
                else if (num == 5)
                {
                    textbox.Items = new object[] 
                {
                    fieldName ,
                    "225pt",
                    "15pt",
                    "380pt",
                    "50pt",
                    CreateTextboxStyle(4),
                     true,
                };
                }

                textbox.ItemsElementName = new Rdl.ItemsChoiceType14[] 
            {
                Rdl.ItemsChoiceType14.Value,
                Rdl.ItemsChoiceType14.Width,
                Rdl.ItemsChoiceType14.Height,
                Rdl.ItemsChoiceType14.Left,
                Rdl.ItemsChoiceType14.Top,
                Rdl.ItemsChoiceType14.Style,
                Rdl.ItemsChoiceType14.CanGrow,
            };
            }
            catch (Exception ex) { }
            return textbox;
        }
        #endregion

        #region CreateTextboxStyle
        private static Rdl.StyleType CreateTextboxStyle(int num)
        {
            Rdl.StyleType style = new Rdl.StyleType();
            if (num == 1)
            {
                style.Items = new object[]
                {
                    "Bold",
                    "Century Gothic",
                    "11pt",
                    "Blue"
                };
            }
            else if (num == 2)
            {
                style.Items = new object[]
                {
                    "Normal",
                     "Century Gothic",
                    "9pt",
                    "Black"
                };
            }
            else if (num == 3)
            {
                style.Items = new object[]
                {
                    "Normal",
                     "Century Gothic",
                    "9pt",
                    "Black"
                };
            }
            else if (num == 4)
            {
                style.Items = new object[]
                {
                    "Bold",
                     "Century Gothic",
                    "10pt",
                     "Black",
              //       "Black"
                };
            }
            else if (num == 5)
            {
                style.Items = new object[]
                {
                    "Normal",
                     "Century Gothic",
                    "9pt",
                    "Black"
                };
            }
            style.ItemsElementName = new Rdl.ItemsChoiceType5[]
            {
                Rdl.ItemsChoiceType5.FontWeight,
                Rdl.ItemsChoiceType5.FontFamily,
                Rdl.ItemsChoiceType5.FontSize, 
                Rdl.ItemsChoiceType5.Color,
            //    Rdl.ItemsChoiceType5.BorderColor,
            };
            return style;
        }
        #endregion

        #region Creating Data source
        private static Rdl.DataSourcesType CreateDataSources()
        {
            Rdl.DataSourcesType dataSources = new Rdl.DataSourcesType();
            dataSources.DataSource = new Rdl.DataSourceType[] { CreateDataSource() };
            return dataSources;
        }

        private static Rdl.DataSourceType CreateDataSource()
        {
            Rdl.DataSourceType dataSource = new Rdl.DataSourceType();
            dataSource.Name = "DummyDataSource";
            dataSource.Items = new object[] { CreateConnectionProperties() };
            return dataSource;
        }

        private static Rdl.ConnectionPropertiesType CreateConnectionProperties()
        {
            Rdl.ConnectionPropertiesType connectionProperties = new Rdl.ConnectionPropertiesType();
            connectionProperties.Items = new object[]
                {
                    "",
                    "SQL",
                };
            connectionProperties.ItemsElementName = new Rdl.ItemsChoiceType[]
                {
                    Rdl.ItemsChoiceType.ConnectString,
                    Rdl.ItemsChoiceType.DataProvider,
                };
            return connectionProperties;
        }
        #endregion

        #region Create the body
        private static Rdl.BodyType CreateBody(string groupBy)
        {
            Rdl.BodyType body = new Rdl.BodyType();
            try
            {
                body.Items = new object[]
                {
                     CreateReportItems(groupBy),
                    "1in",
                };
                body.ItemsElementName = new Rdl.ItemsChoiceType30[]
                {               
                    Rdl.ItemsChoiceType30.ReportItems,
                    Rdl.ItemsChoiceType30.Height,
                     
                };
            }
            catch (Exception ex) { }
            return body;
        }
        #endregion

        #region create report item which act as container
        private static Rdl.ReportItemsType CreateReportItems(string groupBy)
        {
            Rdl.ReportItemsType reportItems = new Rdl.ReportItemsType();
            TableRdlGenerator tableGen = new TableRdlGenerator();
            try
            {
                tableGen.Fields = allColumns;
                reportItems.Items = new object[] { tableGen.CreateList(groupBy) }; //create a list, why list ? we will explain in its definition

            }
            catch (Exception ex) { }
            return reportItems;
        }
        #endregion

        #region Create Data set for table for each field
        private static Rdl.DataSetsType CreateDataSets()
        {
            Rdl.DataSetsType dataSets = new Rdl.DataSetsType();
            dataSets.DataSet = new Rdl.DataSetType[] { CreateDataSet() };
            return dataSets;
        }

        private static Rdl.DataSetType CreateDataSet()
        {
            Rdl.DataSetType dataSet = new Rdl.DataSetType();
            dataSet.Name = "MyData";
            dataSet.Items = new object[] { CreateQuery(), CreateFields() }; //For each column create fields
            return dataSet;
        }

        private static Rdl.QueryType CreateQuery()
        {
            Rdl.QueryType query = new Rdl.QueryType();
            query.Items = new object[] 
                {
                    "DummyDataSource",
                    "",
                };
            query.ItemsElementName = new Rdl.ItemsChoiceType2[]
                {
                    Rdl.ItemsChoiceType2.DataSourceName,
                    Rdl.ItemsChoiceType2.CommandText,
                };
            return query;
        }

        private static Rdl.FieldsType CreateFields()
        {
            Rdl.FieldsType fields = new Rdl.FieldsType();

            fields.Field = new Rdl.FieldType[allColumns.Count];
            for (int i = 0; i < allColumns.Count; i++)
            {
                fields.Field[i] = CreateField(allColumns[i]);
            }

            return fields;
        }

        private static Rdl.FieldType CreateField(String fieldName)
        {
            Rdl.FieldType field = new Rdl.FieldType();
            field.Name = fieldName;
            field.Items = new object[] { fieldName };
            field.ItemsElementName = new Rdl.ItemsChoiceType1[] { Rdl.ItemsChoiceType1.DataField };
            return field;
        }
        #endregion

        #region WriteStream() function-call, Which returns the rdl structure in stream form
        public static MemoryStream WriteStream(Stream stream, string groupBy, string fromDate, string toDate, string billStatus, string reportName)
        {
            XmlSerializer serializer = new XmlSerializer(typeof(Rdl.Report)); //Create object for serialization 
            RdlGenerator rd = new RdlGenerator(); //This class is resonsible for generation of rdlc structure
            serializer.Serialize(stream, RdlGenerator.CreateReport(groupBy, fromDate, toDate, billStatus,reportName)); //CreateReport() function returns an object which contains the entire structure of of RDLC report and we then serialize it, Now the stream contains all the report structure we generated. We further returns this stream through returnStream() function call from in RdlGenerator class.
            return (MemoryStream)stream;
        }
        #endregion
    }
}
