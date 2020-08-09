using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using Rdl;
//using System.Windows.Forms;

namespace DynamicTable
{
    class TableRdlGenerator
    {
        #region Global variables
        public string groupByColName = "";
        private List<string> m_fields;
        public List<string> Fields
        {
            get { return m_fields; }
            set { m_fields = value; }
        }
      
        #endregion

        #region Creates a list, Here we will use one more CreateReport item container and inside that we will create table, And we do so in order to group the tables according to the selection done inside the combobox. Now those tables will be repeated inside the list to full fill the groupby condition for the selected option in combobox.
        public Rdl.ListType CreateList(string groupBy)
        {
            
            groupByColName = groupBy.Trim();
            Rdl.ListType list = new Rdl.ListType();
            list.Name = "list1";
            try
            {
                list.Items = new object[]
                {  
                  CreateReportItems(),
                  CreateGrouping(), //do groupin here
                };           
                list.ItemsElementName = new Rdl.ItemsChoiceType18[]
                {
                     Rdl.ItemsChoiceType18.ReportItems,
                     Rdl.ItemsChoiceType18.Grouping,   
                };   
            }
            catch (Exception ex) { }
            return list;
        }
        #endregion


        #region Do grouping
        private Rdl.GroupingType CreateGrouping()
        {
            Rdl.GroupingType groupingType = new GroupingType();
            try
            {
                groupingType.Name = "pagegrp";
                groupingType.Items = new object[]
            {
             //   true,
             //   true,
                CreateGroupExpressions(),
            };
                groupingType.ItemsElementName = new ItemsChoiceType17[]
            {
            //    ItemsChoiceType17.PageBreakAtStart,
             //   ItemsChoiceType17.PageBreakAtEnd,
             
                ItemsChoiceType17.GroupExpressions
            };
            }
            catch (Exception ex) { }
            return groupingType;
        }
        #endregion

        #region writing the grouping expression here
        private Rdl.GroupExpressionsType CreateGroupExpressions()
        {
            Rdl.GroupExpressionsType groupExpressions = new GroupExpressionsType();
            try
            {
                for (int i = 0; i < m_fields.Count; i++)
                {
                    if (m_fields[i] == groupByColName)
                    {
                        groupExpressions.GroupExpression = new string[] 
                        { 
                           "=Fields!" + groupByColName + ".Value"  ,    
                        };
                        return groupExpressions;
                    }
                    else
                    {
                        groupExpressions.GroupExpression = new string[] 
                        { 
                           ""  ,    
                        };
                    }

                }
           
            }
            catch (Exception ex) { }
            return groupExpressions;
        }
        #endregion

        #region Create report items
        private Rdl.ReportItemsType CreateReportItems()
        {
            Rdl.ReportItemsType reportItems = new Rdl.ReportItemsType();
            try
            {
                reportItems.Items = new object[] 
                {                  
                    CreateTextboxForGroupByColNameDisplay(), 
                    CreateTable(),
                };
            }
            catch (Exception ex) { }
            return reportItems;
        }
        
        private Rdl.TextboxType CreateTextboxForGroupByColNameDisplay()
        {
            Rdl.TextboxType textbox = new Rdl.TextboxType();
            try
            {
                textbox.Name = "groupBYheading";
                //
                for (int i = 0; i < m_fields.Count; i++)
                {
                    if (m_fields[i] == groupByColName)
                    {
                        textbox.Items = new object[] 
                          {
                            "=Fields!" +groupByColName + ".Value" , 
                             CreateTableCellTextboxStyleForGroupBy(),
                             true,
                              "0pt",
                              "700pt",
                               "20pt",
                           };
                        break;
                    }
                    else
                    {
                        textbox.Items = new object[] 
                         {
                             "" , 
                             CreateTableCellTextboxStyleForGroupBy(),
                             true,
                            "0pt",
                            "700pt",
                            "20pt",
                          };
                      }                   
                    textbox.ItemsElementName = new Rdl.ItemsChoiceType14[] 
                {
                    Rdl.ItemsChoiceType14.Value,
                    Rdl.ItemsChoiceType14.Style,
                    Rdl.ItemsChoiceType14.CanGrow,
                    Rdl.ItemsChoiceType14.Top ,   
                     Rdl.ItemsChoiceType14.Width,
                     Rdl.ItemsChoiceType14.Height,
                };
                }
            }
            catch (Exception ex) { }
            return textbox;        
        }
        
