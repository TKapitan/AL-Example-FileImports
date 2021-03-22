/// <summary>
/// Interface TKA IImport File Format.
/// </summary>
interface "TKA IImport File Format"
{
    /// <summary>
    /// Import lines from the select file. The file is selected by user. Based on implementation, some other selections may be neccessary (specific sheet/list/range, ...).
    /// </summary>
    /// <param name="ImportConfigurationCode">Code[20], definition of used import configuration</param>
    /// <returns>Return value of type Record "CSV Buffer" temporary, contains all lines from imported file.</returns>
    procedure ImportFile(ImportConfigurationCode: Code[20]) TempCSVBuffer: Record "CSV Buffer" temporary

    /// <summary>
    /// Returns value from selected line and column number.
    /// </summary>
    /// <param name="LineNo">Integer, specifies number of line.</param>
    /// <param name="ColumnNo">Integer, specifies column number.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetValue(LineNo: Integer; ColumnNo: Integer): Text;

    /// <summary>
    /// Returns information whether the line was imported and exists in the buffer.
    /// </summary>
    /// <param name="LineNo">Integer, specifies number of line.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure Contains(LineNo: Integer): Boolean;

    /// <summary>
    /// Returns information whether the line was imported and exists in the buffer. Then verify whether the line contains the column.
    /// </summary>
    /// <param name="LineNo">Integer, specifies number of line.</param>
    /// <param name="ColumnNo">Integer, specifies column number.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure Contains(LineNo: Integer; ColumnNo: Integer): Boolean;

    /// <summary>
    /// Returns number of lines in buffer imported from file.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure GetCountLines(): Integer;

    /// <summary>
    /// Specifies whether field separator is supported for the format
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure FieldSeparatorSupported(): Boolean
}