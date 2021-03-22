/// <summary>
/// Codeunit TKA Import File Format XLSX (ID 50001) implements Interface TKA IImport File Format.
/// </summary>
codeunit 50001 "TKA Import File Format XLSX" implements "TKA IImport File Format"
{
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        NumberOfRows: Integer;
        IndexDoesNotExistErr: Label 'The row in line %1 with index %2 does not exist. The data could not be retrieved.', Comment = '%1 = wor no, %2 = index of the field';

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

        LastRowNumber: Integer;
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

        LastRowNumber := -1;
        Clear(TempCSVBuffer);
        TempCSVBuffer.DeleteAll();
        repeat
            if LastRowNumber <> TempExcelBuffer."Row No." then begin
                NumberOfRows += 1;
                LastRowNumber := TempExcelBuffer."Row No.";
            end;

            TempCSVBuffer.Init();
            TempCSVBuffer."Line No." := TempExcelBuffer."Row No.";
            TempCSVBuffer."Field No." := TempExcelBuffer."Column No.";
            TempCSVBuffer.Value := TempExcelBuffer."Cell Value as Text";
            TempCSVBuffer.Insert();
        until TempExcelBuffer.Next() < 1;
    end;

    /// <summary>
    /// Returns value from selected line and column number.
    /// </summary>
    /// <param name="LineNo">Integer, specifies number of line.</param>
    /// <param name="ColumnNo">Integer, specifies column number.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetValue(LineNo: Integer; ColumnNo: Integer): Text
    var
        TempExcelBuffer2: Record "Excel Buffer" temporary;
    begin
        TempExcelBuffer2.Copy(TempExcelBuffer, true);
        TempExcelBuffer2.SetRange("Row No.", LineNo);
        TempExcelBuffer2.SetRange("Column No.", ColumnNo);
        if not TempExcelBuffer2.FindFirst() then
            Error(IndexDoesNotExistErr, LineNo, ColumnNo);
        exit(TempExcelBuffer2."Cell Value as Text");
    end;

    /// <summary>
    /// Returns information whether the line was imported and exists in the buffer.
    /// </summary>
    /// <param name="LineNo">Integer, specifies number of line.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure Contains(LineNo: Integer): Boolean
    var
        TempExcelBuffer2: Record "Excel Buffer" temporary;
    begin
        TempExcelBuffer2.Copy(TempExcelBuffer, true);
        TempExcelBuffer2.SetRange("Row No.", LineNo);
        exit(not TempExcelBuffer2.IsEmpty());
    end;

    /// <summary>
    /// Returns information whether the line was imported and exists in the buffer. Then verify whether the line contains the column.
    /// </summary>
    /// <param name="LineNo">Integer, specifies number of line.</param>
    /// <param name="ColumnNo">Integer, specifies column number.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure Contains(LineNo: Integer; ColumnNo: Integer): Boolean
    var
        TempExcelBuffer2: Record "Excel Buffer" temporary;
    begin
        TempExcelBuffer2.Copy(TempExcelBuffer, true);
        TempExcelBuffer2.SetRange("Row No.", LineNo);
        TempExcelBuffer2.SetRange("Column No.", ColumnNo);
        exit(not TempExcelBuffer2.IsEmpty());
    end;

    /// <summary>
    /// Returns number of lines in buffer imported from file.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure GetCountLines(): Integer
    begin
        exit(NumberOfRows);
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