        private Rdl.StyleType CreateTableCellTextboxStyleForGroupBy()
        {
            Rdl.StyleType style = new Rdl.StyleType();
            style.Items = new object[]
                {
                    "Red",
                    "Left",
                     "Century Gothic",
                     "10pt",
                     "Bold",
                };
            style.ItemsElementName = new Rdl.ItemsChoiceType5[]
                {

                  Rdl.ItemsChoiceType5.Color,
                    Rdl.ItemsChoiceType5.TextAlign,
                    Rdl.ItemsChoiceType5.FontFamily,
                    Rdl.ItemsChoiceType5.FontSize, 
                    Rdl.ItemsChoiceType5.FontWeight,
                };
            return style;
        }
        #endregion

        #region Create Table
        public Rdl.TableType CreateTable()
        {         
            Rdl.TableType table = new Rdl.TableType();
            table.Name = "Table1";
            try
            {
                table.Items = new object[]
                {                  
                    CreateTableColumns(), //cretae columns 
                    CreateHeader(), // cretae headers
                    CreateDetails(), // Create Table rows and set the cell sizes
                    "25pt",
                    //"1.5in",
                    //"1.5in",
 
                };
                table.ItemsElementName = new Rdl.ItemsChoiceType21[]
                {
                
                    Rdl.ItemsChoiceType21.TableColumns,
                    Rdl.ItemsChoiceType21.Header,
                    Rdl.ItemsChoiceType21.Details,     
                    Rdl.ItemsChoiceType21.Top ,   
                    //Rdl.ItemsChoiceType21.Height,
                    //Rdl.ItemsChoiceType21.Width,
                };

            }
            catch (Exception ex) { } 
            return table;
        }
        #endregion

        #region create Header
        private Rdl.HeaderType CreateHeader()
        {
            Rdl.HeaderType header = new Rdl.HeaderType();
            try
            {
                header.Items = new object[]
                {
                    CreateHeaderTableRows(),
                };
                header.ItemsElementName = new Rdl.ItemsChoiceType20[]
                {
                    Rdl.ItemsChoiceType20.TableRows,
                   
                };
            }
            catch (Exception ex) { }
            return header;
        }
        #endregion

        #region Create Rows for Header
        private Rdl.TableRowsType CreateHeaderTableRows()
        {
            
            Rdl.TableRowsType headerTableRows = new Rdl.TableRowsType();
            try
            {
                headerTableRows.TableRow = new Rdl.TableRowType[] { CreateHeaderTableRow() };
            }
            catch (Exception ex) { }
            return headerTableRows;
        }
        #endregion

        #region Create Header row
        private Rdl.TableRowType CreateHeaderTableRow()
        {
            Rdl.TableRowType headerTableRow = new Rdl.TableRowType();
            try
            {
                headerTableRow.Items = new object[] { CreateHeaderTableCells(), "0.25in" };
            }
            catch (Exception ex) { } 
            return headerTableRow;
        }
        #endregion

        #region Create Header table cells for each column in DB
        private Rdl.TableCellsType CreateHeaderTableCells()
        {
            Rdl.TableCellsType headerTableCells = new Rdl.TableCellsType();
            headerTableCells.TableCell = new Rdl.TableCellType[m_fields.Count]; //Create header cell for each column in DB
            for (int i = 0; i < m_fields.Count; i++)
            {
                if (m_fields[i] != groupByColName)
                    headerTableCells.TableCell[i] = CreateHeaderTableCell(m_fields[i]);
            }
            return headerTableCells;
        }
        #endregion

        #region For each table cell set style and dimensions
        private Rdl.TableCellType CreateHeaderTableCell(string fieldName)
        {
            Rdl.TableCellType headerTableCell = new Rdl.TableCellType();
            headerTableCell.Items = new object[] { CreateHeaderTableCellReportItems(fieldName) };
            return headerTableCell;
        }

        private Rdl.ReportItemsType CreateHeaderTableCellReportItems(string fieldName)
        {
            Rdl.ReportItemsType headerTableCellReportItems = new Rdl.ReportItemsType();
            headerTableCellReportItems.Items = new object[] { CreateHeaderTableCellTextbox(fieldName) };
            return headerTableCellReportItems;
        }

