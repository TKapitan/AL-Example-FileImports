/// <summary>
/// Codeunit TKA Import File Format CSV (ID 50000) implements Interface TKA IImport File Format.
/// </summary>
codeunit 50000 "TKA Import File Format CSV" implements "TKA IImport File Format"
{
    var
        TempCSVBuffer: Record "CSV Buffer" temporary;

    /// <summary>
    /// Import lines from the select file. The file is selected by user. Based on implementation, some other selections may be neccessary (specific sheet/list/range, ...).
    /// </summary>
    /// <param name="ImportConfigurationCode">Code[20], definition of used import configuration</param>
    /// <returns>Return value of type Record "CSV Buffer" temporary, contains all lines from imported file.</returns>
    procedure ImportFile(ImportConfigurationCode: Code[20]): Record "CSV Buffer" temporary
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

        TempCSVBuffer.SetFilter("Line No.", '<=%1', ImportConfiguration."TKA Skip X Lines");
        TempCSVBuffer.DeleteAll();
        TempCSVBuffer.SetRange("Line No.");
        if not TempCSVBuffer.FindFirst() then
            Error(NoLinesFoundErr);
        exit(TempCSVBuffer);
    end;

    /// <summary>
    /// Returns value from selected line and column number.
    /// </summary>
    /// <param name="LineNo">Integer, specifies number of line.</param>
    /// <param name="ColumnNo">Integer, specifies column number.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetValue(LineNo: Integer; ColumnNo: Integer): Text
    begin
        exit(TempCSVBuffer.GetValue(LineNo, ColumnNo));
    end;

    /// <summary>
    /// Returns information whether the line was imported and exists in the buffer.
    /// </summary>
    /// <param name="LineNo">Integer, specifies number of line.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure Contains(LineNo: Integer): Boolean
    var
        TempCSVBuffer2: Record "CSV Buffer" temporary;
    begin
        TempCSVBuffer2.Copy(TempCSVBuffer, true);
        TempCSVBuffer2.SetRange("Line No.", LineNo);
        exit(not TempCSVBuffer2.IsEmpty());
    end;

    /// <summary>
    /// Returns information whether the line was imported and exists in the buffer. Then verify whether the line contains the column.
    /// </summary>
    /// <param name="LineNo">Integer, specifies number of line.</param>
    /// <param name="ColumnNo">Integer, specifies column number.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure Contains(LineNo: Integer; ColumnNo: Integer): Boolean
    var
        TempCSVBuffer2: Record "CSV Buffer" temporary;
    begin
        TempCSVBuffer2.Copy(TempCSVBuffer, true);
        TempCSVBuffer2.SetRange("Line No.", LineNo);
        TempCSVBuffer2.SetRange("Field No.", ColumnNo);
        exit(not TempCSVBuffer2.IsEmpty());
    end;

    /// <summary>
    /// Returns number of lines in buffer imported from file.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure GetCountLines(): Integer
    begin
        exit(TempCSVBuffer.GetNumberOfLines());
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