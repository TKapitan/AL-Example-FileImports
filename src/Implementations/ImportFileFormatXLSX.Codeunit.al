/// <summary>
/// Codeunit TKA Import File Format XLSX (ID 50001) implements Interface TKA IImport File Format.
/// </summary>
codeunit 50001 "TKA Import File Format XLSX" implements "TKA IImport File Format"
{
    /// <summary>
    /// Import lines from the select file. The file is selected by user. Based on implementation, some other selections may be neccessary (specific sheet/list/range, ...).
    /// </summary>
    /// <param name="ImportConfigurationCode">Code[20], definition of used import configuration</param>
    /// <returns>Return value of type Record "CSV Buffer" temporary, contains all lines from imported file.</returns>
    procedure ImportFile(ImportConfigurationCode: Code[20]) TempCSVBuffer: Record "CSV Buffer" temporary
    var
        ImportConfiguration: Record "TKA Import Configuration";
        TempExcelBuffer: Record "Excel Buffer" temporary;

        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";

        SheetName: Text;
        FileInStream: InStream;

        ImportFileLbl: Label 'Import file';
        NoLinesFoundErr: Label 'There are no lines for import in selected file.';
    begin
        ImportConfiguration.Get(ImportConfigurationCode);
        FileManagement.BLOBImportWithFilter(TempBlob, ImportFileLbl, '', FileManagement.GetToFilterText('', '.xlsx'), 'xlsx');

        TempBlob.CreateInStream(FileInStream);
        SheetName := TempExcelBuffer.SelectSheetsNameStream(FileInStream);

        TempBlob.CreateInStream(FileInStream);
        TempExcelBuffer.OpenBookStream(FileInStream, SheetName);
        TempExcelBuffer.ReadSheet();

        TempExcelBuffer.SetFilter("Row No.", '<=%1', ImportConfiguration."TKA Skip X Lines");
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.SetRange("Row No.");
        if not TempExcelBuffer.FindSet() then
            Error(NoLinesFoundErr);

        Clear(TempCSVBuffer);
        TempCSVBuffer.DeleteAll();
        repeat
            TempCSVBuffer.Init();
            TempCSVBuffer."Line No." := TempExcelBuffer."Row No.";
            TempCSVBuffer."Field No." := TempExcelBuffer."Column No.";
            TempCSVBuffer.Value := TempExcelBuffer."Cell Value as Text";
            TempCSVBuffer.Insert();
        until TempExcelBuffer.Next() < 1;
    end;

    /// <summary>
    /// Specifies whether field separator is supported for the format
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure FieldSeparatorSupported(): Boolean
    begin
        exit(false);
    end;
}