        private Rdl.TextboxType CreateHeaderTableCellTextbox(string fieldName)
        {
            Rdl.TextboxType headerTableCellTextbox = new Rdl.TextboxType();
            
            headerTableCellTextbox.Name = fieldName + "_Header";
            
            if (fieldName == m_fields[0])
            {
                headerTableCellTextbox.Items = new object[] 
                {
                    fieldName,
                    CreateHeaderTableCellTextboxStyleforFirstColumn(),
                    true,
                    "40pt",
                    "200pt",
                };
            }
            else
            {
                headerTableCellTextbox.Items = new object[] 
                {
                    fieldName,
                    CreateHeaderTableCellTextboxStyle(),
                    true,
                    "40pt",
                    "200pt",
                };
            }           
            headerTableCellTextbox.ItemsElementName = new Rdl.ItemsChoiceType14[] 
                {
                    Rdl.ItemsChoiceType14.Value,
                    Rdl.ItemsChoiceType14.Style,
                    Rdl.ItemsChoiceType14.CanGrow,
                      Rdl.ItemsChoiceType14.Top,
                    Rdl.ItemsChoiceType14.Left,
                    
                };
            return headerTableCellTextbox;
        }
       
        private Rdl.StyleType CreateHeaderTableCellTextboxStyleforFirstColumn()
        {
            Rdl.StyleType headerTableCellTextboxStyle = new Rdl.StyleType();
           
            headerTableCellTextboxStyle.Items = new object[]
                {
                    "#CD6C37",
                    "Bold",
                    "10pt",
                     "Century Gothic",
                    CreateBorderStyle(),

                };
            headerTableCellTextboxStyle.ItemsElementName = new Rdl.ItemsChoiceType5[]
                {
                    Rdl.ItemsChoiceType5.Color,
                    Rdl.ItemsChoiceType5.FontWeight,
                    Rdl.ItemsChoiceType5.FontSize,
                    Rdl.ItemsChoiceType5.FontFamily,
                    Rdl.ItemsChoiceType5.BorderStyle,
                   
                    
                };
            return headerTableCellTextboxStyle;
        }
        private Rdl.StyleType CreateHeaderTableCellTextboxStyle()
        {
            Rdl.StyleType headerTableCellTextboxStyle = new Rdl.StyleType();
            headerTableCellTextboxStyle.Items = new object[]
                {
                    "Bold",
                    "9pt",
                     "Century Gothic",
                    "Blue",
                    CreateBorderStyle(),

                };
            headerTableCellTextboxStyle.ItemsElementName = new Rdl.ItemsChoiceType5[]
                {
                    Rdl.ItemsChoiceType5.FontWeight,
                    Rdl.ItemsChoiceType5.FontSize,
                     Rdl.ItemsChoiceType5.FontFamily,
                    Rdl.ItemsChoiceType5.Color,
                    Rdl.ItemsChoiceType5.BorderStyle,
                    
                };
            return headerTableCellTextboxStyle;
        }

       
        private BorderColorStyleWidthType CreateBorderStyle()
        {
            Rdl.BorderColorStyleWidthType bstyle = new Rdl.BorderColorStyleWidthType();
            bstyle.Items = new object[]
            {
                 "Solid",
                  "Solid",
            };
            bstyle.ItemsElementName = new Rdl.ItemsChoiceType3[]
            {
                //  Rdl.ItemsChoiceType3.Default,
                  Rdl.ItemsChoiceType3.Top,
                  Rdl.ItemsChoiceType3.Bottom,
            };
            return bstyle;
        }

#endregion

        #region Creating table rows , setting dimensions and styles for table

        private Rdl.DetailsType CreateDetails()
        {
            Rdl.DetailsType details = new Rdl.DetailsType();
            details.Items = new object[] { CreateTableRows() };
            return details;
        }

        private Rdl.TableRowsType CreateTableRows()
        {
            Rdl.TableRowsType tableRows = new Rdl.TableRowsType();
            tableRows.TableRow = new Rdl.TableRowType[] { CreateTableRow() };
            return tableRows;
        }

        private Rdl.TableRowType CreateTableRow()
        {
            Rdl.TableRowType tableRow = new Rdl.TableRowType();
            tableRow.Items = new object[] { CreateTableCells(), "0.25in" };
            return tableRow;
        }

