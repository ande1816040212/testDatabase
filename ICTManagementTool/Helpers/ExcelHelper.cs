using System;
using System.Linq;
using System.Data;
using System.Collections;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;

namespace ICTManagementTool.Helpers
{
    public class ExcelHelper
    {
        
        public static DataTable ExcelToDataTable(String filePath)
        {

            DataTable returnTable = new DataTable();
            SpreadsheetDocument doc = SpreadsheetDocument.Open(filePath, false);
            using (doc)
            {

                // HERE consider using FirstOrDefault() as First() throws an exception if nothing is found.
                // You should then CHECK that the worksheet and sheet data are not null before trying to access
                // these are LINQ/Lambda expressions that may return no object.
                WorkbookPart workbookPart = doc.WorkbookPart;
                WorksheetPart worksheetPart = workbookPart.WorksheetParts.FirstOrDefault();
                SheetData sheetData = worksheetPart.Worksheet.Elements<SheetData>().FirstOrDefault();

                //this checks if the worksheet is empty
                if (sheetData.ChildElements.Count == 0)
                {
                    throw new System.ArgumentException("Excel document cannot be empty", "original");
                }

                var sharedStringPart = workbookPart.SharedStringTablePart;

                var values = sharedStringPart.SharedStringTable.Elements<SharedStringItem>().ToArray();

                bool firstRow = true;
                ArrayList rowsSkipped = new ArrayList();

                foreach (Row r in sheetData.Elements<Row>())
                {
                    //heading row
                    if (firstRow)
                    {
                        int columnCount = 0;
                        foreach (Cell c in r.Elements<Cell>())
                        {
                            var stringId = Convert.ToInt32(c.InnerText);
                            string columnHeader = workbookPart.SharedStringTablePart.SharedStringTable.Elements<SharedStringItem>().ElementAt(stringId).InnerText;
                            if (!returnTable.Columns.Contains(columnHeader))
                            {
                                returnTable.Columns.Add(columnHeader);
                            }
                            else
                            {
                                rowsSkipped.Add(columnCount);
                            }
                            columnCount++;
                        }

                        firstRow = false;
                    }
                    //data rows
                    else
                    {
                        DataRow newCustomersRow = returnTable.NewRow();
                        int columnCount = 0;
                        int columnInsertCount = 0;
                        foreach (Cell c in r.Elements<Cell>())
                        {
                            if (!rowsSkipped.Contains(columnCount))
                            {

                                var value = "";
                                // The cells contains a string input that is not a formula
                                if (c.DataType != null && c.DataType.Value == CellValues.SharedString)
                                {
                                    var index = int.Parse(c.CellValue.Text);
                                    value = values[index].InnerText;
                                }
                                else if (c.CellValue != null)
                                {
                                    //styleIndex 3 is for dates
                                    if (c.StyleIndex == 3)
                                    {
                                        value = DateTime.FromOADate(int.Parse(c.CellValue.Text)).ToString();
                                    }
                                    else
                                    {
                                        value = c.CellValue.Text;
                                    }
                                }

                                if (c.CellFormula != null)
                                {
                                    value = c.CellFormula.Text;
                                }
                                newCustomersRow[columnInsertCount] = value;
                                columnInsertCount++;
                            }
                            columnCount++;
                        }
                        returnTable.Rows.Add(newCustomersRow);
                    }

                }
            }



            return returnTable;

        }


    }


}