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
    /// Specifies whether field separator is supported for the format
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure FieldSeparatorSupported(): Boolean
}