        private Rdl.TableCellsType CreateTableCells()
        {
            Rdl.TableCellsType tableCells = new Rdl.TableCellsType();
           
            tableCells.TableCell = new Rdl.TableCellType[m_fields.Count];
            for (int i = 0; i < m_fields.Count; i++)
            {
                if (m_fields[i] != groupByColName)
                    if(i==0)
                    {
                        tableCells.TableCell[i] = CreateTableCell(m_fields[i],i);
                    }
                    else
                    {
                        tableCells.TableCell[i] = CreateTableCell(m_fields[i],i);
                    }
                    //tableCells.TableCell[i] = CreateTableCell(m_fields[i]);
            }
            return tableCells;
        }

        private Rdl.TableCellType CreateTableCell(string fieldName, int i)
        {
            Rdl.TableCellType tableCell = new Rdl.TableCellType();
           
            tableCell.Items = new object[] { CreateTableCellReportItems(fieldName,i) };
            return tableCell;
        }

        private Rdl.ReportItemsType CreateTableCellReportItems(string fieldName , int i)
        {
            Rdl.ReportItemsType reportItems = new Rdl.ReportItemsType();
                    reportItems.Items = new object[] { CreateTableCellTextbox(fieldName, i) };
           
            return reportItems;
        }
     
        private Rdl.TextboxType CreateTableCellTextbox(string fieldName, int i)
        {
            Rdl.TextboxType textbox = new Rdl.TextboxType();
            textbox.Name = fieldName;
            textbox.Items = new object[] 
                {
                    "=Fields!" + fieldName + ".Value", //fills in the data
                 // " =Format(First(Fields!fieldName.Value," +fieldName +"),BOLD)",
                   //    "<span style='color:#000000;'> +"+"=Fields!" + fieldName + ".Value" +"</span> ",
                    CreateTableCellTextboxStyle(i,fieldName),
                    true,
                    "130pt",
                };
            textbox.ItemsElementName = new Rdl.ItemsChoiceType14[] 
                {
                    Rdl.ItemsChoiceType14.Value,
                    Rdl.ItemsChoiceType14.Style,
                    Rdl.ItemsChoiceType14.CanGrow,
                    Rdl.ItemsChoiceType14.Top,
                    
                };
            return textbox;
        }

        private Rdl.StyleType CreateTableCellTextboxStyle(int i, string fieldName)
        {
            Rdl.StyleType style = new Rdl.StyleType();
            if (i == 0)
            {
                style.Items = new object[]
                {
                    "=iif(RowNumber(Nothing) mod 2, \"AliceBlue\", \"White\")",
                    "Left",
                     "Century Gothic",
                     "9pt",
                   // " =IIf(InStr(Fields!"+fieldName +".Value, 'AA -Anjali Agarwal') > 0 or IsNothing(Fields!"+fieldName+".Value), 'Red', 'Black') ",
                      "#CD6C37",
                      "Bold",
                };
            }
            else
            {
                style.Items = new object[]
                {
                    "=iif(RowNumber(Nothing) mod 2, \"AliceBlue\", \"White\")",
                    "Left",
                     "Century Gothic",
                     "9pt",
                    "Black",
                };
            }
            style.ItemsElementName = new Rdl.ItemsChoiceType5[]
                {

                    Rdl.ItemsChoiceType5.BackgroundColor,
                    Rdl.ItemsChoiceType5.TextAlign,
                    Rdl.ItemsChoiceType5.FontFamily,
                    Rdl.ItemsChoiceType5.FontSize, 
                     Rdl.ItemsChoiceType5.Color,
                      Rdl.ItemsChoiceType5.FontWeight,                   
                };
            return style;
        }

        private Rdl.TableColumnsType CreateTableColumns()
        {
            Rdl.TableColumnsType tableColumns = new Rdl.TableColumnsType();
            tableColumns.TableColumn = new Rdl.TableColumnType[m_fields.Count];
            for (int i = 0; i < m_fields.Count; i++)
            {
                if (m_fields[i] != groupByColName)
                    tableColumns.TableColumn[i] = CreateTableColumn(i);
            }
            return tableColumns;
        }

        private Rdl.TableColumnType CreateTableColumn(int i)
        {
            Rdl.TableColumnType tableColumn = new Rdl.TableColumnType();
            if (i == 0)
            {
                tableColumn.Items = new object[] { "2.5in" };
            }
            else
            {
                tableColumn.Items = new object[] { "0.5in" };
            }
         
            return tableColumn;
        }
        #endregion
    }
}
