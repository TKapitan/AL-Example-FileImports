/// <summary>
/// Codeunit TKA Import File Format CSV (ID 50000) implements Interface TKA IImport File Format.
/// </summary>
codeunit 50000 "TKA Import File Format CSV" implements "TKA IImport File Format"
{
    /// <summary>
    /// Import lines from the select file. The file is selected by user. Based on implementation, some other selections may be neccessary (specific sheet/list/range, ...).
    /// </summary>
    /// <param name="ImportConfigurationCode">Code[20], definition of used import configuration</param>
    /// <returns>Return value of type Record "CSV Buffer" temporary, contains all lines from imported file.</returns>
    procedure ImportFile(ImportConfigurationCode: Code[20]) TempCSVBuffer: Record "CSV Buffer" temporary
    var
        ImportConfiguration: Record "TKA Import Configuration";

        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";

        FileInStream: InStream;

        ImportFileLbl: Label 'Import file';
        NoLinesFoundErr: Label 'There are no lines for import in selected file.';
    begin
        ImportConfiguration.Get(ImportConfigurationCode);
        FileManagement.BLOBImportWithFilter(TempBlob, ImportFileLbl, '', FileManagement.GetToFilterText('', '.csv'), 'csv');

        TempBlob.CreateInStream(FileInStream);
        ImportConfiguration.TestField("TKA Field Separator");
        TempCSVBuffer.LoadDataFromStream(FileInStream, ImportConfiguration."TKA Field Separator", '');

        TempCSVBuffer.SetFilter("Line No.", '<=%1', ImportConfiguration."TKA Skip X Fields");
        TempCSVBuffer.DeleteAll();
        TempCSVBuffer.SetRange("Line No.");
        if not TempCSVBuffer.FindFirst() then
            Error(NoLinesFoundErr);
    end;

    /// <summary>
    /// Specifies whether field separator is supported for the format
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure FieldSeparatorSupported(): Boolean
    begin
        exit(true);
    end;
}